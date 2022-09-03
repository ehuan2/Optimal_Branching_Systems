%% includes
addpath('util/')

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


