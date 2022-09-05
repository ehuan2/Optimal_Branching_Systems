%% includes
addpath('util/')
addpath('M2/')
addpath('M2/brute-force/SetPartFolder/SetPartFolder')
addpath('weightedMatroidIntersection/')
addpath('matroidPartitioning/')
addpath('F2/')

%% Testing matroid intersection:
clc();
G = [0 0 -1 0 -1; -1 0 0 1 1; 0 1 1 -1 0; 1 -1 0 0 0];
mode = 1;
roots = [1 0 0 0];
F1WithoutMode = @(edgeset) (F1(transformGBasedOffEdgeset(G, edgeset, mode), roots, mode));
F2WithoutMode = @(edgeset) F2(transformGBasedOffEdgeset(G, edgeset, mode), numberOfRoots(roots), mode);
disp(matroidIntersection(5, F1WithoutMode, F2WithoutMode));

%% matroid partitioning:
G = [0 1 0 1 1];
disp(matroidPartitioning(G, 0, 5));

%% F1 family testing: Adjancency
clc();
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 0];
disp('Three nodes, 1 root')
F1(G, roots, 0)
G = [0 1 1; 0 0 0; 0 0 0];
roots = [1 0 0];
disp('Three nodes, 1 root, but no third edge')
F1(G, roots, 0)
disp('Three nodes, 1 root, but incoming to root')
G = [0 1 1; 1 0 0; 0 0 0];
F1(G, roots, 0)
disp('Four nodes, 2 roots')
G = [0 1 1 0; 0 0 0 0; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 1];
F1(G, roots, 0)

%% F1 family testing: Incidence
clc();
disp('Incidence:')
G = [-1 0 -1; 1 -1 0; 0 1 1];
roots = [1 0 0];
disp('Three nodes, 1 root')
F1(G, roots, 1)
G = [-1 0; 1 -1; 0 1];
roots = [1 0 0];
disp('Three nodes, 1 root, but no third edge')
F1(G, roots, 1)
disp('Three nodes, 1 root, but incoming to root')
G = [-1 0 1; 1 -1 -1; 0 1 0];
F1(G, roots, 1)
disp('Four nodes, 2 roots')
G = [0 -1 0 -1; 0 0 1 1; 1 1 -1 0; -1 0 0 0];
roots = [1 0 0 1];
F1(G, roots, 1)

%% directed incidence to undirected testing
G = [0 -1 0 -1; 0 0 1 1; 1 1 -1 0; -1 0 0 0];
directedIncidenceToUndirected(G)

%% F2 testing: Adjancency
clc();
G = [0 1 1; 0 0 1; 0 0 0];
disp('Three nodes, 1 root')
F2(G, 1, 0)
G = [0 1 1; 0 0 0; 0 0 0];
disp('Three nodes, 1 root, but no third edge')
F2(G, 1, 0)
disp('Four nodes, 2 roots')
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
F2(G, 2, 0)
disp('Four nodes, 2 roots v2')
G = [0 1 1 0; 0 0 0 0; 0 1 0 0; 0 0 1 0];
F2(G, 2, 0)

%% F2 family testing: Incidence
clc();
disp('Incidence:')
G = [-1 0 -1; 1 -1 0; 0 1 1];
roots = [1 0 0];
disp('Three nodes, 1 root')
F2(G, 1, 1)
G = [-1 0; 1 -1; 0 1];
disp('Three nodes, 1 root, but no third edge')
F2(G, 1, 1)
disp('Four nodes, 2 roots')
G = [0 -1 0 1; 0 -1 0 -1; 0 0 1 1; 1 1 -1 0; -1 0 0 0];
F2(G, 2, 1)
disp('Four nodes, 2 roots, v2')
G = [0 -1 0 -1; 0 0 1 1; 1 1 -1 0; -1 0 0 0];
F2(G, 2, 1)

%% Testing transforming G
clc();
G = [0 1 0 1; 0 0 1 0; 1 1 0 1; 0 0 1 0];
edgeset = [1 0 1 1 0 1 0];
transformGBasedOffEdgeset(G, edgeset, 0)

G = [1 0 1 1 0 0 0; -1 1 -1 0 0 -1 1; 0 -1 0 -1 1 1 0; 0 0 0 0 -1 0 -1];
edgeset = [0 1 1 0 1 1 0];
transformGBasedOffEdgeset(G, edgeset, 1)

%% OBS Testing:

%% Adjancency: (Be sure to turn mode to 0 in OBS)
%% Three node example:
clc();
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 0];
c = [0 1 1];
disp(optimalBranchingSystems(G, roots, c));
c = [0 1 2]; % C is bigger, so {A, C} is the one
disp(optimalBranchingSystems(G, roots, c));
c = [0 2 1]; % B is bigger, so {A, B} is the one
disp(optimalBranchingSystems(G, roots, c));

%% Three node, 2 roots:
clc();
roots = [1 0 1];
c = [1 2 3];
disp(optimalBranchingSystems(G, roots, c));

%% Four nodes, 1 root: 
% Three branchings here
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 0];

% three branchings, every one matters except for A (which should be third)
% weights are [E C A D B]
clc();
disp('Four nodes 1 root v1:')
c = [2 3 0 1 1]; % should be E, C, A
disp(c)
disp(optimalBranchingSystems(G, roots, c));

disp('Four nodes 1 root v2:')
c = [3 2 1 0 2]; % should be A, E, B
disp(c)
disp(optimalBranchingSystems(G, roots, c));

disp('Four nodes 1 root v3:')
c = [3 2 0 9 4]; % should be A, C, D
disp(c)
disp(optimalBranchingSystems(G, roots, c));

%% Four nodes, 2 roots:
clc();
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 1];
c = [3 102 0 -9 4];
disp('Four nodes 2 roots:')
disp(optimalBranchingSystems(G, roots, c));

%% Single edge
clc();
G = [0 0 1; 0 0 0; 0 0 0];
roots = [1 1 0];
c = [30];
disp('Single edge')
disp(optimalBranchingSystems(G, roots, c));

%% Incidence matrices: (be sure to add in mode = 1)
%% Three node example:
clc();
G = [-1 0 -1; 1 -1 0; 0 1 1];
roots = [1 0 0];
c = [0 1 1];
disp(optimalBranchingSystems(G, roots, c));
c = [0 1 2]; % C is bigger, so {A, C} is the one
disp(optimalBranchingSystems(G, roots, c));
c = [0 2 1]; % B is bigger, so {A, B} is the one
disp(optimalBranchingSystems(G, roots, c));

%% Three node, 2 roots:
clc();
roots = [1 0 1];
c = [1 2 3];
disp(optimalBranchingSystems(G, roots, c));

%% Four nodes, 1 root: 
% Three branchings here
G = [0 0 -1 0 -1; -1 0 0 1 1; 0 1 1 -1 0; 1 -1 0 0 0];
roots = [1 0 0 0];

% three branchings, every one matters except for A (which should be third)
% weights are in order
clc();
disp('Four nodes 1 root v1:')
c = [0 1 3 1 2]; % should be A, C, E
disp(c)
disp(optimalBranchingSystems(G, roots, c));

disp('Four nodes 1 root v2:')
c = [1 3 2 0 3]; % should be A, E, B
disp(c)
disp(optimalBranchingSystems(G, roots, c));

disp('Four nodes 1 root v3:')
c = [0 4 2 9 3]; % should be A, C, D
disp(c)
disp(optimalBranchingSystems(G, roots, c));

%% Four nodes, 2 roots:
clc();
G = [0 0 -1 0 -1; -1 0 0 1 1; 0 1 1 -1 0; 1 -1 0 0 0];
roots = [1 0 0 1];
c = [3 102 0 -9 4];
disp('Four nodes 2 roots:')
disp(optimalBranchingSystems(G, roots, c));

%% Single edge
clc();
G = [-1; 0; 1];
roots = [1 1 0];
c = [30];
disp('Single edge')
disp(optimalBranchingSystems(G, roots, c));

%% five node, 2 roots:
clc();
% node order: r1, s1, s2, s3, r2
G = [-1 0 0 0 -1 -1 0; 1 1 0 0 0 0 1; 0 0 1 -1 0 1 0; 0 0 0 1 1 0 -1; 0 -1 -1 0 0 0 0];
roots = [1 0 0 0 1];

c = [3 4 2 5 -2 4 2]; % goes from A, B, C, D, E, H, I

disp('Five node 2 roots:')
disp(optimalBranchingSystems(G, roots, c));

%% four node multigraph:
clc();
G = [-1 -1 0 0 0 0 0; 1 0 0 1 -1 1 0; 0 0 -1 0 1 -1 1; 0 1 1 -1 0 0 -1];
% node order is r1 s1 s2 r2
roots = [1 0 0 1];
c = [3 4 2 5 -2 4 2]; % goes from A, B, C, D, E, F, G

disp('Four node multigraph:')
disp(optimalBranchingSystems(G, roots, c));
% result: D, E, F, G - a correct branching system

%% 40 edges, 20 node example, with 5 roots
clc();
E = 40;
n = 20;
k = 5;
G = randomIncidenceMatrix(E, n, k);
roots = generateNRoots(n, k);
c = rand(1, E);

disp('Forty edges, 20 node example, 5 roots')
disp(optimalBranchingSystems(G, roots, c));

