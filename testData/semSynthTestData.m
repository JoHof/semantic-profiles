% (c) 2015 Johannes Hofmanninger, johannes.hofmanninger@meduniwien.ac.at
% For academic research / private use only, commercial use prohibited

function [data labels] = semSynthTestData()

CL1 = 200;
CL2 = 200;
CL3 = 300;
data1 = zeros(CL1,2);
data2 = zeros(CL2,2);
data3 = zeros(CL3,2);
data32 = zeros(CL3,2);

for i=1:CL1
    % rand value for x and y axis
    data1(i,1) = 1.5+randn*0.7;   data1(i,2) = 1+randn;
end 

for i = 1 : CL2
    % rand value for x and y axis
    data2(i,1) = 3 + randn*0.3;   data2(i,2) = 2 + randn*3; 
end 

for i = 1:CL3
    % rand value for x and y axis
    data32(i,1) = rand*5.2-1;   data32(i,2) = 1 + randn*0.4; 
end 

[tdatay, tadayidx] = sort(data32(:,1));
for i = 1:CL3
    data3(tadayidx(i),1) = data32(tadayidx(i),1); data3(tadayidx(i),2) = real(data32(tadayidx(i),2) + 3*sqrt((mean(data32(:,1))-tdatay(1)).^2-abs(data32(tadayidx(i),1)-mean(data32(:,1))).^2)-1); 
end

data = [data1; data2; data3]';
labels = [ones(CL1,1); ones(CL2,1)*2; ones(CL3,1)*3 ];

end