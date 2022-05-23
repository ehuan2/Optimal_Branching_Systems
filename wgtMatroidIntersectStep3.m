% performs step 3 of the weighted matroid intersection algorithm
function [A1, A2, S, T] = wgtMatroidIntersectStep3(E, Xk, F1, F2, C1, C2)
  % params:
    % E as a num as the base set
    % Xk as an array of 1 x |E|
    % C1 as (Xk, y, C(Xk, y)) - where Xk is given previously, y is a num and C(Xk, y) is a 1 x |E| size matrix
    % same for C2
    % F1 and F2 are still cell arrays
  % return values:
    % A1 and A2 will be a cell array of x, y matrices
    % S and T will be a matrix of size 1 x |E|

  % computing A1:
  % iterate over E \ Xk, and then iterate over the right one in C1 (single pass for now, should and can improve)
  A1 = {};
  A1Counter = 1;
  for y = 1:E
    if Xk(y) == 0
      C1ActualSet = getCiFromKeyY(C1, y);
      % now we remove the {y}
      C1ActualSet(y) = 0;
      for x = 1:E
        if C1ActualSet(x) == 1
          % then the x works, add in (x, y) pair
          A1{A1Counter} = [x y];
          A1Counter = A1Counter + 1;
        end
      end
    end
  end
   
  % computing A2:
  A2 = {};
  A2Counter = 1;
  for y = 1:E
    if Xk(y) == 0
      C2ActualSet = getCiFromKeyY(C2, y);
      % now we remove the {y}
      C2ActualSet(y) = 0;
      for x = 1:E
        if C2ActualSet(x) == 1
          % then the x works, add in (x, y) pair
          A2{A2Counter} = [y x];
          A2Counter = A2Counter + 1;
        end
      end
    end
  end
  
  % computing S: should be a 1 x |E| size
  S = zeros(size(Xk))

  for y = 1:E
    if Xk(y) == 0
      % now we include y if Xk U {y} is in F1
      XkUnionY = Xk;
      XkUnionY(y) = 1;
      if doesXBelongInY(XkUnionY, F1) == 1
        S(y) = 1;
      end
    end
  end

  % computing T: should be a 1 x |E| size
  T = zeros(size(Xk))

  for y = 1:E
    if Xk(y) == 0
      % now we include y if Xk U {y} is in F1
      XkUnionY = Xk;
      XkUnionY(y) = 1;
      if doesXBelongInY(XkUnionY, F2) == 1
        T(y) = 1;
      end
    end
  end
end

% single pass through Ci, to get the right struct with key y
function CiActualSet = getCiFromKeyY(Ci, y)
  for i = 1:size(Ci, 2)
    % Ci{i}{2} gives the second one, or the y
    if (Ci{i}){2} == y
      CiActualSet = Ci{i}{3}; % and the actual set is in the third section
    end
  end
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

