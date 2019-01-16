%% This script batches through the 


% Analysis parameters
windowBG = [1, 100]; % window to calculate pre stim background discharge
windowResponse = [1, 200]; % window to calc early response prestim = 100 poststim= 900
slide = 5; %ms of sliding window
binSize = 20; %ms per bin for smaller psth

%% Set up
% randomize order to blind
load('C:\Metric Verification\matlab\datasetTests.mat')
orderIndex = 1:length(datasetTests.nReps);
orderIndex = orderIndex(randperm(length(orderIndex)));
results = zeros(1,length(orderIndex));

% Identify the total dataset
dataset1 = dir('E:\Marie data\database\*.mat'); % Find the list of neurons to batch through
dataset1(end) = []; % Drop the reference matrix
plots = figure('units','normalized','outerposition',[0 0 1 1]);

% Define classification dialouge box
prompt = {'1 - No Response 2 - Maybe Response 3 - Definite Response 4 - Strong Response'};
title = 'Eye classification';
dims = [1 35];
definput = {'1'};

%% Batch
for i =  1:length(datasetTests.nReps)
    clear psth* selectTest neuron answer
    % Find animal and depth, then load neuron
    selectTest.animalnum = datasetTests.animalnum(orderIndex(i));
    selectTest.depth = datasetTests.depth(orderIndex(i));
    
    fileList = struct2cell(dataset1);
    fileList = fileList(1,:);
    fileSelect = contains(fileList, num2str(selectTest.animalnum)) & contains(fileList, num2str(selectTest.depth));
    
    load(['E:\Marie data\database\', dataset1(find(fileSelect)).name])
    
    % Find stimulus for selected test
    selectTest.stim = datasetTests.stimulus{orderIndex(i)}(:,:);
    
    if contains(selectTest.stim, 'BBN30')
        selectTest.soundCat = 'BBN';
    else
        selectTest.soundCat = 'Vocal';
    end
    
    % Build psth
    selectTest.presentationmode = fieldnames(neuron.Sounds.(selectTest.soundCat).(selectTest.stim));
    selectTest.presentationmode(contains(selectTest.presentationmode, 'random')) = [];
    
    selectTest.psth = [];
    for b = 1:length(selectTest.presentationmode)
        if isfield(neuron.Sounds.(selectTest.soundCat).(selectTest.stim).(selectTest.presentationmode{b}), 'dB_80')
            selectTest.psth = [selectTest.psth, neuron.Sounds.(selectTest.soundCat).(selectTest.stim).(selectTest.presentationmode{b}).dB_80.peth];
        end
    end
    
    [~, col] = find(isnan(selectTest.psth));
    selectTest.psth(:, unique(col)) = [];
    [selectTest.bins, selectTest.reps] = size(selectTest.psth);
    [selectTest.rasterrow, selectTest.raster] = find(selectTest.psth);
    
    % Apply the sliding window and find average response
    bin = 0;
    for fileList = (binSize/2):slide:selectTest.bins-(binSize/2)
        bin = bin + 1;
        psthBinSlide (bin, 1:selectTest.reps) = sum(selectTest.psth(fileList-(binSize/2)+1:fileList+(binSize/2), :));
    end
    clear p bin
    
    psthBinSlideHzM = (mean(psthBinSlide, 2) / binSize) * 1000;
    selectTest.binsSlide = length(psthBinSlideHzM);
    
    % plot the test response
    selectTest.heighth =max(psthBinSlideHzM)+5;
    selectTest.rasterspacer = selectTest.heighth / selectTest.reps;
    %%
    figure(plots)
    xpoints = [windowResponse(1), windowResponse(1), windowResponse(2), windowResponse(2)];
    ypoints = [0, selectTest.heighth+2, selectTest.heighth+2, 0];
    fill(xpoints, ypoints, [0.85 0.85 0.85])
    hold on
    plot(linspace(-100, 900, selectTest.binsSlide), psthBinSlideHzM, 'linewidth', 2, 'Color', [0.3 0.3 0.3])
    scatter(selectTest.rasterrow-100, selectTest.raster*selectTest.rasterspacer, 8, 'filled', 'k')
    ylim([0 selectTest.heighth])
    xlim([-(100+5) (900 +5)])
    set(gca, 'TickDir', 'out')
    set(gca, 'FontName', 'Arial Narrow')
    set(gca, 'fontsize', 8)
    %         set(gca, 'ytick', [])
    set(gca, 'xcolor', 'k')
    set(gca, 'box', 'off')
    hold off
    %%
    % Classify response
    answer = inputdlg(prompt,title,dims,definput);
    results(orderIndex(i)) = str2double(answer{:,:});
   disp([num2str(i), '/', num2str(length(results)) , ' processed'])
end

save(['C:\Metric Verification\matlab\', date, '.mat'], 'results')

f = warndlg('You finished!');