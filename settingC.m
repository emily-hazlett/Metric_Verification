% This script is for calculating measures of responsiveness and
% Outputting them so they can be imported to spss.
% Responsive measures include RMI and bins above background in windows.
%
% Created by EHazlett 01-03-2018

% Just syllables and strings at 80 dB. Freq scan at 80 dB and BBN RLF at 80
% dB also included. tuning and monotonicity/ threshold will be analyzed
% separately if included.

normalizedBG = [];
subtractedBG=[];

% Stimuli presented in different stimulus sets
bbnAll = {'BBN_30'};
toneAll = {'Hz_15000'; 'Hz_20000'; 'Hz_25000'; 'Hz_30000'; 'Hz_35000'; 'Hz_40000'};
syllableAll = {'Biosonar'; 'DFM_QCFl'; 'DFMl'; 'DFMl_QCFl_UFM'; 'DFMs'; 'QCF'; 'UFM'; 'rBNBl'; 'rBNBs'; 'sAFM'; 'sHFM'; 'sinFM'; 'torQCF'};
stringAll = {'App1_string'; 'App2_string'; 'High1_string'; 'High3_string'; 'Low3_string'; 'Med1_string'; 'Tone25_string'; 'search2_string'};

% Analysis parameters
windowBG = [1, 100]; % window to calculate pre stim background discharge
windowResponse = [1, 200]; % window to calc early response prestim = 100 poststim= 900
slide = 5; %ms of sliding window
binSize = 10; %ms per bin for smaller psth

%% Recalculate windows based on bin size
windowResponse = windowResponse + 100;
windowResponseSlide = [ceil(windowResponse(1)/ slide), ceil(((windowResponse(2)-binSize)/slide))+1];
windowBGSlide = [ceil(windowBG(1)/ slide), ceil(((windowBG(2)-binSize)/slide))];
populationcount = 0;

%% Find all tests and create spss output
soundsAll = [bbnAll; toneAll; syllableAll; stringAll];
clear output

%% Batch through each neuron and find each stim Set presented
dataset1 = dir('E:\Marie data\database\*.mat'); % Find the list of neurons to batch through
dataset1(end) = []; % Drop the reference matrix

for i =  1:size(dataset1,1)
    clear neuron
    load([dataset1(i).folder, '\', dataset1(i).name])
    
    % Find out which stimulus sets were presented to this neuron
    clear stimSets
    stimSets(1) = isfield(neuron.Sounds, 'BBN');
    if isfield(neuron.Sounds, 'Tones')
        stimSets(2) = isfield(neuron.Sounds.Tones, 'Hz_15000');
    else
        stimSets(2) = false;
    end
    if isfield(neuron.Sounds, 'Vocal')
        stimSets(3) = isfield(neuron.Sounds.Vocal, 'Biosonar');
        stimSets(4) = isfield(neuron.Sounds.Vocal, 'App1_string');
    else
        stimSets(3:4) = false;
    end
    
    % Batch through all stimulus sets presented
    for ii = 1:length(stimSets)
        clear stim
        if stimSets(ii)
            switch ii
                case 1
                    stim = bbnAll;
                    soundCat = 'BBN';
                case 2
                    stim = toneAll;
                    soundCat = 'Tones';
                    continue
                case 3
                    stim = syllableAll;
                    soundCat = 'Vocal';
                case 4
                    stim = stringAll;
                    soundCat = 'Vocal';
                    continue
            end
            
            %% Batch through all stim at 80 dB SPL in this stimulus set
            for iii = 1:length(stim)
                if isfield(neuron.Sounds.(soundCat), stim{iii})
                    % Find all ways this stimulus was presented
                    clear presentationmode
                    presentationmode = fieldnames(neuron.Sounds.(soundCat).(stim{iii}));
                    
                    for iv = 1:length(presentationmode)
                        if isfield(neuron.Sounds.(soundCat).(stim{iii}), presentationmode{iv})
                            clear atten
                            atten = fieldnames(neuron.Sounds.(soundCat).(stim{iii}).(presentationmode{iv}));
                            for v = 1:length(atten)
                                clear test
                                test.psth = [];
                                test.psth = neuron.Sounds.(soundCat).(stim{iii}).(presentationmode{iv}).(atten{v}).peth;

                                % drop reps with NaN
                                [~, col] = find(isnan(test.psth));
                                test.psth(:, unique(col)) = [];
                                [test.bins, test.reps] = size(test.psth);
                                
                                if test.reps<30
                                    continue
                                end
                                
                                % Apply the sliding window
                                bin = 0;
                                for p = floor(binSize/2):slide:test.bins-ceil(binSize/2)
                                    bin = bin + 1;
                                    psthBinSlide (bin, 1:test.reps) = sum(test.psth(p-floor(binSize/2)+1:p+ceil(binSize/2), :));
                                end
                                clear p bin
                                
                                % mean values for psth with sliding window
                                test.psthHz = (mean(psthBinSlide, 2) / binSize) * 1000;
                                test.BGm = mean(reshape(test.psthHz(windowBGSlide(1):windowBGSlide(2),:), numel(test.psthHz(windowBGSlide(1):windowBGSlide(2),:)), 1));

                                %% Population matrices
                                populationcount = populationcount+1;
                                rawBG(populationcount) = test.BGm;
                                normalizedBG(populationcount, 1:length(test.psthHz)) = test.psthHz ./ test.BGm;
                                subtractedBG(populationcount, 1:length(test.psthHz)) = test.psthHz - test.BGm;
                                
                            end
                        end
                    end
                end
            end
        end
    end
end
clear neuron

cd('C:\Metric Verification')
% xlswrite('spssOutputter.xlsx', smallSPSSoutput)

%%
clearvars -except norm_pop* sub_pop BGM BGSD psthSlideHz_population reppers rawBG normalizedBG

% Select populations
normalizedBG2 = normalizedBG(rawBG>5, 1:16);
normalizedBG_vector = reshape(normalizedBG2, 1, numel(normalizedBG2));
sububtractedBG2 = subtractedBG(rawBG<1, 1:16); %, sub_pop(BGM<2, end-50:end)];
subtractedBG_vector = reshape(sububtractedBG2, 1, numel(sububtractedBG2));

% Clean 0s, Infs, and NaNs
normalizedBG_clean = normalizedBG_vector;
normalizedBG_clean(isinf(normalizedBG_clean) == 1) = [];
normalizedBG_clean(isnan(normalizedBG_clean) == 1) = [];
normalizedBG_clean2 = normalizedBG_clean;
normalizedBG_clean2(normalizedBG_clean2 == 0) = [];
normalizedBG_final = normalizedBG_clean2;

subtractedBG_clean = subtractedBG_vector;
subtractedBG_clean(isinf(subtractedBG_clean) == 1) = [];
subtractedBG_clean(isnan(subtractedBG_clean) == 1) = [];
subtractedBG_final = subtractedBG_clean;

% Fit a gamma dist

pd = fitdist(normalizedBG_final', 'gamma');
threshold(1) = icdf(pd, 0.05);
threshold(2) = icdf(pd, 0.95);

% Plot
figure(5);
subplot(3, 2, 1)
qqplot(normalizedBG_final, pd)
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off'); set(gca, 'TickLength', [0.0100 0.0250]);

figure(5);
subplot(3, 2, 2)
xpoints = 0:0.01:3.;
plot(xpoints, cdf(pd, xpoints))
hold on
scatter(threshold(2), 0.95, 'filled')
text(threshold(2), 0.7, ['95% CI = ', num2str(round(threshold(2),2))]);
xlabel('# of BG firing rates')
ylabel('count')
title('Cumulative probability plot')
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off'); set(gca, 'TickLength', [0.0100 0.0250]);
hold off

figure(5)
subplot(3, 2, 3:4)
h1 = histogram(normalizedBG_final, 'BinWidth', 0.05);
hold on
line([threshold(2), threshold(2)], [0 max(h1.BinCounts)], 'linewidth', 2, 'color', 'r')
xlabel('Standardized firing rate of background bins (# of BG firing rates) (w/o 0, NaN, & Inf)')
ylabel('count')
title('Histogram and thresholds')
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off');  set(gca, 'TickLength', [0.0100 0.0250]);
hold off

figure(5);
subplot(3, 2, 5:6)
h2 = histogram(subtractedBG_final, 'BinWidth', 0.1);
xlabel('Bin(Hz) - BG(Hz) of bins after response window for neurons with BG < 1Hz')
ylabel('count')
title('setting threshold for low firing neurons (<2 Hz)')
set(gca, 'xlim', [-3 3])
set(gca, 'ylim', [0 3000])
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off');  set(gca, 'TickLength', [0.0100 0.0250]);

