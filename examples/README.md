# Examples

This directory contains example scripts demonstrating how to use the saliency detection algorithms.

## Directory Structure

```
examples/
├── basic/              # Basic usage examples
│   ├── demo_histogram_method.m
│   └── demo_region_method.m
└── benchmark/          # Benchmark evaluation scripts
    ├── testHC.m
    └── testRC.m
```

## Basic Examples

### demo_histogram_method.m

Demonstrates the **Histogram-based Contrast (HC)** method with step-by-step visualization.

**Features:**
- Shows all intermediate processing steps
- Displays color quantization
- Visualizes saliency map
- Draws bounding box
- Reports timing and statistics

**Usage:**
```matlab
cd examples/basic
demo_histogram_method
```

**What you'll see:**
- 9-panel figure showing the complete pipeline
- Processing time and statistics
- Side-by-side comparison

### demo_region_method.m

Demonstrates the **Region-based Contrast (RC)** method with detailed visualization.

**Features:**
- Shows image segmentation
- Displays region-level processing
- Visualizes saliency map
- Draws bounding box
- Reports timing and region statistics

**Usage:**
```matlab
cd examples/basic
demo_region_method
```

**What you'll see:**
- 9-panel figure with segmentation and saliency
- Region count and processing time
- Comparison visualization

## Benchmark Examples

### testHC.m

Evaluates the HC method on a benchmark dataset.

**Features:**
- Processes all images in benchmark directory
- Computes precision and recall for each image
- Calculates average metrics
- Saves results to CSV files
- Generates performance plots

**Usage:**
```matlab
cd examples/benchmark
testHC
```

**Output:**
- `precision_HC.csv` - Per-image precision
- `recall_HC.csv` - Per-image recall
- `precision_average_HC.csv` - Average precision
- `recall_average_HC.csv` - Average recall
- `benchmark_HC.png` - Performance visualization

### testRC.m

Evaluates the RC method on a benchmark dataset.

**Features:**
- Same as testHC but for RC method
- Compares region-based approach
- Saves separate results

**Usage:**
```matlab
cd examples/benchmark
testRC
```

**Output:**
- `precision_RC.csv` - Per-image precision
- `recall_RC.csv` - Per-image recall
- `precision_average_RC.csv` - Average precision
- `recall_average_RC.csv` - Average recall
- `benchmark_RC.png` - Performance visualization

## Customizing Examples

### Change Input Image

In the demo scripts, modify the `imageNumber` variable:

```matlab
% Choose an image (1-6)
imageNumber = 3;  % Change this
```

Or specify a custom path:

```matlab
imagePath = 'path/to/your/image.jpg';
im = imread(imagePath);
```

### Adjust Visualization

Modify the subplot layout or add custom visualizations:

```matlab
% Add custom subplot
subplot(3, 3, 9);
imshow(your_custom_result);
title('Custom Visualization');
```

### Save Results

Add code to save results:

```matlab
% Save saliency mask
imwrite(BW_with_biggest_CC, 'saliency_mask.png');

% Save result with bounding box
imwrite(finalIm, 'result_with_bbox.jpg');
```

## Running All Examples

To run all basic examples:

```matlab
cd examples/basic
demo_histogram_method
pause(2)  % Wait 2 seconds
demo_region_method
```

To run all benchmarks:

```matlab
cd examples/benchmark
testHC
pause(2)
testRC
```

## Tips

1. **Close figures between runs** to avoid clutter:
   ```matlab
   close all
   ```

2. **Suppress output** for batch processing:
   ```matlab
   % Add at the start of script
   warning('off', 'all')
   ```

3. **Time individual steps**:
   ```matlab
   tic
   mask = detect_HC(im);
   elapsed = toc;
   fprintf('Detection took %.2f seconds\n', elapsed);
   ```

4. **Compare methods side-by-side**:
   ```matlab
   im = imread('test.jpg');
   
   tic; mask_hc = detect_HC(im); time_hc = toc;
   tic; mask_rc = detect_RC(im); time_rc = toc;
   
   figure;
   subplot(1,3,1); imshow(im); title('Original');
   subplot(1,3,2); imshow(mask_hc); title(sprintf('HC (%.2fs)', time_hc));
   subplot(1,3,3); imshow(mask_rc); title(sprintf('RC (%.2fs)', time_rc));
   ```

## Creating Your Own Examples

Use this template for new examples:

```matlab
%% My Custom Example
% Description of what this example does
%
% Author: Your Name
% Date: YYYY-MM-DD

%% Setup
clc; clear; close all;
addpath(genpath('../../src'));

%% Load Image
im = imread('../../assets/images/samples/1.jpg');

%% Process
% Your processing code here
mask = detect_HC(im);

%% Visualize
figure;
subplot(1,2,1); imshow(im); title('Input');
subplot(1,2,2); imshow(mask); title('Output');

%% Report Results
fprintf('Processing complete!\n');
```

## Troubleshooting

**Problem**: "File not found" errors
- **Solution**: Make sure you're in the correct directory or use absolute paths

**Problem**: Figures overlap
- **Solution**: Use `figure('Position', [x, y, width, height])` to position windows

**Problem**: Out of memory in benchmark
- **Solution**: Process images in smaller batches or resize images

## See Also

- [Quick Start Guide](../docs/QUICK_START.md)
- [API Reference](../docs/API_REFERENCE.md)
- [Main README](../README.md)

