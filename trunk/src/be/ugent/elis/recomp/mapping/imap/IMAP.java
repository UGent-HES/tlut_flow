package be.ugent.elis.recomp.mapping.imap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;

import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;


public class IMAP {

	private static final int maxI = 8;

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		// Read AIG file
		MappingAIG a = new MappingAIG(args[0]);


		// Mapping
        a.visitAll(new ConeEnumeration(Integer.parseInt(args[1])));
        
        a.visitAll(new ConeRanking());
		double ODepth = a.getDepth();
       	a.visitAllInverse(new Backward());
        
        for (int i=1; i<maxI;i++) {
        	a.visitAll(new Forward(ODepth));
        	a.visitAllInverse(new Backward());
        }
        
        System.out.println(a.numLuts() +"\t"+ a.getDepth());

        // Writing a blif
        a.printMappedBlif(new PrintStream(new File(args[2])));        
	}



}
