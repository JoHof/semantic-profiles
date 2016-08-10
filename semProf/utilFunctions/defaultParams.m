% Functional Matlab Library
% (c) 2013 Rene Donner, rene.donner@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

%% function p = defaultParams(p,defaultp)
%
% Compare fields of "p" with "defaultp".
% If field from "defaultp" is not existent in "p", add it.
function p = defaultParams(p,defaultp)

names = fieldnames(defaultp);

for n = 1:length(names)
    name = names{n};

    if not(isfield(p,name))
        p = setfield(p,name,getfield(defaultp,name)); %#ok<GFLD,SFLD>
    end
end