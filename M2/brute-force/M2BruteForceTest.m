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
%% 3 nodes, 1 roots -- should have three as a solution ({1, 2}, {1, 3}, {2, 3})
G = [0 1 1; 0 0 1; 0 0 0];
M2 = calculateM2BruteForce(G, 1);
three_node_mapping = containers.Map({1, 2, 3}, {'A', 'C', 'B'});
M2 = mapEdgeNumbersToLetters(M2, three_node_mapping);
fprintf('\n three nodes, 1 root:\n')
prettyPrintCellArray(M2);

%% 3 nodes, 2 roots -- should have all as a solution ({1, 2, 3})
M2_two_roots = calculateM2BruteForce(G, 2);
M2_two_roots = mapEdgeNumbersToLetters(M2_two_roots, three_node_mapping);
fprintf('\n three nodes, 2 root:\n')
prettyPrintCellArray(M2_two_roots);

%% four nodes, 1 root
% 1 = r1, 2 = s1, 3 = s2, 4 = s3
G_four_nodes = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
four_node_mapping = containers.Map({1, 2, 3, 4, 5}, {'E', 'C', 'A', 'D', 'B'});
M2_four_nodes_1_root = calculateM2BruteForce(G_four_nodes, 1);
M2_four_nodes_1_root = mapEdgeNumbersToLetters(M2_four_nodes_1_root, four_node_mapping);
fprintf('\n four nodes, 1 root:\n')
prettyPrintCellArray(M2_four_nodes_1_root);
M2_four_nodes_2_roots = calculateM2BruteForce(G_four_nodes, 2);
M2_four_nodes_2_roots = mapEdgeNumbersToLetters(M2_four_nodes_2_roots, four_node_mapping);
fprintf('\n four nodes, 2 root:\n')
prettyPrintCellArray(M2_four_nodes_2_roots);

%% single edge:
% 3 nodes, 1 root, 1 edge
G = [0 0 1; 0 0 0; 0 0 0];
M2 = calculateM2BruteForce(G, 1);
mapping = containers.Map({1}, {'A'});
M2 = mapEdgeNumbersToLetters(M2, mapping);
fprintf('\n single edge case:\n')
prettyPrintCellArray(M2);

%% five nodes, 2 roots:
% Edge numbering to letters: A = 1, H = 2, E = 3, D = 4, I = 5, B = 6, C = 7
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G_five_nodes = [0 1 1 1 0; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 0; 0 1 1 0 0];
M2_five_nodes_2_roots = calculateM2BruteForce(G_five_nodes, 2);
mapping = containers.Map({1, 2, 3, 4, 5, 6, 7}, {'A', 'H', 'E', 'D', 'I', 'B', 'C'});
M2_five_nodes_2_roots = mapEdgeNumbersToLetters(M2_five_nodes_2_roots, mapping);
fprintf('\nfive node 2 roots seven edges:\n')
prettyPrintCellArray(M2_five_nodes_2_roots)

%% four node multigraph:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, B = 5, E = 6
G_four_nodes_multigraph = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 1 1 0];
M2 = calculateM2BruteForce(G_four_nodes_multigraph, 2);
mapping = containers.Map({1, 2, 3, 4, 5, 6}, {'A', 'C', 'F', 'D', 'B', 'E'});
M2 = mapEdgeNumbersToLetters(M2, mapping);
fprintf('\nFour node multigraph:\n')
prettyPrintCellArray(M2);

%% four node multigraph version 2:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, E = 5
G = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 0 1 0];
mapping = containers.Map({1, 2, 3, 4, 5}, {'A', 'C', 'F', 'D', 'E'});
M2 = calculateM2BruteForce(G, 2);
M2 = mapEdgeNumbersToLetters(M2, mapping);
fprintf('\nfour node multigraph v2 J2:\n')
prettyPrintCellArray(M2);

%% five nodes, 2 roots, 9 edges:
% Edge numbering to letters: A = 1, H = 2, E = 3, F = 4, D = 5, I = 6, G = 7, B = 8, C = 9
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G = [0 1 1 1 1; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 1; 0 1 1 0 0];
M2_five_nodes_2_roots_nine_edges = calculateM2BruteForce(G, 2);
five_node_2_roots_nine_edges_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'D', 'I', 'G', 'B', 'C'});
M2_five_nodes_2_roots_nine_edges = mapEdgeNumbersToLetters(M2_five_nodes_2_roots_nine_edges, five_node_2_roots_nine_edges_mapping);
fprintf('M2:\n')
prettyPrintCellArray(M2_five_nodes_2_roots_nine_edges);

%% five node, K3,3 minor:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 0 1 0; 0 0 0 1 1; 0 0 1 0 1; 0 0 1 1 0];
five_node_k33_minor_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8}, {'A', 'B', 'D', 'H', 'C', 'E', 'G', 'F'});
M2_five_nodes_k33 = calculateM2BruteForce(G, 2);
M2_five_nodes_k33 = mapEdgeNumbersToLetters(M2_five_nodes_k33, five_node_k33_minor_mapping);
fprintf('\n Five nodes, K3-3:\n')
prettyPrintCellArray(M2_five_nodes_k33);

%% five node, fish:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
five_node_fish_mapping = containers.Map({1, 2, 3, 4, 5}, {'D', 'E', 'A', 'B', 'C'});
M2_five_nodes_fish = calculateM2BruteForce(G, 2);
M2_five_nodes_fish = mapEdgeNumbersToLetters(M2_five_nodes_fish, five_node_fish_mapping);
fprintf('\n Five nodes, Fish:\n')
prettyPrintCellArray(M2_five_nodes_fish);

%% five node, fish v2:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 1; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
five_node_fish_mapping_v2 = containers.Map({1, 2, 4, 5, 6, 3}, {'D', 'E', 'A', 'B', 'C', 'F'});
M2_five_nodes_fish_v2 = calculateM2BruteForce(G, 2);
M2_five_nodes_fish_v2 = mapEdgeNumbersToLetters(M2_five_nodes_fish_v2, five_node_fish_mapping_v2);
fprintf('\n Five nodes, Fish v2:\n')
prettyPrintCellArray(M2_five_nodes_fish_v2);

%% five node, 9 edges v2:
% nodes to letters: 1 = r1, 2 = s1, 3 = r2, 4 = s2, 5 = s3
G = [0 1 0 1 1; 0 0 0 1 0; 0 1 0 1 1; 0 0 0 0 1; 0 1 0 0 0];
five_node_nine_edges_v2_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'B', 'C', 'G', 'D', 'I'});
M2_five_nodes_nine_edges_v2 = calculateM2BruteForce(G, 2);
M2_five_nodes_nine_edges_v2 = mapEdgeNumbersToLetters(M2_five_nodes_nine_edges_v2, five_node_nine_edges_v2_mapping);
fprintf('\n Five nodes, nine edges v2:\n')
prettyPrintCellArray(M2_five_nodes_nine_edges_v2);
