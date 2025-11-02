# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- GPU acceleration for faster processing
- Python wrapper for cross-language compatibility
- Additional saliency methods (SF, FT)
- Real-time video processing
- Extended benchmark datasets

## [1.0.0] - 2025-11-02

### Added
- Initial public release
- Histogram-based Contrast (HC) saliency detection method
- Region-based Contrast (RC) saliency detection method
- Comprehensive documentation and README
- Example scripts for both methods
- Benchmark evaluation scripts
- Utility functions for visualization
- MIT License
- Contributing guidelines
- Professional project structure

### Changed
- Reorganized project structure for better maintainability
- Improved code documentation with detailed comments
- Enhanced function headers with usage examples
- Updated paths to use relative references

### Fixed
- Path resolution issues in algorithm files
- Documentation formatting and clarity
- Code style consistency across files

### Documentation
- Added comprehensive README with usage examples
- Created CONTRIBUTING.md with development guidelines
- Added LICENSE file (MIT)
- Created CHANGELOG.md for version tracking
- Improved inline code documentation

## [0.1.0] - 2011 (Original Implementation)

### Added
- Initial implementation of HC and RC methods
- Basic test scripts
- Dependencies (RGB2Lab, FelzenSegment)
- Sample images and benchmark data

---

## Version History Summary

- **1.0.0**: First official release with professional structure and documentation
- **0.1.0**: Original research implementation

## Notes

### Breaking Changes
None in this release.

### Migration Guide
If upgrading from the original implementation:
1. Update paths: `addpath(genpath('src'));`
2. Function calls remain the same: `detect_HC(image)` and `detect_RC(image)`
3. Example scripts moved to `examples/` directory
4. Assets moved to `assets/` directory

### Deprecations
None in this release.

### Known Issues
- MEX compilation may require manual setup on some systems
- Large images (>2000x2000) may be slow with RC method
- Color quantization may lose detail in images with subtle color variations

### Future Deprecation Warnings
None at this time.

---

For more details on any release, see the [GitHub Releases](https://github.com/yourusername/saliencyDetection/releases) page.

