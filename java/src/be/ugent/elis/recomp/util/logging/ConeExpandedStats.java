package be.ugent.elis.recomp.util.logging;

import net.sf.javabdd.BDD;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.util.GlobalConstants;

public class ConeExpandedStats extends AbstractMessage {
	static int numMessages = 0;
		
	Cone cone;

	public ConeExpandedStats(Cone cone) {
		super();
		this.cone = cone;
		
		numMessages++;
	}

	@Override
	void doLog() {
		
	}
	
	static void finalLog() {
		if(numMessages>0)
			System.out.println("Debug: Cones expanded: "+numMessages);
	}
}