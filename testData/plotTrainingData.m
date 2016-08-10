% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [ ] = plotTrainingData(data, weakLabels, trueLabels )


%% plotting the training data
figure;
subplot(2,2,1);
scatter(data(1,weakLabels(:,1)),data(2,weakLabels(:,1)),'blue');
title('records with weak label blue')
xlabel('feature1');
ylabel('feature2');
subplot(2,2,2);
scatter(data(1,weakLabels(:,2)),data(2,weakLabels(:,2)),'red');
title('records with weak label red')
xlabel('feature1');
ylabel('feature2');
subplot(2,2,3);
scatter(data(1,weakLabels(:,3)),data(2,weakLabels(:,3)),'green');
title('records with weak label green')
xlabel('feature1');
ylabel('feature2');
subplot(2,2,4);
scatter(data(1,trueLabels==1),data(2,trueLabels==1),'blue');
hold on;
scatter(data(1,trueLabels==2),data(2,trueLabels==2),'red');
scatter(data(1,trueLabels==3),data(2,trueLabels==3),'green');
title('true labeling of records')
xlabel('feature1');
ylabel('feature2');


end

