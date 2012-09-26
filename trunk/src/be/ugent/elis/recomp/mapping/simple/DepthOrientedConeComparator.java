package be.ugent.elis.recomp.mapping.simple;

import java.util.Comparator;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class DepthOrientedConeComparator implements Comparator<Cone> {
	 
	// Cones are ordered by their depth. Cones with equal depth are
	// ordered by area flow.
	public int compare(Cone o1, Cone o2) {
		if (o1.getDepth() > o2.getDepth())
			return 1;
		else if (o1.getDepth() < o2.getDepth())
			return -1;
		else {
			if (o1.getAreaflow() > o2.getAreaflow())
				return 1;
			else if (o1.getAreaflow() < o2.getAreaflow())
				return -1;
			else {
				return o1.toString().compareTo(o2.toString());
			}
				

		}
	}

}
