result = 1;
% test example:
[C1 C2] = wgtMatroidIntersectStep2(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
[A1, A2, S, T] = wgtMatroidIntersectStep3(3, [0 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);

%[m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(3, [4 -2 9], [0 0 0], S, T, A1, A2);

%result = isequal(m1, 0) && isequal(m2, 0) && result;
%result = isequal(Sbar, [1 1 0]) && isequal(Tbar, [1 1 1]) && result;
%result = isequal(A1bar, [0 0 0]) && isequal(A2bar, [0 0 0]) && result;
%result = isequal(Gbar, [0 0 0; 0 0 0; 0 0 0]) && result;

[C1 C2] = wgtMatroidIntersectStep2(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}});
[A1, A2, S, T] = wgtMatroidIntersectStep3(3, [1 0 0], {{}, {1}, {2}, {1, 2}}, {{}, {1}, {2}, {3}}, C1, C2);
[m1, m2, Sbar, Tbar, A1bar, A2bar, Gbar] = wgtMatroidIntersectStep4(3, [4 -2 9], [0 0 0], S, T, A1, A2);
