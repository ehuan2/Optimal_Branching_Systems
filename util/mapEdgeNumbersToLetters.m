% this is a helper function that takes in a group of cell arrays of edge numbers
% and returns its letters given a map M
function setOfEdgeLettersSets = mapEdgeNumbersToLetters(setOfEdgeSets, M)
  function edgeLetters = mapSingleEdgesetToLetters(edgeset)
    edgeLetters = {};
    count = 1;

    for i = 1:size(edgeset, 2)
      edgeLetters{count} = M(edgeset{i});
      count = count + 1;
    end
  end

  setOfEdgeLettersSets = {};
  counter = 1;

  for i = 1:size(setOfEdgeSets, 2)
    setOfEdgeLettersSets{counter} = mapSingleEdgesetToLetters(setOfEdgeSets{i});
    counter = counter + 1;
  end
end
