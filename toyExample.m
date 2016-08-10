% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

% generation of some trainng data
% data = 2x700 vectors
% weakLabels = 700x3 in [0,1] each record is labeled with one to 3 classes
%              of which only one is the true calss                
% true = 700x1 classes
[data, weakLabels, trueLabels] = semSynthWeakTrainingData();

% plot Training Data
plotTrainingData(data,weakLabels,trueLabels);

% specification of learning parameters
p.num_ferns = 1200;      % number of ferns to be generated (1200 default)
p.ferns_depth = 8;       % depth of one fern (e.g. 2^8 partitions per fern) (8 default)
p.sub_dims = 2;          % number of sub-dimensions used on each split (usually <12) (9 default)
p.partitionRes = 5000;   % parameter K in the Paper.  (5000 default)
p.classSmoothing = 15;   % parameter gamma in the paper (prevents overfitting) (20 default)

% training of the model
model = sptrainmodel(data,weakLabels,p);

% generation of test data (equal distribution to training data)
[testdata, testLabels] = semSynthTestData();

% mapping of test data to semantic profiles
profiles = spgetprofiles(testdata,model);

% show test vectors in the semantic profile space
figure;
scatter3(profiles(1,testLabels==1),profiles(2,testLabels==1),profiles(3,testLabels==1),'blue');
hold on;
scatter3(profiles(1,testLabels==2),profiles(2,testLabels==2),profiles(3,testLabels==2),'red');
scatter3(profiles(1,testLabels==3),profiles(2,testLabels==3),profiles(3,testLabels==3),'green');

% calculate averaged precission and recall curves
[mprecisionProf MAPProf baseProf] = preRecall(profiles,profiles,testLabels,testLabels,1);
[mprecision MAP base] = preRecall(testdata,testdata,testLabels,testLabels,1);

% plot the results
figure;
recallLevels = 0.05:0.05:1;
p1 = plot(recallLevels,mprecision,'-','LineWidth',1);
hold on
p2 = plot(recallLevels,mprecisionProf,'-o','LineWidth',1);
title('PR Curve using original vectors and Semantic Profiles');
xlabel('Recall');
ylabel('Precisison');
legend([p1(1),p2(1)],'original Vectors','Semantic Profiles');



