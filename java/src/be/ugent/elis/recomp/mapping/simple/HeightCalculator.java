package be.ugent.elis.recomp.mapping.simple;

import java.util.Vector;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class HeightCalculator implements Visitor<Node, Edge> {
	double oDepth = 0.;
	
	public void init(AIG<Node, Edge> aig) {
		for(Node n:aig.getAllNodes())
			n.setRequiredTime(Double.POSITIVE_INFINITY);
		Vector<Node> PO = new Vector<Node>();
		PO.addAll(aig.getOutputs());
		PO.addAll(aig.getILatches());
		for(Node n:PO)
			oDepth = Math.max(oDepth,n.getDepth());
	}

	
	public void visit(Node node) {
 		
 		// Set the required time of the
 		// primary outputs
		if (node.isOutput() || node.isILatch()) {
			
			node.setRequiredTime(oDepth);
			node.getI0().getTail().setRequiredTime(oDepth);
		
		// Set the required time of the gates
		// and there output edges
		} else if ( node.isGate() ) {
			
			double requiredTime = node.getRequiredTime() - 1.;
			Cone bestCone = node.getBestCone();
			
				for(Node n : bestCone.getRegularLeaves())
					n.setRequiredTime(Math.min(n.getRequiredTime(),requiredTime));
				
		} else if (node.isInput() || node.isOLatch()) {
		}
		
		//System.out.println(node.getName());
	}
	
}


