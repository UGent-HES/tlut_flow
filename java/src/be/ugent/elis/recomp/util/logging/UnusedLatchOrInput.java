package be.ugent.elis.recomp.util.logging;

import be.ugent.elis.recomp.mapping.utils.Node;

public class UnusedLatchOrInput extends AbstractMessage {
	static int numMessages = 0;
	Node node;

	public UnusedLatchOrInput(Node node) {
		super();
		this.node = node;
		numMessages++;
	}

	@Override
	void doLog() {
		System.out.println("Warning: Unused latch or input: "+node.getName());
	}
	
	static void finalLog() {
		System.out.println("Warning: Unused latch or input: " + numMessages + " warnings in total");
	}
}