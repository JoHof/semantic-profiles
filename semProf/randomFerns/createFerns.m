% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [ wordVector, ferns ] = createFerns( featureVector, num_ferns, num_nodes, dim )
%CREATE_FERNS Trains ferns out of featureVectore provided

vector_dim = size(featureVector,2);
sub = size(featureVector,1);

if(dim>vector_dim)
    error('createFern:chkInput', 'featureVector dimension lower than split dimensions!');
end
if(sub<vector_dim)
    fprintf('nDim < N, Input should be provided as column vectors!');
end

switch (ceil(num_nodes/8))
    case 1
        type = 'uint8';
    case 2
        type = 'uint16';
    case {3,4}
        type = 'uint32';
    otherwise
        error('createFern:chkInput', 'Max fern depth is 32!');
end

%allocating memory
binaryVector = zeros([sub num_nodes], type);
wordVector = zeros([sub num_ferns],type);

ferns.dims = zeros(dim,num_ferns,num_nodes);
ferns.proj_vector = zeros(dim,num_ferns,num_nodes);
ferns.threshold = zeros(num_ferns,num_nodes);
for fern=1:1:num_ferns
    for node=1:1:num_nodes
        x = randperm(vector_dim);
        rand_dims = x(1:dim);
        subspace = featureVector(:,rand_dims); %produce a random subspace
        rand_proj_vector =randn([size(subspace,2) 1]); %generate random peojection vector
        projection_values = subspace * rand_proj_vector; %project the subvectors
        ridx = randi(length(projection_values)); %random value with distribution on projection
        threshold = projection_values(ridx); %choose the value
        binaryVector(:,node) = projection_values>threshold; %thresholding of values

        %save fern in data structure
        ferns.dims(:,fern,node) = rand_dims;
        ferns.proj_vector(:,fern,node) = rand_proj_vector;
        ferns.threshold(fern,node) = threshold;
    end
    wordVector(:,fern) = b2d(binaryVector); %save the outcome
end
end

