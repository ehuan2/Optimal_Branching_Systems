% this function here takes in a graph G, and specified root nodes r, 
% and produces a matroid of form of a set of a set of edges
function M1 = calculateM1(G, roots)
  % param:
  % G is a n x n matrix
  % roots is a 1 x n matrix, where if roots[i] = 1, then the ith row/column of G is a root

  % do a single pass through entire matrix
  % if there exists an edge, increment counter
  % if that edge is not going towards a root, then add it to the set S
  % and return the basis of the powerset of that set S

  S = {};
  counter = 1;
  sCounter = 1;
  for i = 1:size(G, 2)
    for j = 1:size(G, 2)
      row = G(i,:);
      if row(j) == 1
        if roots(j) == 0
          % if it's not going into a root, then add it
          S{sCounter} = counter;
          sCounter = sCounter + 1;
        end
        counter = counter + 1;
      end
    end
  end
  M1 = S;
end

function powerSet = generatePowerSet(S)
  % this generates the powerSet based on set S
  % ie.: given {1, 2, 3}, returns {{}, {1}, {2}, {3}, {1, 2}, ...}
  % can do this recursively easily, ie generate all power sets of {2, 3}, and then add in {1} or not {1}
  if size(S, 2) == 1
    powerSet = {{}, S{1}};
  else
    first = S{1};
    rest = S(2:size(S, 2));
    restPowerSet = generatePowerSet(rest);

    powerSetCounter = 1;
    powerSet = {};

    for i = 1:size(restPowerSet, 2)
      powerSet{powerSetCounter} = restPowerSet{i};
      powerSetCounter = powerSetCounter + 1;

      nextSet = restPowerSet{i};
      nextSet{size(nextSet, 2) + 1} = first;
      powerSet{powerSetCounter} = nextSet;
      powerSetCounter = powerSetCounter + 1;
    end
  end
end
