% this function here takes in a graph G, specified root nodes r
% and transforms the result from calculateM1(G, roots) to a csv file
% of a matrix representing the result
function result = exportM1ToCsv(G, roots, txtFile)
  % use calculateM1 first
  M1 = calculateM1(G, roots);

  % for each set in M1, transform it to a matrix (use G as the base)
  for i = 1:size(M1, 2)
    currentSet = M1{i};
    G_copy = G;
    counter = 1;

    % loop over the entire matrix, and for each 1 we encounter
    % we increase the counter, and if it's not what we want, we turn it
    % to a zero
    for j = 1:size(G, 2)
      for k = 1:size(G, 2)
        if G(j, k) == 1
          % check if the counter is what we want, if not, then we eliminate it from the copy
          G_copy(j, k) = doesCellArrayIncludeElement(currentSet, counter);
          % increment the counter
          counter = counter + 1;
        end
      end
    end
    
    outfile = sprintf('%s%d.txt', txtFile, i);
    writematrix(G_copy, outfile);
  end
  result = 1;
end

function cellArrayIncludes = doesCellArrayIncludeElement(cellArray, element)
  cellArrayIncludes = 0;
  for i = 1:size(cellArray, 2)
    if cellArray{i} == element
      cellArrayIncludes = 1;
      break;
    end
  end
end
