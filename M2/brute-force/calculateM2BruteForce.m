% this function takes a graph G and k partitions, and produces M2 through brute force
function [M2] = calculateM2BruteForce(G, k)
  % G is fed in as an n x n adjacency matrix

  % strategy:
  % Generate all k-partitions of the set using all the edges
  % Step 1: let's get the number of nodes, and generate the k-partitions for it
  numEdges = numberOfEdges(G);
  kPartitions = SetPartition(numEdges, k);

  M2 = {};
  M2Counter = 1;

  % transforms adjancency matrix G to an incidence matrix A
  [A, transformedG] = adjacencyToIncidenceMatrix(G);

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
      % if it is a forest, then break
      break;
    end
  end

  % Step 3: If M2 is empty (ie M2Counter is 1), then recurse on the edgeset removing an edge
  M2 = kPartitions;
end

% evaluates whether or not incidence matrix A is a forest
function forestBool = isForest(A)
  % first, calculate the g2rref
  [Arref, M, N, rank] = g2rref(A);

  % todo: check if this actually tells if it's a forest or not...
  % now, get all the leading ones, and check the non-leading ones columns (after the last leading one)
  % and see if it's all 0's. if it's not all zeroes, then it's not a forest

  % assume it's a forest first
  forestBool = 1;

  columns = findLeadingOneColumns(Arref);
  lastLeadingOneIndex = 0;
  for i = 1:size(columns, 2)
    if columns(1, i) == 1
      lastLeadingOneIndex = i;
    end
  end

  Arref
  columns
  lastLeadingOneIndex

  for i = (lastLeadingOneIndex + 1):size(columns, 2)
    % now, check if it's all zeroes in jth column
    for j = 1:size(Arref, 1) 
      if Arref(j, i) ~= 0
        forestBool = 0;
        break;
      end
    end

    if forestBool == 0
      break;
    end
  end
end

% removes all non partition edges by looping from 1 to n, and then making the whole column 0's
% if it doesn't belong in the partition set
function edgesRemoved = removeNonPartitionEdges(A, partition)
  % strategy: transform the edge cell to a 1 x n matrix and then go through that matrix 
  partitionEdges = zeros(1, size(A, 2));
  for i = 1:size(partition, 2)
    partitionEdges(1, partition(i)) = 1;
  end

  edgesRemoved = A;
  for i = 1:size(partitionEdges, 2)
    % loop over it all, if it's a 0 (ie not in partition), then remove the entire column (ie just set all to 0)
    if partitionEdges(i) == 0
      % remove the entire ith column
      for j = 1:size(A, 1)
        edgesRemoved(j, i) = 0;
      end
    end
  end
end
