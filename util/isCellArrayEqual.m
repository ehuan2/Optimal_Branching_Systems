% this function takes in two cell arrays and sees if they're equal
% simply use cellArrayIntersection
function isEqual = isCellArrayEqual(A, B)
  % if the intersection is the same size as A and B, then they're equal
  isEqual = size(A, 1) == size(B, 1) && size(A, 2) == size(B, 2);
end
