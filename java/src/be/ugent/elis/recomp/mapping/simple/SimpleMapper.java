package be.ugent.elis.recomp.mapping.simple;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

import javax.print.attribute.standard.PrinterName;

import be.ugent.elis.recomp.mapping.tmapSimple.ParameterMarker;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;


public class SimpleMapper {

	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		// Read AIG file
		MappingAIG a = new MappingAIG(args[0]);
		
//		a.visitAll(new ParameterMarker(new FileInputStream(args[1])));

		// Mapping
		System.out.println("Cone Enumeration:");
		ConeEnumeration enumerator = new ConeEnumeration(Integer.parseInt(args[1])); 
        a.visitAll(enumerator);        
		System.out.println("Cone Ranking:");
        a.visitAll(new ConeRanking(new DepthOrientedConeComparator()));
        
        double depthBeforeAreaRecovery = a.getDepth();
        a.visitAllInverse(new HeightCalculator());
        a.visitAll(new ConeRanking(new AreaflowOrientedConeComparator(),true,false));
        a.visitAllInverse(new HeightCalculator());
        a.visitAll(new ConeRanking(new AreaOrientedConeComparator(),false,true));
        if(depthBeforeAreaRecovery != a.getDepth()) {
        	System.err.println("Depth increased during area recovery: from "+depthBeforeAreaRecovery+" to "+a.getDepth());
        	System.exit(1);
        }
        
//        a.visitAllInverse(new PrintNameVisitor());
        
        System.out.println("Cone Selection:");
        a.visitAllInverse(new ConeSelection());
        
        System.out.println(a.numLuts() +"\t"+ a.getDepth() +"\t"+ enumerator.getNmbrCones() +"\t"+ enumerator.getNmbrKCones() +"\t"+ enumerator.getNmbrDominatedCones());
        
        // Writing a blif
        a.printMappedBlif(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[2]))));        
	}
}
