package be.ugent.elis.recomp.mapping.simple;

import java.util.Collections;
import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class HeightCalculator implements Visitor<Node, Edge> {
	double oDepth = 0.;
	
	public void init(AIG<Node, Edge> aig) {
		for(Node n:aig.getAllNodes())
			n.setRequiredTime(Double.POSITIVE_INFINITY);
		for(Node n:aig.getOutputs()) {
			oDepth = Math.max(oDepth,n.getDepth());
		}
		System.out.println("node"+oDepth);
	}

	
	public void visit(Node node) {
 		
 		// Set the height of the
 		// primary outputs
		if (node.isOutput() || node.isILatch()) {
			
			node.setRequiredTime(oDepth);
			node.getI0().getTail().setRequiredTime(oDepth);
//			
//			for (Edge e: node.fanIn()) {
//				e.setHeight(1.0);
//			}
		
		// Set the height of the gates
		// and there output edges
		} else if ( node.isGate() ) {
			
			double requiredTime = node.getRequiredTime() - 1.;
			//System.out.println("time"+requiredTime);
			Cone bestCone = node.getBestCone();
			
			for(Node n : bestCone.getRegularLeaves()) {
				n.setRequiredTime(Math.min(n.getRequiredTime(),requiredTime));
			}
	
	 	// Set the height of the
	 	// primary inputs. 
		} else if (node.isInput() || node.isOLatch()) {
			//node.setDepth(node.getI0().getDepth());
			//node.setAreaflow(node.getI0().getAreaflow());
		}
		
		System.out.println(node.getName());
	}


	private void calculateHeight(ConeInterface c) {
		
		// Trivial cones should never be chosen they are only used
		// for cone enumeration.
		if (c.isTrivial()) {

			c.setDepth(Double.POSITIVE_INFINITY);

		} else {
//			Edge maxDepthEdge = Collections.max(c.getInputEdges(), new DepthEdgeComparator());
//			c.setDepth(maxDepthEdge.getDepth());
			
			c.setDepth(c.getMaximumInputDepth()+1);

		}
	}



	
}


