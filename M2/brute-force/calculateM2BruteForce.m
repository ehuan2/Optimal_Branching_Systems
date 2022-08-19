% this function takes a graph G and k partitions, and produces M2 through brute force
function [M2] = calculateM2BruteForce(G, k)
  % G is fed in as an n x n adjacency matrix
  numEdges = numberOfEdges(G);
  allEdges = CellArrayOfNEdges(numEdges);

  % transforms adjancency matrix G to an incidence matrix A
  [A, transformedG] = adjacencyToIncidenceMatrix(G);

  M2 = {};
  M2Counter = 1;

  % this function takes in an edgeset and sees if it is k forest-partitionable
  function edgeSetPartitionable = isEdgesetKForestPartitionable(edgeset)
    % strategy:
    % Generate all k-partitions of the set using all the edges
    % Step 1: let's get the number of nodes, and generate the k-partitions for it
    kPartitions = SetPartition(edgeset, k);

    % assume it's not partitionable
    edgeSetPartitionable = 0;

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

  % Step 3: Create a cell array of all the edges, and then choose numEdges of them 
  while numEdges > 0
    allNumEdgesets = nchoosek(allEdges, numEdges);
    for i = 1:size(allNumEdgesets, 1)
      edgeset = allNumEdgesets(i,:);
      if isEdgesetKForestPartitionable(edgeset) == 1
        M2{M2Counter} = edgeset;
        M2Counter = M2Counter + 1;
      end
    end

    if M2Counter == 1
      % ie there's no added edgeset
      numEdges = numEdges - 1;
    else
      break;
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
