package be.ugent.elis.recomp.mapping.simple;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.Vector;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeSet;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeEnumeration implements Visitor<Node, Edge> {	

	protected int K;
	protected int nmbrKCones;
	protected int nmbrDominatedCones;
	protected int nmbrCones;
 
	public ConeEnumeration(int K) {
		nmbrCones  = 0;
		nmbrDominatedCones = 0;
		nmbrKCones = 0;
		this.K = K;
	}
	
	public int getNmbrKCones() {
		return nmbrKCones;
	}

	public int getNmbrDominatedCones() {
		return nmbrDominatedCones;
	}

	public int getNmbrCones() {
		return nmbrCones;
	}

	public void init(AIG<Node, Edge> aig) {
	}

	public void visit(Node node) {
		ConeSet result = new ConeSet(node);
		
		if (node.isParameter()) {
			result.add(Cone.emptyCone(node));
			System.out.println(node.getName());
		} else {
			
			if (node.isInput() || node.isOLatch()) {
				result.add(Cone.trivialCone(node));
			} else if (node.isGate()) {
				ConeSet mergedConeSet  = mergeInputConeSets(node);
				nmbrCones += mergedConeSet.size();
				ConeSet kFeasibleCones = retainKfeasableCones(mergedConeSet);
				ConeSet nonDominatedConeSet = removeDominatedCones(kFeasibleCones);
				nmbrKCones += nonDominatedConeSet.size();
				result.addAll(nonDominatedConeSet);
				result.add(Cone.trivialCone(node));
//				if (!node.getI0().getTail().isParameter() && !node.getI1().getTail().isParameter() )
//					result.add(Cone.trivialCone(node));
	
			} else if (node.isOutput() || node.isILatch()) {
			}
		}
		node.setConeSet(result);
		
		System.out.println(node.getName() + ": " + nmbrCones);
	}

	protected ConeSet mergeInputConeSets(Node node) {
		//Get the two child nodes of the current node
		Node node0 = node.getI0().getTail();
		Node node1 = node.getI1().getTail();
		
		//Get the cone sets of the child nodes
		ConeSet coneSet0 = node0.getConeSet();
		ConeSet coneSet1 = node1.getConeSet();
		
		//Merge the cone sets of the child nodes 
		ConeSet result = new ConeSet(node);
		for (Cone cone0:coneSet0) {
			for (Cone cone1:coneSet1) {
				Cone merge = Cone.mergeCones(node, cone0, cone1);
				result.add(merge);
			}
		}

		return result;
	}
	
	protected ConeSet removeDominatedCones(ConeSet kFeasibleCones) {
		ConeSet result = new ConeSet(kFeasibleCones.getNode());
		result.addAll(kFeasibleCones);

		Set<Cone> dominatedCones = new HashSet<Cone>();
		Vector<Cone> temp = new Vector<Cone>();
		temp.addAll(result.getCones());
		Collections.sort(temp, new SizeConeComparator());
		
		for (int i=0; i<temp.size(); i++) {
			for (int j=i+1; j<temp.size(); j++) {
				
				if (temp.get(i).dominates(temp.get(j))) {
					dominatedCones.add(temp.get(j));
				}
			}
		}
		
		result.removeAll(dominatedCones);	
		
		return result;
	}
	
	protected ConeSet retainKfeasableCones(ConeSet mergedConeSet) {
		
		ConeSet result = new ConeSet(mergedConeSet.getNode());
		for (Cone c:mergedConeSet) {
			if (c.size() <= K) {
				result.add(c);
			}
		}
		
		return result;
	}

}
