% four node example:
% represent it by a 4 x 4 matrix, it goes r, s1, s2, s3
% we're using 1's to indicate it, and the row represents beginning of edge
% so, if G[0][2] = 1, then that means r -> s2 with some weight.
% number the edges in order, ie we go from the r row -> s3 row, from r column to s3 column
% in our case, c = [6; -3; 1; 2; -1]

G = [0 1 0 1; 0 0 1 0; 0 0 0 1; 0 1 0 0];
roots = [1 0 1 0]; % r and s2 are the roots
[M2, Arref] = calculateM2(G);
