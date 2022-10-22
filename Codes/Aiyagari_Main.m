%%%%%%%%%%%%%%%%%%%%%%%% Aiyagari (1994) Replication %%%%%%%%%%%%%%%%%%%%%%

% Uninsurable income risk + Capital accumulation and production

% Autor: Yanran Guo
% Date:  6/2/2018
% Task:  Compute GE for Aiyagari economy
%        Simulate saving history of N households for T periods


%% Environment Setup
clc;                     % Clear screen
clear;                   % Clear memory
close all;               % Close open windows
addpath(genpath(pwd));   % Include subfolders of the current folder
          
                          
%% Parameterization
cS       = SetParameterValues;
cS.dbg   = 1;            % dbg is debugging parameter
                         % dbg=1, all functions will debug automatically


%% Probability Transition Matrices
[cS.Pi, cS.Z] ...
         = StationaryDis_MarkovProcess(cS.s, cS.P, cS.dbg); % Firm productivity


%% Solve for Stationary Equilibrium
outS     = Aiyagari_Calib(cS);

% Save the results
save ./Output/outS.mat outS

% Plots the policy graph
figure
plot(cS.kGridV, outS.kPolM(:,1), ':', cS.kGridV, outS.kPolM(:,2), '--', 'LineWidth', 1)
ylabel('Saving', 'FontSize', 11)
xlabel('Asset Level', 'FontSize', 11)
legend('s1', 's2', 'Location', 'northwest')
title('Saving Decision Rule (\phi=0)', 'FontSize', 11)
set(gca, 'FontSize', 11, 'LineWidth', 1, 'Box', 'on', 'FontName', 'Times New Roman');
grid on


%% Simulate Households
% I simulated the saving history of nSim=50000 households for T=500 periods.
kHistM = HHSimulation(outS.kPolM, cS);

% Save the results
save ./Output/kHistM.mat kHistM

