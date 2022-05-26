% performs step 4 of the weighted matroid intersection algorithm
function [m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(E, c1, c2, S, T, A1, A2)
  % params:
    % E is a num as the base set
    % c1 and c2 are 1 x |E| matrices
    % S and T are 1 x |E| matrices
    % A1 and A2 are cell array of [x y] pairs
  % return:
    % m1 and m2 are single numbers
    % Sbar and Tbar are again 1 x |E| matrices
    % A1 and A2 are also cell arrays again
    % G, instead of adding in vertex set (already know it), we just have the edge set as a |E| x |E| matrix
  
    % todo: how precise is matlab? doesn't floating numbers mean that there might be some error?

    % finding m1 and m2:
    m1 = calculateMi(c1, S);
    m2 = calculateMi(c2, T);

    % finding Sbar and Tbar:
    Sbar = calculateXbar(S, c1, m1);
    Tbar = calculateXbar(T, c2, m2);

    % finding A1bar and A2bar
    A1bar = calculateAiBar(A1, c1);
    A2bar = calculateAiBar(A2, c2);

    Gbar = zeros(E, E); % form a |E| x |E| matrix, iterate over the two Aibar's and add edges

    for i = 1:size(A1bar, 2)
      [x y] = A1bar(i);
      Gbar(x, y) = 1;
      Gbar(y, x) = 1;
    end

    for i = 1:size(A2bar, 2)
      y = A2bar{i}(1);
      x = A2bar{i}(2);
      Gbar(x, y) = 1;
      Gbar(y, x) = 1;
    end
end

function mi = calculateMi(ci, setX)
  mi = -inf; % given S is null, it'd be 0
  for y = 1:size(setX, 2)
    if setX(y) == 1
      next = ci(y);
      if next > mi
        mi = next;
      end
    end
  end
end

function xBar = calculateXbar(X, ci, mi)
  xBar = zeros(size(X));
  for y = 1:size(X, 2)
      if X(y) == 1
        if ci(y) == mi
            xBar(y) = 1;
        end
      end
  end
end

function AiBar = calculateAiBar(Ai, ci)
  AiBar = {};
  AiBarCounter = 1;

  for i = 1:size(Ai, 2)
    first = Ai{i}(1);
    second = Ai{i}(2);
    if ci(first) == ci(second)
      AiBar{AiBarCounter} = [first second];
      AiBarCounter = AiBarCounter + 1;
    end
  end
end
