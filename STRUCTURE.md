# Repository Structure

Complete overview of the Saliency Detection repository structure.

```
saliencyDectection/
│
├── 📄 README.md                      # Main project documentation (287 lines)
├── 📄 LICENSE                        # MIT License (31 lines)
├── 📄 CONTRIBUTING.md               # Contribution guidelines (309 lines)
├── 📄 CHANGELOG.md                  # Version history (90 lines)
├── 📄 PROJECT_SUMMARY.md            # Reorganization summary
├── 📄 STRUCTURE.md                  # This file
├── 📄 .gitignore                    # Git ignore rules
├── 📄 setup.m                       # Setup script (4789 chars)
│
├── 📁 src/                          # Source code
│   ├── 📁 algorithms/               # Core detection algorithms
│   │   ├── detect_HC.m             # Histogram-based Contrast method
│   │   └── detect_RC.m             # Region-based Contrast method
│   │
│   ├── 📁 utils/                    # Utility functions
│   │   └── drawRectangleOnImage.m  # Bounding box drawing
│   │
│   └── 📁 Dependencies/             # Third-party code
│       ├── 📁 RGB2Lab/             # Color space conversion
│       │   ├── RGB2Lab.m
│       │   └── license.txt
│       │
│       └── 📁 FelzenSegment/       # Image segmentation
│           ├── mexFelzenSegmentIndex.cpp
│           ├── segment-image.h
│           ├── segment-graph.h
│           ├── disjoint-set.h
│           ├── image.h
│           ├── filter.h
│           ├── convolve.h
│           ├── imutil.h
│           ├── imconv.h
│           ├── misc.h
│           ├── pnmfile.h
│           ├── README
│           ├── COPYING
│           └── Makefile
│
├── 📁 examples/                     # Example scripts
│   ├── 📄 README.md                # Examples documentation (253 lines)
│   │
│   ├── 📁 basic/                   # Basic usage demos
│   │   ├── demo_histogram_method.m # HC method demo with visualization
│   │   └── demo_region_method.m    # RC method demo with visualization
│   │
│   └── 📁 benchmark/               # Benchmark evaluation
│       ├── testHC.m                # HC method evaluation
│       └── testRC.m                # RC method evaluation
│
├── 📁 assets/                       # Images and results
│   ├── 📁 images/                  # Input images
│   │   ├── 📁 samples/            # Example images (1.jpg - 6.jpg)
│   │   │   ├── 1.jpg
│   │   │   ├── 2.jpg
│   │   │   ├── 3.jpg
│   │   │   ├── 4.jpg
│   │   │   ├── 5.jpg
│   │   │   └── 6.jpg
│   │   │
│   │   └── 📁 benchmark/          # Benchmark dataset (sample)
│   │       ├── 75.jpg
│   │       ├── 75.png             # Ground truth
│   │       ├── 77.jpg
│   │       ├── 77.png
│   │       ├── 101.jpg
│   │       ├── 101.png
│   │       ├── 124.jpg
│   │       ├── 124.png
│   │       ├── 137.jpg
│   │       └── 137.png
│   │
│   └── 📁 results/                 # Output results
│       ├── 📁 pic/                # Result images
│       │   ├── HC.png
│       │   ├── hc_result.png
│       │   ├── RC.png
│       │   └── rc_result.png
│       │
│       ├── precision_HC.csv        # HC precision per image
│       ├── recall_HC.csv           # HC recall per image
│       ├── precision_average_HC.csv # HC average precision
│       ├── recall_average_HC.csv   # HC average recall
│       ├── precision_RC.csv        # RC precision per image
│       ├── recall_RC.csv           # RC recall per image
│       ├── precision_average_RC.csv # RC average precision
│       └── recall_average_RC.csv   # RC average recall
│
└── 📁 docs/                         # Documentation
    ├── API_REFERENCE.md            # Detailed API documentation (309 lines)
    └── QUICK_START.md              # Quick start guide (259 lines)
```

## File Count Summary

| Category | Count | Description |
|----------|-------|-------------|
| **MATLAB Files** | 10 | Core algorithms, utilities, examples |
| **Documentation** | 8 | README, guides, references |
| **Images** | 16 | Sample images + benchmark dataset |
| **Results** | 12 | CSV files + result images |
| **Dependencies** | 15+ | Third-party code files |
| **Config Files** | 3 | .gitignore, LICENSE, setup |

## Key Files

### Essential Files
- `README.md` - Start here! Main project documentation
- `setup.m` - Run this first to configure environment
- `LICENSE` - MIT License terms

### For Users
- `docs/QUICK_START.md` - 5-minute getting started guide
- `examples/basic/demo_*.m` - Interactive demos
- `docs/API_REFERENCE.md` - Function documentation

### For Contributors
- `CONTRIBUTING.md` - How to contribute
- `CHANGELOG.md` - Version history
- `PROJECT_SUMMARY.md` - Reorganization details

### Core Algorithms
- `src/algorithms/detect_HC.m` - Fast, histogram-based method
- `src/algorithms/detect_RC.m` - Accurate, region-based method
- `src/utils/drawRectangleOnImage.m` - Visualization utility

### Examples
- `examples/basic/demo_histogram_method.m` - HC demo
- `examples/basic/demo_region_method.m` - RC demo
- `examples/benchmark/testHC.m` - HC evaluation
- `examples/benchmark/testRC.m` - RC evaluation

## Directory Purposes

### `/src`
Contains all source code organized by function:
- **algorithms/** - Core saliency detection methods
- **utils/** - Helper functions
- **Dependencies/** - Third-party libraries

### `/examples`
Demonstration and evaluation scripts:
- **basic/** - Simple usage examples
- **benchmark/** - Performance evaluation

### `/assets`
Data files and results:
- **images/samples/** - Test images
- **images/benchmark/** - Evaluation dataset
- **results/** - Output metrics and visualizations

### `/docs`
Additional documentation:
- API reference
- Quick start guide
- Tutorials (future)

## Size Statistics

| Component | Lines of Code | Lines of Docs |
|-----------|--------------|---------------|
| Core Algorithms | ~500 | ~100 |
| Utilities | ~50 | ~20 |
| Examples | ~400 | ~100 |
| Documentation | - | ~1,500 |
| **Total** | **~950** | **~1,720** |

## Navigation Tips

**To get started:**
1. Read `README.md`
2. Run `setup.m`
3. Try `examples/basic/demo_histogram_method.m`

**To understand the code:**
1. Read `docs/API_REFERENCE.md`
2. Look at `src/algorithms/detect_HC.m`
3. Study the examples

**To contribute:**
1. Read `CONTRIBUTING.md`
2. Check `CHANGELOG.md` for version info
3. Follow the coding guidelines

**To evaluate:**
1. Add images to `assets/images/benchmark/`
2. Run `examples/benchmark/testHC.m`
3. Check results in `assets/results/`

## Dependencies

### MATLAB Toolboxes
- Image Processing Toolbox (required)
- Parallel Computing Toolbox (optional)

### Third-party Code
- **RGB2Lab** - Color space conversion
- **FelzenSegment** - Graph-based segmentation (requires MEX compilation)

### System Requirements
- MATLAB R2014a or later
- C++ compiler (for RC method)
- ~100 MB disk space

---

**Last Updated**: November 2, 2025  
**Version**: 1.0.0

