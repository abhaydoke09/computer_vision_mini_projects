function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images
%   Author: Subhransu Maji

%disp(size(im));
%temp_im = im;


% Sanity check
assert(size(im,3) == 3);
%assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);

first_channel = im(:,:,1);
second_channel = im(:,:,2);
third_channel = im(:,:,3);

fc_edge = edge(first_channel,'canny'); 
sc_edge = edge(second_channel,'canny');
tc_edge = edge(third_channel,'canny');

min_diff = Inf;
hshift = -100;
vshift = -100;
for i = -maxShift:maxShift
    for j = -maxShift:maxShift
        %temp_image = circshift(second_channel, [i, j]);
        temp_image = circshift(sc_edge, [i, j]);
        %temp = sum(sum((first_channel-temp_image).^2));
        temp = sum(sum((fc_edge-temp_image).^2));
        
        %temp = sum(sum(fc_edge & sc_edge));
        
         if temp < min_diff
            min_diff = temp;
            hshift = i;
            vshift = j;
        end
    end
end
 
predShift(1,1) = hshift;
predShift(1,2) = vshift;
 
min_diff = Inf;
hshift = -100;
vshift = -100;
for i = -maxShift:maxShift
    for j = -maxShift:maxShift
        %temp_image = circshift(second_channel, [i, j]);
        temp_image = circshift(tc_edge, [i, j]);
        %temp = sum(sum((first_channel-temp_image).^2));
        temp = sum(sum((fc_edge-temp_image).^2));
        
        %temp = sum(sum(fc_edge & sc_edge)); 
        if temp < min_diff
            min_diff = temp;
            hshift = i;
            vshift = j;
        end
    end
end
 
% predShift(2,1) = hshift;
% predShift(2,2) = vshift;

predShift(2,1) = hshift;
predShift(2,2) = vshift;



im(:,:,2) = circshift(im(:,:,2), [predShift(1,1) predShift(1,2)]);
im(:,:,3) = circshift(im(:,:,3), [predShift(2,1) predShift(2,2)]);

%predShift
%pause(5);

[h,w,c]=size(im);

im = im(30:h-30,30:w-30,:);

imShift = im;
