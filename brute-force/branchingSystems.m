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

% copied from calculateM2BruteForce.m -------------------------------------------------- 
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
