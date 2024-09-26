% this function takes a graph G (represented by a matrix) and produces M2 according to the Jack Edmonds lecture
function [M2, Arref, indiceMatrix, transformedA] = calculateM2(G)
  % G is fed in as an n x n matrix

  % first we transform the adjacency matrix G to an indiceMatrix
  [indiceMatrix, transformedA] = adjacencyToIndiceMatrix(G);

  % recognize linearly independent columns
  % since we have the Arref, then each leading one indicates its column in G is linearly independent
  [Arref, M, N, rank] = g2rref(indiceMatrix);

  function columns = findLeadingOneColumns(Arref)
    % generate the matrix of size 1 x n
    % then, for each leading one, set it to high
    columns = zeros(1, size(Arref, 2));

    % so what we do is find the first one in the row (by going right until we get it)
    % then go down and repeat
    columnIndex = 1;
    for i = 1:size(Arref, 2)
      % iterate over all rows
      while columnIndex <= size(Arref, 2)
        currentRow = Arref(i,:);
        if currentRow(columnIndex) == 1
          % move onto next row, ie break, and add current column
          columns(columnIndex) = 1;
          break;
        end
        columnIndex = columnIndex + 1; % go to next column
      end
    end
  end

  leadingOnesMatrix = findLeadingOneColumns(Arref);
  M2 = leadingOnesMatrix;
end

function [indiceMatrix, transformedA] = adjacencyToIndiceMatrix(A)
  % given an indice matrix A, with rows representing the starting edge position
  % calculate an indice matrix, where we order the edges per row then column, that's |V(G)| x |E(G)| size
  
  % first count how many edges there are, and transform A at the same time
  transformedA = zeros(size(A));
  counter = 1;
  for i = 1:size(A, 2)
    for j = 1:size(A, 2)
      row = A(i,:);
      if row(j) == 1
        transformedA(i,j) = counter;
        counter = counter + 1;
      end
    end
  end

  % so now there are counter - 1 edges
  indiceMatrix = zeros(size(A, 2), counter - 1);
  for i = 1:size(A, 2)
    for j = 1:size(A, 2)
      row = transformedA(i,:);
      if row(j) ~= 0
        % we're setting the index matrix to 1 if it comes either in or out of it
        indiceMatrix(i, row(j)) = 1;
        indiceMatrix(j, row(j)) = 1;
      end
    end
  end
end
