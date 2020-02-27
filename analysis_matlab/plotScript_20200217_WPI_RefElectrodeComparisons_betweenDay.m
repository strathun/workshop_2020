%% plotScript_20200217_WPI_RefElectrodeComparisons_betweenDay
% In reference to results from experiment_20200217_WPI_RefElectrodeComparisons
% Wanted to check to see if there was anything that seemed off between
% days, or in other words, if there are any strange inconsistencies in the
% measurements that might be influencing results
% Comparing EIS measurements for 3 different electrode configurations:
% [PtCPtC] Ref: Pt;   Counter: Pt [both Pt. are from cap] 
% [AgPtC]  Ref: AgCl; Counter: Pt (from cap)
% [AgPtW]  Ref: AgCl; Counter: Pt (New wire soldered to Pt.)
% All measurements made in 0.5xPBS

close all 
clearvars 

% Sets relative filepaths from this script
currentFile = mfilename( 'fullpath' );
cd(fileparts(currentFile));
addpath(genpath('../matlab'));
addpath(genpath('../rawData'));
addpath(genpath('../output'));
parts = strsplit(currentFile, {'\', '\'});
outputDir = ['../output/' parts{end}];
[~, ~] = mkdir(outputDir);

%% Extract impedance data
[dataStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-02-17_WPI04A_inVitro\Impedance');
[dataStructure_2] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-02-13_WPI04A_inVitro\Impedance');

dataStructure = [dataStructure dataStructure_2];
dataStructure_2 = [];   % Empty to save mem.

%% Stats for each measurement
% All EIS measurements were taken 3 times in a row. 
% Pull everything into arrays so we can work with it
kk = 1; % Counter for avgStructure
jj = 1; % Counter for avg arrays
numRuns = length( dataStructure );
for ii = 1:numRuns
    avgArray_Zreal(jj,:) = dataStructure(ii).Zreal';
    avgArray_Zim(jj,:) = dataStructure(ii).Zim';
    avgArray_Zmag(jj,:) = dataStructure(ii).Zmag';
    jj = jj + 1;
    if mod( ii, 3 ) == 0
        avgStructure(kk).f = dataStructure( ii - 1 ).f;
        avgStructure(kk).Zreal = mean(avgArray_Zreal);
        avgStructure(kk).Zrealstd = std(avgArray_Zreal);
        avgStructure(kk).Zim = mean(avgArray_Zim);
        avgStructure(kk).Zimstd = std(avgArray_Zim);
        avgStructure(kk).Zmag = mean(avgArray_Zmag);
        avgStructure(kk).Zmagstd = std(avgArray_Zmag);
        kk = kk + 1;
        avgArray_Zreal = [];
        avgArray_Zim = [];
        avgArray_Zmag = [];
        jj = 1; % reset loop counter
    end
end

%% Compare PtPt measurements between days
figure
meaSelect = [3 4];
numSols = length(meaSelect);
for ii = 1:numSols
    jj = meaSelect(ii);
    errorbar(dataStructure(jj).f, ...
             avgStructure(jj).Zmag, ...
             avgStructure(jj).Zmagstd)
    hold on
end
set(gca, 'Xscale', 'log')
set(gca, 'Yscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
legend('Day 2', 'Day 1');
title('PtCPtC Config between days (0.5x PBS)')
xlim([10 1e6])
%%
% Looks very different

%% Compare NewPt/AgCl measurements between days
% NOTE: This is 1x vs 0.5x PBS, but should be ballpark similar
figure
meaSelect = [1 5];
numSols = length(meaSelect);
for ii = 1:numSols
    jj = meaSelect(ii);
    errorbar(dataStructure(jj).f, ...
             avgStructure(jj).Zmag, ...
             avgStructure(jj).Zmagstd)
    hold on
end
set(gca, 'Xscale', 'log')
set(gca, 'Yscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
legend('Day 2 (.5xPBS)', 'Day 1 (1xPBS)');
title('AgPtW config between days')
xlim([10 1e6])
%%
% Looks similar. Also, finally see 0.5x with higher impedance than 1xPBS.
% Interestingly, this is across the frequency spectrum rather than just at
% higher frequencies as described for solutions with the same buffer
% concentration by Cogan.

%%
% 20200217
% There is definitely a difference between measurements made in Day 1 and
% Day 2. The shape looks simlar, but the magnitudes are way off. Need to
% look into this more