% four node example:
% represent it by a 4 x 4 matrix, it goes r, s1, s2, s3
% we're using 1's to indicate it, and the row represents beginning of edge
% so, if G[0][2] = 1, then that means r -> s2 with some weight.
% number the edges in order, ie we go from the r row -> s3 row, from r column to s3 column
% in our case, c = [6; -3; 1; 2; -1]

G = [0 1 0 1; 0 0 1 0; 0 0 0 1; 0 1 0 0];
roots = [1 0 1 0]; % r and s2 are the roots
M1 = calculateM1(G, roots);
% expected value:
% power set of {1, 2, 4, 5}, encoded with basis of {1, 2, 4, 5}

% five node example:
% represent it using a 5 x 5 matrix, it goes r, s1, s2, ..., s4
G2 = [0 1 1 1 1; 0 0 0 1 1; 0 1 0 0 0; 0 0 1 0 1; 0 0 0 0 0];
roots2 = [1 0 0 1 0];
M1_two = calculateM1(G2, roots2);
% expected value:
% basis of {1, 2, 4, 6, 7}, {1, 2, 4, 7, 8, 9}, {1, 2, 6, 7, 8, 9}

% extra five node example
G3 = [0 1 1 1 1; 0 0 0 1 1; 0 1 0 0 1; 0 0 1 0 1; 0 1 1 0 0];
roots3 = [1 0 0 1 0];
M1_three = calculateM1(G3, roots3);
% expected value:
% basis of size 4 choose 2 times 3 choose 2 times 3 choose 2, or 54
% should be all combos of subsets of 2 of {1, 7, 11} x {2, 9, 12} x {4, 6, 8, 10}

% three node examples:
G4 = [0 1 1; 0 0 1; 0 0 0];
roots4 = [1 0 0];
M1_four = calculateM1(G4, roots4);

roots5 = [1 0 1];
M1_five = calculateM1(G4, roots5);

% four node example, pg.11 of cocreate, M2 has different basis
G5 = [0 1 1 0; 0 0 1 1; 0 0 0 1; 0 1 1 0];
[M2_five, Arref5, indiceMatrix5, transformedA5] = calculateM2(G5);
