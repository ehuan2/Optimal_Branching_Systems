% this function brute forces every single permutation of nxn adjacency matrix
function hasError = randomBruteForce(n)
  clc();
  tic;

  hasError = 0;
  oneToN = 1:n*n;

  for i = 1:(n*n)
    sets = nchoosek(oneToN, i);

    for j = 1:size(sets, 1)
      % iterate over every set
      set = sets(j,:);

      matrix = zeros(n, n);
      for k = 1:size(set, 2)
        entry = set(1, k);
        column = mod(entry, n);
        if column == 0
          column = n;
        end
        matrix(floor((entry - 1)/n) + 1, column) = 1;
      end

      % iterate over every possible number of roots (symmetric)
      roots = zeros(1, n);
      for k = 1:n
        % now we let the kth index be 1 (adds onto previous)
        roots(k) = 1;
        hasError = testingG(matrix, roots, 1);
      end
    end
  end
  toc;
end
