% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function y = d2b(x,nBits)

% Convert a decimanl number into a binary array
% 
% Similar to dec2bin but yields a numerical array instead of a string and is found to
% be rather faster
y =zeros([length(x) nBits],'single');
for iBit = 1:nBits                    % Loop over the bits
    y(:,iBit) = bitget(x,iBit);  % Get the bit values
end
