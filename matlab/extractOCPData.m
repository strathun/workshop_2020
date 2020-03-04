function [dataStructure] = extractOCPData(relPath)
%[t, OCP, fnames] = extractOCPData(relPath)
%   This will be a generic function to extract all of the Gamry data to a
%   structure. 
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       t      :
%       OCP    : I believe this is the OCP
%       Vm     : Not sure what this is exactly
%       fnames : cell containing filenames. Same order as other outputs.

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% change .dat files to ..txt files for processing (if not already done)
if ~isempty(dir('*.dta'))
    system(['rename ' '*.dta ' '*.txt']);
end

% Grabs all filenames in current directory
listFiles = dir;
fnames = {listFiles.name}';

%% Finds starting row for impedance data
fid = fopen(fnames{3}, 'rt');
% read the entire file, if not too big
textRows = textscan(fid, '%s', 'delimiter', '\n');
% search for your Region:
a = strfind(textRows{1},'CURVE');
startLine = find(not(cellfun('isempty',a)));
fclose(fid);

%% Pull Impedance data into structure
for kk = 3:length(fnames)
    % Format data to usable format
    fname = fnames(kk);
    rawTable = readtable( cell2mat(fname),'delimiter','tab',...
                          'headerlines', startLine+2, ...
                          'ReadVariableNames', false);
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).t = rawTable.Var3;
    dataStructure(kk-2).OCP = rawTable.Var4;
    dataStructure(kk-2).Vm = rawTable.Var5;
end

cd(currentFolder)
end

