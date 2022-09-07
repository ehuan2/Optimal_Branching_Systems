% ** IMPORTANT CONVENTION **
% We'll be using the -1 to indicate an edge leaving a node
% and 1 to indicate an edge entering a node, for the incidence matrix
function optimal_branching_systms = obs(G, roots, c)
  mode = 1;
  E = 0;
  if mode == 0
    E = numberOfEdges(G);
  else
    E = numberOfEdgesIncidence(G);
  end
  setOfXk = weightedMatroidIntersectionAlgorithm(E, F1Wrapper(G, roots, mode), F2Wrapper(G, roots, mode), c);
  if size(setOfXk, 2) ~= 0
    % check it's the right size
    optimal_branching_systems = setOfXk{size(setOfXk, 2)};
    k = numberOfRoots(roots);

    % if it's not the right size, don't add it in
    n = size(G, 1); % for both incidence and adjacency, both the number of rows

    if countOnes(optimal_branching_systems) ~= k * (n - k)
      optimal_branching_systems = 'no branching systems...';
    end
  end
end

function F1WithoutMode = F1Wrapper(G, roots, mode)
  F1WithoutMode = @(edgeset) (F1(transformGBasedOffEdgeset(G, edgeset, mode), roots, mode));
end

function F2WithoutMode = F2Wrapper(G, roots, mode)
  F2WithoutMode = @(edgeset) F2(transformGBasedOffEdgeset(G, edgeset, mode), numberOfRoots(roots), mode);
end

function numberOfEdges = countOnes(edgeset)
  numberOfEdges = 0;
  for i = 1:size(edgeset, 2)
    if edgeset(i) == 1
      numberOfEdges = numberOfEdges + 1;
    end
  end
end

% F1 Calculation: ----------------------------------------------------------------------------------
% a function that returns a boolean as isInF1 to see if the edgeset G (represented as a matrix)
% is in F1
function isInF1 = F1(G, roots, mode)
  % default to true, and calculate k
  isInF1 = 1;
  k = numberOfRoots(roots);

  if mode == 0
    % adjancency
    for i = 1:size(G, 2)
      % iterate over all the columns and set isInF1 to false if:
      % 1) Any of the roots columns has a 1 in it
      % 2) Any of the non-roots columns has more than k (number of roots) one's in it
      column = G(:,i);
      if roots(i) == 1
        % if it's a root, check the column of it
        for j = 1:size(column, 1)
          if column(j) == 1
            isInF1 = 0;
            break;
          end
        end
      else
        count = 0;
        for j = 1:size(column, 1)
          if column(j) == 1
            count = count + 1;
          end
        end

        if count > k
          isInF1 = 0;
          break;
        end
      end
    end
  else
    % F1 incidence matrix
    % iterate over all the rows of an incidence matrix
    % as those are the ones that indicate the nodes
    % and checks for the same count as well as incoming to roots
    for i = 1:size(G, 1)
      % iterate over all the rows
      row = G(i,:);
      if roots(i) == 1
        % if it's a root, check the column of it
        for j = 1:size(row, 2)
          if row(j) == 1
            isInF1 = 0;
            break;
          end
        end
      else
        count = 0;
        for j = 1:size(row, 2)
          if row(j) == 1
            count = count + 1;
          end
        end

        if count > k
          isInF1 = 0;
          break;
        end
      end
    end
  end
end

% F2 Calculation: ----------------------------------------------------------------------------------
function isInF2 = F2(G, numRoots, mode)
  if mode == 0
    numEdges = numberOfEdges(G);
  else
    numEdges = numberOfEdgesIncidence(G);
  end

  if mode == 0
    % F1: transform an adjacency to an incidence
    % then transform from an adjancency to incidence
    [A, transformedG] = adjacencyToIncidenceMatrix(G);
  else
    % F2: transform the incidence to a non-directed incidence
    % then transform the incidence directed to non-directed (i.e. flip all the -1's)
    A = directedIncidenceToUndirected(G);
  end

  setOfFis = {};
  for i = 1:numRoots
    setOfFis{i} = forestMatroid(A);
  end

  partition = matroidPartitioning(numEdges, setOfFis, numRoots);

  % now we check that each row has a 1 in it
  % assume it's in f2 at the start
  isInF2 = 1;
  for i = 1:size(partition, 1)
    row = partition(i,:);
    count = 0;
    for j = 1:size(row, 2)
      if row(j) == 1
        count = count + 1;
      end
    end
    if count ~= 1
      isInF2 = 0;
      break;
    end
  end
end

function forestMatroidWrapper = forestMatroid(G)
  function isForestPartitions = M1(edgeset)
    gRemovePartition = removeNonPartitionEdges(G, edgeset);
    isForestPartitions = isForest(gRemovePartition);
  end

  forestMatroidWrapper = @(edgeset) M1(edgeset);
end

function edgesRemoved = removeNonPartitionEdges(A, partition)
  edgesRemoved = [];

  for i = 1:size(partition, 1) % partition should be a E x 1 vector
    % loop over it all, if it's a 1 (ie in partition), then append the entire column to the matrix
    if partition(i) == 1
      % append the column to the end of edges removed (should work since in order)
      edgesRemoved = [edgesRemoved A(:,i)];
    end
  end
end

% evaluates whether or not incidence matrix A is a forest
function forestBool = isForest(A)
  % first, check if it's just a n x 1 matrix (then it's a forest, just a single edge)
  if size(A, 2) == 1
    forestBool = 1;
  else
    % first, calculate the g2rref
    [Arref, M, N, rank] = g2rref(A);
    forestBool = (rank == size(A, 2)); % check if the rank if the number of columns we have
  end
end

function X = matroidIntersection(E, F1, F2)
  X = zeros(1, E);
  while 1
    [C1, C2] = wgtMatroidIntersectStep2(E, X, F1, F2);
    [A1, A2, S, T] = wgtMatroidIntersectStep3(E, X, F1, F2, C1, C2);
    G = zeros(E, E); % form a |E| x |E| matrix, iterate over the two Aibar's and add edges

    for i = 1:size(A1, 2)
      x = A1{i}(1);
      y = A1{i}(2);
      G(x, y) = 1;
    end

    for i = 1:size(A2, 2)
      y = A2{i}(1);
      x = A2{i}(2);
      G(y, x) = 1;
    end

    [R, backtrack] = bfs(S, G);
    [RIntersectTEmpty, nextPath] = wgtMatroidIntersectStep6(R, T, X, backtrack);

    if RIntersectTEmpty == 1
      % if it's empty i.e. no path, stop
      break;
    end

    X = nextPath;
  end
end

function partition = matroidPartitioning(E, setOfFis, k)
  % take in a set of k Fi's
  % and generate the matroids to intersect on

  % first, let's generate the ground set X
  % let's represent a pair (x, i), where x is an edge by doing the following:
  % the row represents a certain edge x
  % the column represents the number i

  % going to simply do a rearrangement of the edges when necessary
  partition = matroidIntersection(E * k, M1Wrapper(setOfFis, k), M2Wrapper(k));
  partition = reorganizeVector(partition, k);
end

function toReturn = M1Wrapper(setOfFis, k)
  function isInM1 = M1(edgeset)
    % reorganize edgeset into a E x k matrix
    matrix = reorganizeVector(edgeset, k);

    isInM1 = 1; % assume it is, until it isn't
    % only independent if for each i = 1 ... k
    % Yi, i.e. the column, is a member of Fi
    for i = 1:size(setOfFis, 2)
      column = matrix(:,i);
      Fi = setOfFis{i};
      if Fi(column) == 0
        isInM1 = 0;
        break;
      end
    end
  end
  toReturn = @(edgeset)M1(edgeset);
end

function toReturn = M2Wrapper(k)
  function isInM2 = M2(edgeset)
    % all we want to do, is check that each
    % row only has at most one in it
    isInM2 = 1;
    matrix = reorganizeVector(edgeset, k);

    for i = 1:size(matrix, 1)
      % iterate over each row
      row = matrix(i,:);
      count = 0;
      for j = 1:size(row, 2)
        if row(j) == 1
          count = count + 1;
        end
        if count > 1
          isInM2 = 0;
          break;
        end
      end

      if isInM2 == 0
        break;
      end
    end
  end
  toReturn = @(edgeset)M2(edgeset);
end

function matrix = reorganizeVector(vector, k)
  % given a vector of 1 x (E * k) size,
  % reorganize it to a E x k matrix
  matrix = reshape(vector, k, [])';
end

% Utility Functions:
% this function takes in a matrix G (based off of mode) and an edgeset to remove all edges from G that are not in the edgeset
function newG = transformGBasedOffEdgeset(G, edgeset, mode)
  % edgeset is a 1 x |E| matrix, where a 1 indicates it includes that edge, 0 indicates it doesn't
  if mode == 0
    % adjacency matrix
    % iterate through the edges, and only keep the ones that are 1's in the edgeset
    edgeCount = 0;
    for i = 1:size(G, 1)
      for j = 1:size(G, 2)
        if G(i, j) == 1
          edgeCount = edgeCount + 1;
          if edgeset(edgeCount) == 0
            % if it exists in the adjacency but not the edgeset, remove it
            G(i, j) = 0;
          end
        end
      end
    end
    newG = G;
  else
    % incidence matrix
    % iterate through the columns, and only keep the ones that are 1's
    newG = [];
    for i = 1:size(edgeset, 2)
      if edgeset(i) == 1
        newG = [newG G(:,i)];
      end
    end
  end
end

% this function takes a matrix A and transforms it to an incidence matrix
function [incidenceMatrix, transformedA] = adjacencyToIncidenceMatrix(A)
  % given an incidence matrix A, with rows representing the starting edge position
  % calculate an incidence matrix, where we order the edges per row then column, that's |V(G)| x |E(G)| size
  
  % first count how many edges there are, and transform A at the same time
  transformedA = zeros(size(A));
  counter = 1;
  for i = 1:size(A, 2)
    for j = 1:size(A, 2)
      row = A(i,:);
      if row(j) == 1
        transformedA(i,j) = counter;
        counter = counter + 1;
      end
    end
  end

  % so now there are counter - 1 edges
  incidenceMatrix = zeros(size(A, 2), counter - 1);
  for i = 1:size(A, 2)
    for j = 1:size(A, 2)
      row = transformedA(i,:);
      if row(j) ~= 0
        % we're setting the index matrix to 1 if it comes either in or out of it
        incidenceMatrix(i, row(j)) = 1;
        incidenceMatrix(j, row(j)) = 1;
      end
    end
  end
end

% this function takes in a directed incidence and turns it to an undirected one
function A = directedIncidenceToUndirected(G)
  for i = 1:size(G, 1)
    for j = 1:size(G, 2)
      if G(i, j) == -1
        G(i, j) = 1;
      end
    end
  end
  A = G;
end

% this function here takes in an adjancency matrix G and produces the number of edges
function [numEdges] = numberOfEdges(G)
  numEdges = 0;
  for i = 1:size(G, 2)
    for j = 1:size(G, 2)
      if G(i,j) ~= 0
        numEdges = numEdges + 1;
      end
    end
  end
end

% this funciton calculates the number of edges in an incidence matrix
function numberOfEdges = numberOfEdgesIncidence(G)
  numberOfEdges = size(G, 2);
end

% this function produces the number of roots through the matrix of roots
function [numRoots] = numberOfRoots(roots)
  numRoots = 0;
  for i = 1:size(roots, 2)
    if roots(i) == 1
      numRoots = numRoots + 1;
    end
  end
end

% Weighted Matroid Intersection Algorithm: ---------------------------------------------------------

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

  % we want to be able to hold all the Xk's we have, but we'll use a cell array 
  % because matlab uses the 1 index as first however, setOfXk{k + 1} = Xk.
  setOfXk = {};
  setOfXk{1} = X0;

  c1 = c;
  c2 = zeros(1, E);

  goBackToStep2 = 1;
  goBackToStep4 = 1;

  while goBackToStep2 == 1
    fprintf('Testing k = %d', k);
    % step 2:
    [C1, C2] = wgtMatroidIntersectStep2(E, setOfXk{k + 1}, F1, F2);

    % step 3:
    [A1, A2, S, T] = wgtMatroidIntersectStep3(E, setOfXk{k + 1}, F1, F2, C1, C2);

    % step 4:
    while goBackToStep4 == 1
      [m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(E, c1, c2, S, T, A1, A2);

      % step 5:
      [R, backtrack] = bfs(Sbar, Gbar);

      % step 6: check if R intersect T is empty
      [RIntersectTBarEmpty, XkPlusOne] = wgtMatroidIntersectStep6(R, Tbar, setOfXk{k + 1}, backtrack);

      if RIntersectTBarEmpty == 0
        % set Xk+1 as Xk, add k = k + 1 and go back to 2.
        k = k + 1;
        setOfXk{k + 1} = XkPlusOne;
        break;
      end

      % step 7:
      epsilon = wgtMatroidIntersectStep7(c1, c2, A1, A2, R, m1, m2, S, T);
      
      % step 8:
      if epsilon == inf
        % choose the one with maximum weight amongst X0, X1 ... Xk, ie the sum of the weights in Xi

        maxWeight = -inf;

        for i = 1:size(setOfXk, 2)
          Xi = setOfXk{i};
          currentWgt = 0;

          for j = 1:size(Xi, 2)
            if Xi(j) == 1
              % add to the current weight
              currentWgt = currentWgt + c(j);
            end
          end

          if currentWgt > maxWeight
            % change what X is, as well as the max weight
            X = Xi;
            maxWeight = currentWgt;
          end
        end

        X = setOfXk;

        goBackToStep2 = 0;
        goBackToStep4 = 0;
        break;
      else
        % less than infinity, go back to step 4 after rewriting c1 and c2

        for x = 1:size(R, 2)
          if R(x) == 1
            c1(x) = c1(x) - epsilon;
            c2(x) = c2(x) + epsilon;
          end
        end
      end
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

      if Fi(XkUnionY) == 0 && Fi(XkUnionYExcludeX)
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
      C1{c1Counter} = step2ComputeCi(F1, Xk, y);
      c1Counter = c1Counter + 1;

      C2{c2Counter} = step2ComputeCi(F2, Xk, y);
      c2Counter = c2Counter + 1;
    end
  end
end

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
  S = zeros(size(Xk));

  for y = 1:E
    if Xk(y) == 0
      % now we include y if Xk U {y} is in F1
      XkUnionY = Xk;
      XkUnionY(y) = 1;
      if F1(XkUnionY) == 1
        S(y) = 1;
      end
    end
  end

  % computing T: should be a 1 x |E| size
  T = zeros(size(Xk));

  for y = 1:E
    if Xk(y) == 0
      % now we include y if Xk U {y} is in F1
      XkUnionY = Xk;
      XkUnionY(y) = 1;
      if F2(XkUnionY) == 1
        T(y) = 1;
      end
    end
  end
end

% single pass through Ci, to get the right struct with key y
function CiActualSet = getCiFromKeyY(Ci, y)
   CiActualSet = [0 0 0];
  for i = 1:size(Ci, 2)
    % Ci{i}{2} gives the second one, or the y
    set = Ci{i};
    if set{2} == y
      CiActualSet = Ci{i}{3}; % and the actual set is in the third section
    end
  end
end

% performs step 4 of the weighted matroid intersection algorithm
function [m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(E, c1, c2, S, T, A1, A2)
  % params:
    % E is a num as the base set
    % c1 and c2 are 1 x |E| matrices
    % S and T are 1 x |E| matrices
    % A1 and A2 are cell array of [x y] pairs
  % return:
    % m1 and m2 are single numbers
    % Sbar and Tbar are again 1 x |E| matrices
    % A1 and A2 are also cell arrays again
    % G, instead of adding in vertex set (already know it), we just have the edge set as a |E| x |E| matrix
  
    % todo: how precise is matlab? doesn't floating numbers mean that there might be some error?

    % finding m1 and m2:
    m1 = calculateMi(c1, S);
    m2 = calculateMi(c2, T);

    % finding Sbar and Tbar:
    Sbar = calculateXbar(S, c1, m1);
    Tbar = calculateXbar(T, c2, m2);

    % finding A1bar and A2bar
    A1bar = calculateAiBar(A1, c1);
    A2bar = calculateAiBar(A2, c2);

    Gbar = zeros(E, E); % form a |E| x |E| matrix, iterate over the two Aibar's and add edges

    for i = 1:size(A1bar, 2)
      x = A1bar{i}(1);
      y = A1bar{i}(2);
      Gbar(x, y) = 1;
    end

    for i = 1:size(A2bar, 2)
      y = A2bar{i}(1);
      x = A2bar{i}(2);
      Gbar(y, x) = 1;
    end
end

function mi = calculateMi(ci, setX)
  mi = -inf; % given S is null, it'd be 0
  for y = 1:size(setX, 2)
    if setX(y) == 1
      next = ci(y);
      if next > mi
        mi = next;
      end
    end
  end
end

function xBar = calculateXbar(X, ci, mi)
  xBar = zeros(size(X));
  for y = 1:size(X, 2)
      if X(y) == 1
        if ci(y) == mi
            xBar(y) = 1;
        end
      end
  end
end

function AiBar = calculateAiBar(Ai, ci)
  AiBar = {};
  AiBarCounter = 1;

  for i = 1:size(Ai, 2)
    first = Ai{i}(1);
    second = Ai{i}(2);
    if ci(first) == ci(second)
      AiBar{AiBarCounter} = [first second];
      AiBarCounter = AiBarCounter + 1;
    end
  end
end

function [R, backtrack] = bfs(S, G)
  % given two sets, S representing nodes (so a 1 x n matrix), and an edge matrix G, that's n x n
  % bfs(S, G) represents the vertices reachable from S in G
  % adding in a return vector of backtrack that represents its parent so we can find the smallest path (also 1 x |E|)

  % start with the set of reachable edges, R itself as the ones in S.
  R = S;

  % add to backtrack, we represent the unreachable by -1, and ones in S by 0.
  backtrack = zeros(size(S));
  for i = 1:size(S, 2)
    if S(i) == 1
      backtrack(i) = 0;
    else
      backtrack(i) = -1;
    end
  end

  % maintain a queue by having an index for its head and tail
  head = 1;
  tail = 1;
  queue = {};

  % go through S (ie search through how many columns there are and add all the starting nodes to the queue
  for i = 1:size(S, 2)
    if S(i) == 1
      queue{tail} = i;
      tail = tail + 1;
    end
  end


  % keep searching as long as queue is not empty, ie the head is not at the tail position
  while head ~= tail
    % then, we pop off the next node to search from, and all its neighbours that aren't reached yet
    next = queue{head};
    head = head + 1;

    neighboursRow = G(next,:);

    % iterate over the row of neighbours, and collect all the ones that aren't yet found
    for j = 1:size(neighboursRow, 2)
      if neighboursRow(j) == 1 && R(j) == 0
        % add to R, and add to queue
        R(j) = 1;
        queue{tail} = j;
        tail = tail + 1;

        % add to the backtrack now
        backtrack(j) = next;
      end
    end
  end
end

% step 6: checks if R intersects with Tbar is empty
% and if so, returns a path of Xk delta V(P) where P is a path found from bfs
function [RIntersectTBarEmpty, XkPlusOne] = wgtMatroidIntersectStep6(R, Tbar, Xk, backtrack)
  % params:
    % R, a 1 x |E| matrix of reachable nodes
    % Tbar, a 1 x |E| matrix
    % Xk, a 1 x |E| matrix
    % backtrack a 1 x |E| matrix
  % return:
    % RIntersectTBarEmpty, a boolean that represents whether or not it's empty, true if empty
    % XkPlusOne a 1 x |E| matrix of the Xk delta V(P)

  RIntersectTBarEmpty = 1;
  XkPlusOne = zeros(size(R));

  % keep a collection of all reachable nodes in Tbar, so we can find each path
  RIntersectTBar = zeros(size(R));

  for i = 1:size(R, 2)
    if R(i) == 1 && Tbar(i) == 1
      RIntersectTBarEmpty = 0;
      RIntersectTBar(i) = 1;
    end
  end

  if RIntersectTBarEmpty == 0
    % if we do need to calculate the path, we do it, iterate over RIntersectTBar
    
    % hold these values to find the minimum path, at most it's all of the nodes
    minPathLength = inf;
    minVofP = zeros(size(R));

    for i = 1:size(RIntersectTBar, 2)
      if RIntersectTBar(i) == 1
        [curVofP, curPathLength] = calculateVofP(backtrack, i);

        if curPathLength < minPathLength
          minVofP = curVofP;
        end
      end
    end

    for i = 1:size(R, 2)
      % finds the disjunctive union, basically xor of the minVofP and Xk
      if Xk(i) ~= minVofP(i) && ((Xk(i) || minVofP(i)) == 1)
        XkPlusOne(i) = 1;
      end
    end
  end
end

function [VofP, pathLength] = calculateVofP(backtrack, TbarNode)
  % given a backtrack array, and the node in Tbar, calculate the nodes in V(P), and its pathLength

  current = TbarNode;
  pathLength = -1;
  VofP = zeros(size(backtrack));

  % should not get to -1, but just in case
  while current ~= 0 && current ~= -1
    VofP(current) = 1;
    current = backtrack(current);
    pathLength = pathLength + 1;
  end
end

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
    x = deltaPlusA1{i}(1);
    y = deltaPlusA1{i}(2);

    calc = c1(x) - c1(y);

    if calc < eps1
      eps1 = calc;
    end
  end
  
  % calculating eps2:
  [deltaPlusA2, eps2Empty] = calculateDeltaPlus(A2, R);
  eps2 = inf;
  for i = 1:size(deltaPlusA2, 2)
    y = deltaPlusA2{i}(1);
    x = deltaPlusA2{i}(2);

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

  epsilon = min([eps1 eps2 eps3 eps4]);
end

function [deltaPlus, empty] = calculateDeltaPlus(Ai, R)
  % so delta_Ai(R) = E+(R, Ai \ R) = {(x, y) \in E(Ai) : x \in R \ (Ai \ R), y \in (Ai \ R) \ R}
  % so, delta_Ai(R) = {(x, y) \in E(Ai): x \in R, y \in Ai \ R}

  deltaPlus = {};
  deltaPlusCounter = 1;
  empty = 1;

  % iterate over Ai, adding in the point [x y] if x is in R, and y is in Ai \ R
  for i = 1:size(Ai, 2)
    x = Ai{i}(1);
    y = Ai{i}(2);
    if R(x) == 1 && R(y) == 0
      deltaPlus{deltaPlusCounter} = [x y];
      deltaPlusCounter = deltaPlusCounter + 1;
      empty = 0;
    end
  end
end

% g2rref: -----------------------------------------------------------------------------------------
% This is a modified version of MATLAB's rref (from Revision: 5.9.4.3 $  $Date: 2006/01/18 21:58:54) which calculates row-reduced echelon form in GF(2).  Useful for linear codes. Tolerance was removed because YOLO, and because all values should only be 0 or 1. Original: https://gist.github.com/esromneb/652fed46ae328b17e104, Fork that prints more information: https://gist.github.com/nrenga/3c0ee3af2fb8ca38dcf9113376cae381 (Feb. 28, 2018), Fork that's more compact: https://gist.github.com/ndattani/d77e70364a988bb55701337dd525ace2 (May 30 2022)
% Returns the matrix M of row operations on A, i.e., Arref = M*A, and the matrix N of column operations which if applied to Arref results in a matrix of the form [I_rnk, 0; 0, 0] for the first m columns, where rnk is the gf(2) rank of A, i.e., (Arref*N)_{1:m,1:m} = (M*A*N)_{1:m,1:m} = [I_rnk, 0; 0, 0]. For a square matrix A, Arref*N = M*A*N = [I_rnk, 0; 0, 0].

function [Arref, M, N, rnk] = g2rref(A)

[Arref, M] = gf2redref(A);
[Ardiag, Nt] = gf2redref(Arref');
N = Nt';
rnk = sum(diag(Ardiag));

    function [Arref, Row_ops] = gf2redref(A)
        [m,n] = size(A);
        Row_ops = eye(m);
        Arref = [A, Row_ops];
        nr = size(Arref, 2);
        
        i = 1; j = 1; % Loop over the entire matrix.        
        while (i <= m) && (j <= n)
            while (Arref(i,j) == 0) && (j <= n)
                k = find(Arref(i:m,j),1) + i - 1;  % Find value and index of largest element in the remainder of column j.
                
                if (isempty(k))
                    j = j + 1;
                    continue;
                else
                    Arref([i k],j:nr) = Arref([k i],j:nr); % Swap i-th and k-th rows.
                end
            end         
            if (Arref(i,j) == 1) && (j <= n)
                aijn = Arref(i,j:nr); % Save the right hand side of the pivot row            
                col = Arref(1:m,j);   % Column we're looking at
                col(i) = 0; % Never Xor the pivot row against itself
                flip = col*aijn; % This builds an matrix of bits to flip
                Arref(1:m,j:nr) = xor( Arref(1:m,j:nr), flip ); % Xor the right hand side of the pivot row with all the other rows
                j = j + 1;
            end
            i = i + 1;
        end
        Row_ops = Arref(1:m,(n+1):nr);
        Arref = Arref(1:m,1:n);
    end
end
