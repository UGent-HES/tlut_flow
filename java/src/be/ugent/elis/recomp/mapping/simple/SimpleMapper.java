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
		ConeEnumeration enumerator = new ConeEnumeration(Integer.parseInt(args[1])); 
        a.visitAll(enumerator);        
        a.visitAll(new ConeRanking(new DepthOrientedConeComparator()));
        
        a.visitAllInverse(new HeightCalculator());
        a.visitAll(new ConeRanking(new AreaflowOrientedConeComparator()));
        
//        a.visitAllInverse(new PrintNameVisitor());
        
        a.visitAllInverse(new ConeSelection());
        
        System.out.println(a.numLuts() +"\t"+ a.getDepth() +"\t"+ enumerator.getNmbrCones() +"\t"+ enumerator.getNmbrKCones() +"\t"+ enumerator.getNmbrDominatedCones());
        
        // Writing a blif
        a.printMappedBlif(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[2]))));        
	}
}
