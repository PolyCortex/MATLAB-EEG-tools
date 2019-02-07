
clc
clear

addpath(genpath('./edfreadZip'))
% file = '/Users/vincentbonnardeaux/Documents/MATLAB/SleepEEG-master/SC4001E0-PSG.edf';
file = 'C:\Users\cnzak\Dropbox\PolyCortex\software\SleepEEG\SC4001E0-PSG.edf'; 
hypno = 'C:\Users\cnzak\Dropbox\PolyCortex\software\SleepEEG\SC4001EC-Hypnogram.edf';

[hdr, record] = edfread(file); 
[hdr2, record2] = edfread(hypno);

record1 = record(1,:);

% 'record' data are sampled at 100Hz, corresponding to a time interval 
% per sample of 0.01s; each element of the total number of time slots 
% (corresponding to the number of samples) is divided by the frequency 
% in Hz in order to find the time interval elapsed per sample
N = length(record1);
x = (1:N)/100;

record7 = record(7,:);

figure;
grid on
plot(x(3000001:3003000), record1(3000001:3003000))
title('Activité électrique du cerveau')
xlabel('temps [s]') 
ylabel('amplitude') 
legend('EEG signal')

figure;
grid on
plot(x(1:7950000), record7(1:7950000))
title('Activité électrique du cerveau')
xlabel('temps [s]') 
ylabel('amplitude') 
legend('EEG signal')

% record1_sub = record1(1000001:1030000);
% 
% % normalisation des éléments de la TFD est effectué en divisant le résultat 
% % de la fonction par le nombre d'échantillion du signal
% TFD1 = fft(record1_sub)/length(record1_sub);
% % la TFD est déplacé afin d'assurer que la fréquence zéro apparait à
% % l'origine
% TFD2 = fftshift(TFD1);
% mag = abs(TFD2);
% pha = angle(TFD2);
% % 1000 éléments sur une plage fréquenciel de -250 à 250
% x1 = (-length(TFD2)/2:length(TFD2)/2-1)/2;

% figure
% subplot(211)
% plot(x1, mag)
% title('Magnitude du spectre')
% xlabel('fréquence [Hz]')
% ylabel('amplitude')
% xlim([0 100])
% subplot(212)
% plot(x1, pha)
% title('Phase du spectre')
% xlabel('fréquence [Hz]')
% ylabel('phase [rad]')

record1_sub = record1(3000001:3003000);
Fs = 100;
L = 3000;
f = Fs*(0:(L/2))/L;

% fftSignal = fft(record1_sub);
% P2 = abs(fftSignal/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% figure, plot(f,P1);

% Passe-bande 0.5-35Hz

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
P2 = abs(fftLpFiltered/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure, plot(f,P1);



% alpha band (8-12 Hz)
alphaLimL = find(f==8);
alphaLimH = find(f==12);
alphaAvg = mean(P1(alphaLimL:alphaLimH));

% theta band (3-7 Hz)
thetaLimL = find(f==3);
thetaLimH = find(f==7);
thetaAvg = mean(P1(thetaLimL:thetaLimH));

% delta band (0.5-2 Hz)
deltaLimL = find(f==0.5);
deltaLimH = find(f==2);
deltaAvg = mean(P1(deltaLimL:deltaLimH));

