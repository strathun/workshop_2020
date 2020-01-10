%% plotScript_Nyquist_generic
% Generic script to generate nyquist plots from Gamry data

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
[f, Zreal, Zim, Phase] = ...
    extractImpedanceDataGlobal('../rawData/Gamry/2019-07-12_TDT19_PreSurge');

%% Plot Nyquist
figure
for ii = 1:16
semilogx(Zreal(:,ii), Zim(:,ii) * (-1), '.', 'LineWidth',1.4)
hold on
end
xlabel('real(Z)')
ylabel('-imag(Z)')

%% Plot Real Impedance
figure
for ii = 1:16
semilogx(f(:,ii), Zreal(:,ii),'LineWidth',1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('real(Z)')

%% Plot Phase
figure
for ii = 1:16
semilogx(f(:,ii), Phase(:,ii),'LineWidth',1.4)
hold on
end
xlabel('Frequency (Hz)')
ylabel('Phase')

%% Plot Real Imp vs Phase
figure
for ii = 1:16
semilogx(Zreal(end,ii), Phase(end,ii),'.','LineWidth',1.4)
hold on
end
xlabel('real(Z)')
ylabel('Phase')

%% Plot Imag Imp vs Phase
figure
for ii = 1:16
semilogx(-Zim(end,ii), Phase(end,ii),'.','LineWidth',1.4)
hold on
end
xlabel('-imag(Z)')
ylabel('Phase')

%% Spreading Resistance
% From chapter 5.2, section 2.2 of horch's neuroprosthetic's textbook, at
% f = 0, Z (which is Zreal + Zim) should = Rsp + Re, where Re is the
% parallel resistance of the electrode/electrolyte interface and Rsp is the
% spreading resistance. At f = infinity, Z = Rsp. From these assumptions,
% and by taking our lowest freq as ~0 and highest as ~ infinity, we can
% approximate both of these resistance values. Ideally, Rsp should be very
% similar between electrodes, with any differences coming (theoretically
% from distance from the [reference?] electrode. 

Rsp = Zreal(1,:) + Zim(1,:);
RspArray(1,:) = Rsp;

%% Checking phase

PhaseCalc = rad2deg(atan(Zim(:,:)./Zreal(:,:)));
figure
for ii = 1:16
semilogx(f(:,ii), Phase(:,ii),'.','LineWidth',1.4)
hold on
semilogx(f(:,ii), PhaseCalc(:,ii),'--','LineWidth',1.4)
end
