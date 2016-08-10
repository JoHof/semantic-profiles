% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function y = b2d(x)

% Convert a binary array to a decimal number
% 
% Similar to bin2dec but works with arrays instead of strings and is found to be 
% rather faster
z = single(2.^(0:1:size(x,2)-1));
y = single(x)*z';
y = cast(y,class(x));
%y = bsxfun(@times,x,z')