# API Reference

This document provides detailed information about the functions available in the Saliency Detection toolbox.

## Table of Contents

- [Detection Functions](#detection-functions)
  - [detect_HC](#detect_hc)
  - [detect_RC](#detect_rc)
- [Utility Functions](#utility-functions)
  - [drawRectangleOnImage](#drawrectangleonimage)
- [Setup](#setup)

---

## Detection Functions

### detect_HC

Histogram-based Contrast (HC) saliency detection method.

#### Syntax

```matlab
BW = detect_HC(im)
```

#### Description

`BW = detect_HC(im)` detects salient regions in the input image `im` using the Histogram-based Contrast method. This method is fast and works well for images with distinct color regions.

#### Inputs

- **im** - Input RGB image (H × W × 3 uint8 array)

#### Outputs

- **BW** - Binary mask of the most salient region (H × W logical array)
  - `1` indicates salient pixels
  - `0` indicates background pixels

#### Algorithm Steps

1. **Color Quantization**: RGB space is quantized to 12×12×12 discrete colors
2. **LAB Conversion**: Colors converted to LAB space for perceptual uniformity
3. **Color Reduction**: Rare colors (5%) mapped to nearest main colors (95%)
4. **Saliency Calculation**: Color contrast weighted by frequency
5. **Spatial Smoothing**: Saliency refined using color space neighbors
6. **Thresholding**: Binary mask created (top 20% saliency values)
7. **Morphological Operations**: Noise removal and region cleanup
8. **Component Selection**: Largest connected component extracted

#### Example

```matlab
% Load image
im = imread('example.jpg');

% Detect salient region
saliencyMask = detect_HC(im);

% Display result
figure;
subplot(1,2,1); imshow(im); title('Original');
subplot(1,2,2); imshow(saliencyMask); title('Saliency Mask');
```

#### Performance

- **Speed**: Fast (~0.5-2 seconds for typical images)
- **Memory**: Moderate (depends on image size)
- **Best for**: Images with distinct color regions

#### Reference

Ming-Ming Cheng et al., "Global Contrast based Salient Region Detection", CVPR 2011

---

### detect_RC

Region-based Contrast (RC) saliency detection method.

#### Syntax

```matlab
BW = detect_RC(im)
```

#### Description

`BW = detect_RC(im)` detects salient regions in the input image `im` using the Region-based Contrast method. This method segments the image first and computes region-level saliency with spatial weighting.

#### Inputs

- **im** - Input RGB image (H × W × 3 uint8 array)

#### Outputs

- **BW** - Binary mask of the most salient region (H × W logical array)
  - `1` indicates salient pixels
  - `0` indicates background pixels

#### Algorithm Steps

1. **Image Segmentation**: Felzenszwalb-Huttenlocher algorithm creates regions
2. **Color Quantization**: Same as HC method (12×12×12)
3. **Region Features**: Color histogram computed for each region
4. **Color Distance**: Pairwise color distance between regions
5. **Spatial Weighting**: Distance weighted by spatial proximity and region size
6. **Saliency Aggregation**: Final saliency combines contrast and spatial info
7. **Otsu Thresholding**: Automatic threshold selection
8. **Morphological Operations**: Noise removal
9. **Component Selection**: Largest connected component extracted

#### Parameters

The segmentation uses these default parameters:
- `k = 200` - Controls segment size
- `sigma = 0.8` - Gaussian smoothing parameter
- `minSize = k` - Minimum segment size

#### Example

```matlab
% Load image
im = imread('example.jpg');

% Detect salient region
saliencyMask = detect_RC(im);

% Display result
figure;
subplot(1,2,1); imshow(im); title('Original');
subplot(1,2,2); imshow(saliencyMask); title('Saliency Mask');
```

#### Performance

- **Speed**: Slower than HC (~2-10 seconds for typical images)
- **Memory**: Higher (stores region information)
- **Best for**: Complex scenes with spatial relationships

#### Requirements

- C++ compiler for MEX file compilation (first run only)
- Automatically compiles on first use

#### Reference

Ming-Ming Cheng et al., "Global Contrast based Salient Region Detection", CVPR 2011

---

## Utility Functions

### drawRectangleOnImage

Draw bounding boxes on an image.

#### Syntax

```matlab
im_out = drawRectangleOnImage(im, bbox)
```

#### Description

`im_out = drawRectangleOnImage(im, bbox)` draws rectangular bounding boxes on the input image.

#### Inputs

- **im** - Input RGB image (H × W × 3 uint8 array)
- **bbox** - Bounding box coordinates (N × 4 matrix)
  - Each row: `[row_min, col_min, row_max, col_max]`

#### Outputs

- **im_out** - Output image with bounding boxes drawn (H × W × 3 uint8 array)

#### Example

```matlab
% Load image and detect saliency
im = imread('example.jpg');
mask = detect_HC(im);

% Get bounding box
stats = regionprops(mask, 'BoundingBox');
b = stats.BoundingBox;
bbox = [ceil(b(2)), ceil(b(1)), floor(b(4)), floor(b(3))];
bbox(3) = bbox(1) + bbox(3) - 1;
bbox(4) = bbox(2) + bbox(4) - 1;

% Draw bounding box
result = drawRectangleOnImage(im, bbox);
imshow(result);
```

#### Notes

- Bounding boxes are drawn in red (RGB: 255, 0, 0)
- Multiple boxes can be drawn by providing multiple rows in `bbox`

---

## Setup

### setup

Configure the MATLAB environment for saliency detection.

#### Syntax

```matlab
setup
```

#### Description

`setup` adds necessary paths to the MATLAB search path, checks dependencies, compiles MEX files, and verifies the installation.

#### Example

```matlab
% Run setup after cloning repository
setup
```

#### What it does

1. Adds `src/` and `examples/` to MATLAB path
2. Checks for Image Processing Toolbox
3. Checks for C++ compiler
4. Compiles MEX files for RC method
5. Verifies function availability
6. Optionally saves paths permanently
7. Runs quick test

---

## Tips and Best Practices

### Choosing Between HC and RC

**Use HC when:**
- Speed is important
- Images have distinct color regions
- Simple scenes with clear foreground/background

**Use RC when:**
- Accuracy is more important than speed
- Complex scenes with spatial relationships
- Multiple objects or cluttered backgrounds

### Performance Optimization

1. **Resize large images** before processing:
```matlab
im = imread('large_image.jpg');
im_small = imresize(im, 0.5);  % Reduce to 50%
mask = detect_HC(im_small);
mask_full = imresize(mask, size(im, [1,2]));  % Resize back
```

2. **Batch processing**:
```matlab
images = dir('*.jpg');
for i = 1:length(images)
    im = imread(images(i).name);
    mask = detect_HC(im);
    % Process mask...
end
```

3. **Parallel processing** (if Parallel Computing Toolbox available):
```matlab
parfor i = 1:length(images)
    im = imread(images(i).name);
    mask = detect_HC(im);
    % Process mask...
end
```

### Common Issues

**Issue**: MEX file compilation fails
- **Solution**: Run `mex -setup C++` to configure compiler

**Issue**: Out of memory errors
- **Solution**: Resize images before processing or use smaller batch sizes

**Issue**: No salient region detected
- **Solution**: Check if image has sufficient contrast or adjust thresholds

---

## Version History

- **1.0.0** (2025-11-02): Initial release with HC and RC methods

---

## See Also

- [README.md](../README.md) - Project overview and quick start
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [Examples](../examples/) - Example scripts and demos

