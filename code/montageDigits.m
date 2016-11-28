function avgImage = montageDigits(x)
% MONTAGEDIGITS displays all the digits in a nice format
%   AVGIMAGE = MONTAGEDIGITS(X) montages the digits X and optionally
%   outputs the AVERAGEIMAGE. Change the values of nx to change the number
%   of images in each row of the display.

numImages = size(x, 4);
nx = 20;
ny = ceil(numImages/nx);
montage(x, 'Size', [ny nx]);

if nargout > 0, %compute avgImg
    avgImage = squeeze(mean(x, 4));
end