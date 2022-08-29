#!/usr/bin/env python3
import networkx as nx

### Code by Ray Butterworth, August 2020.

#??# Comments marked with "#??#" indicate that further investigation is needed.

## Use: import matroid.partition.set_list
def set_list(size, allowed, partition_list=[], max=0,
        optimize_JIT=True,          # Build graph only as needed.
        optimize_trivial=True,      # Notice trivial 1-node augmenting path.
        optimize_fill=True,         # Add valid nodes to created partition.
        optimize_init=True):        # Estimate number of partitions needed.

    def partition_node(color_index):                  # Involution: f(f(x))==x.
        return -color_index - 1
        # color_index can be negative or positive.
        # Negative index is dummy color node.

    def color_it(node_index, color_index):              # Assign color to node.
        partition_list[color_index].add(node_index)
        partition_index_map[node_index] = color_index

    def get_uncolored_node_list(only_one=False): # List of unpartitioned nodes.
        uncolored_set = set(range(size))
        for partition in partition_list:
            uncolored_set -= partition
        if not only_one: return list(uncolored_set)

        return list(uncolored_set)[0] if len(uncolored_set) else None

    def init_partition(color_index):
        if optimize_fill:      # Add compatible unassigned nodes to this color.
            for node in get_uncolored_node_list():
                if (not max) or len(partition_list[color_index]) < max:
                    if allowed(partition_list[color_index].union({node})):
                        color_it(node, color_index)

    def create_partition():
        partition_list.append(set())
        color_index = len(partition_list)
        D.add_node(-color_index)               # Negative for dummy color node.
        init_partition(partition_node(-color_index))

    def remove_last_partition():
        partition_list.remove(partition_list[len(partition_list)-1])

    def augment():
        first_node = get_uncolored_node_list(only_one=True)   # Arbitrary node.
        if first_node == None:
            return False                ### Everything is partitioned.

        #2. ======== Add edges to digraph.
        # Optimized version moved to #3.
        if not optimize_JIT: # build entire graph, not only as needed.
            for index, partition in enumerate(partition_list):
                if (not max) or len(partition) < max:
                    for new_node in set(range(size)) - partition:
                        if allowed(partition.union({new_node})):
                            D.add_edge(new_node, -index - 1)    # Can be added.
                        for old in partition:
                            if allowed(partition.union({new_node}) - {old}):
                                D.add_edge(new_node,old) # New can replace old.

        #3. ======== Shortest path from any uncolored node to dummy color node.
        def find_path(start_node):
            back_link_map = {}
            todo_list = [start_node]
            for node in todo_list:
                # This loop moved from #2.
                if optimize_JIT: # Build parts of graph only as needed.
                    for color_index, partition in enumerate(partition_list):
                        if node not in partition:
                            if (not max) or len(partition) < max:
                                if allowed(partition.union({node})):
                                    D.add_edge(node,
                                            partition_node(color_index))
                                    if optimize_trivial:
                                        if node == start_node:  # Trivial path.
                                            return [start_node,
                                                partition_node(color_index)]
                            for old_node in partition:
                                if allowed(partition.union({node})-{old_node}):
                                    D.add_edge(node,old_node)    # Replace old.
                for adjacent in sorted(D[node]):
                    if not adjacent in back_link_map:
                        back_link_map[adjacent] = node
                        todo_list.append(adjacent)
                    if adjacent < 0:                      # A dummy color node.
                        result = []
                        while adjacent != start_node:
                            result = [adjacent] + result
                            adjacent = back_link_map[adjacent]
                        return [start_node] + result
            return []

        path = find_path(first_node)
        if len(path) == 0:    # No augmenting path: create new color partition.
            create_partition()
            return True     ### create_partition() added at least one new node.

        #4. ======== Shift colors on augmenting path.
        for index in range(1, len(path) - 1):
            color_to, color_from = path[index - 1], path[index]
            color_partition = partition_index_map[color_from]
            partition_list[color_partition].remove(color_from)
            partition_index_map.pop(color_from)
            color_it(color_to, color_partition)
        new_color = partition_node(path[len(path) - 1])
        new_node = path[len(path) - 2]
        color_it(new_node, new_color)
        return True                    ### Successful augmentation, try again.

########### Algorithm. ########################################################

    partition_index_map = {}                      # Maps nodes to their colors.

    D = nx.DiGraph()        # Directed graph in which we find augmenting paths.
    D.add_nodes_from(range(size))

    if len(partition_list) != 0:
        print(f"Starting with {len(partition_list)}"
            + f" initial partitions: {partition_list}")
        for color_index in range(1, 1+len(partition_list)):
            for node_index in partition_list[partition_node(-color_index)]:
                partition_index_map[node_index] = partition_node(-color_index)
            init_partition(partition_node(-color_index))
        optimize_init = False;

    if optimize_init:          # Start with allocating this many partititions.
        estimate = int((size + 1) / 2)          #??# Guaranteed to be too big.

        while len(partition_list) < estimate:
            create_partition()

    if optimize_fill: optimize_trivial = False  # "init" already handles this.
    print("Optimization:",
            "Trivial" if optimize_trivial else "",
            "Fill" if optimize_fill else "",
            "JIT" if optimize_JIT else "",
            f"Init({estimate})" if optimize_init else "",
            f"Max({max}))" if max != 0 else ""
        )

    while True:
        D = nx.create_empty_copy(D)                    # Remove existing edges.

        if not augment():
            while (len(partition_list[0]) == 0):
                partition_list.remove(partition_list[0])
                #??# Empty partitions could be removed elsewhere?

            if not optimize_init:
                # If called with an initialized partition list
                # and no additional partitions are added,
                # this solution will not necessarily be optimum.
                return partition_list

            if len(partition_list) > estimate:
                # Optimum solution.
                return partition_list

            remove_last_partition()
            remove_last_partition()
            #??# (Removing two partitions is an convenient arbitrary choice.
            #??#  This could be improved (e.g. perhaps max(2,10%)).)

            estimate = len(partition_list)
            # Loop again with a smaller estimate of the number of partitions.

    #??# "print" statements don't really belong in this section.
    #??# "tally" should be made available to caller.

########### Example test program. #############################################

if __name__ == "__main__":
    import matplotlib.pyplot as plot

    # Last one wins.
    G = nx.complete_graph(5)
    G = nx.complete_graph(19)
    G = nx.petersen_graph()

    initial = []

    max = 0

    def acyclic(edges):
        global tally
        tally += 1
        subgraph = G.edge_subgraph(graph_edges[_] for _ in edges)
        return nx.algorithms.tree.recognition.is_forest(subgraph)
        #??# is_forest() was convenient.
        #??# Being able to test "will the X plus the current subset still
        #??# be independent?" could be much faster.

    tally = 0
    graph_edges = list(G.edges())
    partitions = set_list(G.size(), acyclic, [], max=max)

    print(f"Tests: {tally}")
    print(f"\n{len(graph_edges)} edges, {len(partitions)} partitions:")
    for partition in list(partitions):
        print(f"   {[graph_edges[p] for p in partition]}")

    # Display colored graph.
    def get_color(fraction):
        if fraction < 1/3:
            color = (1 - 3*fraction, 3*fraction, 0)
        elif fraction < 2/3:
            fraction -= 1/3
            color = (0, 1 - 3*fraction, 3*fraction)
        else:
            fraction -= 2/3
            color = (3*fraction, 0, 1 - 3*fraction)
        return color

    edge_color_list = [None] * len(graph_edges)
    for index, set in enumerate(partitions):
        for edge in list(set):
            edge_color_list[edge] = get_color(index / len(partitions))

    nx.draw(G, with_labels=True, pos=nx.circular_layout(G), width=3,
            node_color='pink', edge_color=edge_color_list)
    plot.show()