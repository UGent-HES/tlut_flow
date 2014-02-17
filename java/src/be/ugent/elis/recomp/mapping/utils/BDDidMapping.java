package be.ugent.elis.recomp.mapping.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import be.ugent.elis.recomp.synthesis.BDDFactorySingleton;


public class BDDidMapping {
	
	private final MappingAIG aig;
	private Map<Node, Integer> id_map;
	private Map<Integer, Node> node_map;

	private int param_id_range;
	
	public BDDidMapping(MappingAIG aig) {
		this.aig = aig;
		id_map = new HashMap<Node, Integer>();
		node_map = new HashMap<Integer, Node>();
		
		int id_runner = 0;
		
		//Parameters should get lowest ids
		for(Node node : aig.getInputs())
			if(node.isParameter())
				mapNodeToId(node, id_runner++);
		param_id_range = id_runner - 1;
		
		//Other nodes get higher ids than parameters
		for(Node node : aig.getInputs())
			if(!node.isParameter())
				mapNodeToId(node, id_runner++);
		ArrayList<Node> all = new ArrayList<Node>();
		all.addAll(aig.getAnds());
		all.addAll(aig.getOutputs());
		all.addAll(aig.getILatches());
		all.addAll(aig.getLatches());
		all.addAll(aig.getOLatches());
		for(Node node : all)
			mapNodeToId(node, id_runner++);
		
		//Parameters should stay together and at the front during reordering
		if(getParamIdRange()>=0)
			BDDFactorySingleton.get().addVarBlock(0, getParamIdRange(), false);
	}
	
	private void mapNodeToId(Node node, int id) {
		id_map.put(node, id);
		node_map.put(id, node);
	}
	
	public int getId(Node node) {
		return id_map.get(node);
	}
	
	public Node getNode(int id) {
		return node_map.get(id);
	}
	
	/**
	 * Parameters of the aig have ids from 0 to param_id_range (including).
	 * @return param_id_range
	 */
	public int getParamIdRange() {
		return param_id_range;
	}
}
