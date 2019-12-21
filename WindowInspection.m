%% Reset for clean run
clear all
close all

%% Get a list of all data files
dataDirectory = 'TrainData\';
rawFiles = dir(dataDirectory);
rawFiles = rawFiles(3:end); %first two entries are always '.' and '..'

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
for file = 1:length(rawFiles)
    r = load([rawFiles(file).folder filesep rawFiles(file).name]);
    r = r(:,1:2); %columns 1 and 2 are the force measurments in x and y
    %correct for instrument bias
    r(:,1) = r(:,1) - mean(r(:,1));
    r(:,2) = r(:,2) - mean(r(:,2));

    for index = 1:windowSamples:length(r(:,1))-windowSamples
        set(h,'XData',r(index:index+windowSamples,1),'YData',r(index:index+windowSamples,2));
        txt.String = num2str((index-1)/sampleRate) + "s " + rawFiles(file).name;
        M(imageIndex) = getframe;
        imageIndex = imageIndex + 1;
        drawnow
    end %for windowSamples
end %for files
hold off

%% Create video for frame by frame inspection
v = VideoWriter('InspectionVideo.avi');
open(v);
writeVideo(v, M);
close(v);