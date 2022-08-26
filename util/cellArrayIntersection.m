% this function returns the result of intersecting cell arrays
function intersects = cellArrayIntersection(A, B)
  % given two cell arrays A and B of J1 and J2's, return the intersection between the two of them
  % very simple: turn A and B into just matrices, and just intersect them

  intersects = {};
  if ~(size(A, 1) == 0  || size(B, 1) == 0)
    matrixA = [];
    for i = 1:size(A, 2)  
      % go through every edgeset and add the sorted row
      edgeset = A{i};
      row = zeros(1, size(edgeset, 2));
      for j = 1:size(row, 2)
        row(j) = edgeset{j};
      end
      row = sort(row);
      matrixA = [matrixA; row];
    end

    matrixB = [];
    for i = 1:size(B, 2)  
      % go through every edgeset and add the sorted row
      edgeset = B{i};
      row = zeros(1, size(edgeset, 2));
      for j = 1:size(row, 2)
        row(j) = edgeset{j};
      end
      row = sort(row);
      matrixB = [matrixB; row];
    end

    % before intersecting them, do a test so that the number of columns are the same
    if size(matrixA, 2) == size(matrixB, 2)
      intersectsMatrix = intersect(matrixA, matrixB, 'rows');

      % now we transform intersects back into a cell array
      intersects = {};
      counter = 1;
      for i = 1:size(intersectsMatrix, 1)
        row = {};
        rowCounter = 1;
        for j = 1:size(intersectsMatrix, 2)
          row{rowCounter} = char(intersectsMatrix(i, j));
          rowCounter = rowCounter + 1;
        end
        intersects{counter} = row;
        counter = counter + 1;
      end
    end
  end
end
