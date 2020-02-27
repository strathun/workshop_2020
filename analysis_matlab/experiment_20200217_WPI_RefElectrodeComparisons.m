%% experiment_20200217_WPI_RefElectrodeComparisons
% Comparing EIS measurements for 3 different electrode configurations:
% Ref: Pt;   Counter: Pt [both Pt. are from cap]
% Ref: AgCl; Counter: Pt (from cap)
% Ref: AgCl; Counter: Pt (New wire soldered to Pt.)
% All measurements made in 0.5xPBS
% Adding comparison for AISF
% [PtCPtC] in artifical interstitial fluid (AISF) (20200213)
% [AgPtW]  AISF (20200227)

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
[dataStructure_3] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-02-27_WPI04A_inVitro\Impedance');

dataStructure = [dataStructure dataStructure_2];
dataStructure = [dataStructure dataStructure_3];
dataStructure_2 = [];   % Empty to save mem.
dataStructure_3 = [];   

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

%% Plot Mag Impedance for 0p5 PBS
figure
meaSelect = [1 2 3];  % 1: AgPtW; 2: AgPtC; 3: PtCPtC
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
title( 'Op5 PBS' )
legend('NewPt/AgAgCl', 'CapPt/AgAgCl', 'CapPt/CapPt');
xlim([10 1e6])

%% Nyquist Comparisons
figure
meaSelect = [1 2 3];  % 1: AgPtW; 2: AgPtC; 3: PtCPtC
numSols = length(meaSelect);
for ii = 1:numSols
    jj = meaSelect(ii);
    plot( avgStructure( jj ).Zreal, avgStructure( jj ).Zim * -1, '.')
    hold on
end
xlabel( 'real(z)' )
ylabel( 'im(Z)' ) 
title( 'Op5 PBS' )
legend('NewPt/AgAgCl', 'CapPt/AgAgCl', 'CapPt/CapPt');

%%
% Definitely looks to be a difference in low frequency measurements made
% with AgCl reference electrode and two Pt electrodes. I wonder if we just
% need to account for surface area? 

%% Plot Mag Impedance for AISF
figure
meaSelect = [7 10];  % 7: PtCPtC; 10: AgPtW
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
title('AISF')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
legend('PtCPtC', 'AgPtW');
xlim([10 1e6])

%%
% Very different differences for AISF between electrode setups. Across the
% spectrum decrease in impedance, vs increase in low f impedance seen above
% with 0p5 PBS...