function outS = Aiyagari_Calib(cS)
%% Documentation
%{
1. Function Description:
This function runs calibration routine
It solves the whole model by finding the value for K (agrregate capital)
that clears capital markets 

The basic idea is
(1). Given K, solve the HH problem and get policy function for saving
(2). Compute the aggregate saving S --> a func of prices --> a func of K 
(3). Find K which makes capital market to clear 

2. Input:
cS:  Parameters set at the begining

3. Output:
r: equilibrium interest rate that clears capital market
w: corresponding wage
%}


%%  Run calibration routine
guessK  = 1;   % Initial guess for K
optS    = optimoptions('fsolve', 'Display','none');

wrapper = @(K) CapitalMktClearing(K, cS);
[K_solve, ~, exitFlag] ...
        = fsolve(wrapper, guessK, optS);

% Check if fsolve converges
if exitFlag <= 0
   warning('No convergence');
   keyboard;
end


%% Save
% Save other steady state features
[~, outS] = CapitalMktClearing(K_solve, cS);
fprintf('    r: %5.7f', outS.r);
fprintf('    w: %5.7f\n', outS.w);


end