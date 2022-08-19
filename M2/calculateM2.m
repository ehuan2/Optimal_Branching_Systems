addpath('util/')
% this function takes a graph G (represented by a matrix) and produces M2 according to the Jack Edmonds lecture
function [M2, Arref, incidenceMatrix, transformedA] = calculateM2(G)
  % G is fed in as an n x n matrix

  % first we transform the adjacency matrix G to an incidenceMatrix
  [incidenceMatrix, transformedA] = adjacencyToIndiceMatrix(G);

  % recognize linearly independent columns
  % since we have the Arref, then each leading one indicates its column in G is linearly independent
  [Arref, M, N, rank] = g2rref(incidenceMatrix);

  leadingOnesMatrix = findLeadingOneColumns(Arref);
  M2 = leadingOnesMatrix;
end
