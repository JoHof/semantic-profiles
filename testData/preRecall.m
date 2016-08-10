% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [ mprecision MAP base] = preRecall( trainingVectors,testVectors,trainingLabels,testLabels, queryInDatabase )

    M = pdist2(trainingVectors',testVectors');
    [~, indices] = sort(M);
    clear M
    indices  = uint32(indices);
    if queryInDatabase
        indices = indices(2:end,:);
    end
    
    labels = trainingLabels(indices);
    clear indices
    
    classes = unique(testLabels);
    
    for j = 1:length(classes)
        class = classes(j);
        classQueries = find(testLabels==class);
        
        pr = zeros(length(classQueries),20);
        parfor kk = 1:length(classQueries)
            queryResults = labels(:,classQueries(kk));
            classhit = queryResults==class;
            [pr(kk,:) mp(kk)] = precRecallAP(classhit);
        end
        mprecision(:,j) = mean(pr); %#ok<AGROW>
        MAP(j) = mean(mp); %#ok<AGROW>
        base(j) = sum(trainingLabels==class)/length(trainingLabels); %#ok<AGROW>
    end
end

function [ precision AP ] = precRecallAP( hits )

            hitPos = find(hits);    %ceil(recallLevels*nClass);
            parfor jj = 1:length(hitPos)
                k = hitPos(jj);
                Allprecision(jj) = jj/k;
            end
                   
            AP = mean(Allprecision);
            recallLevels = 0.05:0.05:1;
            kForRecall = ceil(recallLevels*length(hitPos));
            precision = Allprecision(kForRecall);
end