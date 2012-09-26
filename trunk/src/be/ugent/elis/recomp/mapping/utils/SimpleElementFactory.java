package be.ugent.elis.recomp.mapping.utils;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.ElementFactory;
import be.ugent.elis.recomp.aig.NodeType;

public class SimpleElementFactory implements ElementFactory<Node,Edge> {

	public Node newConst0(AIG<Node, Edge> aig) {
		Node con =  new Node(aig, NodeType.CONST0);
		return con;
	}	
	
	public Node newAnd(AIG<Node, Edge> aig) {
		Node and =  new Node(aig, NodeType.AND);
//		and.setName("a"+Integer.toString(var));
		return and;
	}

	public Node newILatch(AIG<Node, Edge> aig) {
		Node latch =  new Node(aig, NodeType.ILATCH);
		return latch;
	}

	public Node newLatch(AIG<Node, Edge> aig) {
		Node latch =  new Node(aig, NodeType.LATCH);
		return latch;
	}

	public Node newOLatch(AIG<Node, Edge> aig) {
		Node latch =  new Node(aig, NodeType.OLATCH);
		return latch;
	}
	
	public Node newInput(AIG<Node, Edge> aig) {
		return new Node(aig, NodeType.INPUT);
	}

	public Node newOutput(AIG<Node, Edge> aig) {
		return new Node(aig, NodeType.OUTPUT);
	}

	public Edge newEdge(Node tail, Node head, boolean inverted) {
		return new Edge(tail, head, inverted);
	}

}
