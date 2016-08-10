% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

%% [ r ] = sptrainmodel(records, classLabels, p)
%
% calculates the semantic profiles for a novel set of records given trained
% model
%
% Input:
%
%    records: a set of vecors in the from dxn
%    classLabels: weakLabels in the form nxc in [0,1] where c = number of
%                 Classes. Each record is labeled with one to c classes
%                 where only one is the true class.
%    p = struct holding parameters. Default parameters are:
%
%    dp.num_ferns = 1200;      % number of ferns to be generated
%    dp.ferns_depth = 8;       % depth of one fern (e.g. 2^8 partitions per fern)
%    dp.sub_dims = 9;          % number of sub-dimensions used on each split (usually <12)
%    dp.partitionRes = 5000;   % parameter K in the Paper 
%    dp.classSmoothing = 20;   % parameter gamma in the paper (prevents overfitting)
%
% Output:
%
%    r: struct holding all the model information needed to infer semantic
%       profiles for a novel record (e.g. like random ferns and relative class
%       frequencies in the partitions selected partitions
%     

function [ r ] = sptrainmodel(records, classLabels, p)

dp.num_ferns = 1200;      % number of ferns to be generated
dp.ferns_depth = 8;       % depth of one fern (e.g. 2^8 partitions per fern)
dp.sub_dims = 9;          % number of sub-dimensions used on each split (usually <12)
dp.partitionRes = 5000;   % parameter K in the Paper 
dp.classSmoothing = 20;   % parameter gamma in the paper (prevents overfitting)

p = defaultParams(p,dp);

if (size(classLabels,2)==1 && length(unique(classLabels))>2)
    classes = unique(classLabels);
    numClasses = length(classes);
    
    tClassLabels = zeros(size(classLabels,1),length(unique(classLabels)));
    for i = 1:numClasses
        tClassLabels(classLabels==classes(i),i) = 1;
    end
    classLabels = tClassLabels;
end

numClasses = size(classLabels,2);

disp('Train the ferns...');
t1 = tic;
[fernsVec r.ferns] = createFerns(records', p.num_ferns, p.ferns_depth, p.sub_dims);
fernsTime = toc(t1);
disp(['Feature space partitioning in ... ' num2str(fernsTime) 's']);

disp('Building class distribution models...');
t2 = tic;
ii = 0:(2^p.ferns_depth)-1;
jj = p.num_ferns;
histClass = zeros(length(ii),jj);
fernsVecT = fernsVec'; %for efficiency
classN = zeros(2^p.ferns_depth,jj);
parfor j = 1:jj
    classN(:,j) = hist(double(fernsVec(:,j)),ii);
end
classN = classN(:);

for i = 1:numClasses
    %actClass = classes(i);
    disp([num2str(i) '...Processing: ' num2str(i)]);
    classHit = logical(classLabels(:,i));
    fVclassHit = single(fernsVecT(:,classHit))'; %slicing for parfor
    %fVnclassHit = double(fernsVecT(:,nclassHit))'; %slicing for parfor
    parfor j = 1:jj
        %histnClass(:,j) = hist(fVnclassHit(:,j),ii);
        histClass(:,j) = hist(fVclassHit(:,j),ii);
    end
    relTermFrequency = (histClass(:)+1)./(classN(:)+p.classSmoothing); %dirichlet prior
    relTermFrequency(isnan(relTermFrequency)) = 0;
    relTermFrequency(relTermFrequency<0) = 0;
    
    [~, scIdx] = sort(relTermFrequency,1,'descend');
    sIdx{i} = scIdx(1:p.partitionRes,:);
    
    [num fern] = ind2sub([2^p.ferns_depth p.num_ferns],sIdx{i});
    num=uint8(num)-1;
    runs = ceil(length(num)/10000);
    very = zeros(size(fernsVec,1),1);
    
    itemsPerIteration = 3e6;
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
    r.maxCount(i) = max(very);
end
clear fVclassHit
clear fVnclassHit
modelTime = toc(t2);
disp(['Distribution model learning in ... ' num2str(modelTime) 's']);


r.sIdx = sIdx;
r.num_ferns = p.num_ferns;
r.ferns_depth = p.ferns_depth;

end

