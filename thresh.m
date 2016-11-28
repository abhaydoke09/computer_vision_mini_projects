function res = thres( v )
%THRES Summary of this function goes here
%   Detailed explanation goes here
res = v;
res(v<0) = 0;
res(v>0) = 100;

end

