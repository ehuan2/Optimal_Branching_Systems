result = 1;
% start with 2 nodes, Xk is null, F1 = {empty set}, F2 = {empty set, {1}, {2}}
% result: C1 = {C1(empty, 1), C1(empty, 2)} = {{1}, {2}}
% result: C2 = {C2(empty, 1), C2(empty, 2)} = {{}, {}}
[C1 C2] = wgtMatroidIntersectStep2(2, [0 0], {{}}, {{}, {1}, {2}});
result = isequal(C1, {{[0 0], 1, [1 0]}, {[0 0], 2, [0 1]}}) && isequal(C2, {{[0 0], 1, [0 0]}, {[0 0], 2, [0 0]}}) && result;

% result = isequal(wgtMatroidIntersectStep2(), []) && result;
% result = isequal(wgtMatroidIntersectStep2(), []) && result;

[C1 C2] = wgtMatroidIntersectStep2(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
result = isequal(C1, {{[0 0], 1, [1 0]}, {[0 0], 2, [0 1]}}) && isequal(C2, {{[0 0], 1, [0 0]}, {[0 0], 2, [0 0]}}) && result;