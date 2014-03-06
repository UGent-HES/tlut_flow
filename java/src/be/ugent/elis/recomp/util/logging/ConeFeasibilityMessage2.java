package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Cone;

public class ConeFeasibilityMessage2 extends AbstractMessage {
	static int numMessages = 0;
	
	Cone cone;

	public ConeFeasibilityMessage2(Cone cone) {
		super();
		this.cone = cone;
		numMessages++;
	}

	@Override
	void doLog() {
		if(!cone.isUnmapped() && cone.isTCON()) {
			if(!(cone.getParent0().isTCON() || cone.getParent0().isTrivial() || cone.getParent0().isNone())
					&& !(cone.getParent1().isTCON() || cone.getParent1().isTrivial() || cone.getParent1().isNone()))
				System.out.println("Debug: Cone "+cone.toString());
		}
	}
	
	static void finalLog() {
	}
}