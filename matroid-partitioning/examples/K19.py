#!/usr/bin/env python3
# import matplotlib.pyplot as plot
import networkx as nx
import matroid.partition

def uptick():
    global tally
    tally += 1

def acyclic(edges):
    uptick()
    subgraph = G.edge_subgraph(graph_edges[_] for _ in edges)
    return nx.algorithms.tree.recognition.is_forest(subgraph)

def run():
    G = nx.complete_graph(19)
    tally = 0
    graph_edges = list(G.edges())
    partitions = matroid.partition.set_list(G.size(), acyclic)

    print(f"Tests: {tally}")
    print(f"\n{len(graph_edges)} edges, {len(partitions)} partitions:")
    for partition in list(partitions):
        print(f"   {[graph_edges[p] for p in partition]}")

    # # Display colored graph.
    # def get_color(fraction):
    #     if fraction < 1/3:
    #         color = (1 - 3*fraction, 3*fraction, 0)
    #     elif fraction < 2/3:
    #         fraction -= 1/3
    #         color = (0, 1 - 3*fraction, 3*fraction)
    #     else:
    #         fraction -= 2/3
    #         color = (3*fraction, 0, 1 - 3*fraction)
    #     return color

    # edge_color_list = [None] * len(graph_edges)
    # for index, set in enumerate(partitions):
    #     for edge in list(set):
    #         edge_color_list[edge] = get_color(index / len(partitions))

    # nx.draw(G, with_labels=True, pos=nx.circular_layout(G), width=3,
    #         node_color='pink', edge_color=edge_color_list)
    # plot.show()
