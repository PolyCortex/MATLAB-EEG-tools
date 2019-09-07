
clc
clear

addpath(genpath('./subFunctions'))
file = 'SC4001E0-PSG.edf'; 
hypno = 'SC4001EC-Hypnogram.edf';

[hdr, record] = edfread(file); 
[hdr2, record2] = edfread(hypno);

% 'hdr.label' indicates that the first row of 'record' corresponds to the
% Fpz-Cz EEG derivation
record1 = record(1,:)*-1;

% Data from 'record' is sampled at 100 Hz which corresponds to a time 
% interval of 0.01 s. A vector array representing time and which is the 
% same length as 'record' is created, each element corresponding 
% the a 0.01s time interval (by dividing each integer element 
% by the sampling frequency) 
N = length(record1);
x = (1:N)/100; 

% 'hdr' start date and time assignment to variables
startDate = hdr.startdate;
startTime = hdr.starttime;

yearNum = 1900+str2num(startDate(7:8));
monthNum = str2num(startDate(4:5));
dayNum = str2num(startDate(1:2));
hourNum = str2num(startTime(1:2));
minuteNum = str2num(startTime(4:5));
secondNum = str2num(startTime(7:8));
% conversion from 'hdr' start date and time to date vector with the form
% [year month day hour minute second]
startVec = [yearNum monthNum dayNum hourNum minuteNum secondNum];    
% conversion from date vector to datetime
start_dt = datetime(startVec);
start_serial = datenum(start_dt);

% load hypnogram date and time data from '.csv' files and assign to
% variables
stageWake = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\wake.csv';
stageS1 = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\n1.csv';
stageS2 = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\n2.csv';
stageS3 = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\n3.csv';
stageS4 = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\n4.csv';
stageREM = 'C:\Users\cnzak\Dropbox\PolyCortex\SleepEEG\subFunctions\hypnogram\REM.csv';
dataWake = xlsread(stageWake);
dataN1 = xlsread(stageS1);
dataN2 = xlsread(stageS2);
dataN3 = [xlsread(stageS3); xlsread(stageS4)];
dataREM = xlsread(stageREM);

% save('sleepEEG.mat','dataWake','dataN1','dataN2','dataN3', 'dataREM')
% load('sleepEEG.mat')

[slowWave_W, delta_W, theta_W, alpha_W, beta_W] = getBands(dataWake, start_serial, record1);
[slowWave_N1, delta_N1, theta_N1, alpha_N1, beta_N1] = getBands(dataN1, start_serial, record1);
[slowWave_N2, delta_N2, theta_N2, alpha_N2, beta_N2] = getBands(dataN2, start_serial, record1);
[slowWave_N3, delta_N3, theta_N3, alpha_N3, beta_N3] = getBands(dataN3, start_serial, record1);
[slowWave_REM, delta_REM, theta_REM, alpha_REM, beta_REM] = getBands(dataREM, start_serial, record1);

% data for ML algorithm is structured below
wake_Array = [slowWave_W delta_W theta_W alpha_W beta_W];
N1_Array = [slowWave_N1 delta_N1 theta_N1 alpha_N1 beta_N1];
N2_Array = [slowWave_N2 delta_N2 theta_N2 alpha_N2 beta_N2];
N3_Array = [slowWave_N3 delta_N3 theta_N3 alpha_N3 beta_N3];
REM_Array = [slowWave_REM delta_REM theta_REM alpha_REM beta_REM];

% ML features input
wake_Array2 = wake_Array(1:50,:);
N1_Array2 = N1_Array(1:50,:);
N2_Array2 = N2_Array(1:50,:);
N3_Array2 = N3_Array(1:50,:);
REM_Array2 = REM_Array(1:50,:);
% equivalent of 'meas' below
training_Array = [wake_Array2; N1_Array2; N2_Array2; N3_Array2; REM_Array2];    
% ML labels input; equivalent of 'meas' below
end0 = size(wake_Array2,1);
for i = 1:end0
    training_Labels{i,1} = 'wake';
end
start1 = end0 + 1;
end1 = end0 + size(N1_Array2,1);
for ii = start1:end1
    training_Labels{ii,1} = 'N1';
end
start2 = end1 + 1;
end2 =  end1 + size(N2_Array2,1);
for k = start2:end2
    training_Labels{k,1} = 'N2';
end
start3 = end2 + 1;
end3 = end2 + size(N2_Array2,1);
for kk = start3:end3
    training_Labels{kk,1} = 'N3';
end
start4 = end3 + 1;
end4 = end3 + size(REM_Array2,1);   
for g = start4:end4
    training_Labels{g,1} = 'REM';
end

load fisheriris

% 'X' represents the numeric matrix of training data, with features for each 
% observation in the form : 
% [(petal length) (petal width) (sepal length) (sepal width)]
% X = meas;
X = training_Array;

% 'Y' are predicted responses (labels) as a function of observations in X
% Y = species;
Y = training_Labels;

% 'treesCount' is the number of decision trees for predicting response Y 
% as a function X
treesCount = 60;

[BaggedEnsemble, nodeLevels, nodeAngles, nodeProp, nodeParents] = generic_random_forests(X,Y,treesCount,'classification');

n = max(nodeLevels);
M = randomPythagor_tree(n, nodeLevels, nodeAngles, nodeParents, 'cool');

% % function 'predict(Mdl,X)' returns a vector of predicted class labels for 
% % the predictor data in the table or matrix 'X', based on the trained 
% % discriminant analysis classification model 'Mdl'
% predict(BaggedEnsemble, wake_Array(57,:))
% predict(BaggedEnsemble, N1_Array(57,:))
% predict(BaggedEnsemble, N2_Array(63,:))
% predict(BaggedEnsemble, N3_Array(67,:))
% predict(BaggedEnsemble, REM_Array(55,:))

imp = BaggedEnsemble.OOBPermutedPredictorDeltaError;

figure;
bar(imp);
title('Curvature Test');
ylabel('Predictor importance estimates');
xlabel('Predictors');
h = gca;
h.XTickLabel = BaggedEnsemble.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

% Out-of-bag (OOB) is the mean prediction error on each training sample, 
% xi, using only the trees that did not have xi in their bootstrap sample.

