
% this function brute forces every single non-root complete
% by defining the roots as the first k as 1's, and the rest of the n - k's as 0s
% then, we have the first k rows' last n - k columns to all be 1's
% and then do the reverse identity matrix for the last (n - k) x (n - k)
function hasError = nonRootComplete(n, k)
  clc();
  tic;
  hasError = 0;

  roots = zeros(1, n);
  for i = 1:k
    roots(i) = 1;
  end

  G = zeros(n, n);

  % doing the first k rows
  for i = 1:k
    for j = (k+1):n
      G(i, j) = 1;
    end
  end

  % doing the last n - k rows
  for i = (k + 1):n
    for j = (k + 1):n
      if i ~= j
        G(i, j) = 1;
      end
    end
  end

  testingG(G, roots, 4);

  toc;
end