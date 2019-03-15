% This script is for calculating measures of responsiveness and
% Outputting them so they can be imported to spss.
% Responsive measures include RMI and bins above background in windows.
%
% Created by EHazlett 01-03-2018

% Just syllables and strings at 80 dB. Freq scan at 80 dB and BBN RLF at 80
% dB also included. tuning and monotonicity/ threshold will be analyzed
% separately if included.

ZScount = 0;
UnitID = 0;
spsscount = 0;
C = 9;
norm_pop = [];

% Stimuli presented in different stimulus sets
bbnAll = {'BBN_30'};
toneAll = {'Hz_15000'; 'Hz_20000'; 'Hz_25000'; 'Hz_30000'; 'Hz_35000'; 'Hz_40000'};
syllableAll = {'Biosonar'; 'DFM_QCFl'; 'DFMl'; 'DFMl_QCFl_UFM'; 'DFMs'; 'QCF'; 'UFM'; 'rBNBl'; 'rBNBs'; 'sAFM'; 'sHFM'; 'sinFM'; 'torQCF'};
stringAll = {'App1_string'; 'App2_string'; 'High1_string'; 'High3_string'; 'Low3_string'; 'Med1_string'; 'Tone25_string'; 'search2_string'};

% Analysis parameters
windowBG = [1, 100]; % window to calculate pre stim background discharge
windowResponse = [1, 200]; % window to calc early response prestim = 100 poststim= 900
slide = 5; %ms of sliding window
binSize = 20; %ms per bin for smaller psth

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
    UnitID = UnitID +1;
    
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
                    clear psth psthBinSlide psthBinSlideHzM baselineHzM baselineHzSD
                    presentationmode = fieldnames(neuron.Sounds.(soundCat).(stim{iii}));
                    presentationmode(contains(presentationmode, 'random')) = [];
                    
                    % Add the reps from different tests
                    psth = [];
                    for b = 1:length(presentationmode)
                        if isfield(neuron.Sounds.(soundCat).(stim{iii}).(presentationmode{b}), 'dB_80')
                            psth = [psth, neuron.Sounds.(soundCat).(stim{iii}).(presentationmode{b}).dB_80.peth];
                        end
                    end
                    
                    % drop reps with NaN
                    [~, col] = find(isnan(psth));
                    psth(:, unique(col)) = [];
                    [bins, reps] = size(psth);

                    if reps<30
                        continue
                    end
                    
                    % Apply the sliding window
                    bin = 0;
                    for p = (binSize/2):slide:bins-(binSize/2)
                        bin = bin + 1;
                        psthBinSlide (bin, 1:reps) = sum(psth(p-(binSize/2)+1:p+(binSize/2), :));
                    end
                    clear p bin
                    
                    % mean values for psth with sliding window
                    psthBinSlideHzM = (mean(psthBinSlide, 2) / binSize) * 1000;
                    baselineHzM = mean(reshape(psthBinSlideHzM(windowBGSlide(1):windowBGSlide(2),:), numel(psthBinSlideHzM(windowBGSlide(1):windowBGSlide(2),:)), 1));
                    baselineHzSD = std(reshape(psthBinSlideHzM(windowBGSlide(1):windowBGSlide(2),:), numel(psthBinSlideHzM(windowBGSlide(1):windowBGSlide(2),:)), 1));

                    populationcount = populationcount+1;
                    BGM(populationcount) = baselineHzM;
                    BGSD(populationcount) = baselineHzSD;
                    reppers(populationcount) = reps;
                    
                    %% Normalized firing rates
                    
                    norm_pop(populationcount, 1:length(psthBinSlideHzM)) = psthBinSlideHzM ./ baselineHzM;
                    sub_pop(populationcount, 1:length(psthBinSlideHzM)) = psthBinSlideHzM - baselineHzM;
                    
                    %% Raw firing rates
                    
                    % Add to population summary
                    psthSlideHz_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideHz_population{populationcount,2} = baselineHzM;
                    psthSlideHz_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthBinSlideHzM)
                        psthSlideHz_population{populationcount,3+j} = psthBinSlideHzM(j);
                    end
                    
                    %% SMI
                    clear psthSlideSMI
                    psthSlideSMI = log10((psthBinSlideHzM+C)./(baselineHzM+C));
                     
                    % Add to population summary
                    psthSlideSMI_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideSMI_population{populationcount,2} = baselineHzM;
                    psthSlideSMI_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthSlideSMI)
                        psthSlideSMI_population{populationcount,3+j} = psthSlideSMI(j);
                    end
                    
                    %% RMI
                    clear psthSlideRMI
                    if baselineHzM > 0
                        psthSlideRMI = (psthBinSlideHzM-baselineHzM)./(psthBinSlideHzM+baselineHzM);
                    else
                        psthSlideRMI = nan(length(psthBinSlideHzM));
                    end
                    
                    % Add to population summary
                    psthSlideRMI_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideRMI_population{populationcount,2} = baselineHzM;
                    psthSlideRMI_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthSlideRMI)
                        psthSlideRMI_population{populationcount,3+j} = psthSlideRMI(j);
                    end
                    
                    %% Z score
                    clear psthSlideZS
                    if baselineHzSD ~= 0 % Can't make a z score with a sd of 0, dummy
                        psthSlideZS = (psthBinSlideHzM - baselineHzM) ./ (baselineHzSD);
                    else
                        psthSlideZS = nan(size(psthBinSlideHzM));
                    end

                    % Add to population summary
                    psthSlideZS_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideZS_population{populationcount,2} = baselineHzM;
                    psthSlideZS_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthSlideRMI)
                        psthSlideZS_population{populationcount,3+j} = psthSlideZS(j);
                    end
                    
                    for looper = windowResponseSlide(1):windowResponseSlide(2)
                        spsscount = spsscount+1;
                        smallSPSSoutput{spsscount, 1} = UnitID;
                        smallSPSSoutput{spsscount, 2} = neuron.animalNum;
                        smallSPSSoutput{spsscount, 3} = neuron.Date;
                        smallSPSSoutput{spsscount, 4} = neuron.Depth;
                        smallSPSSoutput{spsscount, 5} = stim{iii};
                        smallSPSSoutput{spsscount, 6} = baselineHzM;
                        smallSPSSoutput{spsscount, 7} = baselineHzSD;
                        smallSPSSoutput{spsscount, 8} = psthSlideSMI(looper);
                        smallSPSSoutput{spsscount, 9} = psthSlideRMI(looper);
                        smallSPSSoutput{spsscount, 10} = psthSlideZS(looper);
                        smallSPSSoutput{spsscount, 11} = reps;
                    end
%                     
                end
%                 
%                 clear respons* psth baseline* col nBinsOver duration* peak* psthBin*
            end
        end
    end
end
clear neuron

%% results
% View what the population looks like
[~, ind] = sort(cell2mat(psthSlideZS_population(:,2)));
Hz_sorted = psthSlideHz_population(ind,:);
norm_sorted = norm_pop(ind, :);
ZS_sorted = psthSlideZS_population(ind, :);
RMI_sorted = psthSlideRMI_population(ind, :);
SMI_sorted = psthSlideSMI_population(ind, :);

% Hz_sorted = psthSlideHz_population(:,:);
% ZS_sorted = psthSlideZS_population(:, :);
% RMI_sorted = psthSlideRMI_population(:, :);
% SMI_sorted = psthSlideSMI_population(:, :);

% Firing rate figure
figure(1)
subplot(1, 16, 1)
line(cell2mat(Hz_sorted(:,2)),size(RMI_sorted,1):-1:1); title('BG (Hz)');
set(gca, 'ylim', [1 size(RMI_sorted, 1)])
set(gca, 'xscale', 'log')


subplot(1, 16, 2:4)
imagesc(cell2mat(Hz_sorted(:,4:end))); colorbar; colormap('jet'); title('Firing Rate'); set(gca, 'clim', [0 30]);

subplot(1, 16, 5:7)
imagesc(norm_sorted); colorbar; colormap('jet');  title('Standardized Firing Rate'); set(gca, 'clim', [0.1 10]);
set(gca, 'colorscale', 'log')

subplot(1, 16, 8:10)
imagesc(cell2mat(RMI_sorted(:,4:end))); colorbar; colormap('jet');  title('RMI'); set(gca, 'clim', [-1 1]);

subplot(1, 16, 11:13)
imagesc(cell2mat(ZS_sorted(:,4:end))); colorbar; colormap('jet');  title('Z score');  set(gca, 'clim', [-10 10]);
% hold on
% for i = 1: size(SMI_sorted(:,4:end),1)
%     scatter(1:length(ZS_sorted(i,4:end)), (cell2mat(ZS_sorted(i,4:end)) > 2)*i, 'r')
%     scatter(1:length(ZS_sorted(i,4:end)), (cell2mat(ZS_sorted(i,4:end)) < -2)*i, 'b')
% end

subplot(1, 16, 14:16)
imagesc(cell2mat(SMI_sorted(:,4:end))); colorbar; colormap('jet');  title(['SMI C = ', num2str(C)]); set(gca, 'clim', [-0.5 0.5]);
% hold on
% for i = 1: size(SMI_sorted(:,4:end),1)
%     scatter(1:length(SMI_sorted(i,4:end)), (cell2mat(SMI_sorted(i,4:end)) > 0.18)*i, 'r')
%     scatter(1:length(SMI_sorted(i,4:end)), (cell2mat(SMI_sorted(i,4:end)) < -0.29)*i, 'b')
% end

cd('C:\Metric Verification')
% xlswrite('spssOutputter.xlsx', smallSPSSoutput)

%%
clearvars -except norm_pop* sub_pop BGM BGSD psthSlideHz_population reppers

hz_pop = cell2mat(psthSlideHz_population(:, 4:end));
norm_pop2 = norm_pop(BGM>5, 1:16);
norm_pop2_vector = reshape(norm_pop2, 1, numel(norm_pop2));
sub_pop2 = sub_pop(BGM<1, 1:16); %, sub_pop(BGM<2, end-50:end)];
sub_pop2_vector = reshape(sub_pop2, 1, numel(sub_pop2));
hz_pop2 = [hz_pop(BGM>5, 1:16), hz_pop(BGM>5, end-50:end)];

norm_pop2_vector_clean = norm_pop2_vector;
norm_pop2_vector_clean(isinf(norm_pop2_vector_clean) == 1) = [];
norm_pop2_vector_clean(isnan(norm_pop2_vector_clean) == 1) = [];
sub_pop2_vector_clean = sub_pop2_vector;
sub_pop2_vector_clean(isinf(sub_pop2_vector_clean) == 1) = [];
sub_pop2_vector_clean(isnan(sub_pop2_vector_clean) == 1) = [];

norm_pop2_vector_clean2 = norm_pop2_vector_clean;
norm_pop2_vector_clean2(norm_pop2_vector_clean2 == 0) = [];

norm_pop3 = norm_pop2_vector_clean2;
pd = fitdist(norm_pop3', 'gamma');
pd2 = fitdist(norm_pop3', 'burr');

x(1) = icdf(pd, 0.05);
x(2) = icdf(pd, 0.95);

sub_pop3 = sub_pop2_vector_clean;
% TF = isoutlier(sub_pop3);
% sub_pop3(TF) = [];
Co = 2*std(sub_pop3)+mean(sub_pop3);

figure(5);
subplot(3, 2, 1)
qqplot(norm_pop3, pd)
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off'); set(gca, 'TickLength', [0.0100 0.0250]);

figure(5);
subplot(3, 2, 2)
xpoints = 0:0.01:3.;
plot(xpoints, cdf(pd, xpoints))
hold on
scatter(x(2), 0.95, 'filled')
% text(x(1), 0.3, ['95% CI = ', num2str(round(x(1), 2))]); 
text(x(2), 0.7, ['95% CI = ', num2str(round(x(2),2))]); 
xlabel('# of BG firing rates')
ylabel('count')
title('Cumulative probability plot')
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off'); set(gca, 'TickLength', [0.0100 0.0250]);
hold off

figure(5)
subplot(3, 2, 3:4)
h1 = histogram(norm_pop3, 'BinWidth', 0.05);
hold on
% plot(xpoints, pdf(pd, xpoints)*(max(h1.BinCounts)/max(pdf(pd, xpoints))))
line([x(1), x(1)], [0 max(h1.BinCounts)], 'linewidth', 2, 'color', 'r')
line([x(2), x(2)], [0 max(h1.BinCounts)], 'linewidth', 2, 'color', 'r')
xlabel('Standardized firing rate of background bins (# of BG firing rates) (w/o 0, NaN, & Inf)')
ylabel('count')
title('Histogram and thresholds')
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off');  set(gca, 'TickLength', [0.0100 0.0250]);
hold off

figure(5);
subplot(3, 2, 5:6)
h2 = histogram(sub_pop3, 'BinWidth', 0.1);
xlabel('Bin(Hz) - BG(Hz) of bins after response window for neurons with BG < 2Hz')
ylabel('count')
title('setting threshold for low firing neurons (<2 Hz)')
% text(1, 2000, ['C^o = ', num2str(Co)])
set(gca, 'xlim', [-3 3])
set(gca, 'ylim', [0 3000])
set(gca, 'tickdir', 'out'); set(gca, 'box', 'off');  set(gca, 'TickLength', [0.0100 0.0250]);

