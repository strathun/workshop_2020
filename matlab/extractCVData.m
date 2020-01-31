function [dataStructure, fnames] = extractCVData(relPath)
%[dataStructure] = extractCVData(relPath)
% Extracts CV data from Gamry data files
% Puts all traces (voltage and current data) in dataStructure. This script 
% will pull the data from each file in relPath directory. 
% Data is labeled with the electrode number (pulled from filename).
% Inputs:
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
% Outpus:
%       dataStructure: Voltage and current data in dataStructure

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% Hard coded magic numbers
dataRows = 1400;    % number of rows in a CV cycle. (See .dta file to change)
dataColumns = 11;   % number of columns in a CV cycle. (See .dta file to change)

%change .dat files to ..txt files for processing
system(['rename ' '*.dta ' '*.txt']);

% Filenames in the directory
listFiles = dir;
fnames = {listFiles.name}'; %returns cell array
fnames = fnames(cellfun(@(x) length(x) >= 5, fnames));

for ii = 1:length(fnames)
    
    % Grab electrode number from filename
    currentNameStr = char( fnames{ ii } );
    fid = fopen( currentNameStr );
    elecIndex = strfind( currentNameStr , '_E' ) + 2;
    electrode = str2num( currentNameStr( elecIndex:elecIndex+1 ) );
    
    % Finds start of each scan in data file
    sniffer = 'CURVE';
    c = textread(currentNameStr,'%s','delimiter','\n');
    curveStartIndex = find(~cellfun(@isempty,strfind(c, sniffer )));
    fullTraces = length(curveStartIndex) - 1;   % Final curve is typically not a complete measurement, so we're ignoring it.
    
    dataStructure(ii).electrode = electrode;
    for jj = 1:fullTraces
        line = curveStartIndex(jj) + 1;
        % Grab and store all the data
        [dataArray] = textToArray( fnames{ii}, line + 1, dataRows, dataColumns );  % line + 1 because header is 2 lines long
        dataStructure(ii).potential(jj,:) = dataArray(2:end,4);
        dataStructure(ii).current(jj,:) = dataArray(2:end,5);
    end    
end
end

