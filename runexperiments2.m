%% Defining experiment params 
% testcities = {'Mumbai', 'Capetown','Capetownsmall','Lower','Kibera','Kianda', 'AlGeneina','ElDaein','Mokako','Medellin'};
testcities = {'Mumbai', 'Lower','Kibera','Kianda','Capetown','Capetownsmall', 'AlGeneina','ElDaein','Mokako','Medellin'};
kenya.name = 'Kenya';
kenya.cities = {'Lower','Kibera' ,'Kianda'};
kenya.testcities = testcities;
kenya.classmaps = {[],[],[]};
kenya.multiclass = {0,0,0};
kenya.classremove = {[], [], []};

sudan.name = 'Sudan';
sudan.cities = {'AlGeneina','ElDaein'};
sudan.testcities =testcities;
sudan.classmaps = {[];[]};
sudan.multiclass = {0,0};
sudan.classremove = {[];[]};
% 
india.name = 'India';
india.cities = {'Mumbai'};
india.testcities = testcities;
india.classmaps = {[]};
india.multiclass = {0};
india.classremove = {[]};

southafrica.name = 'Southafrica';
% southafrica.cities = {'Capetown'};
southafrica.cities = {'Capetown','Capetownsmall'};
southafrica.testcities =testcities;
southafrica.classmaps = {[],[]};
southafrica.multiclass = {0,0};
southafrica.classremove = {[],[]};

nigeria.name = 'Nigeria';
nigeria.cities = {'Mokako'};
nigeria.testcities =testcities;
nigeria.classmaps = {[]};
nigeria.multiclass = {0};
nigeria.classremove = {[]};

colombia.name = 'Colombia';
colombia.cities = {'Medellin'};
colombia.testcities =testcities;
colombia.classmaps = {[]};
colombia.multiclass = {0};
colombia.classremove = {[]};
%% Classes
% 0 - flat spectra, green veg, water etc
% 0.15 - Metal, tin, or zinc
% 0.3 - Tiles
% 0.55 - Shingles
% 0.7 - Thatch or Grass
% 0.85 - Plastic sheets
% 1 - Asbestos
data.countries = {southafrica, nigeria, kenya, india, sudan,colombia};
% global constants
source = 'S2';
type= 'training';
split = 0.8;
% as we are just doing binary pred
classes = 7;
% method for all 
method= 'spec2inf';
lbls = {'Environment', 'Metal', 'Shingles','Thatch'};
cmap = [0 1 0 0 1 0 0; 0 1 0 1 0 0 0; 0 0 0 1 0 0 0];

server = '/Users/bradley/Documents/Projects/Team2_FDL/synthesis-generate-spectrum/ccfs/';
nCountries= length(data.countries);
%% Set the things that you would like to do
create_binary_mask =0;
train_model = 0;
test_model =0;
classify_image =1;
create_image =1;
calc_meanIOU = 0;
create_all =0;
nTrees = [10,15,25,50,100,200];

%% Run experiment
% if create_binary_mask
%     parfor ii=1:nCountries
%         disp([' Creating Binary Mask... for ' data.countries{ii}.name]);
%         cities = data.countries{ii}.cities;
%         for jj=1:length(cities)
%             disp([' Creating Binary Mask... for ' cities{jj}])
%             spectiff_to_mat(data.countries{ii}.name,cities{jj},source,type,server);
%         end
%     end
% end
% if train_model
%     parfor ii=1:nCountries
%         disp([' Training model... for ' data.countries{ii}.name]);
%         cities = data.countries{ii}.cities;
%         for jj=1:length(cities)
%             inform2spec(data.countries{ii}.name,source,cities{jj},type,method,split,data.countries{ii}.multiclass{jj}, data.countries{ii}.classmaps{jj},data.countries{ii}.classremove{jj}, ntrees,server)
%         end
%     end
% end
%   if test_model
%       parfor ii=1:nCountries
%         disp(['Testing model...for ' data.countries{ii}.name]);
%         cities = data.countries{ii}.cities;
%         for jj=1:length(cities)
%             for kk=1:length(data.countries{ii}.testcities)
%                 predictinf2specontrain(data.countries{ii}.name,source,cities{jj},data.countries{ii}.testcities{kk},type,method,data.countries{ii}.multiclass{jj}, data.countries{ii}.classmaps{jj},data.countries{ii}.classremove{jj},ntrees,server);
%             end
%         end
%       end
%   end
% if classify_image
%      parfor ii=1:nCountries
%         disp(['Classifying image ... for ' data.countries{ii}.name]);
%         cities = data.countries{ii}.cities;
%         for jj=1:length(cities)
%             for kk=1:length(data.countries{ii}.testcities)
%                 classifyimagetest(data.countries{ii}.name,source,cities{jj},data.countries{ii}.testcities{kk},type,method,ntrees,server)
%             end
%         end
%      end
% end
% the classify image below is modified for afrobarometer
if classify_image
     for ii=1:nCountries
        disp(['Classifying image ... for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            parfor kk=1:length(nTrees)
             classifyimage(data.countries{ii}.name,source,cities{jj},'on_Afrobarometer',type,method,nTrees(kk),server)
            end
        end
     end
end
if create_image
     for ii=1:nCountries
        disp(['Create image...for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            for kk=1:length(ntrees)
                plotlabelled(data.countries{ii}.name,cities{jj},'on_Afrobarometer', classes,cmap,lbls,server)
            end
        end
     end
end
if calc_meanIOU
    parfor ii=1:nCountries
        disp(['Create image...for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            for kk=1:length(data.countries{ii}.testcities)
                meanIOU2(data.countries{ii}.name,source,cities{jj},data.countries{ii}.testcities{kk},type,method, server)
            end
        end
     end
end
if create_all
    ground_truth =[];
    for ii=1:nCountries
         disp(['Merging all masks...currently merging ' data.countries{ii}.name]);
         ground_truth = concat_all_binary(data.countries{ii}.name,data.countries{ii}.cities,source,type,server,ground_truth);
    end
    fsave = strcat(load_inf,'All_settlements/','All/','S2/',type,'/All_ground_truth.mat');
    disp(' Saving all informal settlements binary mask ');
    save(fsave,'ground_truth');
end


