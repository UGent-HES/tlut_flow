package be.ugent.elis.recomp.mapping.simple;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.Vector;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class AreaCalculator implements Visitor<Node, Edge> {
	
	public void init(AIG<Node, Edge> aig) {
	}

	
	public void visit(Node node) {
		if ( node.isGate() ) {
			for(Cone cone : node.getConeSet().getCones()) {
				Set<Node> areaSet = new HashSet<Node>();
				calculateAreaSet(cone, areaSet);
				cone.setArea(areaSet.size());
			}
		} 
		//System.out.println(node.getName());
	}
	
	private void calculateAreaSet(Cone cone, Set<Node> areaSet) {
		for(Node n:cone.getRegularLeaves()) {
			if(n.isGate() && !areaSet.contains(n)) {
				areaSet.add(n);
				calculateAreaSet(n.getBestCone(), areaSet);
			}
		}
	}
	
}


