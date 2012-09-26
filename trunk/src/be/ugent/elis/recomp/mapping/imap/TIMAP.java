package be.ugent.elis.recomp.mapping.imap;

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.tmapSimple.ParameterMarker;
import be.ugent.elis.recomp.mapping.tmapSimple.TmapConeEnumeration;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;

public class TIMAP {
	
	private static final int maxI = 8;

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		// Read AIG file
		MappingAIG a = new MappingAIG(args[0]);

		a.visitAll(new ParameterMarker(args[1]));
		
		int K = Integer.parseInt(args[2]);

		// Mapping
        a.visitAll(new TmapConeEnumeration(K));
        
        a.visitAll(new ConeRanking());
		double ODepth = a.getDepth();
       	a.visitAllInverse(new Backward());
        
        for (int i=1; i<maxI;i++) {
        	a.visitAll(new Forward(ODepth));
        	a.visitAllInverse(new Backward());
        }
        
        System.out.println(a.numLuts() +"\t"+ a.getDepth());

        // Writing a blif
        // a.printMappedBlif(new PrintStream(new File(args[3])));
        
        // Writing the parameterizable configuration
        AIG<Node, Edge> b = a.constructParamConfig(K);
        b.printAAG(new PrintStream(new BufferedOutputStream( new FileOutputStream(args[4]))));
        
        // Writing the LUT structure functionality  
        a.printLutStructureBlif(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[5]))), K);
        
        
	}

}
