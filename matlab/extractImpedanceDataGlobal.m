function [dataStructure] = extractImpedanceDataGlobal(relPath)
%[f, Zreal, Zim, Phase] = extractImpedanceDataGlobal(relPath)
%   This will be a generic function to extract all of the Gamry data to a
%   structure. 
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/Gamry/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       f      :
%       Zreal  : 
%       Zim    :
%       Phase  :
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

% Finds starting row for impedance data
fid = fopen(fnames{3}, 'rt');
% read the entire file, if not too big
textRows = textscan(fid, '%s', 'delimiter', '\n');
% search for your Region:
a = strfind(textRows{1},'ZCURVE');
startLine = find(not(cellfun('isempty',a)));
fclose(fid);
% calculates number of rows of data. 3 is to bypass header rows.
[totRows, ~] = size(a);
numRows = totRows - ( startLine + 3 );

data = zeros(numRows, 11, length(fnames)-2);
s = size(data);


for kk = 3:length(fnames)
    % Format data to usable format
    fname = fnames(kk);
%     rawTable=readtable(cell2mat(fname),'delimiter','tab','headerlines',startLine);
    rawTable = readtable(cell2mat(fname),'delimiter','tab',...
                         'headerlines', startLine+2, ...
                         'ReadVariableNames', false);
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).f = rawTable.Var4;
    dataStructure(kk-2).Zreal = rawTable.Var5;
    dataStructure(kk-2).Zim = rawTable.Var6;
    dataStructure(kk-2).Zmag = sqrt( ( rawTable.Var5.^2 ) + ( rawTable.Var6.^2 ) );
    dataStructure(kk-2).Phase = rawTable.Var9;
%     makeArray=table2array(rawTable(2:end,2:end));
%     for ii = 1:s(1)
%         for jj = 1:s(2)
% %             t = str2num(cell2mat(makeArray(ii,jj)));
%             if iscell(makeArray(ii,jj))
%                 t = str2num(cell2mat(makeArray(ii,jj)));
%             elseif isstr(makeArray(ii,jj))
%                 t = str2num((makeArray(ii,jj)));
%             else
%                 t = (makeArray(ii,jj));
%             end
%             
%             data(ii, jj, kk-2) = t;
%     
%         end
%     end
end

cd(currentFolder)
% % Extract data to plot. Also converts to two dimensions
% f(:,:) = data(:,3,:);
% Zreal(:,:) = data(:,4,:);
% Zim(:,:) = data(:,5,:);
% Zmod(:,:) = data(:,7,:);
% Zmag(:,:) = sqrt((Zreal.^2)+(Zim.^2));
% Phase(:,:) = data(:,8,:);

end

