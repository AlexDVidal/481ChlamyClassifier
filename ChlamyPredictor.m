%% Reset for clean run
clear all
close all

%% Get a list of all data files
dataDirectory = 'TestData\';
rawFiles = dir(dataDirectory);
rawFiles = rawFiles(3:end); %first two entries are always '.' and '..'
testFeat = load('TestFeatures.mat');
testFeat = testFeat.testFeatures';
test = array2table(testFeat, 'VariableNames', {'XMean', 'XStd', 'YMean', 'YStd', 'RMean', 'RStd', ...
    'X50Amp', 'X50Phase','X100Amp', 'X100Phase','X150Amp', 'X150Phase','X200Amp', 'X200Phase','X250Amp', 'X250Phase', ...
    'X300Amp', 'X300Phase','X350Amp', 'X350Phase','X400Amp', 'X400Phase','X450Amp', 'X450Phase','X500Amp', 'X500Phase', ...
    'Y50Amp', 'Y50Phase','Y100Amp', 'Y100Phase','Y150Amp', 'Y150Phase','Y200Amp', 'Y200Phase','Y250Amp', 'Y250Phase', ...
    'Y300Amp', 'Y300Phase','Y350Amp', 'Y350Phase','Y400Amp', 'Y400Phase','Y450Amp', 'Y450Phase','Y500Amp', 'Y500Phase'});

class = cell(size(test,1),1);
for index = 1:length(class)
    class{index} = '';
end
test = addvars(test,class);

model = load('TrainedEnsembleModel.mat');
model = model.trained_model;

%% Setup of windowing and recording
sampleRate = 50000;
window = .2; 
windowSamples = window*sampleRate;

%% Setup of recording
imageIndex = 1;
f1 = figure;
ax = gca;        
ax.XLim = [-35 35];
ax.YLim = [-35 35];
txt = text(-32, 32, "", 'Interpreter', 'none');

%% Ploting and recording
hold on
h = plot(0, 0);
imageIndex = 1;
for file = 1:length(rawFiles)
    r = load([rawFiles(file).folder filesep rawFiles(file).name]);
    r = r(:,1:2); %columns 1 and 2 are the force measurments in x and y
    %correct for instrument bias
    r(:,1) = r(:,1) - mean(r(:,1));
    r(:,2) = r(:,2) - mean(r(:,2));
    
    %%
    for index = 1:windowSamples:length(r(:,1))-windowSamples
        pred = predict(model, test(imageIndex,:));
        set(h,'XData',r(index:index+windowSamples-1,1),'YData',r(index:index+windowSamples-1,2));
        txt.String = num2str((index-1)/sampleRate) + "s    Prediction:" + pred(1);
        M(imageIndex) = getframe;
        imageIndex = imageIndex + 1;
        drawnow
    end %for windowSamples
end %for files
hold off

%% Create video for frame by frame inspection
v = VideoWriter('ClassificationVideo.avi');
open(v);
writeVideo(v, M);
close(v);