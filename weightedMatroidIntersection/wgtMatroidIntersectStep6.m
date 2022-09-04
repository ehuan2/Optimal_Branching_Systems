% step 6: checks if R intersects with Tbar is empty
% and if so, returns a path of Xk delta V(P) where P is a path found from bfs
function [RIntersectTBarEmpty, XkPlusOne] = wgtMatroidIntersectStep6(R, Tbar, Xk, backtrack)
  % params:
    % R, a 1 x |E| matrix of reachable nodes
    % Tbar, a 1 x |E| matrix
    % Xk, a 1 x |E| matrix
    % backtrack a 1 x |E| matrix
  % return:
    % RIntersectTBarEmpty, a boolean that represents whether or not it's empty, true if empty
    % XkPlusOne a 1 x |E| matrix of the Xk delta V(P)

  RIntersectTBarEmpty = 1;
  XkPlusOne = zeros(size(R));

  % keep a collection of all reachable nodes in Tbar, so we can find each path
  RIntersectTBar = zeros(size(R));

  for i = 1:size(R, 2)
    if R(i) == 1 && Tbar(i) == 1
      RIntersectTBarEmpty = 0;
      RIntersectTBar(i) = 1;
    end
  end

  if RIntersectTBarEmpty == 0
    % if we do need to calculate the path, we do it, iterate over RIntersectTBar
    
    % hold these values to find the minimum path, at most it's all of the nodes
    minPathLength = inf;
    minVofP = zeros(size(R));

    for i = 1:size(RIntersectTBar, 2)
      if RIntersectTBar(i) == 1
        [curVofP, curPathLength] = calculateVofP(backtrack, i);

        if curPathLength < minPathLength
          minVofP = curVofP;
        end
      end
    end

    for i = 1:size(R, 2)
      % finds the disjunctive union, basically xor of the minVofP and Xk
      if Xk(i) ~= minVofP(i) && ((Xk(i) || minVofP(i)) == 1)
        XkPlusOne(i) = 1;
      end
    end
  end
end

function [VofP, pathLength] = calculateVofP(backtrack, TbarNode)
  % given a backtrack array, and the node in Tbar, calculate the nodes in V(P), and its pathLength

  current = TbarNode;
  pathLength = -1;
  VofP = zeros(size(backtrack));

  % should not get to -1, but just in case
  while current ~= 0 && current ~= -1
    VofP(current) = 1;
    current = backtrack(current);
    pathLength = pathLength + 1;
  end
end