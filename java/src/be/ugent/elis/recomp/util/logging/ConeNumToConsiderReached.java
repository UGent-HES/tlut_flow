package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeNumToConsiderReached extends AbstractMessage {
	static int numMessages = 0;
	Node node;

	public ConeNumToConsiderReached(Node node) {
		super();
		this.node = node;
		numMessages++;
	}

	@Override
	void doLog() {
	}
	
	static void finalLog() {
		System.out.println("Debug: Times max cone num to consider reached: "+numMessages);
	}
}