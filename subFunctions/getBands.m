
function [slowWave, delta, theta, alpha, beta] = getBands(stageData, start_serial, record1)

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

stageNum = size(stageData,1)/2;
vecStage1 = zeros(1, 6);
vecStage2 = zeros(1, 6);

totalEpochs = 0;
for f = 1:stageNum

    vecStage1_1 = stageData(2*f-1, 1:6);
    vecStage2_1 = stageData(2*f, 1:6);
    epochSec_1 = 30; % epoch time interval in seconds  
    pt1Serial_1 = datenum(datetime(vecStage1_1));
    pt2Serial_1 = datenum(datetime(vecStage2_1)); 
    interSerial_1 = pt2Serial_1-pt1Serial_1;
    numEpoch_1 = interSerial_1/(epochSec_1*secInterval);
    totalEpochs = totalEpochs + numEpoch_1;
    
end

col = zeros(round(totalEpochs),1);
stageTable = table(col,col,col,col,col,...
    'VariableNames',{'slowWave' 'delta' 'theta' 'alpha' 'beta'});

rowCounter = 0;
for i = 1:stageNum
    
    vecStage1 = stageData(2*i-1, 1:6);
    vecStage2 = stageData(2*i, 1:6);
    epochSec = 30; % epoch time interval in seconds  
    pt1Serial = datenum(datetime(vecStage1));
    pt2Serial = datenum(datetime(vecStage2)); 
    interSerial = pt2Serial-pt1Serial;
    numEpoch = round(interSerial/(epochSec*secInterval));

    for ii = 1:numEpoch

        subSerialStage1 = pt1Serial+(epochSec*secInterval)*(ii-1);
        subSerialStage2 = pt1Serial+(epochSec*secInterval)*ii;
 
        % index of selected date and time in 'record'
        range1 = round((subSerialStage1-start_serial)/secInterval)*100+1;
        range2 = range1+round((subSerialStage2-subSerialStage1)/secInterval)*100-1;

%         N2 = length(record1(range1:range2));
%         x2 = (1:N2)/100;
%         figure;
%         grid on
%         plot(x2, record1(range1:range2),'b')
%         title('Brain electrical activity')
%         xlabel('time (s)')
%         ylabel('amplitude (\muV)')
%         legend('EEG signal')
%         xlim([0 round(max(x2))])
        
%         % SPECTROGRAM METHOD 1
%         % *USE flattopwin(10000) for whole night
%         [y,f,t,p] = spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis');
%         % for uV^2 use 'p' only
%         % for uV^2/Hz use 'p/100' (sampling frequency normalization)
%         % for dB/Hz use '10*log10(p/100)' OR '10*log10(p)'
%         figure; surf(t,f,10*log10(p),'EdgeColor','none');
%         colormap winter
%         view(-45,65)
        
%         % SPECTROGRAM METHOD 2
%         figure; spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis')
%         colormap winter
%         view(-45,65)
%         % view(135,65)
        
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
        P1 = P3(1:round(N/2+1)); % uV
        P0 = 10*log10(P1);
        freq = 0:Fs/length(lpFilteredSignal):Fs/2;
%         figure; plot(freq,10*log10(P1),'b')
%         grid on
%         title('Periodogram Using FFT')
%         xlabel('Frequency (Hz)')
%         ylabel('Power/Frequency (dB/Hz)')
        
%         % BOUNDED LINE PLOT EXAMPLE
%         smoothdB = smooth(freq,10*log10(P1),0.1,'rloess');
%         ci = smooth(rand(size(smoothdB))*8,0.1,'rloess');
%         figure; boundedline(freq,smoothdB,ci, 'b')
%         title('Boundedline Periodogram')
%         grid on
%         xlabel('Frequency (Hz)')
%         ylabel('Power/Frequency (dB/Hz)')

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

        currRow = rowCounter + ii;
        
        if round(currRow) == 1020
            a = 1;
        end
        
        stageTable{round(currRow),'slowWave'} = slowAvg;
        stageTable{round(currRow),'delta'}  = deltaAvg;
        stageTable{round(currRow),'theta'} = thetaAvg;
        stageTable{round(currRow),'alpha'} = alphaAvg;
        stageTable{round(currRow),'beta'} = betaAvg;
            
    end

    rowCounter = rowCounter + numEpoch;
    
end

slowWave = stageTable.slowWave;
delta = stageTable.delta;
theta = stageTable.theta;
alpha = stageTable.alpha;
beta = stageTable.beta;

end
