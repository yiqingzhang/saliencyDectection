%% Saliency Detection - Setup Script
% This script sets up the MATLAB environment for using the saliency detection toolbox.
% Run this script once after cloning the repository.
%
% Author: Saliency Detection Contributors
% Date: 2025

function setup()
    fprintf('=== Saliency Detection Setup ===\n\n');
    
    %% Get the root directory
    rootDir = fileparts(mfilename('fullpath'));
    fprintf('Root directory: %s\n', rootDir);
    
    %% Add paths
    fprintf('\nAdding paths to MATLAB search path...\n');
    
    % Add source directories
    addpath(genpath(fullfile(rootDir, 'src')));
    fprintf('  + Added src/ and subdirectories\n');
    
    % Add examples
    addpath(genpath(fullfile(rootDir, 'examples')));
    fprintf('  + Added examples/ and subdirectories\n');
    
    %% Check dependencies
    fprintf('\nChecking dependencies...\n');
    
    % Check Image Processing Toolbox
    if license('test', 'image_toolbox')
        fprintf('  ✓ Image Processing Toolbox found\n');
    else
        warning('Image Processing Toolbox not found. Some functions may not work.');
    end
    
    % Check for C++ compiler (needed for MEX)
    try
        mex.getCompilerConfigurations('C++');
        fprintf('  ✓ C++ compiler configured\n');
    catch
        warning('No C++ compiler found. MEX compilation will fail for RC method.');
        fprintf('    To fix: Run "mex -setup C++" and select a compiler\n');
    end
    
    %% Compile MEX files
    fprintf('\nCompiling MEX files...\n');
    
    mexFile = fullfile(rootDir, 'src', 'Dependencies', 'FelzenSegment', 'mexFelzenSegmentIndex.cpp');
    mexOutput = 'mexFelzenSegmentIndex';
    
    if exist(mexFile, 'file')
        try
            currentDir = pwd;
            cd(fullfile(rootDir, 'src', 'Dependencies', 'FelzenSegment'));
            mex('mexFelzenSegmentIndex.cpp', '-output', mexOutput);
            cd(currentDir);
            fprintf('  ✓ Successfully compiled mexFelzenSegmentIndex\n');
        catch ME
            warning('Failed to compile MEX file: %s', ME.message);
            fprintf('    RC method may not work until MEX file is compiled\n');
        end
    else
        warning('MEX source file not found: %s', mexFile);
    end
    
    %% Verify installation
    fprintf('\nVerifying installation...\n');
    
    % Check if main functions exist
    if exist('detect_HC', 'file')
        fprintf('  ✓ detect_HC function found\n');
    else
        warning('detect_HC function not found');
    end
    
    if exist('detect_RC', 'file')
        fprintf('  ✓ detect_RC function found\n');
    else
        warning('detect_RC function not found');
    end
    
    if exist('drawRectangleOnImage', 'file')
        fprintf('  ✓ drawRectangleOnImage function found\n');
    else
        warning('drawRectangleOnImage function not found');
    end
    
    %% Save path (optional)
    fprintf('\nDo you want to save these paths permanently? (y/n): ');
    response = input('', 's');
    
    if strcmpi(response, 'y') || strcmpi(response, 'yes')
        try
            savepath;
            fprintf('  ✓ Paths saved successfully\n');
        catch
            warning('Could not save path. You may need to run setup.m each time you start MATLAB.');
        end
    else
        fprintf('  Paths not saved. Run setup.m each time you start MATLAB.\n');
    end
    
    %% Quick test
    fprintf('\nRunning quick test...\n');
    
    testImagePath = fullfile(rootDir, 'assets', 'images', 'samples', '1.jpg');
    if exist(testImagePath, 'file')
        try
            im = imread(testImagePath);
            fprintf('  ✓ Successfully loaded test image\n');
            
            % Test HC method
            try
                result = detect_HC(im);
                fprintf('  ✓ HC method works correctly\n');
            catch ME
                warning('HC method failed: %s', ME.message);
            end
            
            % Test RC method (may fail if MEX not compiled)
            try
                result = detect_RC(im);
                fprintf('  ✓ RC method works correctly\n');
            catch ME
                warning('RC method failed: %s', ME.message);
            end
        catch ME
            warning('Test failed: %s', ME.message);
        end
    else
        fprintf('  ! Test image not found, skipping test\n');
    end
    
    %% Summary
    fprintf('\n=== Setup Complete ===\n');
    fprintf('\nQuick Start:\n');
    fprintf('  1. Try the HC demo: run examples/basic/demo_histogram_method.m\n');
    fprintf('  2. Try the RC demo: run examples/basic/demo_region_method.m\n');
    fprintf('  3. Read the documentation: open README.md\n');
    fprintf('\nFor help, see: https://github.com/yourusername/saliencyDetection\n\n');
end

