import networkx as nx
import matroid.partition

def uptick():
      global tally
      tally += 1

def forestsPartition(G): 
  tally = 0
  def acyclic(edges):
      subgraph = G.edge_subgraph(graph_edges[_] for _ in edges)
      return nx.algorithms.tree.recognition.is_forest(subgraph)

  graph_edges = list(G.edges())
  partitions = matroid.partition.set_list(G.size(), acyclic)
  print(f"Tests: {tally}")
  print(f"\n{len(graph_edges)} edges, {len(partitions)} partitions:")
  for partition in list(partitions):
      print(f"   {[graph_edges[p] for p in partition]}")
