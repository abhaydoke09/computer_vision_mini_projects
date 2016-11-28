function im = colorCorrect( input_image )
%COLORCORRECT Summary of this function goes here
%   Detailed explanation goes here
im = input_image;
red_channel = input_image(:,:,1);
green_channel = input_image(:,:,2);
blue_channel = input_image(:,:,3);

[h,w] = size(red_channel);
%disp([h,w]);

% ravg = sum(sum(red_channel))/(h*w)
% gavg = sum(sum(green_channel))/(h*w)
% bavg = sum(sum(blue_channel))/(h*w)

ravg = mean2(red_channel);
gavg = mean2(green_channel);
bavg = mean2(blue_channel);


red_channel = red_channel*(128/ravg);
green_channel = green_channel*(128/gavg);
blue_channel = blue_channel*(128/bavg);

im(:,:,1) = red_channel;
im(:,:,2) = green_channel;
im(:,:,3) = blue_channel;
%imagesc(im);
disp(ravg/128);
disp(gavg/128);
disp(bavg/128);


end

