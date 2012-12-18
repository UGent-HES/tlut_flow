/*
 * Copyright (c) 2010 Brigham Young University
 * 
 * This file is part of the BYU RapidSmith Tools.
 * 
 * BYU RapidSmith Tools is free software: you may redistribute it 
 * and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 2 of 
 * the License, or (at your option) any later version.
 * 
 * BYU RapidSmith Tools is distributed in the hope that it will be 
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 * 
 * A copy of the GNU General Public License is included with the BYU 
 * RapidSmith Tools. It can be found at doc/gpl2.txt. You may also 
 * get a copy of the license at <http://www.gnu.org/licenses/>.
 * 
 */
package be.ugent.elis.recomp.util;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Vector;
import java.util.Map;

import edu.byu.ece.rapidSmith.design.Attribute;
import edu.byu.ece.rapidSmith.design.Design;
import edu.byu.ece.rapidSmith.design.Instance;
import edu.byu.ece.rapidSmith.design.Net;
import edu.byu.ece.rapidSmith.design.PIP;
import edu.byu.ece.rapidSmith.device.PrimitiveType;
import edu.byu.ece.rapidSmith.device.PrimitiveSite;
import edu.byu.ece.rapidSmith.device.WireType;
import edu.byu.ece.rapidSmith.router.Node;
import edu.byu.ece.rapidSmith.util.FileTools;

import com.daveKoelle.AlphanumComparator;


public class ExtractInfo {
	

	public static void main(String[] args) throws IOException{
		if(args.length != 4){
			System.out.println("USAGE: <input.xdl> <basename-names.txt> <locationcfilename> <locationheaderfilename>");
			System.exit(0);
		}
		Design design = new Design();
		System.out.println(args[2]);
		
		design.loadXDLFile(args[0]);
		
		//Create a collection of all instances in the XDL
		Collection<Instance> instances = design.getInstances();
		
		HashMap<String,InstanceInfo> logicalName2Instances = new HashMap<String,InstanceInfo>();
		//add the LUT's in each site of the FPGA
		Vector<String> lutsInSite = new Vector<String>();
		if(design.getFamilyName().equals("virtex2p")){
			lutsInSite.add("F");
			lutsInSite.add("G");
		} else{
			System.out.println("This device is not supported, ended program");
			System.exit(0);
		}
		
		
		for(Instance instance:instances){
			PrimitiveType primitiveType = instance.getType();
			if(primitiveType==PrimitiveType.SLICE){
				PrimitiveSite primitiveSite = instance.getPrimitiveSite();
				String name;
				String lutName;
				String path;
				//add each lut of site
				for(String lutSite:lutsInSite){
					if(instance.getAttribute(lutSite)!=null){
						name = instance.getAttribute(lutSite).getLogicalName();
					}
					else{
						//System.out.println("Instance: "+instance.toString()+"\n\n");
						break;
					}
					
					lutName = name.split("/")[name.split("/").length-1];
					if(lutName.length()<name.length()){
						path = name.substring(0, name.length()-lutName.length());
					} else {
						path = "";
					}
				
					if(logicalName2Instances.containsKey(lutName)){
						InstanceInfo info = logicalName2Instances.get(lutName);
						info.addInstance(path, primitiveSite, lutSite);
					} else{
						logicalName2Instances.put(lutName, new InstanceInfo(path, primitiveSite, lutSite));
					}
				}
			}
		}
		
		
		//read the -names.txt file
		BufferedReader in = null;
		try {
			in = new BufferedReader(new FileReader(args[1]));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		String firstLine = in.readLine().trim();
		if(firstLine==null){
			System.out.println("<basename-names.txt> has no lines");
			System.exit(0);
		}
		
		Vector<String> names = new Vector<String>();
		String tlutName;
		while((tlutName=in.readLine())!=null)
		    names.add(tlutName);
		in.close();
		
		
		//prepare the output file
		StringBuilder cFile = new StringBuilder();
		String newLine = System.getProperty("line.separator");
		
		cFile.append("//WARNING: Don't edit. Automatically regenerated file (TLUT flow)"+newLine);
		cFile.append("#include \""+args[3].substring(args[3].lastIndexOf('/')+1)+"\""+newLine+newLine);
		cFile.append("#define LUT_F 0"+newLine);
		cFile.append("#define LUT_G 1"+newLine);
		cFile.append(""+newLine);

		//System.out.println(logicalName2Instances);
		//for (Map.Entry<String, InstanceInfo> entry : logicalName2Instances.entrySet())
        //    System.out.println(entry.getKey() + " -> " + entry.getValue());

		//System.out.println(firstLine);
		if(logicalName2Instances.get(firstLine)==null) {
		    System.err.println("Error: Instance '"+firstLine+"' not found");
		    System.exit(1);
		}
		Vector <String> paths = new Vector(logicalName2Instances.get(firstLine).getPaths());
		Collections.sort(paths,new AlphanumComparator());
		System.out.println(paths);
		cFile.append("const lutlocation location_array[NUMBER_OF_INSTANCES][NUMBER_OF_TLUTS_PER_INSTANCE] = {\n");
		int numberOfTLUTs=0;
		for(String path:paths){
			// process firstLine with the first path
			cFile.append("\t{");
			numberOfTLUTs = 1;
			System.out.println(path);
			/*System.out.println(firstLine);
			System.out.println(logicalName2Instances.get(firstLine).getSite(path));
			System.out.println(logicalName2Instances.get(firstLine).getLut(path));*/
			cFile.append("{"+logicalName2Instances.get(firstLine).getSite(path).getInstanceX()+","+
			    logicalName2Instances.get(firstLine).getSite(path).getInstanceY()+
			    ",LUT_"+logicalName2Instances.get(firstLine).getLut(path)+"}");
			for(String lutName : names){
				/*System.out.println(lutName);
				System.out.println(logicalName2Instances.get(lutName).getSite(path));
				System.out.println(logicalName2Instances.get(lutName).getLut(path));*/
				cFile.append(",{"+logicalName2Instances.get(lutName).getSite(path).getInstanceX()+","+
				    logicalName2Instances.get(lutName).getSite(path).getInstanceY()+
				    ",LUT_"+logicalName2Instances.get(lutName).getLut(path)+"}");
				numberOfTLUTs++;
			}
			cFile.append("} /* "+path+" */,\n");
		}
		cFile.deleteCharAt(cFile.length()-2);
		cFile.append("};"+newLine);
		
		PrintStream stream = new PrintStream(new BufferedOutputStream(new FileOutputStream(args[2])));
		stream.print(cFile.toString());
		stream.flush();
		stream.close();
		
		stream = new PrintStream(new BufferedOutputStream(new FileOutputStream(args[3])));
		stream.println("#include \"xutil.h\""+newLine);
		stream.println("#define NUMBER_OF_INSTANCES "+paths.size());
		stream.println("#define NUMBER_OF_TLUTS_PER_INSTANCE "+numberOfTLUTs+newLine);
		stream.println("#ifndef _lutlocation_type_H");
		stream.println("#define _lutlocation_type_H");
		stream.println("typedef struct {");
		stream.println("\tXuint32 lutCol;");
		stream.println("\tXuint32 lutRow;");
		stream.println("\tXuint8 lutType;");
		stream.println("} lutlocation;");
		stream.println("#endif"+newLine);
        stream.println(
            "extern const lutlocation location_array[NUMBER_OF_INSTANCES][NUMBER_OF_TLUTS_PER_INSTANCE];"+newLine);
		stream.flush();
		stream.close();
	}
}