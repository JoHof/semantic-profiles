% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

%% [ semProfiles ] = spgetprofiles(records, model)
%
% calculates the semantic profiles for a novel set of records given trained
% model
%
% Input:
%
%    records: a set of vecors in the from dxn
%    model:   model returned by function sptrainmodel
%          model = sptrainmodel(trainingData,weakLabels,p);
%
% Output:
%
%    semProfiles: dxn  a set of sem Profiles  where d=number of classes
%

function [ semProfiles ] = spgetprofiles(records, model)

numClasses = length(model.sIdx);

t1 = tic;
[fernsVec] = getFernsResponse(records', model.ferns);
tfernsResp = toc(t1);
disp(['Ferns response in ... ' num2str(tfernsResp) 's']);

semHist = single(zeros(size(fernsVec,1),numClasses));
t2 = tic;
for i = 1:numClasses
    disp([num2str(i) '...Processing: ' num2str(i)]);
    [num fern] = ind2sub([2^model.ferns_depth model.num_ferns],model.sIdx{i});
    num=uint8(num)-1;
    runs = ceil(length(num)/10000); % splitting data for saving some memory
    very = zeros(size(fernsVec,1),1);
    itemsPerIteration = 2e6;
    N = size(fernsVec,1);
    tv = zeros(N,1);
    for run = 1:runs
        subset = ((run-1)*10000)+1:min(run*10000,length(num));
        Nruns = ceil(size(fernsVec,1)/itemsPerIteration);
        for Nrun = 1:Nruns
            Nsubset = ((Nrun-1)*itemsPerIteration)+1:min(Nrun*itemsPerIteration,N);
            tv(Nsubset) = sum(bsxfun(@eq,fernsVec(Nsubset,fern(subset)),num(subset)'),2);
        end
        very = very+tv;
    end
    veryProp = very/model.maxCount(i);
    semHist(:,i) = veryProp;
end
tProfiles = toc(t2);
disp(['Profiles generation in ... ' num2str(tProfiles) 's']);

semProfiles = semHist';

end

