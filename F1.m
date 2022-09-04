% a function that returns a boolean as isInF1 to see if the edgeset G (represented as a matrix)
% is in F1
function isInF1 = F1(G, roots, mode)
  % default to true, and calculate k
  isInF1 = 1;
  k = numberOfRoots(roots);

  if mode == 0
    % adjancency
    for i = 1:size(G, 2)
      % iterate over all the columns and set isInF1 to false if:
      % 1) Any of the roots columns has a 1 in it
      % 2) Any of the non-roots columns has more than k (number of roots) one's in it
      column = G(:,i);
      if roots(i) == 1
        % if it's a root, check the column of it
        for j = 1:size(column, 1)
          if column(j) == 1
            isInF1 = 0;
            break;
          end
        end
      else
        count = 0;
        for j = 1:size(column, 1)
          if column(j) == 1
            count = count + 1;
          end
        end

        if count > k
          isInF1 = 0;
          break;
        end
      end
    end
  else
    % F1 incidence matrix
    % iterate over all the rows of an incidence matrix
    % as those are the ones that indicate the nodes
    % and checks for the same count as well as incoming to roots
    for i = 1:size(G, 1)
      % iterate over all the rows
      row = G(i,:);
      if roots(i) == 1
        % if it's a root, check the column of it
        for j = 1:size(row, 2)
          if row(j) == 1
            isInF1 = 0;
            break;
          end
        end
      else
        count = 0;
        for j = 1:size(row, 2)
          if row(j) == 1
            count = count + 1;
          end
        end

        if count > k
          isInF1 = 0;
          break;
        end
      end
    end
  end
end
