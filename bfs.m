function R = bfs(S, G)
  % given two sets, S representing nodes (so a 1 x n matrix), and an edge matrix G
  % bfs(S, G) represents the vertices reachable from S in G

  % start with the set of reachable edges, R itself as the ones in S.
  R = S;

  % maintain a queue by having an index for its head and tail
  head = 1;
  tail = 1;
  queue = {}

  % go through S and add all the starting nodes to the queue
  for i = 1:size(S)
    if S(i) == 1
      queue{tail} = i;
      tail = tail + 1;
    end
  end


end

function queue