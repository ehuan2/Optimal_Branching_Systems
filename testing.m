%% includes
addpath('util/')
addpath('M2/')
addpath('M2/brute-force/SetPartFolder/SetPartFolder')

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

