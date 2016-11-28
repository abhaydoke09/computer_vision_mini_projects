function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosacing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
%mosim = demosaicBaseline(im);
[imageHeight, imageWidth] = size(im);
mosim = ones(imageHeight, imageWidth, 3)*(-1); %create mosim array of same size as that of im array


%Copy im array data into green_channel. 
%Places in the green_channel where there are red and blue values in the
%bayer pattern will be replaced to -1 while intializing blue_channel and
%red_channel arrays
green_channel = im;
red_channel = ones(imageHeight, imageWidth)*(-1);
blue_channel = ones(imageHeight, imageWidth)*(-1);

%initialize blue channel. Putting -1 at places where there are no blue
%values in the bayer grid
blue_channel(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
green_channel(2:2:imageHeight, 2:2:imageWidth) = -1; %replace green_channel values at these places to -1 as there are no green values.


%initialize red channel. Putting -1 at places where there are no red
%values in the bayer grid
red_channel(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
green_channel(1:2:imageHeight, 1:2:imageWidth) = -1; %replace green_channel values at these places to -1 as there are no green values.

%combine all channel to get mosim array
mosim(:,:,1) = red_channel;
mosim(:,:,2) = green_channel;
mosim(:,:,3) = blue_channel;

%padding the mosim array so that it becomes easy to handle border pixel
%values.
mosim = padarray(mosim, [1 1], 'replicate');
%size(mosim)

for i = 2:imageHeight+1
    for j = 2:imageWidth+1
        %fill green channel where value is -1 with nearest neighbour
        %values. Pixel at the i+1th location is chosen as the Nearest neighbour. 
        %For the boundary condition at the very bottom of the image, nearest neighbour is chosen 
        %as the pixel value of the i-1th i.e. just above pixel.
        if mosim(i,j,2) == -1
            if(i==imageHeight)
                mosim(i,j,2) = mosim(i-1,j,2);
            else
                mosim(i,j,2) = mosim(i+1,j,2);
            end
        end
        
        %In case of the red and the blue channels, for
        %finding the nearest neighbour is found by just looking around the
        %8-nearest neighbours whose value is not -1
  
        %fill blue channel. 
        if mosim(i,j,3) == -1
            for x = -1:1
                for y = -1:1
                    if mosim(i+x,j+y,3) ~= -1
                        mosim(i,j,3) = mosim(i+x,j+y,3);
                    end
                end
            end
        end
        
        %fill red
        if mosim(i,j,1) == -1
            for x = -1:1
                for y = -1:1
                    if mosim(i+x,j+y,1) ~= -1
                        mosim(i,j,1) = mosim(i+x,j+y,1);
                    end
                end
            end
        end 
    end
end
            
mosim = mosim(2:imageHeight+1,2:imageWidth+1,:);

%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
%mosim = demosaicBaseline(im);
[imageHeight, imageWidth] = size(im);
mosim = ones(imageHeight, imageWidth, 3)*(-1);


%Copy im array data into green_channel. 
%Places in the green_channel where there are red and blue values in the
%bayer pattern will be replaced to -1 while intializing blue_channel and
%red_channel arrays
green_channel = im;
red_channel = ones(imageHeight, imageWidth)*(-1);
blue_channel = ones(imageHeight, imageWidth)*(-1);

%initialize blue channel. Putting -1 at places where there are no blue
%values in the bayer grid
blue_channel(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
green_channel(2:2:imageHeight, 2:2:imageWidth) = -1;


%Initialize red channel
red_channel(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
green_channel(1:2:imageHeight, 1:2:imageWidth) = -1;

mosim(:,:,1) = red_channel;
mosim(:,:,2) = green_channel;
mosim(:,:,3) = blue_channel;

%padding the mosim array so that it becomes easy to handle border pixel
mosim = padarray(mosim, [1 1], 'replicate');
temp_mosim = mosim;
%size(mosim)

for i = 2:imageHeight+1
    for j = 2:imageWidth+1
        green_count = 0;
        red_count = 0;
        blue_count = 0;
        green_avg = 0;
        red_avg = 0;
        blue_avg = 0;
        %for the linear interpolation at the each pixel, I am
        %calculating the average value of surrounding pixels with values other than 
        %the -1 and putting it at the current location location.
        for x = -1:1
            for y = -1:1
                if(mosim(i+x,j+y,1) ~= -1)
                    red_avg = red_avg + mosim(i+x,j+y,1);
                    red_count = red_count + 1;
                end
                if(mosim(i+x,j+y,2) ~= -1)
                    green_avg = green_avg + mosim(i+x,j+y,2);
                    green_count = green_count + 1;
                end
                if(mosim(i+x,j+y,3) ~= -1)
                    blue_avg = blue_avg + mosim(i+x,j+y,3);
                    blue_count = blue_count + 1;
                end
            end
        end
%         temp_mosim(i,j,1) = red_avg * 1.0 / red_count;
%         temp_mosim(i,j,2) = green_avg * 1.0 / green_count;
%         temp_mosim(i,j,3) = blue_avg * 1.0 / blue_count;
        
        %Replace value with the average value only if the value at the
        %current position is -1
        if mosim(i,j,1) == -1
            temp_mosim(i,j,1) = red_avg * 1.0 / red_count;
        end
        if mosim(i,j,2) == -1
            temp_mosim(i,j,2) = green_avg * 1.0 / green_count;
        end
        if mosim(i,j,3) == -1
            temp_mosim(i,j,3) = blue_avg * 1.0 / blue_count;
        end
    end
end

mosim = temp_mosim(2:imageHeight+1, 2:imageWidth+1,:);

%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)

[imageHeight, imageWidth] = size(im);
mosim = ones(imageHeight, imageWidth, 3)*(-1);

%Copy im array data into green_channel. 
%Places in the green_channel where there are red and blue values in the
%bayer pattern will be replaced to -1 while intializing blue_channel and
%red_channel arrays
green_channel = im;
red_channel = ones(imageHeight, imageWidth)*(-1);
blue_channel = ones(imageHeight, imageWidth)*(-1);

%initialize blue channel. Putting -1 at places where there are no blue
%values in the bayer grid
blue_channel(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
green_channel(2:2:imageHeight, 2:2:imageWidth) = -1;

%Initializing red channel
red_channel(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
green_channel(1:2:imageHeight, 1:2:imageWidth) = -1;

mosim(:,:,1) = red_channel;
mosim(:,:,2) = green_channel;
mosim(:,:,3) = blue_channel;

%padding the mosim array so that it becomes easy to handle border pixel
mosim = padarray(mosim, [1 1], 'replicate');
temp_mosim = mosim;

for i = 2:imageHeight+1
    for j = 2:imageWidth+1
        %processing green channel. For the border pixels of green channel, I am using average
        %values of the neighbours.
         if mosim(i,j,2) == -1
             if j==2 
                 temp_mosim(i,j,2) = mosim(i,j+1,2);
             elseif j==imageWidth+1
                 temp_mosim(i,j,2) = mosim(i,j-1,2);
             elseif i==2
                 temp_mosim(i,j,2) = mosim(i+1,j,2);
             elseif i==imageHeight+1
                 temp_mosim(i,j,2) = mosim(i-1,j,2);                    
             else
                 if abs(mosim(i-1,j,2) - mosim(i+1,j,2)) > abs(mosim(i,j+1,2) - mosim(i,j-1,2))
                     temp_mosim(i,j,2) = (mosim(i,j+1,2) + mosim(i,j-1,2))/2.0;
                 else
                     temp_mosim(i,j,2) = (mosim(i-1,j,2) + mosim(i+1,j,2))/2.0;
                 end
             end
         end

        % for the red and blue channels, I am using the linear
        % interpolation.
        red_count = 0;
        blue_count = 0;
        red_avg = 0;
        blue_avg = 0;
        for x = -1:1
            for y = -1:1
                if(mosim(i+x,j+y,1) ~= -1)
                    red_avg = red_avg + mosim(i+x,j+y,1);
                    red_count = red_count + 1;
                end
                if(mosim(i+x,j+y,3) ~= -1)
                    blue_avg = blue_avg + mosim(i+x,j+y,3);
                    blue_count = blue_count + 1;
                end
            end
        end
%         temp_mosim(i,j,1) = red_avg * 1.0 / red_count;
%         temp_mosim(i,j,2) = green_avg * 1.0 / green_count;
%         temp_mosim(i,j,3) = blue_avg * 1.0 / blue_count;
        
        if mosim(i,j,1) == -1
            temp_mosim(i,j,1) = red_avg * 1.0 / red_count;
        end
        if mosim(i,j,3) == -1
            temp_mosim(i,j,3) = blue_avg * 1.0 / blue_count;
        end
    end
      
end

mosim = temp_mosim(2:imageHeight+1, 2:imageWidth+1,:);
imshow(mosim);
pause(3);
        
                 
            
            
            
            
            
            