% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [ leafIndizes ] = getFernsResponse( queryVector, ferns )
%  gets the fern response for provided vector and fern

num_ferns = size(ferns.dims,2);
num_nodes = size(ferns.dims,3);

switch (ceil(num_nodes/8))
    case 1
        type = 'uint8';
    case 2
        type = 'uint16';
    case {3,4}
        type = 'uint32';
    otherwise
        fprintf('Max fern depth is 32!\n');
        return;
end

sub = size(queryVector,1);

%memory pre-allocation
binaryVector = zeros([sub num_nodes], type);
leafIndizes = zeros([sub num_ferns],type);

for fern=1:num_ferns
    for node=1:num_nodes
        rand_dims = ferns.dims(:,fern,node);
        subspace = queryVector(:,rand_dims); %produce a random subspace
        rand_proj_vector = ferns.proj_vector(:,fern,node);
        projection_values = subspace * rand_proj_vector; %project the subvectors
        threshold = ferns.threshold(fern,node);
        binaryVector(:,node) = projection_values>(threshold+(1e-10)); %save the outcome and floating point error correction
        %leafIndizes(:,fern) = leafIndizes(:,fern) + cast((projection_values>(threshold+(1e-10)))*2^(node-1),type);
    end
    leafIndizes(:,fern) = b2d(binaryVector);
end
end

