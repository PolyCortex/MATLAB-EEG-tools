
clc
clear

addpath(genpath('./subFunctions'))
muse2Folder = 'C:\Users\cnzak\Dropbox\Shared Files\GBM3100\software\SleepEEG\subFunctions\muse1_4';
muse2Test_1 = fullfile(muse2Folder, 'testFinalCalculs.csv');
% muse1Test_2 = fullfile(muse1Folder, '5minOuvert2.csv');

muse2Data_1 = importMuse2(muse2Test_1, 2, inf);
% muse1Data_2 = importMuse2(muse2Test, 2, inf);

record1 = muse2Data_1.RAW_AF7';
record1 = record1-nanmean(record1); % values centered at zero

% numNAN = sum(isnan(a)); % get the total number of NAN values in the array

% START POINT & EPOCH LENGTH INPUT (SECONDS)
startTime_1 = 30; % start point from begginning of recording (s)
epochTime_1 = 60*2; % epoch length from start point (s)

% % START POINT & EPOCH LENGTH INPUT (SECONDS)
% startTime_2 = 1; % start point from begginning of recording (s)
% epochTime_2 = 60*4.5; % epoch length from start point (s)

% Data from 'record' is sampled at 256 Hz which corresponds to a time 
% interval of 0.0039 s. A vector array representing time and which is the 
% same length as 'record' is created, each element corresponding 
% the a 0.0039s time interval (by dividing each integer element 
% by the sampling frequency) 
Fs = 256; % sampling frequency
N = length(record1);
x = (1:N)/Fs; 

% indexes of selected epoch in 'record' 
range1 = 1+startTime_1*Fs; 
range2 = range1+epochTime_1*Fs; 
record1_sub = record1(range1:range2); % unfiltered signal in time domain
N2 = length(record1_sub);

% time vector in seconds, /60 to obtain minutes, etc.
x2 = (1:N2)/Fs; 

% BANDPASS FILTER 0.5-35Hz
% MATLAB uses the convention that unit frequency is the Nyquist frequency, 
% defined as half the sampling frequency. The cutoff frequency parameter 
% for all basic filter design functions is normalized by the Nyquist 
% frequency. For a system with a 256 Hz sampling frequency, 0.3 Hz is 
% 0.3/(256/2)
normalizedHPCutFreq = 0.3/(Fs/2);
hpFilter = fir1(400,normalizedHPCutFreq,'high');
hpFilteredSignal = filter(hpFilter,1,record1_sub);
normalizedLPcutFreq = 35/(Fs/2);
lpFilter = fir1(400,normalizedLPcutFreq,'low');
lpFilteredSignal = filter(lpFilter,1,hpFilteredSignal);

figure;
grid on
plot(x2, record1_sub,'b')
title('Brain electrical activity')
xlabel('time (min)') 
ylabel('amplitude (\muV)') 
legend('EEG signal')
xlim([0 round(max(x2))])

% FREQUENCY SPECTRUM OVER THE EPOCH LENGTH 
fftLpFiltered = fft(lpFilteredSignal);
N = length(lpFilteredSignal);
P3 = (1/(Fs*N)) * abs(fftLpFiltered).^2;
P3(2:end-1) = 2*P3(2:end-1);
P1 = P3(1:N/2+1); % uV
freq = 0:Fs/length(lpFilteredSignal):Fs/2;
% smoothP1 = smoothdata(P1, 'loess', 150);
smoothP1 = smoothdata(10*log10(P1), 'loess', 150);




figure; plot(freq,smoothP1,'b')
grid on
xlim([0 50])
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

% SPECTROGRAM METHOD 1
% *USE flattopwin(10000) for whole night
[y,f,t,p] = spectrogram(record1_sub,flattopwin(400),10,[],Fs,'yaxis');
% for uV^2 use 'p' only 
% for uV^2/Hz use 'p/Fs' (sampling frequency normalization)
% for dB/Hz use '10*log10(p/Fs)' OR '10*log10(p)' 
figure; surf(t,f,10*log10(p/Fs),'EdgeColor','none');
colormap jet
ylim([0 60])
% view(-45,65)

% SPECTROGRAM METHOD 2
figure; spectrogram(record1_sub,flattopwin(400),10,[],Fs,'yaxis')
colormap jet
ylim([0 60])
% view(-45,65)
% view(135,65)

% % BOUNDED LINE PLOT EXAMPLE
% smoothdB = smooth(freq,10*log10(P1),0.1,'rloess');
% ci = smooth(rand(size(smoothdB))*8,0.1,'rloess');
% figure; boundedline(freq,smoothdB,ci, 'b')
% title('Boundedline Periodogram')
% grid on
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% 
% % alpha band (8-12 Hz)
% [~, alphaLimL] = min(abs(freq-8));
% [~, alphaLimH] = min(abs(freq-12));
% alphaAvg = mean(P1(alphaLimL:alphaLimH));
% 
% % theta band (3-7 Hz)
% [~, thetaLimL] = min(abs(freq-3));
% [~, thetaLimH] = min(abs(freq-7));
% thetaAvg = mean(P1(thetaLimL:thetaLimH));
% 
% % delta band (0.5-2 Hz)
% [~, deltaLimL] = min(abs(freq-0.5));
% [~, deltaLimH] = min(abs(freq-2));
% deltaAvg = mean(P1(deltaLimL:deltaLimH));

