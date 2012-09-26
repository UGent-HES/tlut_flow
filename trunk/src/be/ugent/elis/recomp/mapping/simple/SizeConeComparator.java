package be.ugent.elis.recomp.mapping.simple;

import java.util.Comparator;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class SizeConeComparator implements Comparator<Cone> {

	public int compare(Cone o1, Cone o2) {
		if (o1.size() > o2.size()) {
			return 1;
		} else if (o1.size() < o2.size()) {
			return -1;
		} else {
			return 0;
		}
	}

}
