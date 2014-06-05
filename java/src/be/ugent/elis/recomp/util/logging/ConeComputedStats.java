package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.util.GlobalConstants;

public class ConeComputedStats extends AbstractMessage {
	static int numMessages = 0;
	static final int bins[] = new int[]{1,2,4,8,16,32,64,128,256,512};
	static int hist[] = new int[bins.length];
	static int sumSize = 0;
	static int numBDDs = 0;
	
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

	public ConeComputedStats(Cone cone) {
		super();
		this.cone = cone;
		
		if(cone.isLocalFunctionDefined()) {
			if(GlobalConstants.binizeStatsFlag) {
				int bin = getBin(cone.getLocalFunction().nodeCount());
				hist[bin]++;
			}
			sumSize += cone.getLocalFunction().nodeCount();
			numBDDs++;
		}
		numMessages++;
	}

	@Override
	void doLog() {
		
	}
	
	static void finalLog() {
		if(numBDDs != 0) {
			if(GlobalConstants.binizeStatsFlag) {
				for(int j = 0; j<bins.length; j++)
					System.out.println("Debug: Bin: "+bins[j]+" Cones: "+hist[j]);
			}
			System.out.println("Debug: Avg BDD size computed: "+(sumSize/(float)numBDDs));
		}
	}
}