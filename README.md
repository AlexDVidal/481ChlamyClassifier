# 481ChlamyClassifier

This Repository is for the CSUF Fall 2019 CPSC481 Capstone Project.

The project member is Alex Vidal

This project contains 4 files, WindowInspection.m, ChlamyFeatureExtractor.m, and ChlamyModelTrainer.m, and ChlamyPredictor.
In sequence they are:
WindowInspector - used to visually inspect data and manually select windows to label, 
ChlamyFeatureExtractor - extracts all features from the Chlamy data set, 
ChlamyModelTrainer - uses those features to train a predictive model,
ChlamyPredictor - predicts classifications on new data and attaches them to images to create a video.

The first file is only needed for making new labels. To train the model with existing (hard-coded) labels, run the last three files.
Alternatively, if you wish to use the pre-trained model "TrainedEnsembleModel.mat" then you only need to run the last file.

To run any stage of this project you will need the data sets, if the email with the dropbox link hasn't gone through please email me and I'll resend it. Copy the data into the repository under "TrainData" or "TestData" directories.
