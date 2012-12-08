package be.ugent.elis.recomp.aig;

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

public class MakeCEvaluator {

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		BasicAIG aig = new BasicAIG(args[0]);
		
        //aig.printAAGevaluator2(new PrintStream(new BufferedOutputStream( new FileOutputStream(args[1]))));
        aig.printAAGevaluatorXilinx(
            new PrintStream(new BufferedOutputStream( new FileOutputStream(args[1]))),
            new PrintStream(new BufferedOutputStream( new FileOutputStream(args[2]))),
            args[2]);


	}

}
