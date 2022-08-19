% this function takes in a number n, and produces {1}, {2}, ... {n}
function cellArray = CellArrayOfNEdges(n)
  cellArray = {};
  counter = 1;
  for i = 1:n
    cellArray{counter} = i;
    counter = counter + 1;
  end
end