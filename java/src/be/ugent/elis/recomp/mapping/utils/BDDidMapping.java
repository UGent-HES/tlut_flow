package be.ugent.elis.recomp.mapping.utils;

import java.util.HashMap;
import java.util.Map;


public class BDDidMapping<N> {
	
	private Map<N, Integer> id_map;
	private Map<Integer, N> node_map;
	
	public BDDidMapping() {
		id_map = new HashMap<N, Integer>();
		node_map = new HashMap<Integer, N>();
	}
	
	public <K> BDDidMapping<K> translateMapping(Map<N,K> mapping) {
		BDDidMapping<K> new_mapping = new BDDidMapping<K>();
		for(Map.Entry<N, K> entry : mapping.entrySet()) {
			new_mapping.mapNodeToId(entry.getValue(), getId(entry.getKey()));
		}
		return new_mapping;
	}
	
	public void mapNodeToId(N node, int id) {
		id_map.put(node, id);
		node_map.put(id, node);
	}
	
	public int getId(N node) {
		return id_map.get(node);
	}
	
	public N getNode(int id) {
		N tmp = node_map.get(id);
		if(tmp == null)
			throw new RuntimeException();
		return tmp;
	}
}
