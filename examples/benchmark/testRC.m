%% Benchmark Evaluation for RC Method
% This script evaluates the Region-based Contrast (RC) method on a benchmark dataset.
% It computes precision and recall metrics for each image and saves the results.
%
% Author: Based on Cheng et al., CVPR 2011
% Date: 2025

%% Setup
clc; clear; close all;

% Add paths
addpath(genpath('../../src'));

%% Configuration
% Directory containing test images and ground truth
dirName = {'../../assets/images/benchmark'};

% Output directory for results
outputDir = '../../assets/results';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

fprintf('=== RC Method Benchmark Evaluation ===\n');
fprintf('Dataset: %s\n\n', dirName{1});

%% Process Images
counter = 1;
precisionList = [];
recallList = [];

for j = 1:length(dirName)
    theDir = dir(dirName{j});
    
    for i = 1:size(theDir, 1)
        if ~theDir(i).isdir
            filename = theDir(i).name;
            
            % Process only JPG images
            if length(filename) > 4 && strcmp(filename(end-3:end), '.jpg')
                % Construct paths
                groundTruthFilename = [filename(1:end-4), '.png'];
                imagePath = fullfile(dirName{j}, filename);
                gtPath = fullfile(dirName{j}, groundTruthFilename);
                
                % Check if ground truth exists
                if ~exist(gtPath, 'file')
                    fprintf('Warning: Ground truth not found for %s\n', filename);
                    continue;
                end
                
                fprintf('Processing [%d]: %s... ', counter, filename);
                
                % Load image and ground truth
                im = imread(imagePath);
                GT_image = imread(gtPath);
                
                % Detect salient region using RC method
                tic;
                result = detect_RC(im);
                elapsed = toc;
                
                % Compute metrics
                pos_result = find(result == 1);
                pos_GT = find(GT_image == 255);
                
                resultSize = length(pos_result);
                GTSize = length(pos_GT);
                intersectionSize = length(intersect(pos_GT, pos_result));
                
                % Calculate precision and recall
                if resultSize > 0
                    precision = intersectionSize / resultSize;
                else
                    precision = 0;
                    fprintf('Warning: No detection! ');
                end
                
                if GTSize > 0
                    recall = intersectionSize / GTSize;
                else
                    recall = 0;
                    fprintf('Warning: Empty ground truth! ');
                end
                
                precisionList(counter) = precision;
                recallList(counter) = recall;
                
                fprintf('P=%.3f, R=%.3f (%.2fs)\n', precision, recall, elapsed);
                
                counter = counter + 1;
            end
        end
    end
end

%% Compute Statistics
if ~isempty(precisionList)
    averagePrecision = mean(precisionList);
    averageRecall = mean(recallList);
    stdPrecision = std(precisionList);
    stdRecall = std(recallList);
    
    fprintf('\n=== Results Summary ===\n');
    fprintf('Total images processed: %d\n', length(precisionList));
    fprintf('Average Precision: %.4f ± %.4f\n', averagePrecision, stdPrecision);
    fprintf('Average Recall: %.4f ± %.4f\n', averageRecall, stdRecall);
    fprintf('F-measure: %.4f\n', 2 * averagePrecision * averageRecall / (averagePrecision + averageRecall));
    
    %% Save Results
    fprintf('\nSaving results to %s...\n', outputDir);
    
    csvwrite(fullfile(outputDir, 'precision_RC.csv'), precisionList);
    csvwrite(fullfile(outputDir, 'recall_RC.csv'), recallList);
    csvwrite(fullfile(outputDir, 'precision_average_RC.csv'), averagePrecision);
    csvwrite(fullfile(outputDir, 'recall_average_RC.csv'), averageRecall);
    
    %% Plot Results
    figure('Name', 'RC Method Benchmark Results', 'Position', [100, 100, 1000, 400]);
    
    subplot(1, 2, 1);
    plot(precisionList, 'b-o', 'LineWidth', 1.5);
    hold on;
    plot(recallList, 'r-s', 'LineWidth', 1.5);
    yline(averagePrecision, 'b--', 'LineWidth', 1);
    yline(averageRecall, 'r--', 'LineWidth', 1);
    xlabel('Image Index');
    ylabel('Score');
    title('RC Method: Precision and Recall per Image');
    legend('Precision', 'Recall', 'Avg Precision', 'Avg Recall', 'Location', 'best');
    grid on;
    ylim([0, 1]);
    
    subplot(1, 2, 2);
    bar([averagePrecision, averageRecall]);
    set(gca, 'XTickLabel', {'Precision', 'Recall'});
    ylabel('Score');
    title('RC Method: Average Metrics');
    ylim([0, 1]);
    grid on;
    
    % Add error bars
    hold on;
    errorbar([1, 2], [averagePrecision, averageRecall], [stdPrecision, stdRecall], 'k.', 'LineWidth', 1.5);
    
    % Save figure
    saveas(gcf, fullfile(outputDir, 'benchmark_RC.png'));
    
    fprintf('Results saved successfully!\n');
else
    fprintf('Error: No images were processed!\n');
end

fprintf('\nBenchmark evaluation complete.\n');
