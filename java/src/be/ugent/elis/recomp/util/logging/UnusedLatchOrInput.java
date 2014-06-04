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
		if(numMessages < 10) {
			if(node.isInput())
				System.out.println("Warning: Unused input: "+node.getName());
			else if(node.isOLatch())
				System.out.println("Warning: Unused latch: "+node.getName());
			else
				throw new RuntimeException("Unexpected node type");
		}
	}
	
	static void finalLog() {
		if(numMessages > 0) {
			System.out.println("Warning: Unused latch or input: " + numMessages + " warnings in total");
		}
	}
}