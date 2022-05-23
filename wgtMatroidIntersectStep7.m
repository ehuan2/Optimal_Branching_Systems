% step 7: calculating epsilon, boolean for whether it's infinity or not
function epsilon = wgtMatroidIntersectStep7(c1, c2, A1, A2, R, m1, m2, S, T)
  % params:
    % c1 and c2 are 1 x |E|
    % A1 and A2 are cell arrays of [x y]
    % S, R and T are 1 x |E|
    % m1 and m2 are numbers
  % return:
    % epsilon as a number and isInfinity as the boolean

  % calculating eps1:
  [deltaPlusA1, eps1Empty] = calculateDeltaPlus(A1, R);
  eps1 = inf;
  for i = 1:size(deltaPlusA1, 2)
    [x, y] = deltaPlusA1(i);

    calc = c1(x) - c1(y);

    if calc < eps1
      eps1 = calc;
    end
  end
  
  % calculating eps2:
  [deltaPlusA2, eps2Empty] = calculateDeltaPlus(A2, R);
  eps2 = inf;
  for i = 1:size(deltaPlusA2, 2)
    [y, x] = deltaPlusA2(i);

    calc = c2(x) - c2(y);

    if calc < eps2
      eps2 = calc;
    end
  end
  
  % calculating eps3:
  eps3 = inf;
  for y = 1:size(S, 2)
    if S(y) == 1 && R(y) == 0
      calc = m1 - c1(y);
      if calc < eps3
        eps3 = calc;
      end
    end
  end

  % calculating eps4:
  eps4 = inf;
  for y = 1:size(T, 2)
    if T(y) == 1 && R(y) == 1
      calc = m2 - c2(y);
      if calc < eps4
        eps4 = calc;
      end
    end
  end

  epsilon = min([eps1 eps2 eps3 eps4])
end

function [deltaPlus, empty] = calculateDeltaPlus(Ai, R)
  % so delta_Ai(R) = E+(R, Ai \ R) = {(x, y) \in E(Ai) : x \in R \ (Ai \ R), y \in (Ai \ R) \ R}
  % so, delta_Ai(R) = {(x, y) \in E(Ai): x \in R, y \in Ai \ R}

  deltaPlus = {};
  deltaPlusCounter = 1;
  empty = 1;
  % iterate over Ai, adding in the point [x y] if x is in R, and y is in Ai \ R
  for i = 1:size(Ai, 2)
    [x, y] = Ai(i);
    if R(x) == 1 && Ai(y) == 1 && R(y) == 0
      deltaPlus{deltaPlusCounter} = [x y];
      deltaPlusCounter = deltaPlusCounter + 1;
      empty = 0;
    end
  end
end