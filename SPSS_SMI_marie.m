% This script is for calculating measures of responsiveness and
% Outputting them so they can be imported to spss.
% Responsive measures include RMI and bins above background in windows.
%
% Created by EHazlett 01-03-2018

% Just syllables and strings at 80 dB. Freq scan at 80 dB and BBN RLF at 80
% dB also included. tuning and monotonicity/ threshold will be analyzed
% separately if included.

ZScount = 0;
ccount = 0;
UnitID = 0;
spsscount = 0;
C = 31;

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

thresholdSMI = 0.05; % Cut off for being responsive according to SMI
thresholdRMI = 0.1; % Cut off for being responsive according to RMI
thresholdZS = 2; % Cut off for being responsive according to Z score (1.96 = 95% CI)

%% Recalculate windows based on bin size
windowResponse = windowResponse + 100;
windowResponseSlide = [ceil(windowResponse(1)/ slide), ceil(((windowResponse(2)-binSize)/slide))+1];
windowBGSlide = [ceil(windowBG(1)/ slide), ceil(((windowBG(2)-binSize)/slide))+1];
populationcount = 0;

%% Find all tests and create spss output
soundsAll = [bbnAll; toneAll; syllableAll; stringAll];
clear output


spssOutput{1, 1} = 'animalNum';
spssOutput{1, 2} = 'Date';
spssOutput{1, 3} = 'Depth';
count = 4;

for i = 1:length(soundsAll)
    spssOutput{1, count} = [soundsAll{i}, '_baselineHz'];
    spssOutput{1, count+1} = [soundsAll{i}, '_responsive_SMI'];
    spssOutput{1, count+2} = [soundsAll{i}, '_peakresponse_SMI'];
    spssOutput{1, count+3} = [soundsAll{i}, '_duration_SMI'];
    spssOutput{1, count+4} = [soundsAll{i}, '_responsive_RMI'];
    spssOutput{1, count+5} = [soundsAll{i}, '_peakresponse_RMI'];
    spssOutput{1, count+6} = [soundsAll{i}, '_duration_RMI'];
    spssOutput{1, count+7} = [soundsAll{i}, '_responsive_ZS'];
    spssOutput{1, count+8} = [soundsAll{i}, '_peakresponse_ZS'];
    spssOutput{1, count+9} = [soundsAll{i}, '_duration_ZS'];
    count = count+10;
end

%% Batch through each neuron and find each stim Set presented
dataset1 = dir('E:\Marie data\database\*.mat'); % Find the list of neurons to batch through
dataset1(end) = []; % Drop the reference matrix

for i =  1:size(dataset1,1)
    clear neuron
    load([dataset1(i).folder, '\', dataset1(i).name])
    spssOutput{i+1,1} = neuron.animalNum;
    spssOutput{i+1,2} = neuron.Date;
    spssOutput{i+1,3} = neuron.Depth;
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
                case 3
                    stim = syllableAll;
                    soundCat = 'Vocal';
                case 4
                    stim = stringAll;
                    soundCat = 'Vocal';
            end
            
            %% Batch through all stim at 80 dB SPL in this stimulus set
            for iii = 1:length(stim)
                if isfield(neuron.Sounds.(soundCat), stim{iii})
                    % Find all ways this stimulus was presented
                    clear presentationmode
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
                    
                    ccount = ccount+1;
                    contentsOutputter{ccount, 1} = neuron.animalNum;
                    contentsOutputter{ccount, 2} = neuron.Date;
                    contentsOutputter{ccount, 3} = neuron.Depth;
                    contentsOutputter{ccount, 4} = size(psth);
                    
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
                    
                    %% SMI
                    psthSlideSMI = log10((psthBinSlideHzM+C)/(baselineHzM+C));
                    
                    % response metrics
                    [peakresponseSMI, index] = max(abs(psthSlideSMI(windowResponseSlide(1):windowResponseSlide(2))));
                    peakresponseSMI = peakresponseSMI * sign(psthSlideSMI(index+windowResponseSlide(1)-1));

                    meanresponseSMI = mean(psthSlideSMI(windowResponseSlide(1):windowResponseSlide(2)));
                    responsiveSMI = abs(peakresponseSMI) > thresholdSMI;
                    durationSMI = sum(abs(psthSlideSMI(windowResponseSlide(1):windowResponseSlide(2))) > thresholdSMI); % number of bins that break threshold
                    
                    % Add to population summary
                    psthSlideSMI_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideSMI_population{populationcount,2} = stim{iii};
                    psthSlideSMI_population{populationcount,3} = baselineHzM;
                    for j = 1:length(psthSlideSMI)
                        psthSlideSMI_population{populationcount,3+j} = psthSlideSMI(j);
                    end
                    % Add to max joyplot
                    maxslideSMI{populationcount, 1} = peakresponseSMI;
                    maxslideSMI{populationcount, 2} = stim{iii};
                    % Add to mean joyplot
                    meanslideSMI{populationcount, 1} = meanresponseSMI;
                    meanslideSMI{populationcount, 2} = stim{iii};
                    
                    %% RMI
                    if baselineHzM > 0
                        psthSlideRMI = (psthBinSlideHzM-baselineHzM)/(psthBinSlideHzM+baselineHzM);
                    else
                        psthSlideRMI = nan(length(psthBinSlideHzM));
                    end
                    
                    % response metrics
                    [peakresponseRMI, index] = max(abs(psthSlideRMI(windowResponseSlide(1):windowResponseSlide(2))));
                    peakresponseRMI = peakresponseRMI * sign(psthSlideRMI(index+windowResponseSlide(1)-1));
                    
                    meanresponseRMI = mean(psthSlideRMI(windowResponseSlide(1):windowResponseSlide(2)));
                    responsiveRMI = peakresponseRMI > thresholdRMI;
                    durationRMI = sum(abs(psthSlideRMI(windowResponseSlide(1):windowResponseSlide(2))) > thresholdRMI);
                    
                    % Add to population summary
                    psthSlideRMI_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideRMI_population{populationcount,2} = stim{iii};
                    psthSlideRMI_population{populationcount,3} = baselineHzM;
                    for j = 1:length(psthSlideRMI)
                        psthSlideRMI_population{populationcount,3+j} = psthSlideRMI(j);
                    end
                    % Add to max joyplot
                    maxslideRMI{populationcount, 1} = peakresponseRMI;
                    maxslideRMI{populationcount, 2} = stim{iii};
                    % Add to mean joyplot
                    meanslideRMI{populationcount, 1} = meanresponseRMI;
                    meanslideRMI{populationcount, 2} = stim{iii};
                    
                    %% Z score
                    %                     referencepopZS = psthBinSlideHzM; %(windowBGSlide(1):windowBGSlide(2),:);
                    referencepopZS = psthBinSlideHzM(windowBGSlide(1):windowBGSlide(2),:);
                    baselineHzM = mean(reshape(referencepopZS, numel(referencepopZS), 1));% * (1000/binSize);
                    baselineHzSD = std(reshape(referencepopZS, numel(referencepopZS), 1));% * (1000/binSize);
                    if baselineHzSD ~= 0 % Can't make a z score with a sd of 0, dummy
                        psthSlideZS = (psthBinSlideHzM - baselineHzM) / (baselineHzSD);
                    else
                        psthSlideZS = nan(size(psthBinSlideHzM));
                    end
                    % response metrics
                    [peakresponseZS, index] = max(abs(psthSlideZS(windowResponseSlide(1):windowResponseSlide(2))));
                    peakresponseZS = peakresponseZS * sign(psthSlideZS(index+windowResponseSlide(1)-1));
                    
                    meanresponseZS = mean(psthSlideZS(windowResponseSlide(1):windowResponseSlide(2)));
                    responsiveZS = peakresponseZS > thresholdZS;
                    durationZS = sum(abs(psthSlideZS(windowResponseSlide(1):windowResponseSlide(2))) > thresholdZS);
                    
                    % outputter
                    ZScount = ZScount + 1;
                    ZSoutputter(ZScount, 1) = baselineHzM;
                    ZSoutputter(ZScount, 2) = baselineHzSD;
                    ZSoutputter(ZScount, 3) = baselineHzM;
                    ZSoutputter(ZScount, 4) = meanresponseZS;
                    ZSoutputter(ZScount, 5) =  max(psthSlideZS(windowResponseSlide(1):windowResponseSlide(2)));

                    % Add to population summary
                    psthSlideZS_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideZS_population{populationcount,2} = baselineHzM;
                    psthSlideZS_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthSlideRMI)
                        psthSlideZS_population{populationcount,3+j} = psthSlideZS(j);
                    end
                    % Add to max joyplot
                    maxslideZS{populationcount, 1} = peakresponseZS;
                    maxslideZS{populationcount, 2} = stim{iii};
                    % Add to mean joyplot
                    meanslideZS{populationcount, 1} = meanresponseZS;
                    meanslideZS{populationcount, 2} = stim{iii};
                    
                    for looper = windowResponseSlide(1):windowResponseSlide(2)
                        spsscount = spsscount+1;
                        smallSPSSoutput{spsscount, 1} = UnitID;
                        smallSPSSoutput{spsscount, 2} = neuron.animalNum;
                        smallSPSSoutput{spsscount, 3} = neuron.Date;
                        smallSPSSoutput{spsscount, 4} = neuron.Depth;
                        smallSPSSoutput{spsscount, 5} = stim{iii};
                        smallSPSSoutput{spsscount, 6} = baselineHzM;
                        smallSPSSoutput{spsscount, 7} = baselineHzSD;
%                         smallSPSSoutput{spsscount, 8} = responsiveSMI;
                        smallSPSSoutput{spsscount, 8} = psthSlideSMI(looper);
%                         smallSPSSoutput{spsscount, 10} = durationSMI;
%                         smallSPSSoutput{spsscount, 11} = responsiveRMI;
                        smallSPSSoutput{spsscount, 9} = psthSlideRMI(looper);
%                         smallSPSSoutput{spsscount, 13} = durationRMI;
%                         smallSPSSoutput{spsscount, 14} = responsiveZS;
                        smallSPSSoutput{spsscount, 10} = psthSlideZS(looper);
%                         smallSPSSoutput{spsscount, 16} = durationZS;
                        smallSPSSoutput{spsscount, 11} = reps;
                    end
%                     %% Add data to spss output'
%                     col = find(strcmp(soundsAll, stim{iii}));
%                     spssOutput{i+1, col*10 -9 +3} = baselineHzM;
%                     spssOutput{i+1, col*10 -8 +3} = responsiveSMI;
%                     spssOutput{i+1, col*10 -7 +3} = peakresponseSMI;
%                     spssOutput{i+1, col*10 -6 +3} = durationSMI;
%                     spssOutput{i+1, col*10 -5 +3} = responsiveRMI;
%                     spssOutput{i+1, col*10 -4 +3} = peakresponseRMI;
%                     spssOutput{i+1, col*10 -3 +3} = durationRMI;
%                     spssOutput{i+1, col*10 -2 +3} = responsiveZS;
%                     spssOutput{i+1, col*10 -1 +3} = peakresponseZS;
%                     spssOutput{i+1, col*10 -0 +3} = durationZS;
                end
                
                clear respons* psth *Hz* baseline* col nBinsOver duration* peak* psthBin*
            end
        end
    end
end

%% View what the population looks like
[~, ind] = sort(cell2mat(psthSlideZS_population(:,2)));
ZS_sorted = psthSlideZS_population(ind, :);
RMI_sorted = psthSlideRMI_population(ind, :);
SMI_sorted = psthSlideSMI_population(ind, :);

figure; imagesc(cell2mat(ZS_sorted(:,4:end))); colorbar; title('Z score'); set(gca, 'clim', [-10 30]);
figure; imagesc(cell2mat(RMI_sorted(:,4:end))); colorbar; title('RMI'); set(gca, 'clim', [-1 1]);
figure; imagesc(cell2mat(SMI_sorted(:,4:end))); colorbar; title('SMI'); set(gca, 'clim', [-0.2 0.2]);
% clearvars -except small* ZSoutputter
% unitID = cell2mat(smallSPSSoutput(:,1));
% stim = smallSPSSoutput(:,5);
% baselineHzM = cell2mat(smallSPSSoutput(:,6));
% baselineHzSD = cell2mat(smallSPSSoutput(:,7));
% reps = cell2mat(smallSPSSoutput(:,17));

% xlswrite('spssOutputter.xlsx', smallSPSSoutput)


