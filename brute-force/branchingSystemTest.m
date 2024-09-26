% includes basically
addpath('M1/')

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

