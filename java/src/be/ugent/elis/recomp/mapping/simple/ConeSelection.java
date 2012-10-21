package be.ugent.elis.recomp.mapping.simple;
import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;


public class ConeSelection implements Visitor<Node, Edge> {

	public void init(AIG<Node, Edge> aig) {
		for(Node node : aig.getAllNodes())
			node.setVisible(false);
	}	
	
	public void visit(Node node) {
		
		// Set the child nodes of the outputs visible.
		if (node.isOutput() || node.isILatch()) {
			
			node.getI0().getTail().setVisible(true);
		
		// Make source nodes of the bestcones of visible nodes visible.
		} else if (node.isGate()) {
			
			if (node.isVisible()) {

				ConeInterface bestCone = node.getBestCone();
				for (Node n:bestCone.getRegularLeaves()) {
					n.setVisible(true);
				}
				
			}
		}
	}


}
