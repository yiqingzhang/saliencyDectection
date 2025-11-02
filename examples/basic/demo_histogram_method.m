%% Histogram-based Contrast (HC) Saliency Detection Demo
% This script demonstrates the HC method for salient region detection.
% The HC method is fast and works well for images with distinct color regions.
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
figure('Name', 'HC Saliency Detection Demo', 'Position', [100, 100, 1200, 800]);
subplot(3, 3, 1);
imshow(im);
title('1. Original Image');

%% Step 2: Color Quantization
fprintf('Performing color quantization...\n');

% Quantize RGB to 12x12x12 color space
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

% Show quantized image
quant_im_show = (quant_im - 1) * 23;
subplot(3, 3, 2);
imshow(quant_im_show);
title('2. Color Quantization (12^3 colors)');

%% Step 3: Detect Saliency using HC Method
fprintf('Detecting salient regions using HC method...\n');

% Call the HC detection function
BW_with_biggest_CC = detect_HC(im);

%% Step 4: Compute Saliency Map
% Note: The detect_HC function returns binary mask, but we can show intermediate steps
% For visualization, we'll create a simple saliency map
saliency_map = double(BW_with_biggest_CC);

subplot(3, 3, 4);
imshow(saliency_map);
title('4. Saliency Map');

%% Step 5: Binary Thresholding
subplot(3, 3, 5);
imshow(BW_with_biggest_CC);
title('5. Binary Mask (Thresholded)');

%% Step 6: Morphological Operations
se = strel('disk', 2);
BW_after_dilate = imdilate(BW_with_biggest_CC, se);
BW_after_dilate = imerode(BW_after_dilate, se);

subplot(3, 3, 6);
imshow(BW_after_dilate);
title('6. After Morphological Ops');

%% Step 7: Extract Largest Connected Component
subplot(3, 3, 7);
imshow(BW_with_biggest_CC);
title('7. Largest Connected Component');

%% Step 8: Draw Bounding Box
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

%% Step 9: Side-by-Side Comparison
subplot(3, 3, 9);
imshow(im);
hold on;
% Overlay saliency mask
h = imshow(cat(3, BW_with_biggest_CC, zeros(size(BW_with_biggest_CC)), zeros(size(BW_with_biggest_CC))));
set(h, 'AlphaData', 0.3 * BW_with_biggest_CC);
title('9. Overlay Visualization');
hold off;

%% Timing Results
elapsed = toc;
fprintf('\n=== HC Method Results ===\n');
fprintf('Processing time: %.3f seconds\n', elapsed);
fprintf('Image size: %d x %d\n', size(im, 1), size(im, 2));
fprintf('Salient region area: %d pixels (%.1f%%)\n', ...
    sum(BW_with_biggest_CC(:)), ...
    100 * sum(BW_with_biggest_CC(:)) / numel(BW_with_biggest_CC));

%% Additional Visualization
figure('Name', 'Detailed Comparison', 'Position', [150, 150, 800, 300]);

subplot(1, 3, 1);
imshow(im);
title('Original Image');

subplot(1, 3, 2);
imshow(BW_with_biggest_CC);
title('Saliency Mask (HC)');

subplot(1, 3, 3);
if exist('finalIm', 'var')
    imshow(finalIm);
    title('Result with Bounding Box');
else
    imshow(im);
    title('No Detection');
end

fprintf('\nDemo complete! Close figures to exit.\n');
