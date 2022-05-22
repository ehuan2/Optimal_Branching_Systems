pass = 1;
pass = isequal(bfs([1 0], [0 1; 1 0]), [1 1]) & pass;
pass = isequal(bfs([0 0], [0 1; 1 0]), [0 0]) & pass;
pass = isequal(bfs([0 1 0 0 1], [0 1 0 0 0; 1 0 1 0 0; 0 1 0 0 0; 0 0 0 1 0; 0 0 0 0 0]), [1 1 1 0 1]) & pass;