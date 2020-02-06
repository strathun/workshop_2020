%% plotScript_20200127_WPI_WideFreqRange
% Plots for low (.01Hz) Freq. 

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
% extractImpedanceDataGlobal can only handle one frequency range/folder
% currently
[f_nrm, Zreal_nrm, Zim_nrm, Phase_nrm, fnames_nrm] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-01-27_WPISET01_inVitro');
[f_wide, Zreal_wide, Zim_wide, Phase_wide, fnames_wide] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-01-27_WPISET01_inVitro_wideFRange');

%% Plot Nyquist
figure
timeArray = 5; % This contains the two measurements for different freq range of same electrode
numMeasures = length(timeArray);
for jj = 1:numMeasures
    ii = timeArray(jj);
    plot(Zreal_nrm(:,ii), Zim_nrm(:,ii) * (-1), '.', 'LineWidth',1.4)
    hold on
end
plot(Zreal_wide(:,1), Zim_wide(:,1) * (-1), '.', 'LineWidth',1.4)

xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist')
legend('Wide Range', 'Normal')

%% Plot Real Impedance
figure
timeArray = 5; % This contains the two measurements for different freq range of same electrode
numMeasures = length(timeArray);
for jj = 1:numMeasures
    ii = timeArray(jj);
    semilogx(f_nrm(:,ii), Zreal_nrm(:,ii), 'LineWidth', 1.4)
    hold on
end
semilogx(f_wide(:,1), Zreal_wide(:,1), 'LineWidth', 1.4)

xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance')
legend('Wide Range', 'Normal')

%% Plot Phase
figure
timeArray = 5; % This contains the two measurements for different freq range of same electrode
numMeasures = length(timeArray);
for jj = 1:numMeasures
    ii = timeArray(jj);
    semilogx(f_nrm(:,ii), Phase_nrm(:,ii), 'LineWidth', 1.4)
    hold on
end
semilogx(f_wide(:,1), Phase_wide(:,1), 'LineWidth', 1.4)

xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase')
legend('Wide Range', 'Normal')

%% Plot Mag Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude

Zmag_nrm = sqrt((Zreal_nrm.^2) + (Zim_nrm.^2));
Zmag_wide = sqrt((Zreal_wide.^2) + (Zim_wide.^2));
figure
timeArray = 5; % This contains the two measurements for different freq range of same electrode
numMeasures = length(timeArray);
for jj = 1:numMeasures
    ii = timeArray(jj);
    semilogx(f_nrm(:,ii), Zmag_nrm(:,ii), 'LineWidth', 1.4)
    hold on
end
semilogx(f_wide(:,1), Zmag_wide(:,1), 'LineWidth', 1.4)

xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag')
legend('Wide Range', 'Normal')

%%
% Looks strange... Maybe at very low frequency impedance is almost entirely
% capacitive? Seems like it should be the other way around as it shifts
% toward the resistance as capacitive resistance blows up. Almost like
% there is no parallell resistance.
