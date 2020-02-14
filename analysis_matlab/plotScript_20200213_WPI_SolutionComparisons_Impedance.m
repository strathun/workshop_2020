%% plotScript_20200213_WPI_SolutionComparisons_Impedance
% Comparing impedance measurements using 4 different solutions:
% Old Lab PBS
% New 0.5X PBS
% New 1.0X PBS
% Artificial interstitial fluid
% All but the old PBS come from recipes in Cogan et al. 2007. 

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
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-02-13_WPI04A_inVitro\Impedance');

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

%% Plot Mag Impedance
figure
numSols = length(avgStructure);
for ii = 1:numSols
    errorbar(dataStructure(ii).f, ...
             avgStructure(ii).Zmag, ...
             avgStructure(ii).Zmagstd)
    hold on
end
set(gca, 'Xscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'Impedance (mag)' ) 
legend('0.5xPBS', '1xPBS vs AgAgCl', '1xPBS', 'AISF', 'LabPBS Run 2', 'LabPBS Run 1');

%% Comparing References (Pt. vs AgAgCl)
figure
numSols = length(avgStructure);
for ii = 2:3
    errorbar(dataStructure(ii).f, ...
             avgStructure(ii).Zmag, ...
             avgStructure(ii).Zmagstd)
    hold on
end
set(gca, 'Xscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'Impedance (mag)' ) 
legend('1xPBS vs AgAgCl', '1xPBS');
xlim([10 1e6])

% ylim([0 1.2E5])
%%
% 