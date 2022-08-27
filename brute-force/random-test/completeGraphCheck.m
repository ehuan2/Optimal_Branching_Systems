% given n, checks for the complete graph error for all number of roots
% (complete graph without self cycles)
function hasError = completeGraphCheck(n, k)
  clc();
  tic;
  hasError = 0;

  G = zeros(n, n);
  for i = 1:n
    for j = 1:n
      if i ~= j
        G(i, j) = 1;
      end
    end
  end

  % iterate over every possible number of roots (symmetric)
  roots = zeros(1, n);
  
  for i = 1:k
    % now we let the ith index be 1 (adds onto previous)
    roots(i) = 1;
  end

  hasError = testingG(G, roots, 2);
  toc;
end
