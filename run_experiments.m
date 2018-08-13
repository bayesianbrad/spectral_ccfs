%% Defining experiment params 
testcities = {'Mumbai', 'Capetown','Capetownsmall','Lower','Kibera','Kianda', 'AlGeneina','ElDaein','Mokako','Medellin'};
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
data.countries = {southafrica, nigeria, kenya, india, sudan,colombia};
% global constants
source = 'S2';
type= 'training';
split = 0.8;
% as we are just doing binary pred
classes = 2;
% method for all 
method= 'spec2inf';
server = 'ccfs/';
nCountries= length(data.countries);
%% Set the things that you would like to do
create_binary_mask =1;
train_model = 0;
test_model =0;
classify_image =0;
create_image =0;


%% Run experiment
if create_binary_mask
    parfor ii=1:nCountries
        disp([' Creating Binary Mask... for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            spectiff_to_mat(data.countries{ii}.name,cities{jj},source,type,server);
        end
    end
end
if train_model
    parfor ii=1:nCountries
        disp([' Training model... for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            inform2spec(data.countries{ii}.name,source,cities{jj},type,method,split,data.countries{ii}.multiclass{jj}, data.countries{ii}.classmaps{jj},data.countries{ii}.classremove{jj}, ntrees,server)
        end
    end
end
  if test_model
      parfor ii=1:nCountries
        disp(['Testing model...for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            for kk=1:length(data.countries{ii}.testcities)
                predictinf2spec(data.countries{ii}.name,source,cities{jj},data.countries{ii}.testcities{kk},type,method,data.countries{ii}.multiclass{jj}, data.countries{ii}.classmaps{jj},data.countries{ii}.classremove{jj},ntrees,server);
            end
        end
      end
  end
if classify_image
     parfor ii=1:nCountries
        disp(['Classifying image ... for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            for kk=1:length(data.countries{ii}.testcities)
                classifyidmage(data.countries{ii}.name,source,cities{jj},data.countries{ii}.testcities{kk},type,method,ntrees,server)
            end
        end
     end
end
if create_image
     parfor ii=1:nCountries
        disp(['Create image...for ' data.countries{ii}.name]);
        cities = data.countries{ii}.cities;
        for jj=1:length(cities)
            for kk=1:length(data.countries{ii}.testcities)
                plotlabelled(data.countries{ii}.name,cities{jj},data.countries{ii}.testcities{kk}, classes,server)
            end
        end
     end
end


