package be.ugent.elis.recomp.mapping.utils;

import java.util.HashMap;
import java.util.Map;

import be.ugent.elis.recomp.synthesis.BDDFactorySingleton;

public class BDDidMapping<N> {

	private Map<N, Integer> id_map;
	private Map<Integer, N> node_map;

	public BDDidMapping() {
		id_map = new HashMap<N, Integer>();
		node_map = new HashMap<Integer, N>();
	}

	public BDDidMapping(BDDidMapping<N> orig) {
		id_map = new HashMap<N, Integer>(orig.id_map);
		node_map = new HashMap<Integer, N>(orig.node_map);
	}

	public <K> BDDidMapping<K> translateMapping(Map<N, K> mapping) {
		BDDidMapping<K> new_mapping = new BDDidMapping<K>();
		for (Map.Entry<N, K> entry : mapping.entrySet()) {
			new_mapping.mapNodeToId(entry.getValue(), getId(entry.getKey()));
		}
		return new_mapping;
	}

	public void mapNodeToId(N node, int id) {
		id_map.put(node, id);
		node_map.put(id, node);
	}

	public int getId(N node) {
		Integer id = id_map.get(node);
		if (id == null)
			throw new RuntimeException();
		return (int)id;
	}

	public N getNode(int id) {
		N tmp = node_map.get(id);
		if (tmp == null)
			throw new RuntimeException();
		return tmp;
	}

	public String toString() {
		return node_map.toString();
	}

	public int getNextUnusedId() {
		int id = BDDFactorySingleton.getSecondRangeStart();
		while (node_map.containsKey(id))
			id++;
		if (id > BDDFactorySingleton.get().varNum())
			throw new RuntimeException("Unsufficient number of BDD variables available");
		return id;
	}

}
