% this function tests a given graph G and roots, and a given mode
% mode = 1: tests everything, including intersection
% mode = 2: only tests the branchingSystems
% mode = 3: tests everything, and shows it
% mode = else: tests everything, only shows size
function hasError = optimalBranchingSystems(G, roots, mapping)
  clc();
  mode = 5;
  hasError = 0;

  % now we calculate J1 and J2, and branchings and intersection
  M1 = calculateM1(G, roots);
  branchings = branchingSystems(G, roots);
  k = numberOfRoots(roots);

  switch mode
  case 1
    M2 = calculateM2BruteForce(G, k);
    intersects = cellArrayIntersection(M1, M2);
    if isCellArrayEqual(intersects, branchings) == 0
      hasError = 1; % if they're not the same, there's an error
      fprintf('\nMatrix:\n')
      G
      fprintf('\nRoots:\n')
      roots
      fprintf('\nM1:\n')
      prettyPrintCellArray(M1);
      size(M1)
      fprintf('\nM2:\n')
      prettyPrintCellArray(M2);
      size(M2)
      fprintf('\nIntersection:\n')
      prettyPrintCellArray(intersects);
      size(intersects)
      fprintf('\nBranchings:\n')
      size(branchings)
      prettyPrintCellArray(branchings);
      error('Intersection and branchings not equal...')
    end
  case 2
    fprintf('\nMatrix:\n')
    G
    fprintf('\nRoots:\n')
    roots
    fprintf('\nM1:\n')
    size(M1)
    fprintf('\nBranchings:\n')
    size(branchings)
  case 3
    M2 = calculateM2BruteForce(G, k);

    M1 = mapEdgeNumbersToLetters(M1, mapping);
    M2 = mapEdgeNumbersToLetters(M2, mapping);
    branchings = mapEdgeNumbersToLetters(branchings, mapping);
    intersects = cellArrayIntersection(M1, M2);

    fprintf('\nMatrix:\n')
    G
    fprintf('\nRoots:\n')
    roots
    fprintf('\nM1:\n')
    prettyPrintCellArray(M1);
    size(M1)
    fprintf('\nM2:\n')
    prettyPrintCellArray(M2);
    size(M2)
    fprintf('\nIntersection:\n')
    prettyPrintCellArray(intersects);
    size(intersects)
    fprintf('\nBranchings:\n')
    size(branchings)
    prettyPrintCellArray(branchings);
    fprintf('\nEqual: %d\n', isCellArrayEqual(intersects, branchings))
  case 5
    M2 = calculateM2BruteForce(G, k);

    M1 = mapEdgeNumbersToLetters(M1, mapping);
    M2 = mapEdgeNumbersToLetters(M2, mapping);
    branchings = mapEdgeNumbersToLetters(branchings, mapping);
    intersects = cellArrayIntersection(M1, M2);

    fprintf('\nMatrix:\n')
    G
    fprintf('\nRoots:\n')
    roots
    fprintf('\nM1:\n')
    prettyPrintCellArray(M1);
    fprintf('\nM2:\n')
    prettyPrintCellArray(M2);
    fprintf('\nIntersection:\n')
    prettyPrintCellArray(intersects);
    fprintf('\nBranchings:\n')
    prettyPrintCellArray(branchings);
    fprintf('\nEqual: %d\n', isCellArrayEqual(intersects, branchings))
  otherwise
    M2 = calculateM2BruteForce(G, k);
    intersects = cellArrayIntersection(M1, M2);

    fprintf('\nMatrix:\n')
    G
    fprintf('\nRoots:\n')
    roots
    fprintf('\nM1:\n')
    size(M1)
    fprintf('\nM2:\n')
    size(M2)
    fprintf('\nIntersection:\n')
    size(intersects)
    fprintf('\nBranchings:\n')
    size(branchings)
    fprintf('\nEqual: %d\n', isCellArrayEqual(intersects, branchings))
  end
end

% Cell Array of n edges: ---------------------------------------------------------------------------
% this function takes in a number n, and produces {1}, {2}, ... {n}
function cellArray = CellArrayOfNEdges(n)
  cellArray = {};
  counter = 1;
  for i = 1:n
    cellArray{counter} = i;
    counter = counter + 1;
  end
end

% Cell Array Intersection: -------------------------------------------------------------------------
% this function returns the result of intersecting cell arrays
function intersects = cellArrayIntersection(A, B)
  % given two cell arrays A and B of J1 and J2's, return the intersection between the two of them
  % very simple: turn A and B into just matrices, and just intersect them

  intersects = {};
  if ~(size(A, 1) == 0  || size(B, 1) == 0)
    matrixA = [];
    for i = 1:size(A, 2)  
      % go through every edgeset and add the sorted row
      edgeset = A{i};
      row = zeros(1, size(edgeset, 2));
      for j = 1:size(row, 2)
        row(j) = edgeset{j};
      end
      row = sort(row);
      matrixA = [matrixA; row];
    end

    matrixB = [];
    for i = 1:size(B, 2)  
      % go through every edgeset and add the sorted row
      edgeset = B{i};
      row = zeros(1, size(edgeset, 2));
      for j = 1:size(row, 2)
        row(j) = edgeset{j};
      end
      row = sort(row);
      matrixB = [matrixB; row];
    end

    % before intersecting them, do a test so that the number of columns are the same
    if size(matrixA, 2) == size(matrixB, 2)
      intersectsMatrix = intersect(matrixA, matrixB, 'rows');

      % now we transform intersects back into a cell array
      intersects = {};
      counter = 1;
      for i = 1:size(intersectsMatrix, 1)
        row = {};
        rowCounter = 1;
        for j = 1:size(intersectsMatrix, 2)
          row{rowCounter} = char(intersectsMatrix(i, j));
          rowCounter = rowCounter + 1;
        end
        intersects{counter} = row;
        counter = counter + 1;
      end
    end
  end
end

% Adjacency to incidence matrix: -------------------------------------------------------------------
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

% M1 Calculation: ----------------------------------------------------------------------------------
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


% G2rref calculation: ------------------------------------------------------------------------------
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

% M2 Calculation: ----------------------------------------------------------------------------------
% this function takes a graph G and k partitions, and produces M2 through brute force
function [M2] = calculateM2BruteForce(G, k)
  % G is fed in as an n x n adjacency matrix
  numEdges = numberOfEdges(G);
  allEdges = CellArrayOfNEdges(numEdges);

  % transforms adjancency matrix G to an incidence matrix A
  [A, transformedG] = adjacencyToIncidenceMatrix(G);

  M2 = {};
  M2Counter = 1;

  % Step 3: Create a cell array of all the edges, and then choose numEdges of them 
  n = length(G);
  numEdges = (n - k) * k;
  % while numEdges > 0

  % size of allNumEdgesets = E choose (n - k) * k -- e.g.: n = 6, k = 3, E = 20, we get 20 choose 9 = ~170k
  allNumEdgesets = nchoosek(allEdges, numEdges);
  for i = 1:size(allNumEdgesets, 1)
    edgeset = allNumEdgesets(i,:);
    if isEdgesetKForestPartitionable(A, edgeset, k) == 1
      M2{M2Counter} = edgeset;
      M2Counter = M2Counter + 1;
    end
  end

    % if M2Counter == 1
    %   % ie there's no added edgeset
    %   numEdges = numEdges - 1;
    % else
    %   break;
    % end
  % end
end

% this function takes in an edgeset and sees if it is k forest-partitionable
function edgeSetPartitionable = isEdgesetKForestPartitionable(A, edgeset, k)
  % strategy:
  % Generate all k-partitions of the set using all the edges
  % Step 1: let's get the number of nodes, and generate the k-partitions for it

  % assume it's not partitionable
  edgeSetPartitionable = 0;

  % we only check if it's partitionable if it has more edges than k
  if size(edgeset, 2) >= k
    kPartitions = SetPartition(edgeset, k);

    % Step 2: For each group in kPartitions, check if each partition of the group is a forest
    % if it is a forest, add it to the basis, M2
    for i = 1:size(kPartitions, 1)
      group = kPartitions{i};
      isGroupMadeUpOfForests = 1;
      % then, go through each partition in the group, and remove each column that's not in the partition
      for j = 1:size(group, 2)
        partition = group{j};
        aRemoveEdgesFromPartition = removeNonPartitionEdges(A, partition);
        if isForest(aRemoveEdgesFromPartition) == 0
          % if it's not a forest, then set isGroupMadeOfForests to false, and break
          isGroupMadeUpOfForests = 0;
          break;
        end
      end

      if isGroupMadeUpOfForests == 1
        % if it is a forest, then break, and say it's partitionable
        edgeSetPartitionable = 1;
        break;
      end
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

% removes all non partition edges by looping from 1 to n, and then making the whole column 0's
% if it doesn't belong in the partition set
function edgesRemoved = removeNonPartitionEdges(A, partition)
  % strategy: transform the edge cell to a 1 x n matrix and then go through that matrix 
  partitionEdges = zeros(1, size(A, 2));
  for i = 1:size(partition, 2)
    partitionEdges(1, partition{i}) = 1;
  end

  edgesRemoved = [];

  for i = 1:size(partitionEdges, 2)
    % loop over it all, if it's a 1 (ie in partition), then append the entire column to the matrix
    if partitionEdges(i) == 1
      % append the column to the end of edges removed (should work since in order)
      edgesRemoved = [edgesRemoved A(:,i)];
    end
  end
end


% Set Partition ------------------------------------------------------------------------------------
function list = SetPartition(n, k)
% Purpose: Set partitioning
% LIST = SetPartition(N)
%   N is an integer
%   Return the cell list of all partitions of the integer set {1:N}.
%   Output LIST is the cell of size (B x 1), where B is Bell number B(n),
%   the number of ways of partitionning. Each list{j} is a partition of the
%   set {1:N}.
%
% LIST = SetPartition(N, K)
%   N and K are integers. Specify the fixed size K of the partitions.
%   Return the cell list of all partitions of the integer set {1:N} in K
%   non-empty subsets.
%   Output LIST is the cell of size (S x 1), where S Stirling number of the
%   second kind S(n,k). Each list{j} is a partition of {1:N} having 
%   exactly K non-empty subsets.
%   LIST is large for N large (of course) and K ~ N/2
%
% User can provide a set with elements different than {1:N} by substitute
% the first input argument (N) with SetElements
%       >> LIST = SetPartition(SetElements, ...)
% where SetElements is an array or cell array of N elements.
%
% USAGE EXAMPLE 1:
%
%     % Find all the length-2 partitions of {1,2,3,4} 
%     p=SetPartition(4,2);
%     % Display
%     fprintf('All the length-2 partitions of {1,2,3,4} are:\n') 
%     for i=1:size(p,1)
%         fprintf('\t')
%         for j=1:length(p{i})
%             s = sprintf('%d,', p{i}{j});
%             s(end)=[];
%             s = sprintf('{%s}', s);
%             if j<length(p{i})
%                 s = sprintf('%s + ', s);
%             end
%             fprintf('%s', s)
%         end
%         fprintf('\n')
%     end
%
% EXAMPLE 2:
%     p=SetPartition({'mouse' 'dog' 'cat'});
%
% Notes:
%   - The result has the same class as N.
%   - The result size growth very steep with respect to N. It advisable to
%     call PARTITION with N <= 11.
%   - Recursive algorithm in a general case (i.e. when only N is provided)
%     Iteration (derecursive loops) when K is specified.
%
% See also Bell, Stirling2nd, nchoosek, ndgrid, perms, DispPartObj,
%          partitions, partdisp (Matt Fig's FEX File ID: #24185)
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History
%   Original: 16-May-2009
%   17-May-2009: No more sorting + derecurse when K is provided
%   18-May-2009: Fix the bug for N=0, minor improvements
%   23-May-2003: Possibility to partition generic set elements
%   02-Jun-2009: comments change

if iscell(n) || ~isscalar(n) % NOTE: isscalar({1}) is TRUE
    % Generic set elements
    elements = reshape(n,1,[]);
    n = size(elements,2); % double
    if nargin>=2 % cast n to the same class of k
        n = feval(class(k), n);
    end
else
    % standard set
    elements = (1:n);
end

n = round(n);

if n<0
    error('Partition requires n>=0: n=%d', n);
end

if nargin<2
    if n==0
        list = {{zeros(0,1)}};
    else
        list = partall(n, elements);
    end
else
    k = round(k);
    % Cast k to the same class of n
    k = feval(class(n), k);
    if k>n
        error('SetPartition requires k<=n: k=%d, n=%d', k, n);
    elseif k<0
        error('SetPartition requires k>=0: k=%d', k);
    elseif k==0
        if n>0
            list = {};
        else %if n==0
            list = {{}};
        end
    else
        list = partk(n, k, elements);
    end
end
end % SetPartition


function list = partall(n, elements)
% LIST = PARTALL(N)
%   Return the cell list of all partitions of the integer set {1:n}
%   Output LIST is the cell of size (b x 1), where b is Bell number Bn.
%   Each list{j} is a partition of {1:n}

if n==1
    list = {{elements(n)}};
else
    % Allocate
    bn = Bell(n);
    list = cell(bn, 1);
    
    pos = 0;    
    % recursive call
    lp = partall(n-1, elements);
    for i=1:size(lp,1)
        part_i = insert(lp{i}, n, 1, elements);
        list(pos+(1:size(part_i,1))) = part_i;
        pos = pos + size(part_i,1);
    end
end

end % partall


function list = partk(n, k, elements)
% LIST = PARTK(N, K)
%   Return the cell list of all partitions of the integer set {1:n} in k
%   non-empty subsets.
%   Output LIST is the cell of size (s x 1), where s Stirling number of the
%   second kind S(n,k). Each list{j} is a partition of {1:n} having 
%   exactly K non-empty subsets.

m = n-k+1;

% L is a temporary buffer, L(kappa) stores partition for nu-elements
% nu will be defined later (see line #162)
L = cell(m,1);

% Initialize single partition
for j=1:m
    L{j} = {{elements(1:j)}};
end

% Compute the array of Stirling numbers
[trash S] = Stirling2nd(n, k);
        
% Derecursive loops
for kappa=2:k
    L{1} = {num2cell(elements(1:kappa))};
    for j=2:m
        nu = j + kappa - 1;
        
        % Allocate
        list = cell(S(nu,kappa), 1);
        
        pos = 0;
        lp = L{j};
        for i=1:size(lp,1)
            % augmented insertion
            part_i = insert(lp{i}, nu, 2, elements);
            list(pos+(1:size(part_i,1))) = part_i;
            pos = pos + size(part_i,1);
        end
        
        lp = L{j-1};
        for i=1:size(lp,1)
            % same-size insertion
            part_i = insert(lp{i}, nu, 0, elements);
            list(pos+(1:size(part_i,1))) = part_i;
            pos = pos + size(part_i,1);
        end
        
        % Assign the result
        L{j} = list;
    end % j-loop
end % kappa-loop

% Final result found in the last position of the buffer
list = L{m};

end % partk

% Create a new list of partions from one partition of {1,2,...n-1} and {n}
function part_i = insert(part, n, flag, elements)
% flag = 1, perform all possible insertions
%      = 0, insertion that keeps constant size only
%      = 2, insertion that increase by 1 the size only

l = size(part,2);

if flag == 0
    m = l;
elseif flag == 2
    m = 1;
else % flag == 1
    m = l+1;
end
en = elements(n);

% Allocate and pre-filled
part_i = cell(m,1);

if flag<=1
    [part_i{1:l}] = deal(part);
    % Insert N into each individual existing subset
    for j = 1:l
        part_i{j}{j} = [part_i{j}{j} en];
    end
end

% insert {N} as standalone subset
if flag>=1
    part_i{m} = [part {en}];
end

end % insert

function [S SA] = Stirling2nd(n, k)
% S = Stirling2nd(N,K)
% N and K are integers
% Compute the Stirling's number of the second kind.
% It is the number of all possible partitions of the set {1:N}, where each
% (partition) has exactly K non-empty subsets.
%
% [S SA] = Stirling2nd(N,K) return a (N x K) array of all Stirling's
% numbers of the second kind of S(i,j) with i<=N, j<=min(K,i).
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History
%   Original: 17-May-2009
%   Last update: 18-May-2009, cosmetic changes

k=double(k);
n=double(n);
if k==0
    if n==0
        S = 1;
    else
        S = 0;
    end
    SA = zeros(n,0);
    return
end
SA = nan(n,k);
SA(:,1) = 1;
SA(sub2ind(size(SA),1:k,1:k)) = 1;
for i=2:n
    %for j=max(2,(i+k)-n):min(i-1,k) % ... % recursive path
    for j=2:min(i-1,k)
        SA(i,j) = SA(i-1,j-1) + j*SA(i-1,j);
    end
end
S = SA(n,k);

end

% find leading one columns: ------------------------------------------------------------------------

% finds the leading ones of a rref matrix
function columns = findLeadingOneColumns(Arref)
  % generate the matrix of size 1 x n
  % then, for each leading one, set it to high
  columns = zeros(1, size(Arref, 2));

  % so what we do is find the first one in the row (by going right until we get it)
  % then go down and repeat
  columnIndex = 1;
  for i = 1:size(Arref, 2)
    % iterate over all rows
    while columnIndex <= size(Arref, 2)
      currentRow = Arref(i,:);
      if currentRow(columnIndex) == 1
        % move onto next row, ie break, and add current column
        columns(columnIndex) = 1;
        break;
      end
      columnIndex = columnIndex + 1; % go to next column
    end
  end
end

% IsCellArrayEqual: --------------------------------------------------------------------------------
% this function takes in two cell arrays and sees if they're equal
% simply use cellArrayIntersection
function isEqual = isCellArrayEqual(A, B)
  % if the intersection is the same size as A and B, then they're equal
  isEqual = size(A, 1) == size(B, 1) && size(A, 2) == size(B, 2);
end


% mapEdgeNumbersToLetters: -------------------------------------------------------------------------
% this is a helper function that takes in a group of cell arrays of edge numbers
% and returns its letters given a map M
function setOfEdgeLettersSets = mapEdgeNumbersToLetters(setOfEdgeSets, M)
  function edgeLetters = mapSingleEdgesetToLetters(edgeset)
    edgeLetters = {};
    count = 1;

    for i = 1:size(edgeset, 2)
      edgeLetters{count} = M(edgeset{i});
      count = count + 1;
    end
  end

  setOfEdgeLettersSets = {};
  counter = 1;

  for i = 1:size(setOfEdgeSets, 2)
    setOfEdgeLettersSets{counter} = mapSingleEdgesetToLetters(setOfEdgeSets{i});
    counter = counter + 1;
  end
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

% this function produces the number of roots through the matrix of roots
function [numRoots] = numberOfRoots(roots)
  numRoots = 0;
  for i = 1:size(roots, 2)
    if roots(i) == 1
      numRoots = numRoots + 1;
    end
  end
end

% pretty prints a cell array
function prettyPrintCellArray(p)
  for i=1:size(p,2)
    % print each cell array itself
    fprintf('\t{ ')
    for j=1:length(p{i})
      fprintf('%s ', p{i}{j})
    end
    fprintf('}\n')
  end
end

% this calculates the branching systems based off of M1, where it just removes
% all edge sets in M1 that have lone roots
function branchings = branchingSystems(G, roots)
  M1 = calculateM1(G, roots);

  branchings = {};
  branchingsCounter = 1;

  % go through all of M1, and only adding the ones
  % that don't have lone roots
  n = length(G);
  numRoots = numberOfRoots(roots);

  for i = 1:size(M1, 2)
    currentSet = M1{i};
    G_copy = G;
    counter = 1;

    % loop over the entire matrix, and for each 1 we encounter
    % we increase the counter, and if it's not what we want, we turn it
    % to a zero
    for j = 1:size(G, 2)
      for k = 1:size(G, 2)
        if G(j, k) == 1
          % check if the counter is what we want, if not, then we eliminate it from the copy
          G_copy(j, k) = doesCellArrayIncludeElement(currentSet, counter);
          % increment the counter
          counter = counter + 1;
        end
      end
    end
 

    % then, we check each of the roots' rows and see if it connects to anything
    hasNoLoneRoot = 1;

    for j = 1:size(roots, 2)
      if roots(j) == 1
        % if it is a root, check that row
        isLoneRoot = 1;
        for k = 1:size(G_copy, 2)
          if G_copy(j, k) == 1
            isLoneRoot = 0;
            break;
          end
        end

        if isLoneRoot == 1
          hasNoLoneRoot = 0;
          break;
        end
      end
    end

    % apply J2's process
    [A, transformedG] = adjacencyToIncidenceMatrix(G);
    if size(currentSet, 2) == (n - numRoots) * numRoots && isEdgesetKForestPartitionable(A, currentSet, numRoots) == 1
      branchings{branchingsCounter} = currentSet;
      branchingsCounter = branchingsCounter + 1;
    end
  end
end

function cellArrayIncludes = doesCellArrayIncludeElement(cellArray, element)
  cellArrayIncludes = 0;
  for i = 1:size(cellArray, 2)
    if cellArray{i} == element
      cellArrayIncludes = 1;
      break;
    end
  end
end
