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
package ugent.elis.csl.hes.tFlow.util;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Vector;

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


public class ExtractInfo {
	

	public static void main(String[] args) throws IOException{
		if(args.length != 3){
			System.out.println("USAGE: <input.xdl> <basename-names.txt> <locationfilename>");
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
						System.out.println("Instance: "+instance.toString()+"\n\n");
						break;
					}
					
					lutName=name.split("/")[name.split("/").length -1];
					if(lutName.length()<name.length()){
						path=name.substring(0, name.length()-lutName.length());
					} else {
						path="";
					}
				
					if(logicalName2Instances.containsKey(lutName)){
						InstanceInfo info = logicalName2Instances.get(lutName);
						info.addInstance(lutName, primitiveSite, lutSite);
					} else{
						logicalName2Instances.put(lutName, new InstanceInfo(path, primitiveSite, lutSite));
					}
				}
			}
		}
		//prepare the output file
		StringBuilder hFile = new StringBuilder();
		String newLine = System.getProperty("line.separator");
		hFile.append("#include \"xutil.h\""+newLine+newLine);
		hFile.append("#ifndef _lutlocation_type_H"+newLine);
		hFile.append("#define _lutlocation_type_H"+newLine);
		hFile.append("typedef struct {"+newLine);
		hFile.append("\tXuint32 lutCol;"+newLine);
		hFile.append("\tXuint32 lutRow;"+newLine);
		hFile.append("\tXuint8 lutType;"+newLine);
		hFile.append("} lutlocation;"+newLine+newLine);
		hFile.append("#endif"+newLine);
		hFile.append(""+newLine);
		hFile.append("#define LUT_F 0"+newLine);
		hFile.append("#define LUT_G 1"+newLine);
		hFile.append(""+newLine);
		//hFile.append("const Xuint32  $instArrayName = $numInst;"+newLine);
		
		//read the -names.txt file
		BufferedReader in = null;
		try {
			in = new BufferedReader(new FileReader(args[1]));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String firstLine=in.readLine().trim();
		if(firstLine==null){
			System.out.println("<basename-names.txt> has no lines");
			System.exit(0);
		}
		Vector <String> paths=logicalName2Instances.get(firstLine).getPaths();
		System.out.println(paths);
		hFile.append("const Xuint32  numberOfInstances ="+(paths.size())+";"+newLine);
		hFile.append("const lutlocation location_array["+paths.size()+"][??] = { ");
		int numberOfTLUTs=0;
		for(String path:paths){
			// process firstLine with the first path
			hFile.append("{ ");
			numberOfTLUTs=1;
			System.out.println(firstLine);
			System.out.println(logicalName2Instances.get(firstLine).getSite(path));
			System.out.println(logicalName2Instances.get(firstLine).getLut(path));
			hFile.append("{"+logicalName2Instances.get(firstLine).getSite(path).getInstanceX()+" ,"+logicalName2Instances.get(firstLine).getSite(path).getInstanceY()+" ,LUT_"+logicalName2Instances.get(firstLine).getLut(path)+"}");
			String lutName;
			while((lutName=in.readLine())!=null){
				System.out.println(lutName);
				System.out.println(logicalName2Instances.get(lutName).getSite(path));
				System.out.println(logicalName2Instances.get(lutName).getLut(path));
				hFile.append(",{"+logicalName2Instances.get(lutName).getSite(path).getInstanceX()+" ,"+logicalName2Instances.get(lutName).getSite(path).getInstanceY()+" ,LUT_"+logicalName2Instances.get(lutName).getLut(path)+"}");
				numberOfTLUTs++;
			}
			hFile.append("}, ");
		}
		hFile.deleteCharAt(hFile.length()-2);
		//Print everything and replace ?? character
		hFile.append("};"+newLine);
		in.close();
		PrintStream stream = new PrintStream(new BufferedOutputStream( new FileOutputStream(args[2])));
		stream.print(hFile.toString().replace("??", ""+numberOfTLUTs));
		
		stream.flush();
		stream.close();
	}
}
