% This script is for calculating measures of responsiveness and
% Outputting them so they can be imported to spss.
% Responsive measures include RMI and bins above background in windows.
%
% Created by EHazlett 01-03-2018

% Just syllables and strings at 80 dB. Freq scan at 80 dB and BBN RLF at 80
% dB also included. tuning and monotonicity/ threshold will be analyzed
% separately if included.

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
C = 8;

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
UnitID = 0;
spsscount = 0;

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
                case 3
                    stim = syllableAll;
                    soundCat = 'Vocal';
                case 4
                    stim = stringAll;
                    soundCat = 'Vocal';
                    continue % Don't want to include strings for this analysis, but don't want to break the code
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
                    clear psthSlideRS
                    psthSlideRS = log10(psthBinSlideHzM ./ baselineHzM);

                    % Add to population summary
                    psthSlideRS_population{populationcount,1} = [num2str(neuron.animalNum), '_', neuron.Date, '_', num2str(neuron.Depth)];
                    psthSlideRS_population{populationcount,2} = baselineHzM;
                    psthSlideRS_population{populationcount,3} = stim{iii};
                    for j = 1:length(psthSlideRS)
                        psthSlideRS_population{populationcount,3+j} = psthSlideRS(j);
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
                    
                    %% Output
                    
                    for looper = windowResponseSlide(1):windowResponseSlide(2)
                        spsscount = spsscount+1;
                        smallSPSSoutput{spsscount, 1} = UnitID;
                        smallSPSSoutput{spsscount, 2} = neuron.animalNum;
                        smallSPSSoutput{spsscount, 3} = neuron.Date;
                        smallSPSSoutput{spsscount, 4} = neuron.Depth;
                        smallSPSSoutput{spsscount, 5} = stim{iii};
                        smallSPSSoutput{spsscount, 6} = baselineHzM;
                        smallSPSSoutput{spsscount, 7} = baselineHzSD;
                        smallSPSSoutput{spsscount, 8} = psthBinSlideHzM(looper);
                        smallSPSSoutput{spsscount, 9} = psthSlideRS(looper);
                        smallSPSSoutput{spsscount, 10} = psthSlideRMI(looper);
                        smallSPSSoutput{spsscount, 11} = psthSlideZS(looper);
                        smallSPSSoutput{spsscount, 12} = psthSlideSMI(looper);
                        smallSPSSoutput{spsscount, 13} = reps;
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

cd('C:\Metric Verification')
xlswrite('spssOutputter2.xlsx', smallSPSSoutput)

