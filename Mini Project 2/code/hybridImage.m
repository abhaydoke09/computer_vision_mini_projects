function hybridImage = hybridImage( im1, im2, sig1, sig2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

im1 = double(im1);
im2 = double(im2);
filter1 = fspecial('Gaussian', sig1*2+1, sig1);
filter2 = fspecial('Gaussian', sig2*2+1, sig2);

blurred = imfilter(im1, filter1, 'replicate');
sharpened =  (im2 - imfilter(im2, filter2, 'replicate'));
hybridImage = blurred + sharpened;
%imshow(vis_hybrid_image(mat2gray(hybridImage(j2,j3,7,5)))) Best result
end

