package be.ugent.elis.recomp.mapping.tmapSimple;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeSet;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeSetRemove implements Visitor<Node, Edge> {

	public void init(AIG<Node, Edge> aig) {
	}

	public void visit(Node node) {
		System.out.print(node.getName() + ": " );
	
		if (node.isGate()) {
			//Get the two child nodes of the current node
			Node node0 = node.getI0().getTail();
			if (node0.fanout()==1) {
				node0.removeConeSet();
				System.out.print("node0 ");

			} else if (node0.fanout()>1) {
				boolean remove = true;
				for (Edge e:node0.fanOut()) {
					if (e.getHead().getBestCone()==null) {
						remove = false;
					}
				}
				if (remove) {
					node0.removeConeSet();
					System.out.print("node0* ");
				}
			}
			
			Node node1 = node.getI1().getTail();
			if (node1.fanout()==1) {
				node1.removeConeSet();
				System.out.print("node1 ");
			} else if (node1.fanout()>1) {
				boolean remove = true;
				for (Edge e:node1.fanOut()) {
					if (e.getHead().getBestCone()==null) {
						remove = false;
					}
				}
				if (remove) {
					node1.removeConeSet();
					System.out.print("node1* ");
				}
			}

		} 
		
		
		System.out.println();
	}

}
