% this function takes a graph G (represented by a matrix) and produces M2 according to the Jack Edmonds lecture
function [M2, Arref] = calculateM2(G)
  % G is fed in as an n x n matrix

  % recognize linearly independent columns
  % since we have the Arref, then each leading one indicates its column in G is linearly independent
  [Arref, M, N, rank] = g2rref(G);

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
