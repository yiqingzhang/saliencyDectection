%% Region-based Contrast (RC) Saliency Detection Demo
% This script demonstrates the RC method for salient region detection.
% The RC method is more accurate and considers spatial relationships between regions.
%
% Author: Based on Cheng et al., CVPR 2011
% Date: 2025

%% Setup
clc; clear; close all;

% Add paths
addpath(genpath('../../src'));

%% Configuration
% Choose an image to process (1-6)
imageNumber = 5;
imagePath = sprintf('../../assets/images/samples/%d.jpg', imageNumber);

% Timing
tic;

%% Step 1: Load Image
fprintf('Loading image: %s\n', imagePath);
im = imread(imagePath);

% Display original image
figure('Name', 'RC Saliency Detection Demo', 'Position', [100, 100, 1200, 800]);
subplot(3, 3, 1);
imshow(im);
title('1. Original Image');

%% Step 2: Image Segmentation
fprintf('Segmenting image using Felzenszwalb algorithm...\n');

% Compile MEX file if needed
if ~exist('mexFelzenSegmentIndex', 'file')
    fprintf('Compiling segmentation algorithm...\n');
    depPath = fullfile('../../src/Dependencies/FelzenSegment');
    mex(fullfile(depPath, 'mexFelzenSegmentIndex.cpp'), '-output', 'mexFelzenSegmentIndex');
end

% Segmentation parameters
k = 200;        % Controls size of segments
minSize = k;
sigma = 0.8;

% Convert to LAB color space
colorTransform = makecform('srgb2lab');
imageToSegment = applycform(im, colorTransform);

% Perform segmentation
[blobIndIm, ~, neighbours] = mexFelzenSegmentIndex(imageToSegment, sigma, k, minSize);

% Visualize segmentation
subplot(3, 3, 2);
imshow(label2rgb(blobIndIm, 'jet', 'k', 'shuffle'));
title(sprintf('2. Image Segmentation (%d regions)', max(blobIndIm(:))));

%% Step 3: Color Quantization
fprintf('Performing color quantization...\n');

quant_im = zeros(size(im));
for k = 1:3
    for i = 1:size(quant_im, 1)
        for j = 1:size(quant_im, 2)
            quant_im(i, j, k) = ceil(im(i, j, k) / 21.25);
        end
    end
end
quant_im = uint8(quant_im);
quant_im(quant_im == 0) = 1;

quant_im_show = (quant_im - 1) * 23;
subplot(3, 3, 3);
imshow(quant_im_show);
title('3. Color Quantization');

%% Step 4: Detect Saliency using RC Method
fprintf('Detecting salient regions using RC method...\n');

% Call the RC detection function
BW_with_biggest_CC = detect_RC(im);

%% Step 5: Visualize Saliency Map
saliency_map = double(BW_with_biggest_CC);

subplot(3, 3, 4);
imshow(saliency_map);
title('4. Saliency Map');

%% Step 6: Binary Mask
subplot(3, 3, 5);
imshow(BW_with_biggest_CC);
title('5. Binary Mask (Otsu Threshold)');

%% Step 7: Morphological Operations
se = strel('disk', 2);
BW_after_dilate = imdilate(BW_with_biggest_CC, se);
BW_after_dilate = imerode(BW_after_dilate, se);

subplot(3, 3, 6);
imshow(BW_after_dilate);
title('6. After Morphological Ops');

%% Step 8: Largest Connected Component
subplot(3, 3, 7);
imshow(BW_with_biggest_CC);
title('7. Largest Connected Component');

%% Step 9: Draw Bounding Box
fprintf('Computing bounding box...\n');

STATS = regionprops(BW_with_biggest_CC, 'BoundingBox');
if ~isempty(STATS)
    b = STATS.BoundingBox;
    boundingbox = [ceil(b(2)), ceil(b(1)), floor(b(4)), floor(b(3))];
    boundingbox(3) = boundingbox(1) + boundingbox(3) - 1;
    boundingbox(4) = boundingbox(2) + boundingbox(4) - 1;
    
    % Add path to utils
    addpath('../../src/utils');
    finalIm = drawRectangleOnImage(im, boundingbox);
    
    subplot(3, 3, 8);
    imshow(finalIm);
    title('8. Final Result with Bounding Box');
else
    fprintf('Warning: No salient region detected!\n');
end

%% Step 10: Overlay Visualization
subplot(3, 3, 9);
imshow(im);
hold on;
% Overlay saliency mask in red
h = imshow(cat(3, BW_with_biggest_CC, zeros(size(BW_with_biggest_CC)), zeros(size(BW_with_biggest_CC))));
set(h, 'AlphaData', 0.3 * BW_with_biggest_CC);
title('9. Overlay Visualization');
hold off;

%% Timing Results
elapsed = toc;
fprintf('\n=== RC Method Results ===\n');
fprintf('Processing time: %.3f seconds\n', elapsed);
fprintf('Image size: %d x %d\n', size(im, 1), size(im, 2));
fprintf('Number of regions: %d\n', max(blobIndIm(:)));
fprintf('Salient region area: %d pixels (%.1f%%)\n', ...
    sum(BW_with_biggest_CC(:)), ...
    100 * sum(BW_with_biggest_CC(:)) / numel(BW_with_biggest_CC));

%% Additional Visualization - Comparison
figure('Name', 'Detailed Comparison', 'Position', [150, 150, 1000, 300]);

subplot(1, 4, 1);
imshow(im);
title('Original Image');

subplot(1, 4, 2);
imshow(label2rgb(blobIndIm, 'jet', 'k', 'shuffle'));
title(sprintf('Segmentation (%d regions)', max(blobIndIm(:))));

subplot(1, 4, 3);
imshow(BW_with_biggest_CC);
title('Saliency Mask (RC)');

subplot(1, 4, 4);
if exist('finalIm', 'var')
    imshow(finalIm);
    title('Result with Bounding Box');
else
    imshow(im);
    title('No Detection');
end

fprintf('\nDemo complete! Close figures to exit.\n');
