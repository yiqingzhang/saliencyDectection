# Contributing to Saliency Detection

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

This project adheres to a code of conduct that we expect all contributors to follow:

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Prioritize the community's best interests

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs. actual behavior
- **MATLAB version** and operating system
- **Sample images** (if applicable)
- **Error messages** or screenshots

**Template:**
```markdown
**Description:**
Brief description of the bug

**Steps to Reproduce:**
1. Load image X
2. Run function Y
3. Observe error Z

**Expected Behavior:**
What should happen

**Actual Behavior:**
What actually happens

**Environment:**
- MATLAB Version: R2020a
- OS: Windows 10 / macOS 12 / Ubuntu 20.04
- Image Processing Toolbox Version: X.X

**Additional Context:**
Any other relevant information
```

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Clear use case**: Why is this enhancement needed?
- **Detailed description**: What should it do?
- **Examples**: How would it be used?
- **Alternatives considered**: Other approaches you've thought about

### Pull Requests

We actively welcome your pull requests:

1. Fork the repo and create your branch from `master`
2. Make your changes
3. Add or update tests if applicable
4. Update documentation to reflect your changes
5. Ensure your code follows our style guidelines
6. Submit a pull request

## Development Setup

1. **Fork and clone** the repository:
```bash
git clone https://github.com/yourusername/saliencyDetection.git
cd saliencyDetection
```

2. **Set up MATLAB paths**:
```matlab
addpath(genpath('src'));
```

3. **Test your setup**:
```matlab
% Run a basic example
im = imread('assets/images/samples/1.jpg');
mask = detect_HC(im);
imshow(mask);
```

## Coding Guidelines

### MATLAB Style Guide

Follow these conventions for consistency:

#### File Organization

- One function per file
- File name matches function name
- Use lowercase with underscores for file names (e.g., `detect_HC.m`)

#### Function Documentation

Every function should have a header comment:

```matlab
function [output] = functionName(input1, input2)
% FUNCTIONNAME - Brief one-line description
%
% Detailed description of what the function does.
%
% Syntax:
%   output = functionName(input1, input2)
%
% Inputs:
%   input1 - Description of input1 (type, dimensions)
%   input2 - Description of input2 (type, dimensions)
%
% Outputs:
%   output - Description of output (type, dimensions)
%
% Example:
%   result = functionName(data, params);
%
% See also: RELATEDFUNCTION1, RELATEDFUNCTION2

% Implementation here
end
```

#### Code Style

- **Indentation**: Use 4 spaces (not tabs)
- **Line length**: Keep lines under 80 characters when possible
- **Variable names**: Use descriptive camelCase names
- **Constants**: Use UPPER_CASE for constants
- **Comments**: Add comments for non-obvious logic

**Good:**
```matlab
% Calculate saliency for each color
numColors = size(colorList, 1);
saliencyValues = zeros(numColors, 1);

for i = 1:numColors
    % Compute weighted color contrast
    saliencyValues(i) = computeContrast(colorList(i, :));
end
```

**Bad:**
```matlab
n=size(cl,1);
sv=zeros(n,1);
for i=1:n
sv(i)=cc(cl(i,:));
end
```

#### Error Handling

- Validate inputs at the start of functions
- Provide meaningful error messages
- Use `error()` for critical issues, `warning()` for non-critical

```matlab
function result = myFunction(image)
    % Validate inputs
    if ~isnumeric(image)
        error('myFunction:InvalidInput', 'Input must be numeric');
    end
    
    if ndims(image) ~= 3
        error('myFunction:InvalidDimensions', 'Input must be RGB image (H x W x 3)');
    end
    
    % Function implementation
    % ...
end
```

### Testing

- Test your changes with various image types and sizes
- Include edge cases (very small images, grayscale, etc.)
- Verify results are consistent with expected behavior

### Documentation

- Update README.md if you add new features
- Add examples for new functionality
- Update function headers with accurate information
- Keep comments up-to-date with code changes

## Submitting Changes

### Commit Messages

Write clear, concise commit messages:

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests when relevant

**Good commit messages:**
```
Add GPU acceleration for HC method

Implement CUDA-based color quantization to speed up
histogram-based contrast calculation by 10x.

Fixes #123
```

```
Fix memory leak in region segmentation

Release temporary buffers after processing to prevent
memory accumulation in batch processing scenarios.
```

### Pull Request Process

1. **Update documentation**: Ensure README and other docs reflect your changes
2. **Add tests**: Include test cases for new functionality
3. **Clean commit history**: Squash trivial commits
4. **Fill out PR template**: Provide context and description
5. **Link related issues**: Reference any related issues
6. **Request review**: Tag maintainers for review

**PR Template:**
```markdown
## Description
Brief description of changes

## Motivation and Context
Why is this change needed? What problem does it solve?

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Testing
Describe the tests you ran and how to reproduce them

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing tests pass locally
```

## Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- Performance optimization (vectorization, GPU acceleration)
- Additional test cases and benchmarks
- Documentation improvements
- Bug fixes

### Medium Priority
- New saliency detection methods
- Python wrapper/interface
- Video processing support
- Additional visualization tools

### Nice to Have
- GUI application
- Real-time processing
- Mobile/embedded optimization
- Additional language bindings

## Questions?

If you have questions about contributing:

1. Check existing issues and documentation
2. Open a new issue with the "question" label
3. Reach out to maintainers

## Recognition

Contributors will be:
- Listed in the project's contributor list
- Acknowledged in release notes
- Credited in relevant documentation

Thank you for contributing to Saliency Detection! 🎉

