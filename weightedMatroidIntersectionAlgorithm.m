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
end

% given a matrix X, of size 1 x |E| we check if it belongs in cell array Y, where Y is a 1 x N cell array
function belongToBool = doesXBelongInY(X, Y)
  % first, we iterate over X to collect a cell array, and then use this to check in the for loop  
  XasCellArray = {};
  xIteratorCounter = 1;
  for i = 1:size(X, 2)
    if X(i) == 1
      XasCellArray{xIteratorCounter} = i;
      xIteratorCounter = xIteratorCounter + 1;
    end
  end

  belongToBool = 0;
  for i = 1:size(Y, 2)
    if isequal(Y{i}, XasCellArray)
      belongToBool = 1;
    end
  end
end


% step 2 of the matroid intersection function, computes Ci(Xk, y)
function [C1, C2] = wgtMatroidIntersectStep2(E, Xk, F1, F2)
  % param:
    % E the base set as a pure number
    % Xk is an array of size 1 x |E|
    % F1 and F2 are the two independent sets that form the matroids
  % return:
    % C1(Xk, y) and C2(Xk, y), where we have C1 = [(Xk, y, C1(Xk, y))] for all y's and same for C2
  
  % helper function for step 2, where we compute Ci for the given Fi and Xk and y
  function Ci = step2ComputeCi(Fi, Xk, y)
    % given a cell array for Fi and a matrix for Xk and y, returns (Xk, y, Ci(Xk, y)), with Ci(Xk, y) being a matrix
    % returns 
    Ci = {Xk, y};
    CiActualSet = zeros(size(Xk)); % mark as a 1 x |E| matrix with all 0's
    CiCounter = 1;
    
    % xkunionY should be a 1 x |E| matrix
    XkUnionY = Xk;
    XkUnionY(y) = 1;

    for x = 1:size(XkUnionY, 2)
      % we need to check that Xk union y \ {x} is in Fi
      % and that Xk union y is not in Fi
      XkUnionYExcludeX = XkUnionY;
      XkUnionYExcludeX(x) = 0;

      if doesXBelongInY(XkUnionY, F1) == 0 && doesXBelongInY(XkUnionYExcludeX, Fi)
        % now we add it in
        CiActualSet(x) = 1;
      end
    end
    
    Ci{3} = CiActualSet;
  end

  c1Counter = 1;
  C1 = {};
  c2Counter = 1;
  C2 = {};
  
  for y = 1:E
    % so we use the y if it's not in Xk
    if Xk(y) == 0
      % iterate over i = {1, 2}
      
      XkUnionY = Xk;
      XkUnionY(y) = 1;

      % check first if Xk U {y} belongs in Fi
      C1{c1Counter} = step2ComputeCi(F1, Xk, y)
      c1Counter = c1Counter + 1;

      C2{c2Counter} = step2ComputeCi(F2, Xk, y)
      c2Counter = c2Counter + 1;
    end
  end
end

% performs step 3 of the weighted matroid intersection algorithm
function [A1, A2, S, T] = wgtMatroidIntersectStep3(E, Xk, F1, F2, C1, C2)

end