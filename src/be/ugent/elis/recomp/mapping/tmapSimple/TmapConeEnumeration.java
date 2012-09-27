package be.ugent.elis.recomp.mapping.tmapSimple;

import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.utils.SimpleCone;
import be.ugent.elis.recomp.mapping.utils.SimpleConeSet;
import be.ugent.elis.recomp.mapping.utils.Node;

public class TmapConeEnumeration extends ConeEnumeration {

	public TmapConeEnumeration(int K) {
		super(K);
	}

	@Override
	public void visit(Node node) {
		SimpleConeSet result = new SimpleConeSet(node);
		
		//Add the trivial Cone
//		if (node.isInput() || !node.isParameter())
		if (node.isInput())
			result.add(SimpleCone.trivialCone(node));
		
		
		
		//Generate and add the non trivial Cones
		if (node.isGate()) {
			if (!node.getI0().getTail().isParameter() && !node.getI1().getTail().isParameter()) {
				result.add(SimpleCone.trivialCone(node));				
			}
			SimpleConeSet mergedConeSet  = mergeInputConeSets(node);
			SimpleConeSet kFeasibleCones = retainKfeasableCones(mergedConeSet);
			SimpleConeSet nonDominatedConeSet = removeDominatedCones(kFeasibleCones);
//			SimpleConeSet nonDominatedConeSet = kFeasibleCones;
			result.addAll(nonDominatedConeSet);
		}
		
		node.setConeSet(result);
	}

	@Override
	protected SimpleConeSet retainKfeasableCones(SimpleConeSet input) {
		SimpleConeSet result = new SimpleConeSet(input.getNode());
		for (SimpleCone c:input) {
			if (c.size() - c.numParameters() <= K) {
				result.add(c);
			}
		}
		
		nmbrKCones += result.size();
		
		return result;
	}

	
	
}
