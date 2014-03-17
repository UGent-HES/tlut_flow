package be.ugent.elis.recomp.util.logging;

import net.sf.javabdd.BDD;
import be.ugent.elis.recomp.mapping.utils.Cone;

public class ConeConsideredStats extends AbstractMessage {
	static int numMessages = 0;
	static int maxBddSize = 0;
	static int sumBddSize = 0;
	static int numBdd = 0;
	
	Cone cone;
	
	public float getBddSizeAverage() {
		return (float)sumBddSize/numBdd;
	}

	public ConeConsideredStats(Cone cone) {
		super();
		this.cone = cone;
		
		BDD bdd = cone.getFunction();
		
		if(bdd != null) {
			int nodeCount = bdd.nodeCount();
			sumBddSize += nodeCount;
			numBdd += 1;
			maxBddSize = Math.max(maxBddSize, nodeCount);
		}
		
		numMessages++;
	}

	@Override
	void doLog() {
		
	}
	
	static void finalLog() {
		if(numBdd != 0) {
			System.out.println("Debug: Avg BDD size considered: "+(sumBddSize/(float)numBdd));
			System.out.println("Debug: Max BDD size considered: "+maxBddSize);
		}
	}
}