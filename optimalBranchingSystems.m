% ** IMPORTANT CONVENTION **
% We'll be using the -1 to indicate an edge leaving a node
% and 1 to indicate an edge entering a node, for the incidence matrix
function OBS = optimalBranchingSystems(G, roots, c)
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
    OBS = setOfXk{size(setOfXk, 2)};
    k = numberOfRoots(roots);

    % if it's not the right size, don't add it in
    n = size(G, 1); % for both incidence and adjacency, both the number of rows

    if countOnes(OBS) ~= k * (n - k)
      OBS = 'no branching systems...';
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
