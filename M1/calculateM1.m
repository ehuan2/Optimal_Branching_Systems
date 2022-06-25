% this function here takes in a graph G, and specified root nodes r, 
% and produces a matroid of form of a set of a set of edges
function M1 = calculateM1(G, roots)
  % param:
  % G is a n x n matrix
  % roots is a 1 x n matrix, where if roots[i] = 1, then the ith row/column of G is a root

  % First, let's transform the matrix such that we indicate what the edge number is instead of a 1.
  % this'll help in creating the basis later.

  counter = 1;
  for i = 1:size(G, 2)
    for j = 1:size(G, 2)
      row = G(i,:);
      if row(j) == 1
        G(i,j) = counter;
        counter = counter + 1;
      end
    end
  end
  
  % first, let's calculate k (ie number of roots)
  k = 0;
  for i = 1:size(roots, 2)
    if roots(i) == 1
      k = k + 1;
    end
  end
  
  S = {{}}; % S is a set of cell arrays, start with an empty one
  sCounter = 1;

  % then, we need to collect the columns that are not root columns' set of possible edges
  % ie, we need to collect all possible incoming edge sets per each node, and create a basis based off
  % of its collective possibilities
  for i = 1:size(G, 2) 
    % ignore if i is a root column
    if roots(i) == 1
      continue;
    end

    % go through all the columns
    column = G(:,i);
    % for each column, generate a set of all incoming edges
    % if it's greater than k, than generateEdgeSets, otherwise, just add it
    collection = {};
    collectionCounter = 1;

    % we get the size of a n x 1 vector (so just the first one)
    for j = 1:size(column, 1)
      if column(j) ~= 0
        collection{collectionCounter} = column(j);
        collectionCounter = collectionCounter + 1;
      end
    end

    if collectionCounter > k + 1
      % collectionCounter = number of actual numbers + 1
      allEdgeSets = generateEdgeSets(collection, k);
      
      % iterate over all members of S, and add in size(allEdgesSets, 1) new collections 
      % for each one - where each one has the different collection added in
      % so it multiplies the size by size(allEdgeSets, 1)
      nextS = {};
      nextSCounter = 1;
      
      for n = 1:size(S, 2)
        % iterate over all current members, and add in each row once
        for l = 1:size(allEdgeSets, 1)
          currentSet = S{n};
          currentSetCounter = size(currentSet, 2) + 1; % index the next free spot
          currentEdgeSet = allEdgeSets(l,:); % grab the row of the matrix

          for m = 1:size(currentEdgeSet, 2)
            currentSet{currentSetCounter} = currentEdgeSet(m);
            currentSetCounter = currentSetCounter + 1;
          end

          nextS{nextSCounter} = currentSet;
          nextSCounter = nextSCounter + 1;
        end
      end

      S = nextS;
    else
      % for each member of S, copy over the entire collection
      for n = 1:size(S, 2)
        currentSet = S{n};
        currentSetCounter = size(currentSet, 2) + 1; % index the next free spot

        for l = 1:size(collection, 2)
          currentSet{currentSetCounter} = collection{l};
          currentSetCounter = currentSetCounter + 1;
        end

        S{n} = currentSet;
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

% given a column C (a vector really), with edge numbers, create all possible maximal combinations of those edges
% limiting it at most k edges (ie, each set in the setOfEdgeSets has the most number of edges possible, capping at k)
% returns a matrix of ??? x k-tuples where they represent each possible combination
function setOfEdgeSets = generateEdgeSets(C, k)
  % let's first transform the set C to a vector, so we can use the n choose k function on it
  v = zeros(size(C));
  for i = 1:size(C, 2)
    v(i) = C{i};
  end
  setOfEdgeSets = nchoosek(v, k);
end
