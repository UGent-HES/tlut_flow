package be.ugent.elis.recomp.mapping.imap;

import java.util.Comparator;

import be.ugent.elis.recomp.mapping.utils.SimpleCone;

public class AreaConeComparator implements Comparator<SimpleCone> {

	@Override
	public int compare(SimpleCone o1, SimpleCone o2) {
		if (o1.getAreaflow() > o2.getAreaflow())
			return 1;
		else if (o1.getAreaflow() < o2.getAreaflow())
			return -1;
		else
			return 0;
	}

}
