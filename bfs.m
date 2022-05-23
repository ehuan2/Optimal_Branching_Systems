function [R, backtrack] = bfs(S, G)
  % given two sets, S representing nodes (so a 1 x n matrix), and an edge matrix G, that's n x n
  % bfs(S, G) represents the vertices reachable from S in G
  % adding in a return vector of backtrack that represents its parent so we can find the smallest path (also 1 x |E|)

  % start with the set of reachable edges, R itself as the ones in S.
  R = S;

  % add to backtrack, we represent the unreachable by -1, and ones in S by 0.
  backtrack = zeros(size(S));
  for i = 1:size(S, 2)
    if S(i) == 1
      backtrack(i) = 0;
    else
      backtrack(i) = -1;
    end
  end

  % maintain a queue by having an index for its head and tail
  head = 1;
  tail = 1;
  queue = {};

  % go through S (ie search through how many columns there are and add all the starting nodes to the queue
  for i = 1:size(S, 2)
    if S(i) == 1
      queue{tail} = i;
      tail = tail + 1;
    end
  end


  % keep searching as long as queue is not empty, ie the head is not at the tail position
  while head ~= tail
    % then, we pop off the next node to search from, and all its neighbours that aren't reached yet
    next = queue{head};
    head = head + 1;

    neighboursRow = G(next,:);

    % iterate over the row of neighbours, and collect all the ones that aren't yet found
    for j = 1:size(neighboursRow, 2)
      if neighboursRow(j) == 1 && R(j) == 0
        % add to R, and add to queue
        R(j) = 1;
        queue{tail} = j;
        tail = tail + 1;

        % add to the backtrack now
        backtrack(j) = next;
      end
    end
  end
end
