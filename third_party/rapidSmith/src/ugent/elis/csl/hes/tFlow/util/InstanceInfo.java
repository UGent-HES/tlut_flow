/*
 * Copyright (c) 2010-2011 Brigham Young University
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

public class InstanceInfo {
	
	private Vector <String> paths;
	
	private Vector <PrimitiveSite> sites;
	
	private Vector <String> luts;//F or G lut
	
	/**
	 * Constructor for a new InstanceInfo
	 */
	public InstanceInfo(){
		paths = new Vector<String>();
		sites = new Vector<PrimitiveSite>();
		luts = new Vector<String>();
	}
	
	public InstanceInfo(String path, PrimitiveSite site, String lut){
	    this();
		//System.out.println(path);
		paths.add(path);
		sites.add(site);
		luts.add(lut);
	}
	
	public void addInstance(String path, PrimitiveSite site, String lut){
		paths.add(path);
		sites.add(site);
		luts.add(lut);
	}
	
	public PrimitiveSite getSite(String path){
		return sites.get(paths.indexOf(path));
	}
	
	public String getLut(String path){
		return luts.get(paths.indexOf(path));
	}
	
	public Vector<String> getPaths(){
		return paths;
	}

}
