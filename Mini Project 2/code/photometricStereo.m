function [albedoImage, surfaceNormals] = photometricStereo(imArray, lightDirs)
% PHOTOMETRICSTEREO compute intrinsic image decomposition from images
%   [ALBEDOIMAGE, SURFACENORMALS] = PHOTOMETRICSTEREO(IMARRAY, LIGHTDIRS)
%   comptutes the ALBEDOIMAGE and SURFACENORMALS from an array of images
%   with their lighting directions. The surface is assumed to be perfectly
%   lambertian so that the measured intensity is proportional to the albedo
%   times the dot product between the surface normal and lighting
%   direction. The lights are assumed to be of unit intensity.
%
%   Input:
%       IMARRAY - [h w n] array of images, i.e., n images of size [h w]
%       LIGHTDIRS - [n 3] array of unit normals for the light directions
%
%   Output:
%        ALBEDOIMAGE - [h w] image specifying albedos
%        SURFACENORMALS - [h w 3] array of unit normals for each pixel
%
% Author: Subhransu Maji
%
% Acknowledgement: Based on a similar homework by Lana Lazebnik

[h, w, n] = size(imArray);
albedoImage = ones(h,w);

for i = 1:h
    for j = 1:w
        pixelVals = reshape(imArray(i,j,:),[n,1]);
        %disp('pixelvals');
        %disp(size(pixelVals));
        %disp('lightDirs');
        % disp(size(lightDirs));
        gox = lightDirs\pixelVals;
        %disp('gox');
        %disp(size(gox));
        magnitude = norm(gox);
        albedoImage(i,j) = magnitude;
        gox = gox./magnitude;
        surfaceNormals(i,j,1) = gox(1);
        surfaceNormals(i,j,2) = gox(2);
        surfaceNormals(i,j,3) = gox(3);
    end
end

% temp_surface = zeros(h, w, 3);
% images = reshape(imArray,[n,h*w]);
% 
% surfaceNormals = lightDirs\images;
% 
% surfaceNormals = surfaceNormals;
% disp('images');
% disp(size(surfaceNormals));
% magnitude = sqrt(sum(surfaceNormals.^2));
% disp(size(magnitude));
% surfaceNormals(1,:) = surfaceNormals(1,:)./magnitude;
% surfaceNormals(2,:) = surfaceNormals(2,:)./magnitude;
% surfaceNormals(3,:) = surfaceNormals(3,:)./magnitude;
% 
% temp_surface(:,:,1) = reshape(surfaceNormals(1,:),[h, w]);
% temp_surface(:,:,2) = reshape(surfaceNormals(2,:),[h, w]);
% temp_surface(:,:,3) = reshape(surfaceNormals(3,:),[h, w]);
% surfaceNormals = temp_surface;
% albedoImage = reshape(magnitude,[h w]);
% disp(size(surfaceNormals));


%%% implement this %% 