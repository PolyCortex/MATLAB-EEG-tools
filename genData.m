
clc
clear

addpath(genpath('./subFunctions'))
file = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\SC4001E0-PSG.edf'; 
hypno = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\SC4001EC-Hypnogram.edf';

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
stageWake = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\wake.csv';
stageS1 = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\n1.csv';
stageS2 = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\n2.csv';
stageS3 = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\n3.csv';
stageS4 = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\n4.csv';
stageREM = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\hypnogram\REM.csv';
dataWake = xlsread(stageWake);
dataN1 = xlsread(stageS1);
dataN2 = xlsread(stageS2);
dataN3 = [xlsread(stageS3); xlsread(stageS4)];
dataREM = xlsread(stageREM);

desFolder = 'C:\Users\cnzak\OneDrive\Desktop\Audio & Video\PolyCortex\SleepEEG\trainingDataset';
imLabel1 = '1_wakeData';
imLabel2 = '2_n1Data';
imLabel3 = '3_n2Data';
imLabel4 = '4_n3Data';
imLabel5 = '5_remData';
getVolume(dataWake, start_serial, record1, desFolder, imLabel1);
getVolume(dataN1, start_serial, record1, desFolder, imLabel2);
getVolume(dataN2, start_serial, record1, desFolder, imLabel3);
getVolume(dataN3, start_serial, record1, desFolder, imLabel4);
getVolume(dataREM, start_serial, record1, desFolder, imLabel5);
