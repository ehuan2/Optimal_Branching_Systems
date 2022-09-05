function partition = matroidPartitioning(E, setOfFis, k)
  % take in a set of k Fi's
  % and generate the matroids to intersect on

  % first, let's generate the ground set X
  % let's represent a pair (x, i), where x is an edge by doing the following:
  % the row represents a certain edge x
  % the column represents the number i

  % going to simply do a rearrangement of the edges when necessary
  partition = matroidIntersection(E * k, M1Wrapper(setOfFis, k), M2Wrapper(k));
  partition = reorganizeVector(partition, k);
end

function toReturn = M1Wrapper(setOfFis, k)
  function isInM1 = M1(edgeset)
    % reorganize edgeset into a E x k matrix
    matrix = reorganizeVector(edgeset, k);

    isInM1 = 1; % assume it is, until it isn't
    % only independent if for each i = 1 ... k
    % Yi, i.e. the column, is a member of Fi
    for i = 1:size(setOfFis, 2)
      column = matrix(:,i);
      Fi = setOfFis{i};
      if Fi(column) == 0
        isInM1 = 0;
        break;
      end
    end
  end
  toReturn = @(edgeset)M1(edgeset);
end

function toReturn = M2Wrapper(k)
  function isInM2 = M2(edgeset)
    % all we want to do, is check that each
    % row only has at most one in it
    isInM2 = 1;
    matrix = reorganizeVector(edgeset, k);

    for i = 1:size(matrix, 1)
      % iterate over each row
      row = matrix(i,:);
      count = 0;
      for j = 1:size(row, 2)
        if row(j) == 1
          count = count + 1;
        end
        if count > 1
          isInM2 = 0;
          break;
        end
      end

      if isInM2 == 0
        break;
      end
    end
  end
  toReturn = @(edgeset)M2(edgeset);
end

function matrix = reorganizeVector(vector, k)
  % given a vector of 1 x (E * k) size,
  % reorganize it to a E x k matrix
  matrix = reshape(vector, k, [])';
end