package be.ugent.elis.recomp.aig;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;

public class AagToGraph {

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		BasicAIG aig = new BasicAIG(args[0]);
			
		aig.printGraph(new PrintStream(new File(args[1])));
//		aig.printGraph(System.out);
	}

}
