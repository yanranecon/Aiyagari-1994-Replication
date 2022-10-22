function [kPolM, valueM] = VFI_Interp(r, w, cS)
%% Documentation
%{
1. Function Description:
This program gets the policy function and value function using Value
Funtion Iteration and Iterpolation to smooth out value function.

I loop over all possible values of the states. For each value in k and s, I
find the k' that maximizes Bellman equation given my guess of the value
function. 
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
(1). kPolM:      policy function, optimal choic for next period k
(2). valueM:     value function
%}


%% Policy Function & Value Function
tol = 10^(-5);
dif = tol + 10;

% Create holders
v0  = zeros(cS.nk, cS.ns);
v1  = zeros(cS.nk, cS.ns);
k11 = zeros(cS.nk, cS.ns);

while dif > tol
    
    for j = 1:length(cS.s)

        for i = 1:cS.nk

            k0       = cS.kGridV(i,1);
            s0       = cS.s(j,1);
            k1       = fminbnd(@ValFun_Stoch, cS.kMin, cS.kMax);
            v1(i,j)  = -ValFun_Stoch(k1);
            k11(i,j) = k1;

        end

    end
    
    dif = norm(v1-v0);
    v0  = v1;

end

kPolM   = k11;
valueM  = v0;


%% Nested: objective function
    function val = ValFun_Stoch(k)

        g = interp1(cS.kGridV, v0, k, 'linear'); % Smooth out value function
        c = w * s0 + k0 * (1 + r) - k;           % Consumption

        if c <= 0
           val = -8888888888888888 - 800*abs(c); % Keep it from going negative
        else
           u   = CRRA_Utility(c, cS);
           val = u + cS.beta * (g * cS.P(j,:)');
        end

        val    = -val;

    end


end