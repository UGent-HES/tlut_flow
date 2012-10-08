package be.ugent.elis.recomp.mapping.simple;

import java.util.Comparator;

import be.ugent.elis.recomp.mapping.utils.Edge;

public class DepthEdgeComparator implements Comparator<Edge> {

	public int compare(Edge o1, Edge o2) {
		
		if (o1.getDepth() < o2.getDepth())
			return -1;
		else if (o1.getDepth() > o2.getDepth())
			return 1;
		else
			return 0;
	}

}
