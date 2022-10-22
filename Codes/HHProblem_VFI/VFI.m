function [kPolM, IndM, valueM] = VFI(r, w, cS)
%% Documentation
%{
1. Function Description:
This program gets the policy function and value function using Value
Funtion Iteration.

I loop over all possible values of the states. For each value in k and s, I
find the k' in vector of k states that maximizes Bellman equation given my 
guess of the value function. 

Outside of the loop I have a "while" statement, which tells MATLAB to keep 
repeating the text as long as the difference between value functions is 
greater than the tolerance.

2. Inputs:
(1). cS.nk:      the number of possible realizations of k
(2). cS.kGridV:  vector of k grid
(3). cS.s:       vector of productivity state
(4). cS.kMin:    lower bound of k
(5). cS.kMax:    Upper bound of k

3. Output:
(1). kPolM:  policy function, optimal choic for next period k
             nk*ns matrix
(2). IndM:   indicator showing the location of Pol_k1 in vector of k state
             nk*ns matrix
(3). valueM: value function, nk*ns matrix
%}


%% Preparation
% ns matrices, whose size is nk*nk
% Each matrix is given productivity s, the consumption for each k (row), and the all the possible k' (column)
cPolM   = ones(cS.nk, cS.nk, cS.ns); 

% nk*nk matrix of k', given each k (row), the possible choices of k' (colum)
kChoiceM = ones(cS.nk,1) * cS.kGridV';

% The BC is c+k'=ws+(1+r)k, hence c=ws+[(1+r)k-k']
% Then compute the matrix of (1+r)k-k' for each given k and all possible k'
% This is a nk*nk matrix called kM, e.g. the first row means
% kM(1,1): when k=kGridV(1) and k'=kGridV(1), the value of (1+r)k-k'
% kM(1,2): when k=kGridV(1) and k'=kGridV(2), the value of (1+r)k-k'
kM = (1+r) * cS.kGridV * ones(1,cS.nk) - kChoiceM;

% Since c=ws+[(1+r)k-k']
% cPolM contains ns matrices. Each matrix corresponds to one realization of 
% s with kM
for i = 1:cS.ns
    cPolM(:,:,i) = w * cS.s(i,1) + kM;
end

% Pick up the elements in cPolM that are negative
cPolM(cPolM<0) = 0;
% This is a logic value. 
% It means that if c is a negative number, I assign logic value 'false'  (i.e. 0)

% Due to the last step, some c have numeric value (for those >= 0), some c have logic value
% The value of utility which is calculated base on logic value is 'inf'
uM            = CRRA_Utility(cPolM, cS);
% Assign a very large negtive value (i.e. -realmax) to utility when it is inf
uM(isinf(uM)) = -realmax;

% uM has ns matrices. Each one is a nk*nk matrix corresponds to one 
% realization of productivity. Combine all these matrices together, and
% make uM to be one big (ns*nk)*nk matrix
% Each column is a kprime, first nk rows are each k with s1, second nk rows
% are each k with s2
uM = reshape(permute(uM,[1,3,2]), [], size(uM,2));


%% Value Function Iteration
tol  = 10^(-5);
dif  = tol + 10;
iter = 0;

%v0  = reshape(uM(:,1),cS.nk,cS.ns)'; 
% uM(:,1) is the utility obtained by all possible states (k) and one particular k'=-0.2
% v0 is a ns*nk matrix. The first row show utility when productivity is low
% second row is utility when productivity is high

v0 = zeros(cS.ns, cS.nk);
% Whether to use uM(:,1) as v0, or to set v0 to be zero matrix, the VFI
% result doesn't change.
% Hence for simplicity, I use zero matrix as my initial guess for v0.

while dif > tol
    
    % Construct total return function 
    walue = uM + cS.beta * kron(cS.P * v0, ones(cS.nk,1)); 
    
    [v1, IndM] = max(walue, [], 2);
        % Each row of walue shows a given a with all possible k'
        % v1 tells the largest value in each row of walue, (ns*nk)*1 vector
        % Ind tells the location of the largest value in each row
        
     v1    = reshape(v1, cS.nk, cS.ns)';
        % Transform v1 from a (ns*nk)*1 vector to ns*nk matrix       
     dif   = norm(v1-v0);
     v0    = v1;
     iter  = iter+1;

end

formatSpec = '(VFI) Iter %i \n';
fprintf(formatSpec,iter)


%% Outcomes
IndM   = reshape(IndM, cS.nk, cS.ns);

kPolM  = zeros(cS.nk, cS.ns);
for i  = 1:cS.ns
kPolM(:,i) = cS.kGridV(IndM(:,i));
end

valueM = v1';


end