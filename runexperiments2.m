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
server =   '/Users/bradley/Documents/Projects/Team2_FDL/synthesis-generate-spectrum/ccfs/';
source = 'S2';
type= 'training';
split = 0.8;
% as we are just doing binary pred
classes = 7;
% method for all 
method= 'spec2mat';
lbls = {'Environment', 'Metal', 'Tiles','Shingles','Thatch', 'Plastic', 'Asbestos'};
cmap = [0 1 0 0 1 0 0;
        0 1 0 1 0 0 0; 
        0 0 0 1 0 0 0];
%% Set the things that you would like to do
create_binary_mask =0;
train_model =  0;
test_model =0;
classify_image =0;
create_image =1;
calc_meanIOU = 0;
create_all =0;
ntrees = [25 200];
legend_true=0; %plot legend 1 , else 0
predict = 1; % Train and test on same city
nCountries = length(data.countries);
if classify_image
     for ii=1:nCountries
        disp(['Classifying image ... for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            parfor kk=1:length(ntrees)
             classifyimage(data.countries{ii}.name,source,cities{jj},'on_Afrobarometer',type,method,ntrees(kk),server)
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
                plotlabelled(data.countries{ii}.name,cities{jj},'on_Afrobarometer', classes,method,cmap,lbls,ntrees(kk),legend_true,server)

            end
        end
     end
end
