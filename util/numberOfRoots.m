% this function produces the number of roots through the matrix of roots
function [numRoots] = numberOfRoots(roots)
  numRoots = 0
  for i = 1:size(roots, 2)
    if roots(i) == 1
      numRoots = numRoots + 1
    end
  end
end