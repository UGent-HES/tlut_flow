package be.ugent.elis.recomp.mapping.tmapSimple;

import java.util.HashSet;
import java.util.Set;

import be.ugent.elis.recomp.aig.AbstractEdge;
import be.ugent.elis.recomp.aig.AbstractNode;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class AbstractTMapCone< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {

	private Node root;
	protected Set<Node> RegularLeaves;
	protected Set<Node> ParameterLeaves;
	
	public AbstractTMapCone(Node root) {
		super();
		this.root = root;
		RegularLeaves = new HashSet<Node>();
		ParameterLeaves = new HashSet<Node>();
	}
	
	

	
}
