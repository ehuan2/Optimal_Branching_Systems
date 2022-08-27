% pretty prints a cell array
function prettyPrintCellArray(p)
  for i=1:size(p,2)
    % print each cell array itself
    fprintf('\t{ ')
    for j=1:length(p{i})
      fprintf('%d ', p{i}{j})
    end
    fprintf('}\n')
  end
end
