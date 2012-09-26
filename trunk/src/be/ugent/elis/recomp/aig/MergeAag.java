package be.ugent.elis.recomp.aig;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;

public class MergeAag {

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		BasicAIG aig0 = new BasicAIG(args[0]);
		BasicAIG aig1 = new BasicAIG(args[1]);
		
		aig0.merge(aig1);
		
		aig0.printAAG(new PrintStream(new File(args[2])));

	}

}
