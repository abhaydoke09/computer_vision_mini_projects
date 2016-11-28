function m = computeMatches(f1,f2)
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Mini project 3

[N,d] = size(f1);
[M,d] = size(f2);
m = zeros(N,1);
for i = 1:N
    [min_values,I] = sort(sum((f2-f1(i,:)).^2,2),'ascend');
    ratio = min_values(1)/min_values(2);
    if ratio<0.8
        m(i) = I(1);
    else
        m(i) = 0;
    end
end





