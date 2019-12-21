%% Reset for clean run
clear all
close all

%% Get a list of all data files
trainDirectory = 'TrainData\';
testDirectory = 'TestData\';
trainFiles = dir(trainDirectory);
trainFiles = trainFiles(3:end); %first two entries are always '.' and '..'
testFiles = dir(testDirectory);
testFiles = testFiles(3:end); %first two entries are always '.' and '..'

%% Setup of windowing and recording
sampleRate = 50000; %hertz
window = .2; %seconds
windowSamples = window*sampleRate; %samples in a window

%% Feature set parameters
%Features to extract: X,Y,R-mean and std, amp and phase of x/y spectrogram
%500Hz
nTrainSamples = 1;
nTestSamples = 1;
overlap = 0;
numFFT = 1000; %breaks spectrogram bins into ~50 Hz, therefore 20 each in x/y
nFeatures = 46;

%% Extract training features
trainFeatures = zeros(nFeatures, 1);
for file = 1:length(trainFiles)
    d = load([trainFiles(file).folder filesep trainFiles(file).name]);
    %correct for instrument bias by subtracting mean from x/y in reference
    %to whole dataset
    x = d(:,1) - mean(d(:,1));
    y = d(:,2) - mean(d(:,2));
    r = sqrt(x.^2 + y.^2);
    sx = spectrogram(x, windowSamples, overlap, numFFT, sampleRate, 'yaxis');
    sy = spectrogram(y, windowSamples, overlap, numFFT, sampleRate, 'yaxis');
    
    windowIndex = 1;
    for index = 1:windowSamples:length(r(:,1))-windowSamples
        %statistics extraction
        trainFeatures(1,nTrainSamples) = mean(x(index:index+windowSamples-1));
        trainFeatures(2,nTrainSamples) = std(x(index:index+windowSamples-1));
        trainFeatures(3,nTrainSamples) = mean(y(index:index+windowSamples-1));
        trainFeatures(4,nTrainSamples) = std(x(index:index+windowSamples-1));
        trainFeatures(5,nTrainSamples) = mean(r(index:index+windowSamples-1));
        trainFeatures(6,nTrainSamples) = std(r(index:index+windowSamples-1));
        
        %phase and amplitude of x spectrogram to 500Hz
        trainFeatures(7:16,nTrainSamples) = abs(sx(1:10,windowIndex));
        trainFeatures(17:26,nTrainSamples) = angle(sx(1:10,windowIndex));
        
        %phase and amplitude of y spectrogram to 500Hz
        trainFeatures(27:36,nTrainSamples) = abs(sy(1:10,windowIndex));
        trainFeatures(37:46,nTrainSamples) = angle(sy(1:10,windowIndex));
        windowIndex = windowIndex + 1;
        nTrainSamples = nTrainSamples+1;
    end %for windowSamples
end %for files

%% Extract testing features
testFeatures = zeros(nFeatures,1);
for file = 1:length(testFiles)
    d = load([testFiles(file).folder filesep testFiles(file).name]);
    %correct for instrument bias by subtracting mean from x/y in reference
    %to whole dataset
    x = d(:,1) - mean(d(:,1));
    y = d(:,2) - mean(d(:,2));
    r = sqrt(x.^2 + y.^2);
    sx = spectrogram(x, windowSamples, overlap, numFFT, sampleRate, 'yaxis');
    sy = spectrogram(y, windowSamples, overlap, numFFT, sampleRate, 'yaxis');
    
    windowIndex = 1;
    for index = 1:windowSamples:length(r(:,1))-windowSamples
        %statistics extraction
        testFeatures(1,nTestSamples) = mean(x(index:index+windowSamples-1));
        testFeatures(2,nTestSamples) = std(x(index:index+windowSamples-1));
        testFeatures(3,nTestSamples) = mean(y(index:index+windowSamples-1));
        testFeatures(4,nTestSamples) = std(x(index:index+windowSamples-1));
        testFeatures(5,nTestSamples) = mean(r(index:index+windowSamples-1));
        testFeatures(6,nTestSamples) = std(r(index:index+windowSamples-1));
        
        %phase and amplitude of x spectrogram to 500Hz
        testFeatures(7:16,nTestSamples) = abs(sx(1:10,windowIndex));
        testFeatures(17:26,nTestSamples) = angle(sx(1:10,windowIndex));
        
        %phase and amplitude of y spectrogram to 500Hz
        testFeatures(27:36,nTestSamples) = abs(sy(1:10,windowIndex));
        testFeatures(37:46,nTestSamples) = angle(sy(1:10,windowIndex));
        windowIndex = windowIndex + 1;
        nTestSamples = nTestSamples + 1;
    end %for windowSamples
end %for files

%% Save Feature tables for late use

save('TrainFeatures.mat', 'trainFeatures');
save('TestFeatures.mat', 'testFeatures');