package be.ugent.elis.recomp.mapping.imap;

import java.util.Collections;
import java.util.Vector;

import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.SimpleCone;
import be.ugent.elis.recomp.mapping.utils.SimpleConeSet;
import be.ugent.elis.recomp.mapping.utils.Node;

public class Forward extends ConeRanking {
	
	double ODepth;

	public Forward(double ODepth) {
		this.ODepth = ODepth;
	}

	@Override
	protected Cone bestCone(Node node) {
		SimpleConeSet coneSet = node.getConeSet();
		
		//Find all possible cones.
		Vector<SimpleCone> possible = new Vector<SimpleCone>();
		for (SimpleCone cone: coneSet) {
			if (cone.getDepth() <= ODepth - node.getHight()) {
				possible.add(cone);
			}
		}
		
		//Select the cone with lowest Area Flow
		Cone result = Collections.min(possible, new AreaConeComparator());
		
		return result;
	}
	
}
