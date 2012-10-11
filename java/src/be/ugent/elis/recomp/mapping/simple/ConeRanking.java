package be.ugent.elis.recomp.mapping.simple;

import java.util.Collections;
import java.util.Comparator;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeRanking implements Visitor<Node, Edge> {
	
	private Comparator<Cone> coneComparator;
	
	public ConeRanking(Comparator<Cone> coneComparator) {
		this.coneComparator = coneComparator;
	}

	public void init(AIG<Node, Edge> aig) {	
	}

	
	public void visit(Node node) {
 		
 		// Set the area flow and the depth of the
 		// primary inputs and there output edges.
		if (node.isInput() || node.isOLatch()) {
			
			node.setDepth(0.0);
			node.setAreaflow(0.0);
			
			for (Edge e: node.fanOut()) {
				e.setDepth(0.0);
				e.setAreaflow(0);
			}
		
		// Set the area flow and the depth of the gates
		// and there output edges
		} else if ( node.isGate() ) {
			
			// Calculate depth and area flow for each cone.
			for (ConeInterface c:node.getConeSet()) {
				calculateDepth(c);
				calculateAreaflow(c);
			}
			
			// Select the best cone in the coneset.
			Cone bestCone= bestCone(node);
			node.setBestCone(bestCone);
			node.setDepth(bestCone.getDepth());
			node.setAreaflow(bestCone.getAreaflow());
			

			
			// Set the depth and area flow of the edges
			for (Edge e:node.fanOut()) {
				e.setDepth(bestCone.getDepth());
				e.setAreaflow(bestCone.getAreaflow() / node.fanOut().size());
			}
	 	// Set the area flow and the depth of the
	 	// primary outputs. 
		} else if (node.isOutput() || node.isILatch()) {
			node.setDepth(node.getI0().getDepth());
			node.setAreaflow(node.getI0().getAreaflow());
		}
		
		//System.out.println(node.getName());
	}

	protected Cone bestCone(Node node) {
		return Collections.min(node.getConeSet().getCones(), coneComparator);
	}

	private void calculateAreaflow(ConeInterface cone) {
		
		// Trivial cones should never be chosen they are only used
		// for cone enumeration.
		if (cone.isTrivial()) {
		
			cone.setAreaflow(Double.POSITIVE_INFINITY);

		
		} else {
			
			double areaflow = 0;
			
			//This is wrong but o so fast
			for (Node n: cone.getRegularLeaves()) {
				areaflow += n.getAreaflow()/n.fanout();
			}
			
			
			cone.setAreaflow(areaflow + 1);
		
		}
	}

	private void calculateDepth(ConeInterface c) {
		
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


