package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class ConeNotConsideredToMerge extends AbstractMessage {
	static int numMessages = 0;
	Cone cone;

	public ConeNotConsideredToMerge(Cone cone) {
		super();
		this.cone = cone;
		numMessages++;
	}

	@Override
	void doLog() {
	}
	
	static void finalLog() {
		System.out.println("Debug: Num cones not considered to merge because of excessive BDD size: "+numMessages);
	}
}