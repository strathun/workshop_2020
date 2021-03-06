%% experiment_20200217_WPI_PtCapVsPtWire
% Gut check to see if there are any large differences between cap Pt ref
% and the Pt wire.
% Comparing EIS measurements for 2 different electrode configurations:
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

%% Compare Pt Counter electrodes
figure
meaSelect = [1 2];  %1 = AgPtW; 2 = AgPtC
numSols = length(meaSelect);
for ii = 1:numSols
    jj = meaSelect(ii);
    errorbar(dataStructure(jj).f, ...
             avgStructure(jj).Zmag./1e6, ...
             avgStructure(jj).Zmagstd./1e6)
    hold on
end
set(gca, 'Xscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (MOhm)' ) 
legend('Pt Wire', 'Pt Cap');
title('Comparison of Pt Counter electrodes')
xlim([10 1e6])
%%
% Look very similar. Good indicator that there isn't any obvious
% significant differences between the two counter electrodes. 
