function kHistM = HHSimulation(kPolM, cS)
%% Documentation:
% This function simulates a population of households
% The basic idea is
% (1). Populate a set of households
% (2). Households go through sequence of labor endowments given in eIdxM
% (3). Compute capital holdings of these households based on policy function kPolM

% INPUTS:
% (1). kPolM:    k' policy function, by [ik, is]
% (2). cS.nSim:  # of HHs we want to simulate
% (3). cS.T:     # of periods we want to simulate

% OUTPUTS:
% kHistM: capital stock histories for households by [ind, period]


%% Input Validation
validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                   'size', [cS.nk, cS.ns]})

               
%% Simulate capital histories, period by period
eIdxM  = LaborEndowSimulation(cS);   % Simulate history of labor productivity endowments
                                     % eIdxM is labor endowment index for each simulated individal
kHistM = zeros(cS.nSim, cS.T);


for t = 1 : cS.T
    
   for is = 1 : cS.ns
      % Find households with labor endowment is at this period
      idxV = find(eIdxM(:,t) == is);

      if ~isempty(idxV)
         if t < cS.T
            % Find next period capital for each individual by interpolation
            kHistM(idxV, t+1) = interp1(cS.kGridV(:), kPolM(:,is), ...
                                        kHistM(idxV, t), 'linear');
         end
         
      end % if idexV is not empty

   end % for is

end % for t



%% Output Validation
validateattributes(kHistM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                   '>', cS.kGridV(1) - 1e-6})

               
end