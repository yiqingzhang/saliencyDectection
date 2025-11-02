# Saliency Detection

[![MATLAB](https://img.shields.io/badge/MATLAB-R2014a+-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A MATLAB implementation of **Global Contrast based Salient Region Detection** algorithms from the paper by Cheng et al. (CVPR 2011). This repository provides two complementary methods for detecting visually salient regions in images:

- **HC (Histogram-based Contrast)**: Fast, color-based saliency detection
- **RC (Region-based Contrast)**: More accurate, region-based saliency detection with spatial information

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Methods](#methods)
- [Examples](#examples)
- [Benchmark Results](#benchmark-results)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [Citation](#citation)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## ✨ Features

- **Two complementary algorithms**: HC (fast) and RC (accurate)
- **Easy-to-use API**: Simple function calls with clear documentation
- **Benchmark evaluation**: Precision and recall metrics on standard datasets
- **Visualization tools**: Draw bounding boxes and visualize saliency maps
- **Well-documented code**: Clear comments and structured implementation
- **Example scripts**: Ready-to-run demos for both methods

## 🚀 Installation

### Prerequisites

- MATLAB R2014a or later
- Image Processing Toolbox
- C++ compiler for MEX files (for RC method)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/saliencyDetection.git
cd saliencyDetection
```

2. Add the source directory to your MATLAB path:
```matlab
addpath(genpath('src'));
```

3. (Optional) For the RC method, the MEX file will be compiled automatically on first run. To compile manually:
```matlab
cd src/Dependencies/FelzenSegment
mex mexFelzenSegmentIndex.cpp -output mexFelzenSegmentIndex
```

## 🎯 Quick Start

### Histogram-based Contrast (HC) Method

```matlab
% Load an image
im = imread('assets/images/samples/1.jpg');

% Detect salient region using HC method
saliency_mask = detect_HC(im);

% Display results
figure;
subplot(1,2,1); imshow(im); title('Original Image');
subplot(1,2,2); imshow(saliency_mask); title('Saliency Map (HC)');
```

### Region-based Contrast (RC) Method

```matlab
% Load an image
im = imread('assets/images/samples/1.jpg');

% Detect salient region using RC method
saliency_mask = detect_RC(im);

% Display results
figure;
subplot(1,2,1); imshow(im); title('Original Image');
subplot(1,2,2); imshow(saliency_mask); title('Saliency Map (RC)');
```

## 📖 Usage

### Basic Detection

Both methods return a binary mask where `1` indicates salient regions and `0` indicates background:

```matlab
% HC Method - Fast, color-based
mask_hc = detect_HC(image);

% RC Method - Accurate, region-based
mask_rc = detect_RC(image);
```

### Drawing Bounding Boxes

```matlab
% Get bounding box from saliency mask
STATS = regionprops(mask_hc, 'BoundingBox');
b = STATS.BoundingBox;
bbox = [ceil(b(2)), ceil(b(1)), floor(b(4)), floor(b(3))];
bbox(3) = bbox(1) + bbox(3) - 1;
bbox(4) = bbox(2) + bbox(4) - 1;

% Draw bounding box on image
result = drawRectangleOnImage(image, bbox);
imshow(result);
```

### Running Examples

```matlab
% Run HC method demo
cd examples/basic
demo_histogram_method

% Run RC method demo
demo_region_method
```

### Benchmark Evaluation

```matlab
% Evaluate HC method on benchmark dataset
cd examples/benchmark
testHC

% Evaluate RC method on benchmark dataset
testRC
```

Results will be saved as CSV files in `assets/results/`.

## 🔬 Methods

### Histogram-based Contrast (HC)

The HC method computes saliency based on color contrast in the image histogram:

1. **Color Quantization**: RGB space is quantized into 12×12×12 discrete colors
2. **Color Space Conversion**: Colors are converted to LAB space for perceptual uniformity
3. **Color Reduction**: Rare colors (5%) are mapped to nearest main colors (95%)
4. **Saliency Calculation**: Each color's saliency is computed as the sum of color distances weighted by color frequency
5. **Spatial Smoothing**: Saliency values are smoothed using color space neighbors
6. **Thresholding**: Binary mask is created using adaptive thresholding

**Advantages**: Fast, simple, good for images with distinct color regions

### Region-based Contrast (RC)

The RC method segments the image and computes region-level saliency:

1. **Image Segmentation**: Felzenszwalb-Huttenlocher algorithm creates perceptually uniform regions
2. **Color Quantization**: Same as HC method
3. **Region Features**: Color histogram is computed for each region
4. **Region Contrast**: Pairwise color distance between all regions
5. **Spatial Weighting**: Contrast is weighted by spatial distance and region size
6. **Saliency Aggregation**: Final saliency combines contrast and spatial information

**Advantages**: More accurate, considers spatial relationships, better for complex scenes

## 🖼️ Examples

### Input and Output Comparison

| Original Image | HC Saliency Map | RC Saliency Map |
|:--------------:|:---------------:|:---------------:|
| ![Input](assets/results/pic/HC.png) | ![HC Result](assets/results/pic/hc_result.png) | ![RC Result](assets/results/pic/rc_result.png) |

### Sample Results

The `assets/images/samples/` directory contains example images (1.jpg - 6.jpg) that you can use to test the algorithms.

## 📊 Benchmark Results

Performance metrics on the benchmark dataset:

| Method | Average Precision | Average Recall |
|--------|------------------|----------------|
| HC     | See `assets/results/precision_average_HC.csv` | See `assets/results/recall_average_HC.csv` |
| RC     | See `assets/results/precision_average_RC.csv` | See `assets/results/recall_average_RC.csv` |

Detailed per-image results are available in the `assets/results/` directory.

## 📁 Project Structure

```
saliencyDetection/
├── src/                          # Source code
│   ├── algorithms/               # Core detection algorithms
│   │   ├── detect_HC.m          # Histogram-based Contrast method
│   │   └── detect_RC.m          # Region-based Contrast method
│   ├── utils/                   # Utility functions
│   │   └── drawRectangleOnImage.m
│   └── Dependencies/            # Third-party dependencies
│       ├── RGB2Lab/             # RGB to LAB color conversion
│       └── FelzenSegment/       # Image segmentation (Felzenszwalb)
├── examples/                    # Example scripts
│   ├── basic/                   # Basic usage demos
│   │   ├── demo_histogram_method.m
│   │   └── demo_region_method.m
│   └── benchmark/               # Benchmark evaluation scripts
│       ├── testHC.m
│       └── testRC.m
├── assets/                      # Images and results
│   ├── images/                  # Sample and benchmark images
│   │   ├── samples/            # Example images for testing
│   │   └── benchmark/          # Benchmark dataset (small sample)
│   └── results/                # Output results and metrics
├── docs/                        # Additional documentation
├── README.md                    # This file
├── LICENSE                      # MIT License
├── CONTRIBUTING.md             # Contribution guidelines
├── CHANGELOG.md                # Version history
└── .gitignore                  # Git ignore rules
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- How to submit issues
- How to propose new features
- Code style guidelines
- Pull request process

## 📝 Citation

If you use this code in your research, please cite the original paper:

```bibtex
@inproceedings{cheng2011global,
  title={Global Contrast based Salient Region Detection},
  author={Cheng, Ming-Ming and Zhang, Guo-Xin and Mitra, Niloy J. and Huang, Xiaolei and Hu, Shi-Min},
  booktitle={IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
  pages={409--416},
  year={2011},
  organization={IEEE}
}
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Original Paper**: Ming-Ming Cheng et al., "Global Contrast based Salient Region Detection", CVPR 2011
- **Segmentation Algorithm**: Felzenszwalb and Huttenlocher, "Efficient Graph-Based Image Segmentation", IJCV 2004
- **RGB2Lab Conversion**: Color space conversion utilities

## 🗺️ Roadmap

Future improvements and features:

- [ ] Add GPU acceleration for faster processing
- [ ] Implement additional saliency detection methods (e.g., SF, FT)
- [ ] Add Python wrapper for cross-language compatibility
- [ ] Extend benchmark evaluation with more datasets (MSRA, ECSSD, etc.)
- [ ] Add real-time video saliency detection
- [ ] Optimize memory usage for large images
- [ ] Add multi-scale saliency detection
- [ ] Create GUI for interactive saliency detection

## 📧 Contact

For questions, issues, or suggestions, please:
- Open an issue on GitHub
- Contact the maintainers

---

**Note**: This is a research implementation. For production use, consider optimizing the code for your specific use case.
