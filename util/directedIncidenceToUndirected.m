% this function takes in a directed incidence and turns it to an undirected one
function A = directedIncidenceToUndirected(G)
  for i = 1:size(G, 1)
    for j = 1:size(G, 2)
      if G(i, j) == -1
        G(i, j) = 1;
      end
    end
  end
  A = G;
end
