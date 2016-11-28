% Evaluation code for image stitching
%
% Your goal is to implement image stitching with RANSAC 
%
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Image stitching

imageName = 'fishes.jpg';
numBlobsToDraw = 1000;
imName = imageName(1:end-4);

dataDir = fullfile('..','data','blobs');
im = imread(fullfile(dataDir, imageName));


%% Implement the code to detect blobs here
blobs = detectBlobs(im);

%% Draw blobs on the image
drawBlobs(im, blobs, numBlobsToDraw);
title('Blob detection');