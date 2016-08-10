% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [ data, weakLabels, trueLabels ] = semSynthWeakTrainingData()

[data, trueLabels] = semSynthTestData();

classes = unique(trueLabels);
numClasses = length(classes);
tClassLabels = zeros(size(trueLabels,1),length(unique(trueLabels)));
randTrue = randperm(numel(tClassLabels));
tClassLabels(randTrue(1:ceil(length(randTrue)/2))) = 1;
for i = 1:numClasses
    tClassLabels(trueLabels==classes(i),i) = 1;
end
weakLabels = logical(tClassLabels);

end

