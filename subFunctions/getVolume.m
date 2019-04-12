
function getVolume(stageData, start_serial, record1, folder, imLabel)

set(0,'DefaultFigureVisible','off');

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

% specVol = zeros(224, 224, round(totalEpochs));
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

        % SPECTROGRAM
        figure; spectrogram(record1(range1:range2),flattopwin(100),10,[],100,'yaxis')
        colormap winter
        axis off
        colorbar off
        specFrame = getframe(gca);
        specImg = specFrame.cdata;
        specBW = rgb2gray(specImg);
        specBW = imresize(specBW,[224 224]);
        currRow = rowCounter + ii;
        disp(currRow)
        %specVol(:,:, currRow) = specBW;
        
        imwrite(specBW, fullfile(folder, [imLabel '_' num2str(ii, '%04.0f') '.png']))
        
    end

    rowCounter = rowCounter + numEpoch;
    
end

% maskNum = size(specVol_W,3);
% imshow3D(specVol,[])

end
