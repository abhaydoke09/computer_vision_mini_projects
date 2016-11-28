function output = prepareData(imArray, ambientImage)
% PREPAREDATA prepares the images for photometric stereo
%   OUTPUT = PREPAREDATA(IMARRAY, AMBIENTIMAGE)
%
%   Input:
%       IMARRAY - [h w n] image array
%       AMBIENTIMAGE - [h w] image 
%
%   Output:
%       OUTPUT - [h w n] image, suitably processed
%
% Author: Subhransu Maji
%

% Implement this %
% Step 1. Subtract the ambientImage from each image in imArray

output = zeros(size(imArray));
[h,w,n] = size(imArray)
for i = 1:n
    img = imArray(:,:,i);
    img = img - ambientImage;
    % Step 2. Make sure no pixel is less than zero
    img(img<0) = 0;
    % Step 3. Rescale the values in imarray to be between 0 and 1
    img = img/255;
    
    output(:,:,i) = img; 
end


