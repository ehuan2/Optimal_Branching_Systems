% generates a graph with n nodes, k roots and E edges, and tests it
function hasError = randomGraph(n, k, E)
  clc();
  tic;

  hasError = 0;
  roots = zeros(n);

  for i = 1:k
    roots(i) = 1;
  end

  G = zeros(n, n);

  % now we generate a random permutation with E edges
  edgeset = randperm(n*n, E);
  for i = 1:E
    entry = edgeset(1, i);
    column = mod(entry, n);
    if column == 0
      column = n;
    end
    G(floor((entry - 1)/n) + 1, column) = 1;
  end

  hasError = testingG(G, roots, 4);
  toc;

end
