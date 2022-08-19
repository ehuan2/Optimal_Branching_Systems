addpath('M2/brute-force/SetPartFolder/SetPartFolder')
addpath('util/')
addpath('M2/')
% set partition testing:
p = SetPartition({2, 3, 5, 7}, 3);
% partitions 6 different times! (should work!)

% the following results in an error. However, we know that if roots > edges
% we can of course partition it (each root can take an e    dge, as a forest)
% p2 = SetPartition({2, 3, 4}, 4);

% Testing M2 Brute Force ---------------------------------------------------------------------------
% 3 nodes, 1 roots -- should have three as a solution ({1, 2}, {1, 3}, {2, 3})
G = [0 1 1; 0 0 1; 0 0 0];
M2 = calculateM2BruteForce(G, 1)

% 3 nodes, 2 roots -- should have all as a solution ({1, 2, 3})
M2_two_roots = calculateM2BruteForce(G, 2)

