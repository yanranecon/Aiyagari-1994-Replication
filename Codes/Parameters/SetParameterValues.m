function cS = SetParameterValues
%% Documentation
%  This function file assigns values to parameters in my Aiyagari (1994)
%  replication exercise.

%  The value of these parameters are fixed instead of being calibrated.
%  Only two parameters will be calibrated: interest rate r and wage w.


%% Main
% ******** Household ********
cS.beta  = 0.96;                 % Discount factor
cS.gamma = 2;                    % CRRA utility curvature
cS.s     = [0.8, 1.2]';          % Labor productivity
cS.ns    = length(cS.s);         % Number of realizations of productivity
cS.P     = [0.9, 0.1; 0.1, 0.9]; % Markov transition
cS.phi   = 0;                    % Debt limit in new steady state: k'>=0
cS.nSim  = 5e4;                  % Number of individuals to simulate
cS.T     = 5e2;                  % Number of periods to simulate


% ******** Production ********
cS.delta = 0.1;                  % Depreciation rate
cS.alpha = 0.33;                 % Capital share in production function


% ******** Discretize State Space ********
% Two states in Aiyagari economy, labor productivity (s) and saving (k)
% Given the parameterization for s, it is already discrete.
% However, k is still on the real line. 
% Need to approximate a's support with a discrete grid, starting from phi
% and going up to a large number
cS.nk     = 200;                 % Number of grids I set
cS.kMin   = cS.phi;              % Due to the borrowing constraint: k >= phi
cS.kMax   = 30;                  % Some arbitrary number, need double check
cS.kGridV = linspace(cS.kMin, cS.kMax, cS.nk);  % Set k grid, it's a 1*nk row 
cS.kGridV = cS.kGridV';          % Make it to be a nk*1 vector


end