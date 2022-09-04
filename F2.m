function isInF2 = F2(G, numRoots, mode)
  if mode == 0
    numEdges = numberOfEdges(G);
  else
    numEdges = numberOfEdgesIncidence(G);
  end
  allEdges = CellArrayOfNEdges(numEdges);

  if mode == 0
    % F1: transform an adjacency to an incidence
    % then transform from an adjancency to incidence
    [A, transformedG] = adjacencyToIncidenceMatrix(G);
  else
    % F2: transform the incidence to a non-directed incidence
    % then transform the incidence directed to non-directed (i.e. flip all the -1's)
    A = directedIncidenceToUndirected(G);
  end

  % this function takes in an edgeset and sees if it is k forest-partitionable
  function edgeSetPartitionable = isEdgesetKForestPartitionable(edgeset, k)
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
    else 
      % if k > # of edges, obviously is k forest partitionable -- given that there are no self-loops!
      edgeSetPartitionable = 1;
    end
  end
  isInF2 = isEdgesetKForestPartitionable(allEdges, numRoots);
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
