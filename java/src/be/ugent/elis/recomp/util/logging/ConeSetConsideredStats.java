package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.ConeSet;

public class ConeSetConsideredStats extends AbstractMessage {
	static int numMessages = 0;
	static int numConeSets = 0;
	static int maxConeSetSize = 0;
	static int sumConeSetSize = 0;
	static long sumSquaredConeSetSize = 0;

	public ConeSetConsideredStats(ConeSet coneSet) {
		super();

		numConeSets += 1;
		sumConeSetSize += coneSet.size();
		sumSquaredConeSetSize += coneSet.size()*coneSet.size();
		maxConeSetSize = Math.max(maxConeSetSize, coneSet.size());
		
		numMessages++;
	}

	@Override
	void doLog() {
		
	}
	
	static void finalLog() {
		if(numConeSets != 0) {
			System.out.println("Debug: Avg ConeSet size considered: "+(sumConeSetSize/(float)numConeSets));
			System.out.println("Debug: Avg squared ConeSet size considered: "+(sumSquaredConeSetSize/(float)numConeSets));
			System.out.println("Debug: Max ConeSet size considered: "+maxConeSetSize);
		}
	}
}