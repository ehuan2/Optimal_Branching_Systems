% finds the leading ones of a rref matrix
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

