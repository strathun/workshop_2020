%% experiment_20200217_WPI_SolutionComparison_Part2
% The original solution comparison looked to have some weird issues with
% measurements in the new PBS solutions. Looking back at those
% measurements, it might have been something to do with the cap wires, but
% can't say definitively now. 
% Comparing EIS measurements for 3 different solutions/configurations:
% [PtCPtC] in artifical interstitial fluid (AISF)
% [AgPtW]  0.5xPBS
% [AgPtW]  1.0xPBS

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

%% Compare Mag Impedance across solutions
figure
meaSelect = [1 5 7];  % 1: AgPtW, 0.5x; 5: AgPtW, 1x; 7: PtPt, AISF
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
legend('AgPtW, 0.5x', 'AgPtW, 1x', 'PtPt, AISF');
title('')
xlim([10 1e6])
%%
% Differences don't seem to dramatic here. Really should take a second
% measurements using the AgCl setup in the new AISF solution. 