%% three node example:
% Edge numbering to letters: A = 1, B = 2, C = 3
% nodes to letters: 1 = r, 2 = s1, 3 = s2
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 0];
mapping = containers.Map({1, 2, 3}, {'A', 'C', 'B'});
optimalBranchingSystems(G, roots, mapping);

%% three node, 2 roots:
% Edge numbering to letters: A = 1, B = 2, C = 3
% nodes to letters: 1 = r1, 2 = t, 3 = r2
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 1];
mapping = containers.Map({1, 2, 3}, {'A', 'C', 'B'});
optimalBranchingSystems(G, roots, mapping);

%% four nodes, 1 root:
% Edge numbering to letters: E = 1, C = 2, A = 3, D = 4, B = 5
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 0];
mapping = containers.Map({1, 2, 3, 4, 5}, {'E', 'C', 'A', 'D', 'B'});
optimalBranchingSystems(G, roots, mapping);

%% four nodes, 2 roots:
% Edge numbering to letters: E = 1, C = 2, A = 3, D = 4, B = 5
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = r2
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 1];
mapping = containers.Map({1, 2, 3, 4, 5}, {'E', 'C', 'A', 'D', 'B'});
optimalBranchingSystems(G, roots, mapping);

%% single edge:
% 3 nodes, 1 root, 1 edge
G = [0 0 1; 0 0 0; 0 0 0];
roots = [1 1 0];
mapping = containers.Map({1}, {'A'});
optimalBranchingSystems(G, roots, mapping);

%% five nodes, 2 roots:
% Edge numbering to letters: A = 1, H = 2, E = 3, D = 4, I = 5, B = 6, C = 7
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G = [0 1 1 1 0; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 0; 0 1 1 0 0];
roots = [1 0 0 0 1];
mapping = containers.Map({1, 2, 3, 4, 5, 6, 7}, {'A', 'H', 'E', 'D', 'I', 'B', 'C'});
optimalBranchingSystems(G, roots, mapping);

%% four node multigraph:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, B = 5, E = 6
% order of rows: r1, r2, s1, s2
G = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 1 1 0];
roots = [1 1 0 0];
mapping = containers.Map({1, 2, 3, 4, 5, 6}, {'A', 'C', 'F', 'D', 'B', 'E'});
optimalBranchingSystems(G, roots, mapping);

%% four node multigraph version 2:
% edge numbering to letters: A = 1, C = 2, F = 3, D = 4, E = 5
% order of rows: r1, r2, s1, s2
G = [0 0 1 0; 0 0 1 1; 0 0 0 1; 0 0 1 0];
roots = [1 1 0 0];
mapping = containers.Map({1, 2, 3, 4, 5}, {'A', 'C', 'F', 'D', 'E'});
optimalBranchingSystems(G, roots, mapping);

%% five nodes, 2 roots, 9 edges:
% Edge numbering to letters: A = 1, H = 2, E = 3, F = 4, D = 5, I = 6, G = 7, B = 8, C = 9
% nodes to letters: 1 = r1, 2 = s1, 3 = s2, 4 = s3, 5 = r2
G = [0 1 1 1 1; 0 0 0 0 0; 0 0 0 1 0; 0 1 0 0 1; 0 1 1 0 0];
roots = [1 0 0 0 1];
mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'D', 'I', 'G', 'B', 'C'});
optimalBranchingSystems(G, roots, mapping);

%% five node, K3,3 minor:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 0 1 0; 0 0 0 1 1; 0 0 1 0 1; 0 0 1 1 0];
roots = [1 1 0 0 0];
mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8}, {'A', 'B', 'D', 'H', 'C', 'E', 'G', 'F'});
optimalBranchingSystems(G, roots, mapping);

%% five node, fish:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
roots = [1 1 0 0 0];
mapping = containers.Map({1, 2, 3, 4, 5}, {'D', 'E', 'A', 'B', 'C'});
optimalBranchingSystems(G, roots, mapping);

%% five node, fish v2:
% nodes to letters: 1 = r1, 2 = r2, 3 = s1, 4 = s2, 5 = s3
G = [0 0 1 0 0; 0 0 1 0 1; 0 0 0 1 0; 0 0 0 0 1; 0 0 0 1 0];
roots = [1 1 0 0 0];
mapping = containers.Map({1, 2, 4, 5, 6, 3}, {'D', 'E', 'A', 'B', 'C', 'F'});
optimalBranchingSystems(G, roots, mapping);

%% five node, 9 edges v2:
% nodes to letters: 1 = r1, 2 = s1, 3 = r2, 4 = s2, 5 = s3
G = [0 1 0 1 1; 0 0 0 1 0; 0 1 0 1 1; 0 0 0 0 1; 0 1 0 0 0];
roots = [1 0 1 0 0];
mapping = containers.Map({1, 2, 3, 4, 5, 6, 7, 8, 9}, {'A', 'H', 'E', 'F', 'B', 'C', 'G', 'D', 'I'});
optimalBranchingSystems(G, roots, mapping);
