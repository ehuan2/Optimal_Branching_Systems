function [C1, C2] = weightedMatroidIntersectionAlgorithm(E, F1, F2, c)
  % param:
  % E is the base set, here is simply a number of its size
  % F1 and F2 are matrices that represent the independent subsets of E
    % believe it should be 1 if it represents that the edge belongs to the subset
  % c represents a weight from an edge in [E] to a real number, should be a 1 x |E| matrix
  % return:
  % set X (size E that contains a bit of 1 for each edge in the set) that's the intersection of F1 and F2 of max weight

  % step 1: initialize k, X0, c1 and c2

  k = 0;
  X0 = zeros(1, E); 

  % we want to be able to hold all the Xk's we have, but we'll use a cell array 
  % because matlab uses the 1 index as first however, setOfXk{k + 1} = Xk.
  setOfXk = {};
  setOfXk{1} = X0;

  c1 = c;
  c2 = zeros(1, E);

  % step 2:
  [C1, C2] = wgtMatroidIntersectStep2(E, Xk{k + 1}, F1, F2)

  % step 3:
  [A1, A2, S, T] = wgtMatroidIntersectStep3(E, Xk{k + 1}, F1, F2, C1, C2)

  % step 4:
end

% performs step 3 of the weighted matroid intersection algorithm
function [A1, A2, S, T] = wgtMatroidIntersectStep3(E, Xk, F1, F2, C1, C2)

end

% performs step 4 of the weighted matroid intersection algorithm
function [m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(E, c1, c2, S, T, A1, A2)

end