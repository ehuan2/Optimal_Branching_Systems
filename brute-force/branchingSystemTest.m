% includes basically
addpath('M1/')
addpath('util/')

% three node example:
% Edge numbering to letters: A = 1, B = 2, C = 3
% nodes to letters: 1 = r, 2 = s1, 3 = s2
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 0];
M1_three_nodes_1_root = calculateM1(G, roots);
branchings_three_nodes_1_root = branchingSystems(G, roots);

% three node, 2 roots:
% Edge numbering to letters: A = 1, B = 2, C = 3
% nodes to letters: 1 = r1, 2 = t, 3 = r2
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 1];
M1_three_nodes_2_roots = calculateM1(G, roots);
branchings_three_nodes_2_roots = branchingSystems(G, roots);

% four nodes, 1 root:
% Edge numbering to letters: E = 1, C = 2, A = 3, D = 4, B = 5
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 0];
M1_four_nodes_1_root = calculateM1(G, roots);
branchings_four_nodes_1_root = branchingSystems(G, roots);

% four nodes, 2 roots:
% Edge numbering to letters: E = 1, C = 2, A = 3, D = 4, B = 5
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = r2
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 1];
M1_four_nodes_2_roots = calculateM1(G, roots);
branchings_four_nodes_2_roots = branchingSystems(G, roots);

% five nodes, 2 roots:
% Edge numbering to letters: A = 1, H = 2, E = 3, D = 4, I = 5, B = 6, C = 7
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G = [0 1 1 1 0; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 0; 0 1 1 0 0];
roots = [1 0 0 0 1];
M1_five_nodes_2_roots = calculateM1(G, roots);
branchings_five_nodes_2_roots = branchingSystems(G, roots);

% four node multigraph:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, B = 5, E = 6
% order of rows: r1, r2, s1, s2
G = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 1 1 0];
roots = [1 1 0 0];
M1_four_nodes_multigraph = calculateM1(G, roots);
branchings_four_nodes_multigraph = branchingSystems(G, roots);

% four node multigraph version 2:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, E = 5
% order of rows: r1, r2, s1, s2
G = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 0 1 0];
roots = [1 1 0 0];
M1_four_nodes_v2_multigraph = calculateM1(G, roots);
branchings_four_nodes_v2_multigraph = branchingSystems(G, roots);

% five nodes, 2 roots, 9 edges:
% Edge numbering to letters: A = 1, H = 2, E = 3, F = 4, D = 5, I = 6, G = 7, B = 8, C = 9
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G = [0 1 1 1 1; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 1; 0 1 1 0 0];
roots = [1 0 0 0 1];
M1_five_nodes_2_roots_nine_edges = calculateM1(G, roots);
branchings_five_nodes_2_roots_nine_edges = branchingSystems(G, roots);
five_node_2_roots_nine_edges_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'D', 'I', 'G', 'B', 'C'});
M1_five_nodes_2_roots_nine_edges = mapEdgeNumbersToLetters(M1_five_nodes_2_roots_nine_edges, five_node_2_roots_nine_edges_mapping);
branchings_five_nodes_2_roots_nine_edges = mapEdgeNumbersToLetters(branchings_five_nodes_2_roots_nine_edges, five_node_2_roots_nine_edges_mapping);

% five node, K3,3 minor:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 0 1 0; 0 0 0 1 1; 0 0 1 0 1; 0 0 1 1 0];
roots = [1 1 0 0 0];
five_node_k33_minor_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8}, {'A', 'B', 'D', 'H', 'C', 'E', 'G', 'F'});
M1_five_nodes_k33 = calculateM1(G, roots);
branchings_five_nodes_k33 = branchingSystems(G, roots);
M1_five_nodes_k33 = mapEdgeNumbersToLetters(M1_five_nodes_k33, five_node_k33_minor_mapping);
branchings_five_nodes_k33 = mapEdgeNumbersToLetters(branchings_five_nodes_k33, five_node_k33_minor_mapping);
fprintf('J1:\n')
prettyPrintCellArray(M1_five_nodes_k33);
fprintf('Branchings:\n')
prettyPrintCellArray(branchings_five_nodes_k33);

% five node, fish:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
roots = [1 1 0 0 0];
five_node_fish_mapping = containers.Map({1, 2, 3, 4, 5}, {'D', 'E', 'A', 'B', 'C'});
M1_five_nodes_fish = calculateM1(G, roots);
M1_five_nodes_fish = mapEdgeNumbersToLetters(M1_five_nodes_fish, five_node_fish_mapping);
fprintf('\n Five nodes, Fish J1:\n')
prettyPrintCellArray(M1_five_nodes_fish);
branchings_five_nodes_fish = branchingSystems(G, roots);
branchings_five_nodes_fish = mapEdgeNumbersToLetters(branchings_five_nodes_fish, five_node_fish_mapping);
fprintf('\n Five nodes, Fish Branchings:\n')
prettyPrintCellArray(branchings_five_nodes_fish);

% five node, fish v2:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 1; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
roots = [1 1 0 0 0];
five_node_fish_mapping_v2 = containers.Map({1, 2, 4, 5, 6, 3}, {'D', 'E', 'A', 'B', 'C', 'F'});
M1_five_nodes_fish_v2 = calculateM1(G, roots);
M1_five_nodes_fish_v2 = mapEdgeNumbersToLetters(M1_five_nodes_fish_v2, five_node_fish_mapping_v2);
fprintf('\n Five nodes, Fish Version 2 J1:\n')
prettyPrintCellArray(M1_five_nodes_fish_v2);
branchings_five_nodes_fish_v2 = branchingSystems(G, roots);
branchings_five_nodes_fish_v2 = mapEdgeNumbersToLetters(branchings_five_nodes_fish_v2, five_node_fish_mapping_v2);
fprintf('\n Five nodes, Fish Version 2 Branchings:\n')
prettyPrintCellArray(branchings_five_nodes_fish_v2);

% five node, 9 edges v2:
% nodes to letters: 1 = r1, 2 = s1, 3 = r2, 4 = s2, 5 = s3
G = [0 1 0 1 1; 0 0 0 1 0; 0 1 0 1 1; 0 0 0 0 1; 0 1 0 0 0];
roots = [1 0 1 0 0];
five_node_nine_edges_v2_mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'B', 'C', 'G', 'D', 'I'});
M1_five_nodes_nine_edges_v2 = calculateM1(G, roots);
M1_five_nodes_nine_edges_v2 = mapEdgeNumbersToLetters(M1_five_nodes_nine_edges_v2, five_node_nine_edges_v2_mapping);
fprintf('\n Five nodes, nine edges v2 J1:\n')
prettyPrintCellArray(M1_five_nodes_nine_edges_v2);
branchings_five_nodes_2_roots_nine_edges_v2 = branchingSystems(G, roots);
branchings_five_nodes_2_roots_nine_edges_v2 = mapEdgeNumbersToLetters(branchings_five_nodes_2_roots_nine_edges_v2, five_node_nine_edges_v2_mapping);
fprintf('\n Five nodes, nine edges Version 2 Branchings:\n')
prettyPrintCellArray(branchings_five_nodes_2_roots_nine_edges_v2);
