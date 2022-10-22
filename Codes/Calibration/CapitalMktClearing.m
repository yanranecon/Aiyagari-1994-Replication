function [dev, outS] = CapitalMktClearing(K, cS)
%% Documentation:
% This function returns deviations from calibration targets and equilibrium condition
% The main equilibrium conditions used here is Capital Mkt Clearing Condition 

% INPUTS:
% (1). K:  calibration targets
% (2). cS: parameters           

% OUTPUTS:
% (1). dev:  deviation between model generated K and my guess for K
% (2). outS: other variables characterizing steady state
%            r: interest rate given my guess for K
%            w: wage given my guess for K
%            kPolM:  policy function of saving
%            Ind:    the location of optimal saving (i.e. k') on k grid
%            valueM: value function
%            mu:     stationary distribution


%% Main
% Compute the prices faced by HHs
[outS.r, outS.w] = Prices_Firm_FOC(K, cS);

% Solve household problem (with exogenous prices)
[outS.kPolM, IndM, outS.valueM] ...
                 = VFI(outS.r, outS.w, cS);

% Stationary distribution
outS.mu          = Stationary_Dist(IndM, cS);

% Aggregate capital
outS.wealth      = sum(cS.kGridV'*outS.mu);

% Deviation  
dev              = outS.wealth - K;


end