
clc
clear

addpath(genpath('./edfreadZip'))
file = 'C:\Users\cnzak\OneDrive\Desktop\PolyCortex\matlab PSG\SC4001E0-PSG.edf'; 
[hdr, record] = edfread(file); 
record1 = record(1,:);

% les données 'record' sont échantillonnés à 100 Hz, correspondant 
% à une intervalle de temps par échantillon de 0.01 s
% chaque éléments du nombre total d'intervalles de temps (correspondant au 
% nombre d'échantillons) est divisé par la fréquence en Hz afin de 
% retrouver l'intervalle de temps écoulée par échantillon
N = length(record1);
x = (1:N)/100;

figure;
grid on
plot(x(1000000:1030000), record1(1000000:1030000))
title('Activité électrique du cerveau')
xlabel('temps [s]') 
ylabel('amplitude') 
legend('EEG signal')

record1_sub = record1(1000000:1030000);

% normalisation des éléments de la TFD est effectué en divisant le résultat 
% de la fonction par le nombre d'échantillion du signal
TFD1 = fft(record1_sub)/length(record1_sub);
% la TFD est déplacé afin d'assurer que la fréquence zéro apparait à
% l'origine
TFD2 = fftshift(record1_sub);
mag = abs(TFD2);
pha = angle(TFD2);
% 1000 éléments sur une plage fréquenciel de -250 à 250
x1 = (-length(TFD2)/2:length(TFD2)/2-1)/2;

figure
subplot(211)
plot(x1, mag)
title('Magnitude du spectre')
xlabel('fréquence [Hz]')
ylabel('amplitude')
xlim([0 100])
subplot(212)
plot(x1, pha)
title('Phase du spectre')
xlabel('fréquence [Hz]')
ylabel('phase [rad]')
