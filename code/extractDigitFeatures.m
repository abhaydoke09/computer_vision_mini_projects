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
    case 'hog'
        features = zeroFeatures(x);
    case 'lbp'
        %features = zeroFeatures(x);
        mask = [1,2,4;8,0,16;32,64,128];
        [W,H,C,N] = size(x);
        features = [];
        x = reshape(x, [784,2000]);
        %x = x - mean(x,2);
        x = x./sqrt(sum((x.^2),1));
        %x = sqrt(x);
        x = reshape(x,[28,28,1,2000]);
        for imageNumber = 1:N
            image = x(:,:,1,imageNumber);
            image = reshape(image, [W,H]);
            lbpVector = zeros(1,255);
            for pixelH = 2:H-1
                for pixelW = 2:W-1
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
            
            features = cat(1,features,lbpVector);
            
        end
        %disp(features(1,:));
        %disp(size(features));
        %features = features - mean(features,2);
        features = features';
        features = features./sqrt(sum((features.^2),1));
        %disp(size(features));
end

function features = zeroFeatures(x)
features = zeros(10, size(x,4));