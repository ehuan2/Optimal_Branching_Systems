function X = matroidIntersection(E, F1, F2)
  X = zeros(1, E);
  while 1
    [C1, C2] = wgtMatroidIntersectStep2(E, X, F1, F2);
    [A1, A2, S, T] = wgtMatroidIntersectStep3(E, X, F1, F2, C1, C2);
    G = zeros(E, E); % form a |E| x |E| matrix, iterate over the two Aibar's and add edges

    for i = 1:size(A1, 2)
      x = A1{i}(1);
      y = A1{i}(2);
      G(x, y) = 1;
    end

    for i = 1:size(A2, 2)
      y = A2{i}(1);
      x = A2{i}(2);
      G(y, x) = 1;
    end

    [R, backtrack] = bfs(S, G);
    [RIntersectTEmpty, nextPath] = wgtMatroidIntersectStep6(R, T, X, backtrack);

    if RIntersectTEmpty == 1
      % if it's empty i.e. no path, stop
      break;
    end

    X = nextPath;
  end
end
