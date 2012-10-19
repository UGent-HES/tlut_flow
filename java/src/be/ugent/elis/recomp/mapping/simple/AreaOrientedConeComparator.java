package be.ugent.elis.recomp.mapping.simple;

import java.util.Comparator;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class AreaOrientedConeComparator implements Comparator<Cone> {
	 
	// Cones are ordered by their depth. Cones with equal depth are
	// ordered by area flow.
	public int compare(Cone o1, Cone o2) {
		double requiredTime = o1.getRoot().getRequiredTime();
		if(requiredTime==Double.POSITIVE_INFINITY) {
			if (o1.getDepth() > o2.getDepth())
				return 1;
			else if (o1.getDepth() < o2.getDepth())
				return -1;
			else if (o1.getArea() > o2.getArea())
				return 1;
			else if (o1.getArea() < o2.getArea())
				return -1;
			else 
				return o1.toString().compareTo(o2.toString());			
		} else {
			boolean o1Feasible = o1.getDepth() <= requiredTime;
			boolean o2Feasible = o2.getDepth() <= requiredTime;
			if (o1Feasible && !o2Feasible)
				return -1;
			else if (o2Feasible && !o1Feasible)
				return 1;
			else if (o1.getArea() > o2.getArea())
				return 1;
			else if (o1.getArea() < o2.getArea())
				return -1;
			else if (o1.getDepth() > o2.getDepth())
				return 1;
			else if (o1.getDepth() < o2.getDepth())
				return -1;
			else
				return o1.toString().compareTo(o2.toString());
		}
	}

}
