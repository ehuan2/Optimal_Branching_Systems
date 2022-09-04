% this function generates a 1 x n matrix of E roots
function roots = generateNRoots(n, E)
  roots = zeros(1, n);
  for i = 1:E
    roots(i) = 1;
  end
end
