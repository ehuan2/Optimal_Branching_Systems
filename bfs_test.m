pass = 1;
[R, backtrack] = bfs([1 0], [0 1; 1 0]);
pass = isequal(R, [1 1]) & pass;
pass = isequal(backtrack, [0 1]) & pass;
[R, backtrack] = bfs([0 0], [0 1; 1 0]);
pass = isequal(R, [0 0]) & pass;
pass = isequal(backtrack, [-1 -1]) & pass;
[R, backtrack] = bfs([0 1 0 0 1], [0 1 0 0 0; 1 0 1 0 0; 0 1 0 0 0; 0 0 0 1 0; 0 0 0 0 0]);
pass = isequal(R, [1 1 1 0 1]) & pass;
pass = isequal(backtrack, [2 0 2 -1 0]) & pass;

[C1 C2] = wgtMatroidIntersectStep2(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
[A1, A2, S, T] = wgtMatroidIntersectStep3(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);

[m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(3, [4 -2 9], [0 0 0], S, T, A1, A2);

[R, backtrack] = bfs(Sbar, Gbar);

[C1 C2] = wgtMatroidIntersectStep2(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
[A1, A2, S, T] = wgtMatroidIntersectStep3(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);
[m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(3, [4 -2 9], [0 0 0], S, T, A1, A2);
[R, backtrack] = bfs(Sbar, Gbar);
