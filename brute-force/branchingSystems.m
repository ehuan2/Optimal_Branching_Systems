% this calculates the branching systems based off of M1, where it just removes
% all edge sets in M1 that have lone roots
function branchings = branchingSystems(G, roots)
  M1 = calculateM1(G, roots);

  branchings = {};
  branchingsCounter = 1;

  % go through all of M1, and only adding the ones
  % that don't have lone roots

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

    if hasNoLoneRoot == 1
      % if it is not a lone root, add in the branching
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
