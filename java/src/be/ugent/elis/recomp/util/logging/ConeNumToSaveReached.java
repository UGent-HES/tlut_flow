package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeNumToSaveReached extends AbstractMessage {
	static int numMessages = 0;
	Node node;

	public ConeNumToSaveReached(Node node) {
		super();
		this.node = node;
		numMessages++;
	}

	@Override
	void doLog() {
	}
	
	static void finalLog() {
		System.out.println("Debug: Times max cone num to save reached: "+numMessages);
	}
}