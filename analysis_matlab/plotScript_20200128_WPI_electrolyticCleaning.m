%% plotScript_20200128_WPI_electrolyticCleaning
% Attempted to get impedance down to match values given by manufacturer
% (WPI) ~100kOhm at 1kHz, using electrolytic cleaning method specificed in
% their data sheet. Appears to have increased impedance...
% Also, looking at any effects from signal amplitude from 05-30 mVrms

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
% Day before electrolysis cleaning
[dataStructure_pre] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-01-27_WPI04A_inVitro');

% Day of electrolysis cleaning
[dataStructure_post] = ...
    extractImpedanceDataGlobal('../rawData/Gamry/2020-01-28_WPI04A_inVitro');

% Day after cleaning
[dataStructure_post2] = ...
    extractImpedanceDataGlobal('../rawData/Gamry/2020-01-29_WPI04A_inVitro');

%% Plot Nyquist
% Comparing effects of signal amplitude as well as pre-post electrolysis

% Signal Amplitude
figure
% [~, numMeasurements] = size(f);
for ii = 1:4
    plot(dataStructure_post(ii).Zreal, dataStructure_post(ii).Zim * (-1), '.', 'LineWidth',1.4)
    hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

figure
% Pre-cleaning day. 
for ii = 1:1
    kk = 5;
    plot(dataStructure_pre(kk).Zreal, dataStructure_pre(kk).Zim * (-1), '.', 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    plot(dataStructure_post(kk).Zreal, dataStructure_post(kk).Zim * (-1), '.', 'LineWidth',1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    plot(dataStructure_post2(kk).Zreal, dataStructure_post2(kk).Zim * (-1), '.', 'LineWidth',1.4)
    hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')
title('Nyquist Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2', 'Clearn_R3', '24hr-Post')

%% Plot Real Impedance
% Comparing signal amplitude as well as pre-post electrolysis

% Signal Amplitude
figure
for ii = 1:4
semilogx(dataStructure_post(ii).f, dataStructure_post(ii).Zreal, 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')


figure
% Pre-cleaning day. 
for ii = 1:1
    kk = 5;
    semilogx(dataStructure_pre(kk).f, dataStructure_pre(kk).Zreal, 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(dataStructure_post(kk).f, dataStructure_post(kk).Zreal, 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(dataStructure_post2(kk).f, dataStructure_post2(kk).Zreal, 'LineWidth',1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')
title('Real Impedance Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2', 'Clearn_R3', '24hr-Post')

%% Plot Phase
% Comparing signal amplitude as well as pre-post electrolysis

% Signal Amplitude
figure
for ii = 1:4
semilogx(dataStructure_post(ii).f, dataStructure_post(ii).Phase, 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')


figure
% Pre-cleaning day. 
for ii = 1:1
    kk = 5;
    semilogx(dataStructure_pre(kk).f, dataStructure_pre(kk).Phase, 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(dataStructure_post(kk).f, dataStructure_post(kk).Phase, 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(dataStructure_post2(kk).f, dataStructure_post2(kk).Phase, 'LineWidth',1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2', 'Clearn_R3', '24hr-Post')

%% Plot Mag Impedance
% Comparing signal amplitude as well as pre-post electrolysis
% Signal Amplitude
figure
for ii = 1:4
semilogx(dataStructure_post(ii).f, dataStructure_post(ii).Zmag, 'LineWidth', 1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag Signal Amplitude')
legend('20mVrms', '05mVrms', '10mVrms', '30mVrms')

figure
% Pre-cleaning day. 
for ii = 1:1
    kk = 5;
    semilogx(dataStructure_pre(kk).f, dataStructure_pre(kk).Zmag, 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(dataStructure_post(kk).f, dataStructure_post(kk).Zmag, 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(dataStructure_post2(kk).f, dataStructure_post2(kk).Zmag, 'LineWidth',1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Z)')
title('Zmag Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2', 'Clearn_R3', '24hr-Post')

%%
% Looks like the real impedance matched the manufacturer values quite well.
% Maybe this is what they're giving? Still, the electrolytic cleaning
% increased the impedance and caused an interesting phase shift. 
%%
% Values never seem to quite return to those pre-clean (except real
% impedance). Still not certain that this is because of some effects from
% the cleaning or if this is variability from day to day. Another thing to
% look into is submersion depth for these electrodes.
