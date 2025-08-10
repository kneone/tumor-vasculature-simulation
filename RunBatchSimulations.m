%======================= Batch Simulation Runner ==========================%
% initialCellSets: 一个 cell array，每个元素是一组 initial cell 的数据。
% 示例: {cellSet1, cellSet2, ...}
% 示例：三组数据，每组有若干个初始肿瘤点

clear all
close all
clc

% 设置文件夹路径
folderPath = 'E:\WORK\Tumor-Growth-Simulation-master\cellSets';  % 例如 'C:\Users\YourName\Documents\MATLAB\data'

% 获取文件夹中所有 .mat 文件
files = dir(fullfile(folderPath, '*.mat'));

% 初始化 cell 数组用于存储所有cellSet
initialCellSets = cell(1, numel(files));
fileNames = cell(1, numel(files));

% 遍历每个文件
for i = 1:numel(files)
    % 构建完整路径
    filePath = fullfile(folderPath, files(i).name);
    [~, name, ~] = fileparts(files(i).name);
    fileNames{i} = name;

    % 加载 .mat 文件
    data = load(filePath);

    % 假设变量名是 'cellSet'
    if isfield(data, 'cellSet')
        initialCellSets{i} = data.cellSet;
    else
        warning('文件 %s 中未找到变量 "cellSet"', files(i).name);
    end
end

% === 遍历所有 initial sets ===
for i = 1:length(initialCellSets)
    try
        fprintf('\n====== 正在运行第 %d / %d 模拟======\n', i, length(initialCellSets));

        % % === 设置输出文件夹 ===
        outputFolderName = 'TumorGrowth_Results';

        % 如果文件夹还没创建，初始化一次即可（在第一次）
        if i == 1 && ~exist(outputFolderName, 'dir')
            mkdir(outputFolderName);
        end

        % === 调用主函数，传入目标输出文件夹 ===
        Main3DTumorAngio_run(initialCellSets{i}, fileNames{i});

    catch ME
        % === 错误处理，不中断整个批次 ===
        fprintf('❌ 发生错误，终止运行模拟 %d: %s\n', i, ME.message);
        continue;  % 继续下一组数据
    end
end

fprintf('\n✅ 模拟全部结束.\n');


