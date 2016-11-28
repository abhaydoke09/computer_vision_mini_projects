function blobs = detectBlobs(im, param)
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Mini project 3

% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% Dummy - returns a blob at the center of the image
im = im2double(rgb2gray(im));
% sig = 2;
% k = 1.44;
sig = 1.414;
k = sqrt(1.414);
n = 15;
[h,w] = size(im);
pyramid = zeros(h,w,n);


for i = 1:n
    sigi = sig * k^(i-1);
    filt_size = 2*ceil(3*sigi)+1;  
    LoG =  sigi^2 * fspecial('log', filt_size, sigi);
    laplacianImage = imfilter(im, LoG, 'same', 'replicate'); 
    laplacianImage = laplacianImage .^ 2; 
    pyramid(:,:,i) = laplacianImage.^2;
end

scale_pyramid = zeros(h, w, n);
for i = 1:n
    scale_pyramid(:,:,i) = ordfilt2(pyramid(:,:,i), 3^2, ones(3));
end
for i = 1:n
    scale_pyramid(:,:,i) = max(scale_pyramid(:,:,max(i-1,1):min(i+1,n)),[],3);
end
scale_pyramid = scale_pyramid .* (scale_pyramid == pyramid);

blobs = zeros(20000,4);
point_counter = 1;
for i = 1:n
    [row,cols] = find(scale_pyramid(:,:,i)>0.00001);
    number_of_points = length(row);
    for j = 1:number_of_points
        blobs(point_counter,1) = cols(j);
        blobs(point_counter,2) = row(j);
        blobs(point_counter,3) = sig * k^(i-1)*sqrt(2);
        blobs(point_counter,4) = scale_pyramid(row(j),cols(j));
        point_counter = point_counter + 1;
    end
end
[values, order] = sort(-blobs(:,3));
blobs = blobs(order,:);
blobs = blobs(1:1000,:);
