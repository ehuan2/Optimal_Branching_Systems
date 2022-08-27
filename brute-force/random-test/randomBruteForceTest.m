addpath('brute-force/')
addpath('brute-force/random-test/')
addpath('M1/')
addpath('util/')
addpath('M2/')
addpath('M2/brute-force')
addpath('M2/brute-force/SetPartFolder/SetPartFolder')

%% all 2 node graphs
randomBruteForce(2)

%% all 3 node graphs
randomBruteForce(3)

%% all 4 node graphs
randomBruteForce(4)

%% 5 node complete graph, 2 roots
completeGraphCheck(5, 2);

%% 6 node complete graph, 4 roots
completeGraphCheck(6, 4);

%% 100 node complete graph, 98 roots
% WAYYY too big -- incidence matrix is literally 99^100
% completeGraphCheck(100, 98);

%% non-root complete 6 node graph, 4 roots
nonRootComplete(6, 4)

%% non-root complete 20 node graph, 18 roots
nonRootComplete(20, 18)

%% non-root complete 100 nodes, 99 roots
nonRootComplete(100, 99)

%% random 6 node example with 1 roots and 20 edges
randomGraph(6, 1, 20)

%% random 100 node, 40 roots, 100 edges
randomGraph(100, 40, 1600)

%% random 20 node example with 10 roots, 200 edges
randomGraph(20, 10, 200)
