package be.ugent.elis.recomp.mapping.utils;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;


public class PrintNameVisitor implements Visitor<Node, Edge> {

	@Override
	public void init(AIG<Node, Edge> aig) {
	}

	@Override
	public void visit(Node node) {
		System.out.println(node.getName());	
	}

}
