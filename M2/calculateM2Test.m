% four node example:
% represent it by a 4 x 4 matrix, it goes r, s1, s2, s3
% we're using 1's to indicate it, and the row represents beginning of edge
% so, if G[0][2] = 1, then that means r -> s2 with some weight.
% number the edges in order, ie we go from the r row -> s3 row, from r column to s3 column
% in our case, c = [6; -3; 1; 2; -1]

G = [0 1 0 1; 0 0 1 0; 0 0 0 1; 0 1 0 0];
roots = [1 0 1 0]; % r and s2 are the roots
[M2, Arref, indiceMatrix, transformedA] = calculateM2(G);

% five node example:
% represent it using a 5 x 5 matrix, it goes r, s1, s2, ..., s4
G2 = [0 1 1 1 1; 0 0 0 1 1; 0 1 0 0 0; 0 0 1 0 1; 0 0 0 0 0];
roots2 = [1 0 0 1 0];
[M2_two, Arref2, indiceMatrix2, transformedA2] = calculateM2(G2);

% extra five node example
G3 = [0 1 1 1 1; 0 0 0 1 1; 0 1 0 0 1; 0 0 1 0 1; 0 1 1 0 0];
[M2_three, Arref3, indiceMatrix3, transformedA3] = calculateM2(G3);

% three node examples:
G4 = [0 1 1; 0 0 1; 0 0 0];
[M2_four, Arref4, indiceMatrix4, transformedA4] = calculateM2(G4);

% four node example, pg.11 of cocreate, M2 has different basis
G5 = [0 1 1 0; 0 0 1 1; 0 0 0 1; 0 1 1 0];
[M2_five, Arref5, indiceMatrix5, transformedA5] = calculateM2(G5);
