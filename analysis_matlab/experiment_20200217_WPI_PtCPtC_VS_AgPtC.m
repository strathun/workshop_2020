%% experiment_20200217_WPI_PtCPtC_VS_AgPtC
% Looking at extent of differences between Pt and Ag reference wire.
% Comparing EIS measurements for 2 different electrode configurations:
% [PtCPtC] Ref: Pt;   Counter: Pt [both Pt. are from cap]
% [AgPtC]  Ref: AgCl; Counter: Pt (from cap)
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
meaSelect = [2 3];  % 2 = AgPtC; 3 = PtCPtC
numSols = length(meaSelect);
for ii = 1:numSols
    jj = meaSelect(ii);
    errorbar(dataStructure(jj).f, ...
             avgStructure(jj).Zmag./1e3, ...
             avgStructure(jj).Zmagstd./1e3)
    hold on
end
set(gca, 'Xscale', 'log')
set(gca, 'Yscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (KOhm)' ) 
legend('Ag Ref', 'Pt Ref');
title('Comparison of Ag vs Pt Reference')
xlim([10 1e6])
%%
% 
