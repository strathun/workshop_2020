%% plotScript_20200129_WPI_ImpedanceTimeChanges
% Repeated impedance measurements over 45 minutes of single WPI electrode.

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
[f, Zreal, Zim, Phase, fnames] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-01-29_WPI04A_inVitro');

%% Plot Nyquist
figure
timeArray = 11:18; % This contains the time measurements from this day
for jj = 1:8
    ii = timeArray(jj);
    plot(Zreal(:,ii), Zim(:,ii) * (-1), '.', 'LineWidth',1.4)
    hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist')
legend('10mins', '15', '20', '25', '30', '35', '40', '45')

%% Plot Real Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
timeArray = 11:18; % This contains the time measurements from this day
for jj = 1:8
    ii = timeArray(jj);
    semilogx(f(:,ii), Zreal(:,ii), 'LineWidth', 1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance')
legend('10mins', '15', '20', '25', '30', '35', '40', '45')

%% Plot Phase
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
timeArray = 11:18; % This contains the time measurements from this day
for jj = 1:8
    ii = timeArray(jj);
    semilogx(f(:,ii), Phase(:,ii), 'LineWidth', 1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Signal Amplitude')
legend('10mins', '15', '20', '25', '30', '35', '40', '45')

%% Plot Mag Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude

Zmag = sqrt((Zreal.^2) + (Zim.^2));
figure
timeArray = 11:18; % This contains the time measurements from this day
for jj = 1:8
    ii = timeArray(jj);
    semilogx(f(:,ii), Zmag(:,ii), 'LineWidth', 1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag Signal Amplitude')
legend('10mins', '15', '20', '25', '30', '35', '40', '45')

%%
% Approximately 30kOhm (~10% change) in magnitude of impedance over the 45
% minutes. 
