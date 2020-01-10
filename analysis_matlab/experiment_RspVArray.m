%% experiment_RspVArray
% Looking to see how consistent Rsp values are across multiple arrays.
% Looking at multiple TDTs and UEA vs TDT

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

gamryFileNames = {'2018-03-09_UEA3_PreSurge';
                  '2018-08-22_TDT12_PreSurge';
                  '2019-05-06_TDT17_PreSurge';
                  '2019-07-12_TDT19_PreSurge'};
gamryLocation = '../rawData/Gamry/';

% Generate Impedance Data Structures
numExperiments = length(gamryFileNames);
for ii = 1:numExperiments
    currentFileName = [ gamryLocation gamryFileNames{ii} ];
    [ dataStructure(ii).f, dataStructure(ii).Zreal, ...
        dataStructure(ii).Zim, dataStructure(ii).Phase] = ...
        extractImpedanceDataGlobal(currentFileName);
    
    % Not sure which Zmag is correct...
    dataStructure(ii).Zmag = sqrt( (dataStructure(ii).Zreal).^2 + ...
        (dataStructure(ii).Zim).^2 );
%     dataStructure(ii).ZmagTest = (dataStructure(ii).Zreal) + ...
%         (dataStructure(ii).Zim);
    % TDT vs UEA
    if strfind(gamryFileNames{ii},'TDT')
        dataStructure(ii).ArrayType = 'TDT';
    else
        dataStructure(ii).ArrayType = 'UEA';
    end
end

%%
figure
for ii = 1:numExperiments
    scatter(ones(1,16)*ii, dataStructure(ii).Zmag(1,:))
    hold on
end

