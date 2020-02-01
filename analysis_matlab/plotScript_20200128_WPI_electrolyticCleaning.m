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
[f_pre, Zreal_pre, Zim_pre, Phase_pre, fnames_pre] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\2020-01-27_WPI04A_inVitro');

% Day of electrolysis cleaning
[f_post, Zreal_post, Zim_post, Phase_post, fnames_post] = ...
    extractImpedanceDataGlobal('../rawData/Gamry/2020-01-28_WPI04A_inVitro');

% Day after cleaning
[f_post2, Zreal_post2, Zim_post2, Phase_post2, fnames_post2] = ...
    extractImpedanceDataGlobal('../rawData/Gamry/2020-01-29_WPI04A_inVitro');

%% Plot Nyquist
% Comparing effects of signal amplitude as well as pre-post electrolysis

% Signal Amplitude
figure
% [~, numMeasurements] = size(f);
for ii = 1:4
    plot(Zreal_post(:,ii), Zim_post(:,ii) * (-1), '.', 'LineWidth',1.4)
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
    plot(Zreal_pre(:,kk), Zim_pre(:,kk) * (-1), '.', 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    plot(Zreal_post(:,kk), Zim_post(:,kk) * (-1), '.', 'LineWidth',1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    plot(Zreal_post2(:,kk), Zim_post2(:,kk) * (-1), '.', 'LineWidth',1.4)
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
semilogx(f_post(:,ii), Zreal_post(:,ii), 'LineWidth', 1.4)
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
    semilogx(f_pre(:,kk), Zreal_pre(:,kk), 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(f_post(:,kk), Zreal_post(:,kk), 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(f_post2(:,kk), Zreal_post2(:,kk), 'LineWidth',1.4)
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
semilogx(f_post(:,ii), Phase_post(:,ii), 'LineWidth', 1.4)
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
    semilogx(f_pre(:,kk), Phase_pre(:,kk), 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(f_post(:,kk), Phase_post(:,kk), 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(f_post2(:,kk), Phase_post2(:,kk), 'LineWidth',1.4)
    hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')
title('Phase Electrolytic Cleaning')
legend('Pre-Clean', 'Clean_R1', 'Clearn_R2', 'Clearn_R3', '24hr-Post')

%% Plot Mag Impedance
% Comparing signal amplitude as well as pre-post electrolysis

% Calc magnitude of impedance
Zmag_pre = sqrt((Zreal_pre.^2) + (Zim_pre.^2));
Zmag_post = sqrt((Zreal_post.^2) + (Zim_post.^2));
Zmag_post2 = sqrt((Zreal_post2.^2) + (Zim_post2.^2));

% Signal Amplitude
figure
[~, numMeasurements] = size(f_post);
for ii = 1:4
semilogx(f_post(:,ii), Zmag_post(:,ii), 'LineWidth', 1.4)
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
    semilogx(f_pre(:,kk), Zmag_pre(:,kk), 'LineWidth',1.4)
    hold on
end
% Electrolytic Cleaning
plotOrder = [1 5 6];    % Measurements before and after cleaning 1 (5) and 2 (6)
for ii = 1:3
    kk = plotOrder(ii);
    semilogx(f_post(:,kk), Zmag_post(:,kk), 'LineWidth', 1.4)
    hold on
end
% 24-hours post cleaning First run of that day 
for ii = 1:1
    kk = 1;
    semilogx(f_post2(:,kk), Zmag_post2(:,kk), 'LineWidth',1.4)
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
