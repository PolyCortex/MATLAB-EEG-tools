
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

save('sleepEEG.mat','dataWake','dataN1','dataN2','dataN3', 'dataREM')
load('sleepEEG.mat')

[slowWave_W, delta_W, theta_W, alpha_W, beta_W] = getBands(dataWake, start_serial, record1);
[slowWave_N1, delta_N1, theta_N1, alpha_N1, beta_N1] = getBands(dataN1, start_serial, record1);
[slowWave_N2, delta_N2, theta_N2, alpha_N2, beta_N2] = getBands(dataN2, start_serial, record1);
[slowWave_N3, delta_N3, theta_N3, alpha_N3, beta_N3] = getBands(dataN3, start_serial, record1);
[slowWave_REM, delta_REM, theta_REM, alpha_REM, beta_REM] = getBands(dataREM, start_serial, record1);

%***Median Feature Vectors***
% For a continuous probability distribution, the median is the value such 
% that a number is equally likely to fall above or below it.
stageMedW = median([slowWave_W delta_W theta_W alpha_W beta_W]);
stageMedN1 = median([slowWave_N1 delta_N1 theta_N1 alpha_N1 beta_N1]);
stageMedN2 = median([slowWave_N2 delta_N2 theta_N2 alpha_N2 beta_N2]);
stageMedN3 = median([slowWave_N3 delta_N3 theta_N3 alpha_N3 beta_N3]);
stageMedREM = median([slowWave_REM delta_REM theta_REM alpha_REM beta_REM]);

% use 'help violin' command for modifications to the plot

% WAKE DATA VIOLIN PLOT

vio_W{:,1} = slowWave_W;
vio_W{:,2} = delta_W;
vio_W{:,3} = theta_W;
vio_W{:,4} = alpha_W;
vio_W{:,5} = beta_W;

figure;[h,L,MX,MED]=violin(vio_W,'xlabel',{'slow wave','delta','theta',...
    'alpha','beta'},'facecolor',[1 0 0;1 0 0;1 0 0;1 0 0;1 0 0], 'edgecolor', [],'mc',[],'medc',[]);
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (dB/Hz)','FontSize',14)
title('Wake Stage Frequency Distribution, Fpz-Cz')
set(L,'visible','off')

% N1 DATA VIOLIN PLOT

vio_N1{:,1} = slowWave_N1;
vio_N1{:,2} = delta_N1;
vio_N1{:,3} = theta_N1;
vio_N1{:,4} = alpha_N1;
vio_N1{:,5} = beta_N1;

figure;[h,L,MX,MED]=violin(vio_N1,'xlabel',{'slow wave','delta','theta',...
    'alpha','beta'},'facecolor',[0 0 1;0 0 1;0 0 1;0 0 1;0 0 1], 'edgecolor', [],'mc',[],'medc',[]);
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (dB/Hz)','FontSize',14)
title('N1 Stage Frequency Distribution, Fpz-Cz')
set(L,'visible','off')

% N2 DATA VIOLIN PLOT

vio_N2{:,1} = slowWave_N2;
vio_N2{:,2} = delta_N2;
vio_N2{:,3} = theta_N2;
vio_N2{:,4} = alpha_N2;
vio_N2{:,5} = beta_N2;

figure;[h,L,MX,MED]=violin(vio_N2,'xlabel',{'slow wave','delta','theta',...
    'alpha','beta'},'facecolor',[0 0 1;0 0 1;0 0 1;0 0 1;0 0 1], 'edgecolor', [],'mc',[],'medc',[]);
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (dB/Hz)','FontSize',14)
title('N2 Stage Frequency Distribution, Fpz-Cz')
set(L,'visible','off')

% N3 DATA VIOLIN PLOT

vio_N3{:,1} = slowWave_N3;
vio_N3{:,2} = delta_N3;
vio_N3{:,3} = theta_N3;
vio_N3{:,4} = alpha_N3;
vio_N3{:,5} = beta_N3;

figure;[h,L,MX,MED]=violin(vio_N3,'xlabel',{'slow wave','delta','theta',...
    'alpha','beta'},'facecolor',[0 0 1;0 0 1;0 0 1;0 0 1;0 0 1], 'edgecolor', [],'mc',[],'medc',[]);
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (dB/Hz)','FontSize',14)
title('N3 Stage Frequency Distribution, Fpz-Cz')
set(L,'visible','off')

% REM DATA VIOLIN PLOT

vio_REM{:,1} = slowWave_REM;
vio_REM{:,2} = delta_REM;
vio_REM{:,3} = theta_REM;
vio_REM{:,4} = alpha_REM;
vio_REM{:,5} = beta_REM;

figure;[h,L,MX,MED]=violin(vio_REM,'xlabel',{'slow wave','delta','theta',...
    'alpha','beta'},'facecolor',[0.3010 0.7450 0.9330;0.3010 0.7450 0.9330;0.3010 0.7450 0.9330;0.3010 0.7450 0.9330;0.3010 0.7450 0.9330], 'edgecolor', [],'mc',[],'medc',[]);
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (dB/Hz)','FontSize',14)
title('REM Stage Frequency Distribution, Fpz-Cz')
set(L,'visible','off')

%% CLASSIFICATION TEST

% obtain seconds, minutes and hours intervals for serial date operations
pt1 = datenum(datetime([2019 02 14 16 20 00]));
pt2 = datenum(datetime([2019 02 14 16 20 01]));
pt3 = datenum(datetime([2019 02 14 16 21 00]));
pt4 = datenum(datetime([2019 02 14 17 20 00]));
pt5 = datenum(datetime([2019 02 15 16 20 00]));
secInterval = pt2-pt1; 
minInterval = pt3-pt1;
hrInterval = pt4-pt1;
dayInterval = pt5-pt1;

% conversion from 'hdr' start date and time to date vector with the form
% [year month day hour minute second]
startVec = [yearNum monthNum dayNum hourNum minuteNum secondNum];    
% conversion from date vector to datetime
start_dt = datetime(startVec);
start_serial = datenum(start_dt);

% *****DATE & TIME INPUT*****
% select date here in date vector form [year month day hour minute second]
vec1 = [yearNum monthNum 25 01 09 00];
centiSec = 5; % added centiseconds

add_cs = centiSec*secInterval/100;  
serial1 = datenum(datetime(vec1))+add_cs;

% *****TIME INTERVAL INPUT*****
% select epoch duration starting from date and time input
% *USE 30*1000 for whole night (~8 hours)
epochSec = 30; % epoch time interval in seconds 

serial2 = datenum(datetime(vec1))+epochSec*secInterval;

% index of selected date and time in 'record' 
range1 = round((serial1-start_serial)/secInterval)*100; 
range2 = range1+round((serial2-serial1)/secInterval)*100; 

% N2 = length(record1(range1:range2));
% x2 = (1:N2)/100; 
% figure;
% grid on
% plot(x2, record1(range1:range2),'b')
% title('Brain electrical activity')
% xlabel('time (s)') 
% ylabel('amplitude (\muV)') 
% legend('EEG signal')
% xlim([0 round(max(x2))])

% % SPECTROGRAM METHOD 1
% % *USE flattopwin(10000) for whole night
% [y,f,t,p] = spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis');
% % for uV^2 use 'p' only 
% % for uV^2/Hz use 'p/100' (sampling frequency normalization)
% % for dB/Hz use '10*log10(p/100)' OR '10*log10(p)' 
% figure; surf(t,f,10*log10(p),'EdgeColor','none');
% colormap winter
% view(-45,65)
% 
% % SPECTROGRAM METHOD 2
% figure; spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis')
% colormap winter
% view(-45,65)
% % view(135,65)

% BANDPASS FILTER 0.5-35Hz
record1_sub = record1(range1:range2);
% MATLAB uses the convention that unit frequency is the Nyquist frequency, 
% defined as half the sampling frequency. The cutoff frequency parameter 
% for all basic filter design functions is normalized by the Nyquist 
% frequency. For a system with a 100 Hz sampling frequency, 0.3 Hz is 
% 0.3/50
normalizedCutFreq = 0.3/50;
hpFilter = fir1(400,normalizedCutFreq,'high');
hpFilteredSignal = filter(hpFilter,1,record1_sub);
% fftHpFiltered = fft(hpFilteredSignal);
% P2 = abs(fftHpFiltered/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
%figure, plot(f,P1);
normalizedLPcutFreq = 35/50;
lpFilter = fir1(400,normalizedLPcutFreq,'low');
lpFilteredSignal = filter(lpFilter,1,hpFilteredSignal);
fftLpFiltered = fft(lpFilteredSignal);

N = length(lpFilteredSignal);
Fs = 100; % sampling frequency
P3 = (1/(Fs*N)) * abs(fftLpFiltered).^2;
P3(2:end-1) = 2*P3(2:end-1);
P1 = P3(1:N/2+1); % uV
P0 = 10*log10(P1);
freq = 0:Fs/length(lpFilteredSignal):Fs/2;
% figure; plot(freq,P0,'b')
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% % BOUNDED LINE PLOT EXAMPLE
% smoothdB = smooth(freq,10*log10(P1),0.1,'rloess');
% ci = smooth(rand(size(smoothdB))*8,0.1,'rloess');
% figure; boundedline(freq,smoothdB,ci, 'b')
% title('Boundedline Periodogram')
% grid on
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')

% slow wave band (0.5-2.0 Hz)
[~, slowLimL] = min(abs(freq-0.5));
[~, slowLimH] = min(abs(freq-2));
slowAvg = mean(P0(slowLimL:slowLimH));

% delta band (0-3.99 Hz)
[~, deltaLimL] = min(abs(freq-0));
[~, deltaLimH] = min(abs(freq-3.99));
deltaAvg = mean(P0(deltaLimL:deltaLimH));

% theta band (3-7 Hz)
[~, thetaLimL] = min(abs(freq-3));
[~, thetaLimH] = min(abs(freq-7));
thetaAvg = mean(P0(thetaLimL:thetaLimH));

% alpha band (8-13 Hz)
[~, alphaLimL] = min(abs(freq-8));
[~, alphaLimH] = min(abs(freq-12));
alphaAvg = mean(P0(alphaLimL:alphaLimH));

% beta band (3-7 Hz)
[~, betaLimL] = min(abs(freq-13));
[~, betaLimH] = min(abs(freq-20));
betaAvg = mean(P0(betaLimL:betaLimH));

epochBands = [slowAvg deltaAvg thetaAvg alphaAvg betaAvg];

scoreW = sum(abs(epochBands - stageMedW));
scoreN1 = sum(abs(epochBands - stageMedN1));
scoreN2 = sum(abs(epochBands - stageMedN2)); 
scoreN3 = sum(abs(epochBands - stageMedN3)); 
scoreREM = sum(abs(epochBands - stageMedREM));

[~, stageInd] = min([scoreW scoreN1 scoreN2 scoreN3 scoreREM]);
if stageInd == 1
    disp('Wake');
    classStage = 'Wake';
elseif stageInd == 2
    disp('N1');
    classStage = 'N1';
elseif stageInd == 3
    disp('N2');
    classStage = 'N2';
elseif stageInd == 4
    disp('N3');
    classStage = 'N3';
elseif stageInd == 5
    disp('REM');
    classStage = 'REM';
end

figure
name = {'slow wave';'delta';'theta';'alpha';'beta'};
data = [slowAvg, deltaAvg, thetaAvg, alphaAvg, betaAvg];
hb = bar(data);
set(hb, 'FaceColor',[0.5 0.5 0.5])
title({'Epoch Frequency Averages, Fpz-Cz', ['Classification : ' classStage]})
ylim([-20 30])
xlabel('Frequency Band')
ylabel('Power/Frequency (db/Hz)')
grid('on')
set(gca,'xticklabel',name)