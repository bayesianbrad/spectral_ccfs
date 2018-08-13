function predictinf2spec(country,source,city,testcity,type,method,multiclass, class_map,classes_remove,ntrees,server)
% Performs a prediction on the given test set and saves the metrics: IOU,
% classification percentage of informal, classification percentage of 
% environment. 

% Inputs
% multiclass - int [1 = true, 0 = false] If multiclass, will relabel all labels to be either 
%               1 for informal or 0 for everything else. Specified by
%               class map
% country - str of country name 
% source - str of either 'S2' or 'DG'
% city - str of city name
% testcity - the pre-trained citymodel used for testing
% type - str either 'test' or 'training'
% method     - str either 'spec2imf' or 'spec2mat'
% class_map - array that represents a mapping from the original class
% values to new class values i.e class_map = [3 2 1 5; 0 0 0 1];
% classes_remove - array of classes to be removed.

if ~exist('multiclass','var')
    multiclass = 0;
end
if ~exist('classes_remove','var')
    classes_remove = [];
end
if ~exist('class_map','var')
    class_map = [];
end
if ~exist('server','var')
    server='';
end
if strcmp(testcity,city)
    disp(' Test city is equal to city, not allowed. Exiting...');
    return
end
baseModel = strcat(server,'model/');
fload = strcat(baseModel,method,'/pre_trained_',testcity,'_with_',num2str(ntrees),'trees.mat');
CCF = load(fload);

baseTest = strcat(server,'Training_sets_and_ground_truth/informal_classification/');
endf = strcat(city,'_ground_truth.mat');
ftest = strcat(baseTest,country,'/',city,'/',source,'/',type,'/',endf);
alldata = load(ftest);
alldata = alldata.ground_truth;
spectrum = alldata(:,1:10);
classes = alldata(:,11);

%% Normalise data to be zero mean and variance 1

spectrum = center_data(spectrum);

%% Transpose and concat arrays into one array for testing
spectrum = [spectrum, classes];

if multiclass==1
    %% Remove unecessary classes
%     classes_remove = [4 6];
    spectrum = remove_classes(spectrum, classes_remove, 11);
    %% Replace classes
    spectrum = remove_replace(spectrum,class_map);
end


%% Test model
disp(['CCF prediction on ', city]);
YpredCCF = predictFromCCF(CCF,spectrum(:,1:10));
YTest = spectrum(:,11);
disp(['CCF Test missclassification rate (lower better) ' num2str(100*(1-mean(mean(YTest==(YpredCCF))))) '%']);
f1=YTest == 1;
classification1 = sum(sum(YTest(f1) == YpredCCF(f1))) / sum(sum(f1)) ;
% disp(['The classification rate for informal settlements is :' num2str(classification1) '%']);
f0=YTest == 0;
classification0 = sum(sum(YTest(f0) == YpredCCF(f0))) / sum(sum(f0));
% disp(['The classification rate for formal settlements is :' num2str(classification0) '%']);
true_positive = sum(sum(YTest == YpredCCF));
false_negative_p_false_positives = sum(sum( abs(YTest - YpredCCF)));
IOU = true_positive / (false_negative_p_false_positives+ true_positive);

metrics = cell(3,2);
metrics{1,1}='mean IOU :';
metrics{1,2} = IOU;
metrics{2,1}='Informal classification : ';
metrics{2,2}= classification1;
metrics{3,1}= 'Environment classification : ' ;
metrics{3,2} = classification0;

fmetric = strcat(server,'predictions/',country,'/',city,'/','prediction_with_',testcity,'_metrics.dat');
fileID = fopen(fmetric,'w');
formatSpec = '%s %.5f \n';
[nrows,ncols] = size(metrics);
for row = 1:nrows
    fprintf(fileID,formatSpec,metrics{row,:});
end

fclose(fileID);

end

