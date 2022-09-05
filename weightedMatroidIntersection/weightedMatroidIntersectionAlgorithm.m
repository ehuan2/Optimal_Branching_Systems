function X = weightedMatroidIntersectionAlgorithm(E, F1, F2, c)
  % param:
  % E is the base set, here is simply a number of its size
  % F1 and F2 are matrices that represent the independent subsets of E
    % believe it should be 1 if it represents that the edge belongs to the subset
  % c represents a weight from an edge in [E] to a real number, should be a 1 x |E| matrix
  % return:
  % set X (size E that contains a bit of 1 for each edge in the set) that's the intersection of F1 and F2 of max weight

  % step 1: initialize k, X0, c1 and c2

  k = 0;
  X0 = zeros(1, E); 

  % we want to be able to hold all the Xk's we have, but we'll use a cell array 
  % because matlab uses the 1 index as first however, setOfXk{k + 1} = Xk.
  setOfXk = {};
  setOfXk{1} = X0;

  c1 = c;
  c2 = zeros(1, E);

  goBackToStep2 = 1;
  goBackToStep4 = 1;

  while goBackToStep2 == 1
    fprintf('Testing k = %d', k);
    % step 2:
    [C1, C2] = wgtMatroidIntersectStep2(E, setOfXk{k + 1}, F1, F2);

    % step 3:
    [A1, A2, S, T] = wgtMatroidIntersectStep3(E, setOfXk{k + 1}, F1, F2, C1, C2);

    % step 4:
    while goBackToStep4 == 1
      [m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(E, c1, c2, S, T, A1, A2);

      % step 5:
      [R, backtrack] = bfs(Sbar, Gbar);

      % step 6: check if R intersect T is empty
      [RIntersectTBarEmpty, XkPlusOne] = wgtMatroidIntersectStep6(R, Tbar, setOfXk{k + 1}, backtrack);

      if RIntersectTBarEmpty == 0
        % set Xk+1 as Xk, add k = k + 1 and go back to 2.
        k = k + 1;
        setOfXk{k + 1} = XkPlusOne;
        break;
      end

      % step 7:
      epsilon = wgtMatroidIntersectStep7(c1, c2, A1, A2, R, m1, m2, S, T);
      
      % step 8:
      if epsilon == inf
        % choose the one with maximum weight amongst X0, X1 ... Xk, ie the sum of the weights in Xi

        maxWeight = -inf;

        for i = 1:size(setOfXk, 2)
          Xi = setOfXk{i};
          currentWgt = 0;

          for j = 1:size(Xi, 2)
            if Xi(j) == 1
              % add to the current weight
              currentWgt = currentWgt + c(j);
            end
          end

          if currentWgt > maxWeight
            % change what X is, as well as the max weight
            X = Xi;
            maxWeight = currentWgt;
          end
        end

        X = setOfXk;

        goBackToStep2 = 0;
        goBackToStep4 = 0;
        break;
      else
        % less than infinity, go back to step 4 after rewriting c1 and c2

        for x = 1:size(R, 2)
          if R(x) == 1
            c1(x) = c1(x) - epsilon;
            c2(x) = c2(x) + epsilon;
          end
        end
      end
    end
  end
end
