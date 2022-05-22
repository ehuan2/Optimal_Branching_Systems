function X = weightedMatroidIntersectionAlgorithm(E, F1, F2, c)
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

c1 = c;
c2 = zeros(1, E);

% step 2: iterate over E \ Xk and for i = {1, 2} compute:
% Ci(Xk, y) = 
