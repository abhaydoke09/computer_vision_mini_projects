% Demo code for alignment of Prokudin-Gorskii images
%
% Your code should be run after you implement alignChannels
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images
%   Author: Subhransu Maji

% Path to your data directory
dataDir = fullfile('..','data','large-images');

% Path to your output directory (change this to your output directory)
outDir = fullfile('..', 'output', 'large-images');
if ~exist(outDir, 'file')
    mkdir(outDir);
end

% List of images
%imageNames = {'00125v.jpg',	'00153v.jpg', '00398v.jpg', '00149v.jpg', '00351v.jpg',	'01112v.jpg'};
imageNames = {'lady.tif', 'emir.tif', 'onion_church.tif', 'three_generations.tif', 'village.tif', 'workshop.tif'};

% Display variable
display = true;

% Set maximum shift to check alignment for
maxShift = 15;

% Loop over images, untile them into images, align
for i = 1:length(imageNames),
    % Read image
    im = imread(fullfile(dataDir, imageNames{i}));
    
    % Convert to double
    im = im2double(im);
    
    
    % Images are stacked vertically
    % From top to bottom are B, G, R channels (and not RGB)
    imageHeight = floor(size(im,1)/3);
    imageWidth  = size(im,2);
    
    % Allocate memory for the image 
    channels = zeros(imageHeight, imageWidth, 3);
    
    
    % We are loading the color channels from top to bottom
    % Note the ordering of indices
    channels(:,:,3) = im(1:imageHeight,:);
    channels(:,:,2) = im(imageHeight+1:2*imageHeight,:);
    channels(:,:,1) = im(2*imageHeight+1:3*imageHeight,:);
    
    [h,w,c] = size(channels);
    channels = channels(50:h-50,50:w-50,:);
    
    %Blur the original image with the gaussian blur filter
    channels = imgaussfilt(channels);
    
    %Generate the image pyramid with 4 scaled images reduced to half.
    c1 = impyramid(channels,'reduce');
    %disp(size(c1));
    c2 = impyramid(c1,'reduce');
    %disp(size(c2));
    c3 = impyramid(c2,'reduce');
    c4 = impyramid(c3,'reduce');
  
    
    %Calculating shifts for the c4 and then applying the shifts to the next
    %large image in the pyramid i.e. c3.
    [colorIm, predShift] = alignChannels(c4, maxShift);
    c3(:,:,2) = circshift(c3(:,:,2), [predShift(1,1)*2 predShift(1,2)*2]);
    c3(:,:,3) = circshift(c3(:,:,3), [predShift(2,1)*2 predShift(2,2)*2]);
    
    %Calculating shifts for the c3 and then applying the shifts to the next
    %large image in the pyramid i.e. c2.
    [colorIm, predShift] = alignChannels(c3, maxShift);
    c2(:,:,2) = circshift(c2(:,:,2), [predShift(1,1)*2 predShift(1,2)*2]);
    c2(:,:,3) = circshift(c2(:,:,3), [predShift(2,1)*2 predShift(2,2)*2]);
    
    %Calculating shifts for the c2 and then applying the shifts to the next
    %large image in the pyramid i.e. c1.
    [colorIm, predShift] = alignChannels(c2, maxShift);
    c1(:,:,2) = circshift(c1(:,:,2), [predShift(1,1)*2 predShift(1,2)*2]);
    c1(:,:,3) = circshift(c1(:,:,3), [predShift(2,1)*2 predShift(2,2)*2]);
    
    %Scaling the c1 to the original size by expanding.
    [colorIm, predShift] = alignChannels(c1, maxShift);
    
    colorIm = impyramid(colorIm,'expand');
    colorIm = imsharpen(colorIm);
    
   
    % Print the alignments
    fprintf('%2i %s shift: B (%2i,%2i) R (%2i,%2i)\n', i, imageNames{i}, predShift(1,:), predShift(2,:));
    
    % Write image output
    outimageName = sprintf([imageNames{i}(1:end-5) '-aligned.jpg']);
    outimageName = fullfile(outDir, outimageName);
    imwrite(colorIm, outimageName);
   
    % Optionally display the results
    if display
        figure(1); clf;
        subplot(1,2,1); imagesc(im); axis image off; colormap gray
        title('Input image');
        subplot(1,2,2); imagesc(colorIm); axis image off;
        title('Aligned image');
        pause(1);
    end
end

