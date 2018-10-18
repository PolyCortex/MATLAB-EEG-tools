
clc
clear

addpath(genpath('./edfreadZip'))
file = 'C:\Users\cnzak\OneDrive\Desktop\PolyCortex\matlab PSG\SC4001E0-PSG.edf'; 
[hdr, record] = edfread(file); 
record1 = record(1,:);

% les donn�es 'record' sont �chantillonn�s � 100 Hz, correspondant 
% � une intervalle de temps par �chantillon de 0.01 s
% chaque �l�ments du nombre total d'intervalles de temps (correspondant au 
% nombre d'�chantillons) est divis� par la fr�quence en Hz afin de 
% retrouver l'intervalle de temps �coul�e par �chantillon
N = length(record1);
x = (1:N)/100;

figure;
grid on
plot(x(1000000:1030000), record1(1000000:1030000))
title('Activit� �lectrique du cerveau')
xlabel('temps [s]') 
ylabel('amplitude') 
legend('EEG signal')

record1_sub = record1(1000000:1030000);

% normalisation des �l�ments de la TFD est effectu� en divisant le r�sultat 
% de la fonction par le nombre d'�chantillion du signal
TFD1 = fft(record1_sub)/length(record1_sub);
% la TFD est d�plac� afin d'assurer que la fr�quence z�ro apparait �
% l'origine
TFD2 = fftshift(record1_sub);
mag = abs(TFD2);
pha = angle(TFD2);
% 1000 �l�ments sur une plage fr�quenciel de -250 � 250
x1 = (-length(TFD2)/2:length(TFD2)/2-1)/2;

figure
subplot(211)
plot(x1, mag)
title('Magnitude du spectre')
xlabel('fr�quence [Hz]')
ylabel('amplitude')
xlim([0 100])
subplot(212)
plot(x1, pha)
title('Phase du spectre')
xlabel('fr�quence [Hz]')
ylabel('phase [rad]')
