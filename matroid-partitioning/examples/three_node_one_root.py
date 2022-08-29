import numpy as np
import networkx as nx
from matroid import forestsPartition

def run():
  A = np.array([[0, 1, 1], [0, 0, 1], [0, 0, 0]])
  G = nx.from_numpy_matrix(A, create_using=nx.MultiDiGraph)

  forestsPartition.forestsPartition(G)
