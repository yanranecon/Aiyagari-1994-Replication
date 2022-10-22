function [Pi, Z] = StationaryDis_MarkovProcess(s, P, dbg)
%% Documentation
%{
1. Function description:
This function solves for stationary distribution of a Markov Process s
given the transition matrix P

2. INPUTS:
(1). s:   The Markov Process, [a n*1 vector]
          e.g. s={s_L; s_H}={1;2}, s is the possible realizations of productivity
(2). P:   The transition Matrix, [a n*n matrix]
(3). dbg: Debugging indicator (=1: debug; =0: skip)

3. OUTPUTS:
(1). Pi: The stationary distribution of s, [a n*1 vector]
         Pi should be a row vector, such that Pi*P=Pi
         and the sum of all elements in Pi should be 1
(2). Z:  Mean of s with stationry distribution, [a scalar]
%}


%%  Input Validation
% Since P is the transition matrix
% 1. All elements in P should be positive
% 2. The sum of each row in P should be 1
% 3. P should be a squared matrix

if dbg ==1

   if any(P(:) < 0)
      error('Cannot compute stationary distribution due to wrong transition matrix');
   end

   for i = 1 : length(P)
   if sum(P(i,:)) ~= 1
      error('Sum of each row of transition matrix should be 1');
   end
   end

   if size(P,1) ~= size(P,2)
      error('Transition matrix should be a squared matrix');
   end

end


%% Compute the stationary distribution and mean
A  = P';
for i = 1 : length(P)
  A(i,i) = P(i,i) - 1;  
end

A  = [A; ones(1, length(P))];
B  = [zeros(length(P),1); 1];
Pi = A \ B;
Z  = s'*Pi;


end