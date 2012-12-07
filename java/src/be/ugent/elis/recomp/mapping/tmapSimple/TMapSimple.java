package be.ugent.elis.recomp.mapping.tmapSimple;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.AreaOrientedConeComparator;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.simple.ConeSelection;
import be.ugent.elis.recomp.mapping.simple.HeightCalculator;
import be.ugent.elis.recomp.mapping.simple.DepthOrientedConeComparator;
import be.ugent.elis.recomp.mapping.simple.AreaflowOrientedConeComparator;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;

public class TMapSimple {

	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		// Find the base name of the aag file
		//String baseName = args[0].substring(0,args[0].lastIndexOf('.'));
		
		// Read AIG file
		MappingAIG a = new MappingAIG(args[0]);
		
		a.visitAll(new ParameterMarker(new FileInputStream(args[1])));
		
		int K = Integer.parseInt(args[2]);

		// Mapping
		ConeEnumeration enumerator = new ConeEnumeration(K);
		System.out.println("Cone Enumeration:");
        a.visitAll(enumerator);
		System.out.println("Cone Ranking:");
        a.visitAll(new ConeRanking(new DepthOrientedConeComparator()));

        double depthBeforeAreaRecovery = a.getDepth();
        a.visitAllInverse(new ConeSelection());
        a.visitAllInverse(new HeightCalculator());
        a.visitAll(new ConeRanking(new AreaflowOrientedConeComparator(),true,false));
        a.visitAllInverse(new ConeSelection());
        a.visitAllInverse(new HeightCalculator());
        a.visitAll(new ConeRanking(new AreaOrientedConeComparator(),false,true));
        if(depthBeforeAreaRecovery != a.getDepth()) {
        	System.err.println("Depth increased during area recovery: from "+depthBeforeAreaRecovery+" to "+a.getDepth());
        	System.exit(1);
        }


		//Frees memory when possible
//		System.out.println("Cone Enumeration and Ranking:");
//		ConeEnumeration enumerator = new ConeEnumeration(K);
//        a.visitAll(enumerator,new ConeRanking(), new ConeSetRemove());
        
        
        System.out.println("Cone Selection:");
        a.visitAllInverse(new ConeSelection());

        
        
        // Writing a blif
//        a.printMappedBlif(new PrintStream(new File(args[3])));
        
		System.out.println("Generating the parameterizable configuration:");
		AIG<Node, Edge> b;
        /*if(args.length > 6){
			 b = a.constructParamConfig(K);
		}else{
			 b = a.constructParamConfig_old(K);
		}*/
		b = a.constructParamConfig(K);
        
        System.out.println("Writing the parameterizable configuration:");
        b.printAAG(new PrintStream(new BufferedOutputStream( new FileOutputStream(args[4]))));
//        b.printAAGevaluator(new PrintStream(new BufferedOutputStream( new FileOutputStream("test.c"))));
        System.out.println("Writing the LUT structure:"); 
        if(args.length > 6){
        	a.printLutStructureBlif(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[5]))), K);
        	String vhdFile = args[7];
        	String inVhdFile = args[6];
        	String nameFile = args[8];
        	a.printLutStructureVhdl(inVhdFile, vhdFile, nameFile, K);
        }else{
        	//a.printLutStructureBlif_old(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[5]))), K);
        	a.printLutStructureBlif(new PrintStream(new BufferedOutputStream(new FileOutputStream(args[5]))), K);
        }


        System.out.println(a.numLuts() +"\t"+ a.getDepth() + "\t" +a.numTLuts() + "\t" +a.avDupl() +"\t"+ enumerator.getNmbrCones() +"\t"+ enumerator.getNmbrKCones() +"\t"+ enumerator.getNmbrDominatedCones());

//        System.out.println(a.numLuts() +"\t"+ a.getDepth() +"\t"+ enumerator.getNmbrCones() +"\t"+ enumerator.getNmbrKCones() +"\t"+ enumerator.getNmbrDominatedCones()+ "\t" + b.getAnds().size());

        
	}
	
}
