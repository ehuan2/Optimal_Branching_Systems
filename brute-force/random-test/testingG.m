% this function tests a given graph G and roots, and a given mode
% mode = 1: tests everything, including intersection
% mode = 2: only tests the branchingSystems
% mode = 3: tests everything, and shows it
% mode = else: tests everything, only shows size
function hasError = testingG(G, roots, mode)
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
