%%
clear all;
close all;
trainFeat = load('TrainFeatures.mat');
trainFeat = trainFeat.trainFeatures';
testFeat = load('TestFeatures.mat');
testFeat = testFeat.testFeatures';

%Create tables for train and test, add a class entry
train = array2table(trainFeat, 'VariableNames', {'XMean', 'XStd', 'YMean', 'YStd', 'RMean', 'RStd', ...
    'X50Amp', 'X50Phase','X100Amp', 'X100Phase','X150Amp', 'X150Phase','X200Amp', 'X200Phase','X250Amp', 'X250Phase', ...
    'X300Amp', 'X300Phase','X350Amp', 'X350Phase','X400Amp', 'X400Phase','X450Amp', 'X450Phase','X500Amp', 'X500Phase', ...
    'Y50Amp', 'Y50Phase','Y100Amp', 'Y100Phase','Y150Amp', 'Y150Phase','Y200Amp', 'Y200Phase','Y250Amp', 'Y250Phase', ...
    'Y300Amp', 'Y300Phase','Y350Amp', 'Y350Phase','Y400Amp', 'Y400Phase','Y450Amp', 'Y450Phase','Y500Amp', 'Y500Phase'});
test = array2table(testFeat, 'VariableNames', {'XMean', 'XStd', 'YMean', 'YStd', 'RMean', 'RStd', ...
    'X50Amp', 'X50Phase','X100Amp', 'X100Phase','X150Amp', 'X150Phase','X200Amp', 'X200Phase','X250Amp', 'X250Phase', ...
    'X300Amp', 'X300Phase','X350Amp', 'X350Phase','X400Amp', 'X400Phase','X450Amp', 'X450Phase','X500Amp', 'X500Phase', ...
    'Y50Amp', 'Y50Phase','Y100Amp', 'Y100Phase','Y150Amp', 'Y150Phase','Y200Amp', 'Y200Phase','Y250Amp', 'Y250Phase', ...
    'Y300Amp', 'Y300Phase','Y350Amp', 'Y350Phase','Y400Amp', 'Y400Phase','Y450Amp', 'Y450Phase','Y500Amp', 'Y500Phase'});
class = cell(size(train,1),1);
for index = 1:length(class)
    class{index} = '';
end
train = addvars(train,class);

class = cell(size(test,1),1);
for index = 1:length(class)
    class{index} = '';
end
test = addvars(test,class);

%%
%Write the corresponding classes for our sparse data
tumble = [21 27 47 153 157 192 196 202 236 467 500 549 566 583 865];
idle = [89 101 205 207 291 343 355 488 654 667 686 839 1126 1231 1367];
run = [98 152 166 171 180 190 193 473 529 600 739 799 811 831 1214];

train.class(tumble) = {'tumble'};
train.class(idle) = {'idle'};
train.class(run) = {'run'};


%grab classified entries and clear them from train
tr = train([tumble idle run],:);
train([tumble idle run], :) = [];
% Assign higher cost for misclassification, order is idle run tumble
C = [0, 1, 2; 1, 0, 2; 10, 5, 0];
iteration = 1;

while(size(train,1) > 1)
    fprintf("Trying iteration %d with %d elements\n.", iteration, size(tr,1));
    if size(tr,1) > size(train,1)
        ts = train;
        train = [];
    else
        k = randperm(size(train,1));
        ts = train(k(1:size(tr,1)),:); 
        train(k(1:size(tr,1)),:) = [];
    end%if
%%
if(iteration == 1)
    subsample = 1:height(tr);
else
    % Create a random sub sample (to speed up training) from the training set
    subsample = randi([1 height(tr)], round(height(tr)/4), 1);
end

rng(1);

% Create a 5-fold cross-validation set from training data
cvp = cvpartition(length(subsample),'KFold',5);

% bayesian optimization parameters (stop after 15 iterations)
opts = struct('Optimizer','bayesopt','CVPartition',cvp,...
        'AcquisitionFunctionName','expected-improvement-plus','MaxObjectiveEvaluations',15);    
trained_model = fitcensemble(tr(subsample,:),'class','Cost',C,...
    'OptimizeHyperparameters',{'Method','NumLearningCycles','LearnRate'},...
    'HyperparameterOptimizationOptions',opts)

save('TrainedEnsembleModel', 'trained_model');

% Predict class labels for new set using model
% NOTE: if training ensemble without optimization, need to use trained_model.Trained{idx} to predict
predicted_class = predict(trained_model, ts);
ts.class = predicted_class;
tr = [tr; ts];
iteration = iteration + 1;
end%while loop
%%
%conf_mat = confusionmat(testing_set.class, predicted_class);
%conf_mat_per = conf_mat*100./sum(conf_mat, 2);
% Visualize model performance in heatmap
%labels = {'idle', 'run', 'tumble'};
%heatmap(labels, labels, conf_mat_per, 'Colormap', winter, 'ColorbarVisible','off');