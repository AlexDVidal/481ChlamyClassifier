# 481ChlamyClassifier

This Repository is for the CSUF Fall 2019 CPSC481 Capstone Project.

The project member is Alex Vidal

This project contains 3 files, WindowInspection.m, ChlamyFeatureExtractor.m, and ChlamyModelTrainer.m, and ChlamyPredictor.
WindowInspector is used to visually inspect data and manually select windows to label, 
ChlamyFeatureExtractor extracts all features from the Chlamy data set, 
ChlamyModelTrainer uses those features to train a predictive model,
and ChlamyPredictor predicts classifications on new data and attaches them to images to create a video.

To run this project you will need data to train, if the email with the dropbox link hasn't gone through please email me and I'll resend it.
Copy any data into the repository and optionally copy the pretrained model "TrainedEnsembleModel.mat" to skip model training and just run ChlamyPredictor.
