function features = extractDigitFeatures(x, featureType)
% EXTRACTDIGITFEATURES extracts features from digit images
%   features = extractDigitFeatures(x, featureType) extracts FEATURES from images
%   images X of the provided FEATURETYPE. The images are assumed to the of
%   size [W H 1 N] where the first two dimensions are the width and height.
%   The output is of size [D N] where D is the size of each feature and N
%   is the number of images. 

switch featureType
    case 'pixel'
        features = zeroFeatures(x);
        features = reshape(x, [784,2000]);
        %features = features - mean(features,2);
        %features = features./sum((features.^2),1);
        %features = features ./ std(features,0,2);
        %features = (features - min(features,[],2))./(max(features,[], 2) - min(features,[],2));
        
        %features = sqrt(features);
        features = features./sqrt(sum((features.^2),1));
        features = sqrt(features);
        disp(size(features));
        
    case 'hog'
        %features = zeroFeatures(x);
        [W,H,C,N] = size(x);
        blockSize = 4;
        overlap = 0;
        stepSize = int16(blockSize*(1-overlap));
        binAngle = 20;
        histogramSize = int16(360 / binAngle);
        
        features = [];
        for imageNumber = 1:N
            image = x(:,:,1,imageNumber);
            image = reshape(image,[W,H]);
            [h,w] = size(image);
            [gx, gy] = imgradientxy(image);
            [gMag, gDir] = imgradient(gx,gy);
            
            totalSteps = int16(h/stepSize);
         
            imageHistogram = [];

            for i = 1:totalSteps
                for j = 1:totalSteps
                    startRow = (i-1)*stepSize;
                    startColumn = (j-1)*stepSize;
                    tempMag = gMag(startRow+1:startRow+blockSize,startColumn+1:startColumn+blockSize);
                    tempDir = gDir(startRow+1:startRow+blockSize,startColumn+1:startColumn+blockSize);
                    negativeDirIndices = find(tempDir<0);
                    tempDir(negativeDirIndices) = tempDir(negativeDirIndices)+360;
                    tempHistogram = zeros(1,18);
                    for blockH = 1:blockSize
                        for blockW = 1:blockSize
                            %disp(tempDir(blockH,blockW));
                            binNumber = int16(floor(mod(tempDir(blockH,blockW),360)/binAngle)+1);
                            tempHistogram(binNumber) = tempHistogram(binNumber) + tempMag(blockH,blockW);
                        end
                    end
                    imageHistogram = cat(2,imageHistogram,tempHistogram);
                end
            end
            features = cat(1,features,imageHistogram);
        end
        
        features = features';
        features = features./sqrt(sum((features.^2),1));
        features = sqrt(features);
        disp(size(features));
        
        
%     case 'lbp'
%         %features = zeroFeatures(x);
%         mask = [1,2,4;128,0,8;64,32,16];
%         [W,H,C,N] = size(x);
%         features = [];
%         x = reshape(x, [784,2000]);
%         %x = x - mean(x,2);
%         x = x./sum((x.^2),1);
%         %x = sqrt(x);
%         x = reshape(x,[28,28,1,2000]);
%         for imageNumber = 1:N
%             image = x(:,:,1,imageNumber);
%             image = reshape(image, [W,H]);
%             lbpVector = zeros(1,255);
%             for pixelH = 2:H-1
%                 for pixelW = 2:W-1
%                     pixelVal = image(pixelH, pixelW);
%                     patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
%                     %disp(patch)
%                     lessThanIndices = find(patch<pixelVal);
%                     greaterThanIndices = find(patch>=pixelVal);
%                     patch(lessThanIndices) = 0;
%                     patch(greaterThanIndices) = 1;
%                     %disp(patch);
%                     
%                     patch(2,2) = 0;
%                     patch = patch.*mask;
%                     
%                     LBP = sum(sum(patch));
%                     %disp(patch);
%                     %disp(LBP);
%                     if(LBP~=255)
%                         %lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
%                         lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
%                     end
%                     
%                 end
%             end
%             %disp(features);
%             
%             features = cat(1,features,lbpVector);
%             
%         end
%         %disp(features(1,:));
%         %disp(size(features));
%         %features = features - mean(features,2);
%         features = features';
%         
%         %disp(size(features));
%     case 'lbp'
%         zero = [0];
%         one = [1     2     4     8    16    32    64   128];
%         two = [3     6    12    24    48    96   192   129];
%         three = [7    14    28    56   112   224   193   131];
%         four = [15    30    60   120   240   225   195   135];
%         five = [31    62   124   248   241   227   199   143];
%         six = [63   126   252   249   243   231   207   159];
%         seven = [127   254   253   251   247   239   223   191];
%         eight = [255];
%         
%         mask = [1,2,4;128,0,8;64,32,16];
%         [W,H,C,N] = size(x);
%         features = zeros(N,9);
%         %x = reshape(x, [784,2000]);
%         %x = x - mean(x,2);
%         %x = x./sum((x.^2),1);
%         %x = reshape(x,[28,28,1,2000]);
%         for imageNumber = 1:N
%             image = x(:,:,1,imageNumber);
%             image = reshape(image, [W,H]);
%             lbpVector = zeros(1,255);
%             for pixelH = 2:H-1
%                 for pixelW = 2:W-1
%                     pixelVal = image(pixelH, pixelW);
%                     patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
%                     %disp(patch)
%                     lessThanIndices = find(patch<pixelVal);
%                     greaterThanIndices = find(patch>=pixelVal);
%                     patch(lessThanIndices) = 0;
%                     patch(greaterThanIndices) = 1;
%                     %disp(patch);
%                     
%                     patch(2,2) = 0;
%                     
%                     patch = patch.*mask;
%                     
%                     LBP = sum(sum(patch));
%                     %disp(patch);
%                     %disp(LBP);
%                     if LBP==0
%                         features(imageNumber,1) = features(imageNumber,1)+1;
%                     elseif ismember(LBP,one)
%                         features(imageNumber,2) = features(imageNumber,2)+1;
%                     elseif ismember(LBP,two)
%                         features(imageNumber,3) = features(imageNumber,3)+1;
%                     elseif ismember(LBP,three)
%                         features(imageNumber,4) = features(imageNumber,4)+1;
%                     elseif ismember(LBP,four)
%                         features(imageNumber,5) = features(imageNumber,5)+1;
%                     elseif ismember(LBP,five)
%                         features(imageNumber,6) = features(imageNumber,6)+1;
%                     elseif ismember(LBP,six)
%                         features(imageNumber,7) = features(imageNumber,7)+1;
%                     elseif ismember(LBP,seven)
%                         features(imageNumber,8) = features(imageNumber,8)+1;
%                     elseif LBP==255
%                      %   features(imageNumber,9) = features(imageNumber,9)+1;
%                     else
%                         features(imageNumber,9) = features(imageNumber,9)+1;
%                 
%                     end
%                     
%                 end
%             end
%             %disp(features);
%             
%             %features = cat(1,features,lbpVector);
%             
%         end
%         disp(features(1,:));
%         %disp(size(features));
%         %features = features - mean(features,2);
%         features = features';
%         
%         %disp(size(features));     
%         
case 'lbp'
        %features = zeroFeatures(x);
        mask = [1,2,4;128,0,8;64,32,16];
        [W,H,C,N] = size(x);
        features = [];
        %x = reshape(x, [784,2000]);
        %x = x - mean(x,2);
        %x = x./sqrt(sum((x.^2),1));
        %x = sqrt(x);
        %x = reshape(x,[28,28,1,2000]);
        for imageNumber = 1:N
            image = x(:,:,1,imageNumber);
            image = reshape(image, [W,H]);
            fullVector = [];
            lbpVector = zeros(1,255);
            for pixelH = 2:int16((H-1)/2)
                for pixelW = 2:int16((W-1)/2)
                    pixelVal = image(pixelH, pixelW);
                    patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
                    %disp(patch)
                    lessThanIndices = find(patch<pixelVal);
                    greaterThanIndices = find(patch>=pixelVal);
                    patch(lessThanIndices) = 0;
                    patch(greaterThanIndices) = 1;
                    %disp(patch);
                    
                    patch(2,2) = 0;
                    patch = patch.*mask;
                    
                    LBP = sum(sum(patch));
                    %disp(patch);
                    %disp(LBP);
                    if(LBP~=255)
                        %lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                        lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                    end
                    
                end
            end
            fullVector = cat(2,fullVector,lbpVector);
            lbpVector = zeros(1,255);
            for pixelH = 2:int16((H-1)/2)
                for pixelW = int16((W-1)/2):W-1
                    pixelVal = image(pixelH, pixelW);
                    patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
                    %disp(patch)
                    lessThanIndices = find(patch<pixelVal);
                    greaterThanIndices = find(patch>=pixelVal);
                    patch(lessThanIndices) = 0;
                    patch(greaterThanIndices) = 1;
                    %disp(patch);
                    
                    patch(2,2) = 0;
                    patch = patch.*mask;
                    
                    LBP = sum(sum(patch));
                    %disp(patch);
                    %disp(LBP);
                    if(LBP~=255)
                        %lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                        lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                    end
                    
                end
            end
            %disp(features);
            fullVector = cat(2,fullVector,lbpVector);
            
            lbpVector = zeros(1,255);
            for pixelH = int16((H-1)/2):H-1
                for pixelW = 2:int16((W-1)/2)
                    pixelVal = image(pixelH, pixelW);
                    patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
                    %disp(patch)
                    lessThanIndices = find(patch<pixelVal);
                    greaterThanIndices = find(patch>=pixelVal);
                    patch(lessThanIndices) = 0;
                    patch(greaterThanIndices) = 1;
                    %disp(patch);
                    
                    patch(2,2) = 0;
                    patch = patch.*mask;
                    
                    LBP = sum(sum(patch));
                    %disp(patch);
                    %disp(LBP);
                    if(LBP~=255)
                        %lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                        lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                    end
                    
                end
            end
            %disp(features);
            fullVector = cat(2,fullVector,lbpVector);
            
            lbpVector = zeros(1,255);
            for pixelH = int16((H-1)/2):H-1
                for pixelW = int16((W-1)/2):W-2
                    pixelVal = image(pixelH, pixelW);
                    patch = image(pixelH-1:pixelH+1,pixelW-1:pixelW+1);
                    %disp(patch)
                    lessThanIndices = find(patch<pixelVal);
                    greaterThanIndices = find(patch>=pixelVal);
                    patch(lessThanIndices) = 0;
                    patch(greaterThanIndices) = 1;
                    %disp(patch);
                    
                    patch(2,2) = 0;
                    patch = patch.*mask;
                    
                    LBP = sum(sum(patch));
                    %disp(patch);
                    %disp(LBP);
                    if(LBP~=255)
                        %lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                        lbpVector(LBP+1) = lbpVector(LBP+1) + 1; 
                    end
                    
                end
            end
            %disp(features);
            fullVector = cat(2,fullVector,lbpVector);
            
            
            features = cat(1,features,fullVector);
            
        end
        %disp(features(1,:));
        %disp(size(features));
        %features = features - mean(features,2);
        %features = sqrt(features);
        %features = features./sqrt(sum((features.^2),1));
        features = sqrt(features);
        features = features';
        
        
        disp(size(features));
end

function features = zeroFeatures(x)
features = zeros(10, size(x,4));