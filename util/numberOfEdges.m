% this function here takes in an adjancency matrix G and produces the number of edges
function [numEdges] = numberOfEdges(G)
  numEdges = 0;
  for i = 1:size(G, 2)
    for j = 1:size(G, 2)
      if G(i,j) ~= 0
        numEdges = numEdges + 1;
      end
    end
  end
end
