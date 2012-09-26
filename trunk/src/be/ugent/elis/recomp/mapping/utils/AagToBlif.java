package be.ugent.elis.recomp.mapping.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;


public class AagToBlif {

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		// Read AIG file
		MappingAIG a = new MappingAIG(args[0]);
		
		for (Node n : a.getAnds()) {
			n.setVisible(true);
			
			Cone c = new SimpleCone(n);
			c.addLeave(n.getI0().getTail());
			c.addLeave(n.getI1().getTail());
			n.setBestCone(c);
		}
		
		a.printMappedBlif(new PrintStream(new File(args[1])));

	}

}
