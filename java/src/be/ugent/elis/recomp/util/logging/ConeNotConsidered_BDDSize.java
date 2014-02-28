package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class ConeNotConsidered_BDDSize extends AbstractMessage {
	static int numMessages = 0;
	Cone cone;

	public ConeNotConsidered_BDDSize(Cone cone) {
		super();
		this.cone = cone;
		numMessages++;
	}

	@Override
	void doLog() {
	}
	
	static void finalLog() {
		System.out.println("Debug: Num cones not considered because of excessive BDD size: "+numMessages);
	}
}