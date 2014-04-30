#!/usr/bin/env python

import sys
import os
import re
import pydot
from collections import defaultdict

verbose_flag = False
export_graphs = True

class ActivationSet:
    def __init__(self, id, size):
        self.id = id
        self.size = size
        self.size_to_map = size
        self.unused = size
        self.share_sets = None
        self.share_sets_reduced = None
        self.share_ids = None
        self.map_to = []
    def __str__(self):
        return "ActivationSet(id=%d,size=%d,share_ids=%s)"%(self.id,self.size,self.share_ids) #[set.id for set in self.share_sets])
    def __repr__(self):
        return "ActivationSet(id=%d)"%(self.id)
        
def parse():
    activationsets = dict()
    expr = re.compile(r"ActivationSet\(activation_function{(?P<id>\d+)},share_with\{(?P<share_ids>(?:\d+,)+)\},num_luts\{(?P<size>\d+)\}")
    
    lines = sys.stdin.readlines()
    for line in lines:
        m = expr.match(line)
        if m==None: continue
        id = int(m.group('id'))
        size = int(m.group('size'))
        activationsets[id] = ActivationSet(id, size)
    
    for line in lines:
        m = expr.match(line)
        if m==None: continue
        id = int(m.group('id'))
        share_ids = map(int, m.group('share_ids').rstrip(',').split(','))
        share_ids.sort()
        share_sets = set(activationsets[share_id] for share_id in share_ids)
        activationsets[id].share_sets = share_sets
        activationsets[id].share_ids = share_ids
        if verbose_flag:
            print activationsets[id]
    return set(activationsets.values())
    
def largest_unconnected_subset(activationsets):
    largest_notconnected_subset_size, largest_notconnected_subset = find_largest_notconnected_subset(activationsets)
    #print len(part), '#'
    #print map(str,part), '==>', 
    if verbose_flag:
        print map(str,largest_notconnected_subset), 'total size=', largest_notconnected_subset_size
    
    sum_all_activationset_size = sum(activationset.size for activationset in activationsets.values())
    print 'num nodes in all activationsets:', sum_all_activationset_size
    print 'max num nodes active at any time (except those not in an activationset):', sum_largest_notconnected_subset_size
    print 'num nodes saved:', sum_all_activationset_size-sum_largest_notconnected_subset_size
    return largest_notconnected_subset

def cluster_partition(activationsets, partition_ids=None):
    if partition_ids==None: partition_ids = [activationset.id for activationset in activationsets]
    if len(partition_ids)==0: return [activationsets]
    
    partition_id = partition_ids[0]
    connected = set()
    not_connected = set()
    for activationset in activationsets:
        if activationset.id == partition_id or partition_id in activationset.share_ids:
            connected.add(activationset)
        else:
            not_connected.add(activationset)
    partitioning = []
    if connected:
        partitioning += cluster_partition(connected, partition_ids[1:])
    if not_connected:
        partitioning += cluster_partition(not_connected, partition_ids[1:])
    return partitioning

def shareids_partition(activationsets):
    partitioning = defaultdict(list)
    for activationset in activationsets:
        partitioning[tuple(activationset.share_ids)].append(activationset)
    return partitioning.values()

def connected_to(activationset):
    old = {}
    new = {activationset}
    while new != old:
        old = set(new)
        new.update(*(connected.share_sets for connected in old))
    return new
    
def connected_partition(activationsets):
    activationsets = set(activationsets)
    partitioning = []
    while activationsets:
        activationset = next(iter(activationsets))
        part = connected_to(activationset)
        activationsets.difference_update(part)
        partitioning.append(part)
    return partitioning

def find_largest_notconnected_subset(activationsets, untested_sets=None):
    if untested_sets==None: 
        untested_sets = list(activationsets)
        untested_sets.sort(key=lambda set:len(set.share_sets))
    untested_sets = untested_sets[:]
    total_size = sum(activationset.size for activationset in activationsets)

    while True:
        if len(untested_sets)==0: return (total_size,activationsets)
        testset = untested_sets.pop()
        if testset not in activationsets: 
            continue
        part_with = activationsets.difference(testset.share_sets)
        part_without = activationsets.difference({testset})
        if len(part_with) == len(activationsets): 
            continue
        break
    max_with, part_with = find_largest_notconnected_subset(part_with, untested_sets)
    max_without, part_without = find_largest_notconnected_subset(part_without, untested_sets)
    if max_with>max_without:
        return (max_with, part_with)
    else:
        return (max_without, part_without)

    
def draw_activationsets(activationsets):
    global graph
    graph = pydot.Dot(graph_type='graph')
    
    for s in activationsets:
        node = pydot.Node("%s (%d)"%(s.id, s.size))
        graph.add_node(node)
        s.dot_node = node
    
    for s in activationsets:
        for s2 in s.share_sets:
            if s.id<=s2.id:
                edge = pydot.Edge(s.dot_node, s2.dot_node)
                graph.add_edge(edge)
            else:
                assert s in s2.share_sets

    largest_notconnected_subset_size, largest_notconnected_subset = \
        find_largest_notconnected_subset(activationsets)
    for s in largest_notconnected_subset:
        s.dot_node.set_penwidth(5)

    try:
        os.remove('sharing_graph.pdf')
    except OSError:
        pass
    #graph.write_pdf('sharing_graph.pdf')
    
def draw_resource_mapping(activationsets):
    mapping_graph = pydot.Dot(graph_type='digraph')
    
    for s in activationsets:
        node = pydot.Node("%s (%d)"%(s.id, s.size))
        mapping_graph.add_node(node)
        s.dot_node = node
    
    for s in activationsets:
        for map_to in s.map_to:
            edge = pydot.Edge(s.dot_node, map_to.dot_node)
            mapping_graph.add_edge(edge)

    largest_notconnected_subset_size, largest_notconnected_subset = \
        find_largest_notconnected_subset(activationsets)
    for s in largest_notconnected_subset:
        s.dot_node.set_penwidth(5)

    mapping_graph.write_raw('mapping_graph.dot')
    try:
        os.remove('mapping_graph.pdf')
    except OSError:
        pass
    if export_graphs:
        mapping_graph.write_pdf('mapping_graph.pdf')

def map_resources(activationsets):
    for s in activationsets:
        s.share_sets_reduced = set(s.share_sets)
        s.size_to_map = s.size
        s.unused = s.size
        
    largest_notconnected_subset_size, largest_notconnected_subset = \
        find_largest_notconnected_subset(activationsets)
    for s in largest_notconnected_subset:
        s.size_to_map = 0
        
    todo_sets = set(s for s in largest_notconnected_subset if s.share_sets_reduced)
    while todo_sets:
        parent = max(todo_sets, key=lambda s: s.unused)
        if not parent.share_sets_reduced:
            todo_sets.remove(parent)
            continue
        child = max(parent.share_sets_reduced, key=lambda s: s.size_to_map)
        if child.size_to_map==0:
            todo_sets.remove(parent)
            continue
        child.map_to.append(parent)
        if parent.unused >= child.size_to_map:
            parent.unused -= child.size_to_map
            child.size_to_map = 0
            todo_sets.add(child)
        else:
            child.size_to_map -= parent.unused
            parent.unused = 0
        child.share_sets_reduced.intersection_update(parent.share_sets_reduced)
        for e in graph.get_edge(parent.dot_node.get_name(), child.dot_node.get_name()):
            e.set_color("red")
        if parent.unused == 0:
            todo_sets.remove(parent)
                
    for s in activationsets:
        if s.size_to_map != 0:
            print "unmapped:", s
    

def main():
    activationsets = parse()
    draw_activationsets(activationsets)
    map_resources(activationsets)
    draw_resource_mapping(activationsets)
    
    if export_graphs:
        graph.write_pdf('sharing_graph.pdf')
    
if __name__=="__main__":
    main()