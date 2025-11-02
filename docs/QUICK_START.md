# Quick Start Guide

Get started with Saliency Detection in 5 minutes!

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/saliencyDetection.git
cd saliencyDetection
```

### Step 2: Run Setup

Open MATLAB and run:

```matlab
setup
```

This will:
- Add necessary paths
- Check dependencies
- Compile MEX files
- Verify installation

## Your First Detection

### Example 1: Basic HC Detection

```matlab
% Load an image
im = imread('assets/images/samples/1.jpg');

% Detect salient region (fast method)
mask = detect_HC(im);

% Display result
figure;
subplot(1,2,1); imshow(im); title('Original');
subplot(1,2,2); imshow(mask); title('Salient Region');
```

### Example 2: Basic RC Detection

```matlab
% Load an image
im = imread('assets/images/samples/1.jpg');

% Detect salient region (accurate method)
mask = detect_RC(im);

% Display result
figure;
subplot(1,2,1); imshow(im); title('Original');
subplot(1,2,2); imshow(mask); title('Salient Region');
```

### Example 3: With Bounding Box

```matlab
% Load and detect
im = imread('assets/images/samples/1.jpg');
mask = detect_HC(im);

% Get bounding box
stats = regionprops(mask, 'BoundingBox');
b = stats.BoundingBox;
bbox = [ceil(b(2)), ceil(b(1)), floor(b(4)), floor(b(3))];
bbox(3) = bbox(1) + bbox(3) - 1;
bbox(4) = bbox(2) + bbox(4) - 1;

% Draw bounding box
result = drawRectangleOnImage(im, bbox);

% Display
figure;
imshow(result);
title('Detected Salient Region');
```

## Run the Demos

### Interactive Demos

```matlab
% HC method demo (fast)
cd examples/basic
demo_histogram_method

% RC method demo (accurate)
demo_region_method
```

### Benchmark Evaluation

```matlab
% Evaluate on benchmark dataset
cd examples/benchmark
testHC  % Test HC method
testRC  % Test RC method
```

## Understanding the Output

Both `detect_HC` and `detect_RC` return a **binary mask**:
- **1 (white)**: Salient pixels
- **0 (black)**: Background pixels

The mask has the same dimensions as the input image (H × W).

## Common Workflows

### Workflow 1: Extract Salient Object

```matlab
% Detect saliency
im = imread('photo.jpg');
mask = detect_HC(im);

% Extract salient region
salient_object = im;
for c = 1:3
    channel = im(:,:,c);
    channel(~mask) = 0;  % Set background to black
    salient_object(:,:,c) = channel;
end

% Display
imshow(salient_object);
```

### Workflow 2: Highlight Salient Region

```matlab
% Detect saliency
im = imread('photo.jpg');
mask = detect_HC(im);

% Create overlay
overlay = im;
red_channel = overlay(:,:,1);
red_channel(mask) = 255;  % Highlight in red
overlay(:,:,1) = red_channel;

% Display
figure;
subplot(1,2,1); imshow(im); title('Original');
subplot(1,2,2); imshow(overlay); title('Highlighted');
```

### Workflow 3: Batch Processing

```matlab
% Process multiple images
imageFiles = dir('my_images/*.jpg');

for i = 1:length(imageFiles)
    % Load image
    filename = imageFiles(i).name;
    im = imread(fullfile('my_images', filename));
    
    % Detect saliency
    mask = detect_HC(im);
    
    % Save result
    [~, name, ~] = fileparts(filename);
    imwrite(mask, fullfile('results', [name, '_mask.png']));
    
    fprintf('Processed %d/%d: %s\n', i, length(imageFiles), filename);
end
```

## Choosing the Right Method

| Feature | HC Method | RC Method |
|---------|-----------|-----------|
| Speed | ⚡ Fast (0.5-2s) | 🐢 Slower (2-10s) |
| Accuracy | ✓ Good | ✓✓ Better |
| Best for | Simple scenes | Complex scenes |
| Memory | Low | Higher |
| Dependencies | None | MEX compiler |

**Rule of thumb:**
- Start with **HC** for speed
- Use **RC** when accuracy matters

## Tips for Best Results

### 1. Image Quality
- Use good quality images (not too blurry)
- Ensure sufficient contrast between object and background
- Avoid extremely low resolution images

### 2. Performance
```matlab
% For large images, resize first
im = imread('large_image.jpg');
im_small = imresize(im, 0.5);
mask = detect_HC(im_small);
mask_full = imresize(mask, size(im, [1,2]));
```

### 3. Multiple Objects
```matlab
% To detect multiple salient regions
mask = detect_HC(im);
CC = bwconncomp(mask);
numObjects = CC.NumObjects;
fprintf('Found %d salient regions\n', numObjects);
```

## Troubleshooting

### Problem: "Undefined function 'detect_HC'"
**Solution**: Run `setup` to add paths

### Problem: "MEX file not found" (RC method)
**Solution**: 
```matlab
mex -setup C++  % Configure compiler
setup           % Rerun setup to compile
```

### Problem: Out of memory
**Solution**: Resize images before processing
```matlab
im = imresize(im, 0.5);  % Reduce to 50%
```

### Problem: No salient region detected
**Solution**: Check image contrast and content
```matlab
% Verify image loaded correctly
imshow(im);

% Check image statistics
fprintf('Min: %d, Max: %d, Mean: %.1f\n', ...
    min(im(:)), max(im(:)), mean(im(:)));
```

## Next Steps

1. **Explore Examples**: Check out `examples/` directory
2. **Read API Reference**: See `docs/API_REFERENCE.md`
3. **Benchmark**: Run evaluation on your own dataset
4. **Contribute**: See `CONTRIBUTING.md` for guidelines

## Getting Help

- 📖 Read the [full documentation](../README.md)
- 🐛 Report issues on [GitHub Issues](https://github.com/yourusername/saliencyDetection/issues)
- 💬 Ask questions in [Discussions](https://github.com/yourusername/saliencyDetection/discussions)

---

**Happy detecting!** 🎯

