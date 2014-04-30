#!/usr/bin/env python
# This has been merged into the ResourceSharingCalculator in Java

import sys, re
from collections import defaultdict

verbose_flag = False

class ActivationSet:
    def __init__(self, id, size):
        self.id = id
        self.size = size
        self.share_sets = None
        self.share_ids = None
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

def main():
    activationsets = parse()
    
#     print 'cluster partitioning\n', '\n'.join(map(repr,cluster_partition(activationsets.values())))

#     print 'share ids partitioning'
#     partitioning = shareids_partition(activationsets.values())
#     for part in partitioning:
#         print repr(part), repr(part[0].share_sets), 'total size=', sum(activationset.size for activationset in part)
        
    print 'connected components partitioning'
    partitioning = connected_partition(activationsets)
    sum_largest_notconnected_subset_size = 0
    #print len(activationsets.values())
    for part in partitioning:
        largest_notconnected_subset_size, largest_notconnected_subset = find_largest_notconnected_subset(part)
        #print len(part), '#'
        #print map(str,part), '==>', 
        if verbose_flag:
            print map(str,largest_notconnected_subset), 'total size=', largest_notconnected_subset_size
        sum_largest_notconnected_subset_size += largest_notconnected_subset_size
    
    sum_all_activationset_size = sum(activationset.size for activationset in activationsets)
    print 'num nodes in all activationsets:', sum_all_activationset_size
    print 'max num nodes active at any time (except those not in an activationset):', sum_largest_notconnected_subset_size
    print 'num nodes saved:', sum_all_activationset_size-sum_largest_notconnected_subset_size

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

if __name__=="__main__":
    main()