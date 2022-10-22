function [r, w] = Prices_Firm_FOC(K, cS)
%% Documentation
%{
1. Function description:
This function solves for interest rate (r) and wage (w) given K, using
firm's two FOCs

Firm Problem in Aiyagari (1994) is specified as
      max ZK^(alpha)N^(1-alpha) - (r+delta)K - wN
FOC:  r = Z*alpha*(K/N)^(alpha-1) - delta
      w = Z*(1-alpha)*(K/N)^alpha

2. INPUTS:
(1). K:        guess for K
(2). cS.Z:     firm productivity
(3). cS.alpha: capital-output share
(4). cS.delta: depreciation rate

3. OUTPUTS:
(1). r: Rate of return to capital
(2). w: wage
%}


%% Compute the prices: interest rate and wage 
r = cS.alpha*cS.Z*(K.^(cS.alpha-1)) - cS.delta;
w = (1-cS.alpha)*cS.Z*(K.^(cS.alpha));


end