%% OBS Testing:

%% Adjancency: (Be sure to turn mode to 0 in OBS)
%% Three node example:
clc();
G = [0 1 1; 0 0 1; 0 0 0];
roots = [1 0 0];
c = [0 1 1];
disp(obs(G, roots, c));
c = [0 1 2]; % C is bigger, so {A, C} is the one
disp(obs(G, roots, c));
c = [0 2 1]; % B is bigger, so {A, B} is the one
disp(obs(G, roots, c));

%% Three node, 2 roots:
clc();
roots = [1 0 1];
c = [1 2 3];
disp(obs(G, roots, c));

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
disp(obs(G, roots, c));

disp('Four nodes 1 root v2:')
c = [3 2 1 0 2]; % should be A, E, B
disp(c)
disp(obs(G, roots, c));

disp('Four nodes 1 root v3:')
c = [3 2 0 9 4]; % should be A, C, D
disp(c)
disp(obs(G, roots, c));

%% Four nodes, 2 roots:
clc();
G = [0 1 1 0; 0 0 0 1; 0 1 0 0; 0 0 1 0];
roots = [1 0 0 1];
c = [3 102 0 -9 4];
disp('Four nodes 2 roots:')
disp(obs(G, roots, c));

%% Single edge
clc();
G = [0 0 1; 0 0 0; 0 0 0];
roots = [1 1 0];
c = [30];
disp('Single edge')
disp(obs(G, roots, c));

%% Incidence matrices: (be sure to add in mode = 1)
%% Three node example:
clc();
G = [-1 0 -1; 1 -1 0; 0 1 1];
roots = [1 0 0];
c = [0 1 1];
disp(obs(G, roots, c));
c = [0 1 2]; % C is bigger, so {A, C} is the one
disp(obs(G, roots, c));
c = [0 2 1]; % B is bigger, so {A, B} is the one
disp(obs(G, roots, c));

%% Three node, 2 roots:
clc();
roots = [1 0 1];
c = [1 2 3];
disp(obs(G, roots, c));

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
disp(obs(G, roots, c));

disp('Four nodes 1 root v2:')
c = [1 3 2 0 3]; % should be A, E, B
disp(c)
disp(obs(G, roots, c));

disp('Four nodes 1 root v3:')
c = [0 4 2 9 3]; % should be A, C, D
disp(c)
disp(obs(G, roots, c));

%% Four nodes, 2 roots:
clc();
G = [0 0 -1 0 -1; -1 0 0 1 1; 0 1 1 -1 0; 1 -1 0 0 0];
roots = [1 0 0 1];
c = [3 102 0 -9 4];
disp('Four nodes 2 roots:')
disp(obs(G, roots, c));

%% Single edge
clc();
G = [-1; 0; 1];
roots = [1 1 0];
c = [30];
disp('Single edge')
disp(obs(G, roots, c));

%% five node, 2 roots:
clc();
% node order: r1, s1, s2, s3, r2
G = [-1 0 0 0 -1 -1 0; 1 1 0 0 0 0 1; 0 0 1 -1 0 1 0; 0 0 0 1 1 0 -1; 0 -1 -1 0 0 0 0];
roots = [1 0 0 0 1];

c = [3 4 2 5 -2 4 2]; % goes from A, B, C, D, E, H, I

disp('Five node 2 roots:')
disp(obs(G, roots, c));

%% four node multigraph:
clc();
G = [-1 -1 0 0 0 0 0; 1 0 0 1 -1 1 0; 0 0 -1 0 1 -1 1; 0 1 1 -1 0 0 -1];
% node order is r1 s1 s2 r2
roots = [1 0 0 1];
c = [3 4 2 5 -2 4 2]; % goes from A, B, C, D, E, F, G

disp('Four node multigraph:')
disp(obs(G, roots, c));
% result: D, E, F, G - a correct branching system

%% 40 edges, 20 node example, with 5 roots
clc();
E = 80;
n = 20;
k = 18;
G = randomIncidenceMatrix(E, n, k);
roots = generateNRoots(n, k);
c = rand(1, E);

disp('Forty edges, 20 node example, 2 roots')
disp(obs(G, roots, c));

% this function generates a random incidence matrix with E edges
% avoiding going into any roots (roots is always the a number of 1's followed by 0's, so we just pass in the number)
function incidence = randomIncidenceMatrix(E, n, roots)
  incidence = zeros(n, E);

  for i = 1:E
    % choose a random node to enter
    enterNode = randi([(roots + 1) n], 1, 1);
    incidence(enterNode, i) = 1;
    % choose a random node to leave
    exitNode = randi([1 n], 1, 1);
    if exitNode == enterNode
      exitNode = exitNode - 1; % subtract one away 
    end
    incidence(exitNode, i) = -1;
  end
end

% this function generates a 1 x n matrix of E roots
function roots = generateNRoots(n, E)
  roots = zeros(1, n);
  for i = 1:E
    roots(i) = 1;
  end
end
