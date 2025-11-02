function [BW_with_biggest_CC] = detect_HC(im)
% DETECT_HC - Histogram-based Contrast (HC) saliency detection
%
% This function performs salient region detection using the Histogram-based
% Contrast method from Cheng et al., CVPR 2011.
%
% Syntax:
%   BW_with_biggest_CC = detect_HC(im)
%
% Inputs:
%   im - Input RGB image (H x W x 3 uint8 array)
%
% Outputs:
%   BW_with_biggest_CC - Binary mask of the most salient region (H x W logical array)
%
% Reference:
%   Ming-Ming Cheng, Guo-Xin Zhang, Niloy J. Mitra, Xiaolei Huang, Shi-Min Hu
%   "Global Contrast based Salient Region Detection", IEEE CVPR 2011
%
% Author: Implementation based on Cheng et al. paper
% Date: 2011

% Add path to RGB2Lab conversion utility
addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Dependencies', 'RGB2Lab'))

% Step 1: Color quantization - reduce RGB space to 12x12x12 discrete colors
quant_im = zeros(size(im));
for k = 1:3
    for i = 1:size(quant_im,1) 
        for j = 1:size(quant_im,2)
            quant_im(i,j,k) = ceil(im(i,j,k) / 21.25);
        end
    end
end
quant_im = uint8(quant_im);
quant_im(quant_im==0) = 1;

% Convert quantized image to displayable format
quant_im_minus1 = quant_im - 1;
quant_im_show = quant_im_minus1 * 23;

% Step 2: Convert to LAB color space for perceptual color difference
lab = RGB2Lab(quant_im_show);

% Step 3: Build color histogram and LAB color space
countSpace = zeros(12,12,12);

labSpace = cell(12,12,12);
changeColorSpace = cell(12,12,12);  % Maps rare colors to main colors
for i = 1:12
    for j = 1:12
        for k = 1:12
            changeColorSpace{i,j,k} = [i,j,k];
        end
    end
end
for i = 1:size(im,1)
    for j = 1:size(im,2)
        r_level = quant_im(i,j,1);
        g_level = quant_im(i,j,2);
        b_level = quant_im(i,j,3);
        countSpace(r_level,g_level,b_level) = countSpace(r_level,g_level,b_level) + 1;
        labSpace{r_level,g_level,b_level} = {lab(i,j,1),lab(i,j,2),lab(i,j,3)};
     
    end
end

% Step 4: Identify main colors (covering 95% of pixels) and rare colors
[sortedArray,rank] = sort(countSpace(:),'descend');
totalPixelNum = size(im,1) * size(im,2);
sumPixel = 0;
pixelThreshold = 0.95;  % Keep colors that cover 95% of image
totalPixelThreshold = floor(totalPixelNum * pixelThreshold);

for i = 1:length(sortedArray)
    [I,J,K] = ind2sub([12,12,3],rank(i));
    mainColorList(i,1:3) = [I,J,K];
    sumPixel = sumPixel + sortedArray(i);
    if(sumPixel > totalPixelThreshold)
        break
    end
end

% Identify rare colors (remaining 5%)
for j = i + 1:length(sortedArray)
    if(sortedArray(j) == 0)
        break
    end
    [I,J,K] = ind2sub([12,12,3],rank(j));
    rareColorList(j-i,1:3) = [I,J,K]; 
    
end

% Step 5: Replace each rare color with the nearest main color in LAB space
for i = 1:size(rareColorList,1)
    tmp = rareColorList(i,1:3);
    I = tmp(1);
    J = tmp(2);
    K = tmp(3);
    diffList = zeros(size(mainColorList,1),1);
    for j = 1:size(mainColorList,1)
        tmp = mainColorList(j,1:3);
        II = tmp(1);
        JJ = tmp(2);
        KK = tmp(3);
        theDiff = zeros(1,3);
        theDiff(1) = labSpace{I,J,K}{1} - labSpace{II,JJ,KK}{1};
        theDiff(2) = labSpace{I,J,K}{2} - labSpace{II,JJ,KK}{2};
        theDiff(3) = labSpace{I,J,K}{3} - labSpace{II,JJ,KK}{3};

        diffList(j) = norm(theDiff);
    end
    [~,diffListRank] = sort(diffList);
    substitudeColorRank = diffListRank(1);
    substitudeColor = mainColorList(substitudeColorRank,1:3);
    changeColorSpace{I,J,K} = substitudeColor;
    % Update the count space
    II = substitudeColor(1);
    JJ = substitudeColor(2);
    KK = substitudeColor(3);
    countSpace(II,JJ,KK) = countSpace(II,JJ,KK) + countSpace(I,J,K);
    countSpace(I,J,K) = 0;
end

% Step 6: Apply color reduction to the quantized image
quant_im_reduce = quant_im;
for i = 1:size(quant_im,1)
    for j = 1:size(quant_im,2)
        I = quant_im(i,j,1);
        J = quant_im(i,j,2);
        K = quant_im(i,j,3);
        newColor = changeColorSpace{I,J,K};
        quant_im_reduce(i,j,1) = newColor(1);
        quant_im_reduce(i,j,2) = newColor(2);
        quant_im_reduce(i,j,3) = newColor(3);
    end
end


% Step 7: Calculate saliency for each main color
% Saliency is based on color contrast weighted by color frequency
frequencyList = zeros(size(mainColorList,1),1);
for i = 1:size(mainColorList,1)
    tmp = mainColorList(i,1:3);
    I = tmp(1);
    J = tmp(2);
    K = tmp(3);
    frequencyList(i) = countSpace(I,J,K) / totalPixelNum;
end

saliencyList = zeros(size(mainColorList,1),1);
diffLabMatrix = zeros(size(mainColorList,1),size(mainColorList,1));
for i = 1:size(mainColorList,1)
    tmp = mainColorList(i,1:3);
    I = tmp(1);
    J = tmp(2);
    K = tmp(3);
    for j = 1:size(mainColorList,1)
        if(j >= i)
            break;
        end
        tmp = mainColorList(j,1:3);
        II = tmp(1);
        JJ = tmp(2);
        KK = tmp(3);
        theDiff = zeros(1,3);
        theDiff(1) = labSpace{I,J,K}{1} - labSpace{II,JJ,KK}{1};
        theDiff(2) = labSpace{I,J,K}{2} - labSpace{II,JJ,KK}{2};
        theDiff(3) = labSpace{I,J,K}{3} - labSpace{II,JJ,KK}{3};
        diffLabMatrix(i,j) = norm(theDiff);
        diffLabMatrix(j,i) = diffLabMatrix(i,j);
        
    end

end

for i = 1:size(mainColorList,1)
    saliencySum = 0;
    for j = 1:size(mainColorList,1)
        if(i == j)
            continue;
        end
        saliencySum = saliencySum + frequencyList(j) * diffLabMatrix(i,j);
    end
    saliencyList(i) = saliencySum;
end

% Step 8: Smooth saliency values using spatial coherence
% Each color's saliency is refined by its neighbors in color space
m = ceil(length(saliencyList) / 4);
newSaliencyList = size(saliencyList);
for i = 1:length(saliencyList)
    [~,neighbourList] = sort( diffLabMatrix(:,i) );
    nearColorList = neighbourList(1:m);
    T = 0;
    for j = 1:m
        T = T + diffLabMatrix(i,nearColorList(j));
    end
    newSaliencySum = 0;
    for j = 1:m
        newSaliencySum = newSaliencySum + (T - diffLabMatrix(i,nearColorList(j)) )*saliencyList(nearColorList(j));
    end
    newSaliencyList(i) = newSaliencySum / ((m-1)*T);
end

% Step 9: Create saliency map
saliencySpace = zeros(12,12,12);
for i = 1:size(mainColorList,1)
    tmp = mainColorList(i,1:3);
    I = tmp(1);
    J = tmp(2);
    K = tmp(3);
    saliencySpace(I,J,K) = newSaliencyList(i);
end

theSaliencyMax = max(newSaliencyList(:));
saliencyIm = zeros(size(im,1),size(im,2));
for i = 1:size(im,1)
    for j = 1:size(im,2)
        tmp = quant_im_reduce(i,j,1:3);
        I = tmp(1);
        J = tmp(2);
        K = tmp(3);
        saliencyIm(i,j) = saliencySpace(I,J,K);
    end
end

saliencyIm = saliencyIm / theSaliencyMax;
saliency = saliencyIm;

% Step 10: Threshold saliency map to create binary mask
saliencySorted = sort(saliency(:),'descend');
percentageThreshold = 0.20;
threshold = saliencySorted(floor(percentageThreshold*length(saliencySorted)));


BW = im2bw(saliency, threshold);

% Step 11: Morphological operations to clean up the binary mask
se = strel('disk',2);        
BW_after_dilate = imdilate(BW,se);
BW_after_dilate = imerode(BW_after_dilate,se);

% Step 12: Extract the largest connected component as the salient region
CC = bwconncomp(BW_after_dilate);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
BW_with_biggest_CC = zeros(size(BW));
BW_with_biggest_CC(CC.PixelIdxList{idx}) = 1;


end

