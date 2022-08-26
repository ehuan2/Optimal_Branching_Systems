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
% moved to branchingSystemTest.m

%% five node, fish v2:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 1; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
five_node_fish_mapping_v2 = containers.Map({1, 2, 4, 5, 6, 3}, {'D', 'E', 'A', 'B', 'C', 'F'});
%% five node, 9 edges v2:
% nodes to letters: 1 = r1, 2 = s1, 3 = r2, 4 = s2, 5 = s3
G = [0 1 0 1 1; 0 0 0 1 0; 0 1 0 1 1; 0 0 0 0 1; 0 1 0 0 0];
five_node_nine_edges_v2_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'B', 'C', 'G', 'D', 'I'});
