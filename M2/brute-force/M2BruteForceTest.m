addpath('M2/brute-force/SetPartFolder/SetPartFolder')
% set partition testing:
p = SetPartition({2, 3, 5, 7}, 3);
% partitions 6 different times! (should work!)

% the following results in an error. However, we know that if roots > edges
% we can of course partition it (each root can take an edge, as a forest)
% p2 = SetPartition({2, 3, 4}, 4);