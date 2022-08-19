% this function takes a matrix A and transforms it to an incidence matrix
function [incidenceMatrix, transformedA] = adjacencyToIncidenceMatrix(A)
  % given an incidence matrix A, with rows representing the starting edge position
  % calculate an incidence matrix, where we order the edges per row then column, that's |V(G)| x |E(G)| size
  
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
  incidenceMatrix = zeros(size(A, 2), counter - 1);
  for i = 1:size(A, 2)
    for j = 1:size(A, 2)
      row = transformedA(i,:);
      if row(j) ~= 0
        % we're setting the index matrix to 1 if it comes either in or out of it
        incidenceMatrix(i, row(j)) = 1;
        incidenceMatrix(j, row(j)) = 1;
      end
    end
  end
end
