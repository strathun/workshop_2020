%% experiment_20200303_WPI_5hrSoak
% This experiment was to see how stable the OCP is in our usual setup, as
% well as determine if there is a clear relationship between OCP and
% impedance. 
% WPI E08 was soaked in 1xPBS for approx 5hours with OCP measured for 10
% minutes about every 12 minutes, separated each time with 3 EIS
% measurements.
% All measurements made with the following configuration:
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
[dataStructure_Impedance_temp] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-03-03_WPI04A_inVitro\Impedance');
% [dataStructure_OCP] = ...
%     extractOCPData('..\rawData\Gamry\2020-03-03_WPI04A_inVitro\OCP');
   

%% Rearrange dataStructure 
% Order is weird. Need to fix this so everything below works well.
% NOTE: this is hard coded right now based off the order at 20200303. If
% anything changes to extractImpedanceDataGlobal, this will likely need to
% be adjusted. 

numRuns = length( dataStructure_Impedance_temp );
dataStructure_Impedance = dataStructure_Impedance_temp(1); % build ds with proper fields
orderArray = [1 12 18 19 20 21 22 23 24 2 3 4 5 6 ...
              7 8 9 10 11 13 14 15 16 17 ]; % weird hard coded order
pp = 0; % counter for triplets below
for ii = 1:( numRuns / 3 )
    kk = ii + 2*pp; 
    jj = orderArray(ii);
    dataStructure_Impedance(kk) = ...
         dataStructure_Impedance_temp( jj );
    dataStructure_Impedance(kk + 1) = ...
         dataStructure_Impedance_temp(jj + 24);
    dataStructure_Impedance(kk + 2) = ...
         dataStructure_Impedance_temp(jj + 48);
    pp = pp + 1;
end


%% Stats for each measurement
% All EIS measurements were taken 3 times in a row. 
% Pull everything into arrays so we can work with it
kk = 1; % Counter for avgStructure
jj = 1; % Counter for avg arrays
numRuns = length( dataStructure_Impedance );
for ii = 1:numRuns
    avgArray_Zreal(jj,:) = dataStructure_Impedance(ii).Zreal';
    avgArray_Zim(jj,:) = dataStructure_Impedance(ii).Zim';
    avgArray_Zmag(jj,:) = dataStructure_Impedance(ii).Zmag';
    jj = jj + 1;
    if mod( ii, 3 ) == 0
        avgStructure(kk).f = dataStructure_Impedance( ii - 1 ).f;
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

%% Compare Mag Impedance across time
% Each triplet EIS measurement is about 10-12 minutes from the previous
figure
numSols = length(avgStructure);
for ii = 1:numSols
    errorbar(dataStructure_Impedance(ii).f, ...
             avgStructure(ii).Zmag, ...
             avgStructure(ii).Zmagstd)
    hold on
end
set(gca, 'Xscale', 'log')
set(gca, 'Yscale', 'log')
xlabel( 'Frequency (Hz)' )
ylabel( 'mag(Z) (Ohm)' ) 
legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', ...
    '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24');
title('Impedance Changes over Time in 1xPBS')
xlim([10 1e6])
%%
% 