function [BW_with_biggest_CC] = detect_RC(im)
% DETECT_RC - Region-based Contrast (RC) saliency detection
%
% This function performs salient region detection using the Region-based
% Contrast method from Cheng et al., CVPR 2011. This method segments the
% image into regions and computes saliency based on region-level contrast.
%
% Syntax:
%   BW_with_biggest_CC = detect_RC(im)
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

% Add path to dependencies
addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Dependencies', 'RGB2Lab'))

% Compile the Felzenszwalb and Huttenlocher segmentation algorithm (IJCV 2004)
if ~exist('mexFelzenSegmentIndex', 'file')
    fprintf('Compiling the segmentation algorithm of Felzenszwalb and Huttenlocher...\n');
    depPath = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Dependencies', 'FelzenSegment');
    mex(fullfile(depPath, 'mexFelzenSegmentIndex.cpp'), '-output', 'mexFelzenSegmentIndex');
end


% Thresholds for the Felzenszwalb and Huttenlocher segmentation algorithm.
% Note that by default, we set minSize = k, and sigma = 0.8.
k = 200; % controls size of segments of initial segmentation. 
minSize = k;
sigma = 0.8;


%change the image to lab color map
colorTransform = makecform('srgb2lab');
imageToSegment = applycform(im, colorTransform);
    
% Get initial segmentation, boxes, and neighbouring blobs
[blobIndIm , ~, neighbours] = mexFelzenSegmentIndex(imageToSegment, sigma, k, minSize);


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

%show the image after quantization
quant_im_minus1 = quant_im - 1;
quant_im_show = quant_im_minus1 * 23;


lab = RGB2Lab(quant_im_show);
%begin to count
countSpace = zeros(12,12,12);

labSpace = cell(12,12,12);
changeColorSpace = cell(12,12,12);%this part mark if the colour space need to be change
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

[sortedArray,rank] = sort(countSpace(:),'descend');
totalPixelNum = size(im,1) * size(im,2);
sumPixel = 0;
pixelThreshold = 0.95;
totalPixelThreshold = floor(totalPixelNum * pixelThreshold);

for i = 1:length(sortedArray)
    [I,J,K] = ind2sub([12,12,3],rank(i));
    mainColorList(i,1:3) = [I,J,K];
    sumPixel = sumPixel + sortedArray(i);
    if(sumPixel > totalPixelThreshold)
        break
    end
end

%we use the value of i from the last part
for j = i + 1:length(sortedArray)
    if(sortedArray(j) == 0)
        break
    end
    [I,J,K] = ind2sub([12,12,3],rank(j));
    rareColorList(j-i,1:3) = [I,J,K]; 
    
end

%replace each rare colour to main colour
for i = 1:length(rareColorList)
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
    %update the count space
    II = substitudeColor(1);
    JJ = substitudeColor(2);
    KK = substitudeColor(3);
    countSpace(II,JJ,KK) = countSpace(II,JJ,KK) + countSpace(I,J,K);
    countSpace(I,J,K) = 0;
end

%replace the original picture
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


%so now we can begin to work with fewer colours
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

%get the frequency table for each region
numberOfRegion = size(neighbours,1);
numberOfMainColor = size(mainColorList,1);
frequencyTable = zeros(numberOfMainColor,numberOfRegion);
mainColorIndexSpace = zeros(12,12,12);
for i = 1:size(mainColorList,1)   %this is an inverted list
    tmp = mainColorList(i,1:3);
    I = tmp(1);
    J = tmp(2);
    K = tmp(3);
    mainColorIndexSpace(I,J,K) = i;
    
end
regionSizeList = zeros(numberOfRegion,1);
for i = 1: numberOfRegion
    regionPos = find(blobIndIm == i);
    regionSizeList(i) = length(regionPos);
    
    for j = 1:length(regionPos)
        pos = regionPos(j);
        [x,y] = ind2sub(size(blobIndIm),pos);
        I = quant_im_reduce(x,y,1);
        J = quant_im_reduce(x,y,2);
        K = quant_im_reduce(x,y,3);
    
        
        frequencyTable(mainColorIndexSpace(I,J,K),i) = frequencyTable(mainColorIndexSpace(I,J,K),i) + 1; 
    end
    frequencyTable(:,i) = frequencyTable(:,i) / regionSizeList(i);
end

regionColorDistMatrix = zeros(numberOfRegion,numberOfRegion);
for i = 1:numberOfRegion
    for j = i+1 : numberOfRegion
        diffValue = 0;
        for m = 1:numberOfMainColor
            for n = 1:numberOfMainColor
                diffValue = diffValue + frequencyTable(m,i)*frequencyTable(n,j)*diffLabMatrix(n,m);
            end
        end
        regionColorDistMatrix(i,j) = diffValue;
        regionColorDistMatrix(j,i) = diffValue;
    end

end

%get the region distance matrix
longestDist = norm(size(quant_im_reduce));
STATS = regionprops(blobIndIm, 'Centroid');
regionGeoDistMatrix = zeros(numberOfRegion,numberOfRegion);
for i = 1:numberOfRegion
    for j = i+1 : numberOfRegion
        regionGeoDistMatrix(i,j) = norm(STATS(i).Centroid - STATS(j).Centroid) / longestDist;
        regionGeoDistMatrix(j,i) = regionGeoDistMatrix(i,j);
    end
end

regionSaliencyList = zeros(numberOfRegion,1);
for i = 1:numberOfRegion
    saliencyValue = 0;
    for j = 1:numberOfRegion
        if(i==j)
            continue;
        end
        saliencyValue = saliencyValue + exp(regionGeoDistMatrix(i,j)/0.4) * regionSizeList(j) * regionColorDistMatrix(i,j);
    end
    regionSaliencyList(i) = saliencyValue;
end

saliencyMax = max(regionSaliencyList);
regionSaliencyList = regionSaliencyList / saliencyMax;

%paint the saliency map
saliency = zeros(size(blobIndIm));
for i = 1:numberOfRegion
    regionPos = find(blobIndIm == i);
    saliency(regionPos) = regionSaliencyList(i);
end


OtsuThreshold = graythresh(saliency);
BW_otsu = im2bw(saliency,OtsuThreshold);


BW = BW_otsu;
%BW = im2bw(saliency, threshold);


se = strel('disk',2);        
BW_after_dilate = imdilate(BW,se);
% BW = imdilate(BW,se);
BW_after_dilate = imerode(BW_after_dilate,se);


%find the largest one
CC = bwconncomp(BW_after_dilate);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
BW_with_biggest_CC = zeros(size(BW));
BW_with_biggest_CC(CC.PixelIdxList{idx}) = 1;



end

