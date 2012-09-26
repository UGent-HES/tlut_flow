package be.ugent.elis.recomp.mapping.imap;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class Backward implements Visitor<Node, Edge> {

	@Override
	public void init(AIG<Node, Edge> aig) {
		for (Node n:aig.getAllNodes()) {
			n.setVisible(false);
			n.setHight(0);
		}
		for (Edge e:aig.getAllEdges()) {
			e.setHeight(0);
		}
	}
	
	public void visit(Node node) {
		
		// Set the child nodes of the outputs visible.
		if (node.isOutput() || node.isILatch()) {
			
			node.setHight(0);
			node.getI0().setHeight(1);
			
			node.getI0().getTail().setVisible(true);
		
		// Make source nodes of the bestcones of visible nodes visible.
		} else if (node.isGate()) {
			
			if (node.isVisible()) {
				Cone bestCone = node.getBestCone();
				
				double h=0;
				for (Edge edge: node.fanOut()) {
					if (edge.getHeight() > h) {
						h=edge.getHeight();
					}
				}
				
				for (Node n: bestCone.getNodes()) {
					if (h>n.getHight()) {
						n.setHight(h);
					}
				}
				
				for (Edge e: bestCone.getInputEdges()) {
					 if ((h+1) > e.getHeight()) {
						 e.setHeight(h+1);
					 }
				 }

				for (Node n:bestCone.getLeaves()) {
					n.setVisible(true);
				}
				
			}
		}
		
		return;
	}

	
	
}
