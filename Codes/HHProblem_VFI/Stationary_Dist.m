function mu = Stationary_Dist(IndM, cS)
%% Documentation
%{
1. Function Description:
   Given prices and the policy function k'=g(k,s), this program find the associated
stationary distribution mu(k,s) by iterating until finding a fixed point of
the following operator 
          mu(k',s')=sum_k sum_s 1{k'=g(k,s)} prob(s'|s) mu(k,s)

   The idea is that taking the decision rules from the value function
iteration step and a guess at the distribution as given, we can map current
states into future states, and then repeat this mapping as necessary until
convergence.

2. Input
(1). IndM:   For each k and s, there is a corresponding optimal k'. 
             IndM is an nk*ns matrix, showing the position of k' in the k
             state vector for each k and s combination.
(2). cS.s:   vector of productivity state (ns*1 vector)
(3). cS.P:   transition probability (ns*ns matrix)

3. Output:
mu: stationary distribution of k and s
%}


%% Stationary Distribution
%{ 
                               Step-1.
Make an initial guess at the stationary distribution. A convenient
one is the uniorm, so that mu_0 = 1/(nk*ns) for all (k,s) on the grid
%}
mu0 = ones(cS.nk, cS.ns) ./ (cS.nk*cS.ns);

%--------------------------------------------------------------------------
%{
                               Step-2. 
Given my initial guess, compute mu1(k,s)=Tmu0(k,s) for all (k,s) on the grid.
Given the decision rule, and setting mu1(k,s)=0 at the start of each new
iteration before looping through all k,s,s', we can compute mu1 by
accumulation. That is for each triple (k,s,s')
         mu1(g(k,s),s') = mu1(g(k,s),s') + mu0(k,s)*Prob(s,s')

                              Step-3.
Compute the sup-norm metric: sup_(k,s) |mu1(k,s)-mu0(k,s)|
If the convergence metric is within tolerance, exit the loop and set mu1=mu.
Otherwise, set mu0=mu1 and repeat steps 2 and 3.
%}
tol    = 10^(-5);
dif    = tol + 1;
itermu = 0;

while dif > tol   

    mu1 = zeros(cS.nk,cS.ns);

    for i = 1 : cS.nk                % Capital

        for j = 1 : cS.ns            % Current labor productivity shock

            for jprime = 1 : cS.ns   % Next period labor productivity shock
                mu1(IndM(i,j),jprime) = mu1(IndM(i,j), jprime) + cS.P(j, jprime) * mu0(i,j);
            end 

        end 
        
    end 
    
    dif    = max(max(abs(mu0 - mu1)));
    mu0    = mu1;
    itermu = itermu+1;
    
end

formatSpec = '(Stationary Distribution Iteration) current diff: %2.4f ,Iter %i \n';
fprintf(formatSpec,dif,itermu)

mu = mu1;


end