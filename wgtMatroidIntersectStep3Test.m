result = 1;
% test example:
[C1 C2] = wgtMatroidIntersectStep2(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
% [A1, A2, S, T] = wgtMatroidIntersectStep3(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);

% result = isequal(A1, {}) && isequal(A2, {}) && isequal(S, [0 1 1]) && isequal(T, [1 1 1]) && result;

[C1 C2] = wgtMatroidIntersectStep2(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
[A1, A2, S, T] = wgtMatroidIntersectStep3(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);
