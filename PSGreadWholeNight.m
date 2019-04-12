
clc
clear

addpath(genpath('./subFunctions'))
file = 'C:\Users\cnzak\Dropbox\PolyCortex\software\SleepEEG BACKUP\SC4001E0-PSG.edf'; 
hypno = 'C:\Users\cnzak\Dropbox\PolyCortex\software\SleepEEG BACKUP\SC4001EC-Hypnogram.edf';

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

% *****DATE & TIME INPUT*****
% select date here in date vector form [year month day hour minute second]
vec1_Wake = [yearNum monthNum 24 17 11 30]; %Wake Stage 30s Epoch
% vec1 = vec1_Wake;
vec1_N1 = [yearNum monthNum 25 00 44 00]; %N1 Stage 30s Epoch
% vec1 = vec1_N1;
vec1_N2 = [yearNum monthNum 25 02 31 30]; %N2 Stage 30s Epoch
% vec1 = vec1_N2;
vec1_N3 = [yearNum monthNum 25 01 09 00]; %N3 Stage 30s Epoch
% vec1 = vec1_N3;
vec1_REM = [yearNum monthNum 25 05 56 00]; %REM Stage 30s Epoch
% vec1 = vec1_REM;
vec1_whole = [yearNum monthNum 24 23 50 30]; %whole night
vec1 = vec1_whole;
%vec1 = [yearNum monthNum 25 01 09 00]; %user selected
centiSec = 5; % added centiseconds

add_cs = centiSec*secInterval/100;  
serial1 = datenum(datetime(vec1))+add_cs;

% *****TIME INTERVAL INPUT*****
% select epoch duration starting from date and time input
% *USE 30*1150 for whole night (~8 hours)
epochSec = 30*1150; % epoch time interval in seconds 

serial2 = datenum(datetime(vec1))+epochSec*secInterval;

% index of selected date and time in 'record' 
range1 = round((serial1-start_serial)/secInterval)*100; 
range2 = range1+round((serial2-serial1)/secInterval)*100; 

N2 = length(record1(range1:range2));
% x2 = (1:N2)/100; %seconds
x2 = (1:N2)/100/3600; %hours
blueLine =  rgb('RoyalBlue');
figure;
grid on
plot(x2, record1(range1:range2),'Color',blueLine)
title('Brain electrical activity')
xlabel('time (h)') 
ylabel('amplitude (\muV)') 
legend('EEG signal')
xlim([0 round(max(x2))])

% SPECTROGRAM METHOD 1
% *USE flattopwin(3000) for whole night
[y,f,t,p] = spectrogram(record1(range1:range2),flattopwin(10000),10,[],120,'yaxis');
% for uV^2 use 'p' only 
% for uV^2/Hz use 'p/100' (sampling frequency normalization)
% for dB/Hz use '10*log10(p/100)' OR '10*log10(p)' 
t = t/3600; % time in hours
figure; surf(t,f,10*log10(p),'EdgeColor','none');
colorbar
xlabel('Time (h)','FontSize',14)
ylabel('Frequency (Hz)','FontSize',14)
zlabel('Power/Frequency (dB/Hz)','FontSize',14)
% xlim([0 30])
ylim([0 60])
zlim([-40 40])
if vec1 == vec1_Wake
    title('Wake Stage 30s Epoch Spectrogram, Fpz-Cz')
elseif vec1 == vec1_N1
    title('N1 Stage 30s Epoch Spectrogram, Fpz-Cz')
elseif vec1 == vec1_N2
    title('N2 Stage 30s Epoch Spectrogram, Fpz-Cz')
elseif vec1 == vec1_N3  
    title('N3 Stage 30s Epoch Spectrogram, Fpz-Cz')
elseif vec1 == vec1_REM   
    title('REM Stage 30s Epoch Spectrogram, Fpz-Cz')
elseif vec1 == vec1_whole   
    title('Whole Night Spectrogram, Fpz-Cz','FontSize',16)
else
    title('Spectrogram, Fpz-Cz')
end
% colormap(jet)
% the colormap
redColor = rgb('Salmon');
blueColor =  rgb('RoyalBlue');
Mc = 16;
Nc = Mc*2+1; % number of colors, uneven so there is a neutral middle
rgb = [blueColor;redColor];
cmap = [linspace(rgb(1,1),rgb(2,1),Nc)' linspace(rgb(1,2),rgb(2,2),Nc)' linspace(rgb(1,3),rgb(2,3),Nc)' ];
colormap(cmap);
if epochSec == 30
    view(70,65) % 30 second epoch
else
    view(20,75) % whole night or other
end
% % SPECTROGRAM METHOD 2
% figure; spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis')
% 
% % the colormap
% redColor = rgb('Salmon');
% blueColor =  rgb('RoyalBlue');
% Mc = 16;
% Nc = Mc*2+1; % number of colors, uneven so there is a neutral middle
% rgb = [blueColor;redColor];
% cmap = [linspace(rgb(1,1),rgb(2,1),Nc)' linspace(rgb(1,2),rgb(2,2),Nc)' linspace(rgb(1,3),rgb(2,3),Nc)' ];
% colormap(cmap);
% view(70,65)
% %view(-45,65)
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
freq = 0:Fs/length(lpFilteredSignal):Fs/2;
figure; plot(freq,10*log10(P1),'b')
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

% BOUNDED LINE PLOT EXAMPLE
smoothdB = smooth(freq,10*log10(P1),0.1,'rloess');
ci = smooth(rand(size(smoothdB))*8,0.1,'rloess');
figure; boundedline(freq,smoothdB,ci, 'b')
title('Boundedline Periodogram Example')

% alpha band (8-12 Hz)
[~, alphaLimL] = min(abs(freq-8));
[~, alphaLimH] = min(abs(freq-12));
alphaAvg = mean(P1(alphaLimL:alphaLimH));

% theta band (3-7 Hz)
[~, thetaLimL] = min(abs(freq-3));
[~, thetaLimH] = min(abs(freq-7));
thetaAvg = mean(P1(thetaLimL:thetaLimH));

% delta band (0.5-2 Hz)
[~, deltaLimL] = min(abs(freq-0.5));
[~, deltaLimH] = min(abs(freq-2));
deltaAvg = mean(P1(deltaLimL:deltaLimH));

