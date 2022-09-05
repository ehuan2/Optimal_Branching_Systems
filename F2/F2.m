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
