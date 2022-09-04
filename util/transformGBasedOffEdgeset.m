% this function takes in a matrix G (based off of mode) and an edgeset to remove all edges from G that are not in the edgeset
function newG = transformGBasedOffEdgeset(G, edgeset, mode)
  % edgeset is a 1 x |E| matrix, where a 1 indicates it includes that edge, 0 indicates it doesn't
  if mode == 0
    % adjacency matrix
    % iterate through the edges, and only keep the ones that are 1's in the edgeset
    edgeCount = 0;
    for i = 1:size(G, 1)
      for j = 1:size(G, 2)
        if G(i, j) == 1
          edgeCount = edgeCount + 1;
          if edgeset(edgeCount) == 0
            % if it exists in the adjacency but not the edgeset, remove it
            G(i, j) = 0;
          end
        end
      end
    end
    newG = G;
  else
    % incidence matrix
    % iterate through the columns, and only keep the ones that are 1's
    newG = [];
    for i = 1:size(edgeset, 2)
      if edgeset(i) == 1
        newG = [newG G(:,i)];
      end
    end
  end
end
