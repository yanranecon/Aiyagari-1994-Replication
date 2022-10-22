function u = CRRA_Utility(c, cS)

%% Documentation
%{
1. Function description:
This function generates CRRA utility function

2. INPUTS:
(1). c:        Consumption
(2). cS.gamma: Curvature of utility function

3. OUTPUTS:
(1). u:        Utility
%}


%% CRRA Utility Function
u = (c.^(1-cS.gamma))./(1-cS.gamma);
end