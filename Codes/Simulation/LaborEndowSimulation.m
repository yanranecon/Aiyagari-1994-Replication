function eIdxM = LaborEndowSimulation(cS)
%% Documentation:
% This function simulates history of labor productivity endowments 

% INPUTS:
% (1). ns:            number of labor productivity endowments
% (2). nSim:          number of individuals to simulate
% (3). T:             length of histories
% (4). Pi:            prob of each state at date 1
% (5). P(s',s):       transition matrix, showing the prob of state being s'
%                     tomorrow given the state today is s

% OUTPUT:
% eIdxM: labor endowment index by [ind, period]
%        It is a (nSim x T) matrix
%        nSim is the number of individuals we want to simulate
%        T    is the number of periods we want to simulate


% ******************************** Notice ********************************* 
% We simulate nSim individuals for each period
% eIdxM(999, 29): for the 29th period, there are 1000 simulated individuals. 
%                 eIdxM(999, 29) shows the labor endomwnt index for the 999th individual
% eIdxM shows the labor endowment index, not the labor endowment itself!!!

% Example:
% My eIdxM is 2. It means that my labor endowment is the 2nd element in the
% labor endowment vector. It doesn't mean that my labor endowment is 3


%% Main
% Seed random number generator for repeatability
% It is important to use the same random numbers for every iteration over
% the guesses for calibration targeted parameter
% Otherwise simulated aggregates change a little bit every time, which will
% confuses Matlab equation solvers
rng(433);


%% Preliminaries
% For each state, find cumulative probability distribution for next period
trProbM              = cS.P';
cumTrProbM           = cumsum(trProbM);
cumTrProbM(cS.ns, :) = 1;

% Need to transpose this for the formula below now by [s, s']
cumTrProbM           = cumTrProbM';


%%  Iterate over dates
eIdxM                = zeros([cS.nSim, cS.T]);
rvInM                = rand([cS.nSim, cS.T]);    % Uniform random variables, by [ind, t]

% Draw t=1
eIdxM(:, 1)          = 1 + sum((rvInM(:,1) * ones(1, cS.ns)) > (ones(cS.nSim,1) * cumsum(cS.Pi(:)')), 2);

% For t = 2, ..., T
for t = 1 : (cS.T-1)
   eIdxM(:, t+1)     = 1 + sum((rvInM(:,t+1) * ones(1, cS.ns)) > cumTrProbM(eIdxM(:,t), :), 2);
end

                          
%% Note:
% The transition matrix used in function 'LaborEndowSimulation' is 
% trProbM(s',s), which shows the prob of tomorrow's state being s' given
% today's state being s
% However, the transition matrix we defined in the main file is
% cS.P = trProbM(i,j) = Prob i --> j
% Hence in order to use the transition matrix cS.P as an
% input in 'LaborEndowSimulation', we have to transpose cS.P
% That is why I define trProbM  as cS.P' above


end