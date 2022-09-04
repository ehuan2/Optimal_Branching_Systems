% this function generates a random incidence matrix with E edges
% avoiding going into any roots (roots is always the a number of 1's followed by 0's, so we just pass in the number)
function incidence = randomIncidenceMatrix(E, n, roots)
  incidence = zeros(n, E);

  for i = 1:E
    % choose a random node to enter
    enterNode = randi([(roots + 1) n], 1, 1);
    incidence(enterNode, i) = 1;
    % choose a random node to leave
    exitNode = randi([1 n], 1, 1);
    if exitNode == enterNode
      exitNode = exitNode - 1; % subtract one away 
    end
    incidence(exitNode, i) = -1;
  end
end