package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class ConeFeasibilityMessage extends AbstractMessage {
	static int numMessages = 0;
	static final int bins[] = new int[]{1,2,4,8,16,32,64,128,200,300};
	static int histFeasible[] = new int[bins.length];
	static int hist[] = new int[bins.length];
	
	Cone cone;

	private int getBin(int i) {
		int j=0;
		for(int b : bins) {
			if(i<=b)
				return j;
			j++;
		}
		return bins.length-1;
	}

	public ConeFeasibilityMessage(Cone cone) {
		super();
		this.cone = cone;
		
		if(cone.getFunction() != null) {
			int bin = getBin(cone.getFunction().nodeCount());
			if(!cone.isUnmapped())
				histFeasible[bin]++;
			hist[bin]++;
		}
		numMessages++;
	}

	@Override
	void doLog() {
		
	}
	
	static void finalLog() {
		for(int j = 0; j<bins.length; j++)
			System.out.println("Debug: Bin: "+bins[j]+" Feasibility: "+(histFeasible[j]/(float)hist[j])+" Cones: "+hist[j]);
	}
}