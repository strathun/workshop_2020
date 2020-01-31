%% plotScript_20200128_WPI_electrolyticCleaning
% Attempted to get impedance down to match values given by manufacturer
% (WPI) ~100kOhm at 1kHz, using electrolytic cleaning method specificed in
% their data sheet. Appears to have increased impedance...
% Also, looking at any effects from signal amplitude from 05-30 mVrms

% [ ] Add Pre cleaning measurements and 24 hours post. 

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
    extractImpedanceDataGlobal('../rawData/Gamry/2020-01-28_WPI04A_inVitro');

%% Plot Nyquist
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
% [~, numMeasurements] = size(f);
for ii = 1:4
plot(Zreal(:,ii), Zim(:,ii) * (-1), '.', 'LineWidth',1.4)
hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

% Electrolytic Cleaning
figure
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
kk = plotOrder(ii);
plot(Zreal(:,kk), Zim(:,kk) * (-1), '.', 'LineWidth',1.4)
hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2')

%% Plot Real Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
for ii = 1:4
semilogx(f(:,ii), Zreal(:,ii), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

% Electrolytic Cleaning
figure
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
kk = plotOrder(ii);
semilogx(f(:,kk), Zreal(:,kk), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2')

%% Plot Real Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
for ii = 1:4
semilogx(f(:,ii), Phase(:,ii), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

% Electrolytic Cleaning
figure
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
kk = plotOrder(ii);
semilogx(f(:,kk), Phase(:,kk), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2')

%% Plot Mag Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude

Zmag = sqrt((Zreal.^2) + (Zim.^2));
figure
[~, numMeasurements] = size(f);
for ii = 1:4
semilogx(f(:,ii), Zmag(:,ii), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

% Electrolytic Cleaning
figure
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
kk = plotOrder(ii);
semilogx(f(:,kk), Zmag(:,kk), 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2')

%%
% Looks like the real impedance matched the manufacturer values quite well.
% Maybe this is what they're giving? Still, the electrolytic cleaning
% increased the impedance and caused an interesting phase shift. 
