package be.ugent.elis.recomp.mapping.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.AbstractNode;
import be.ugent.elis.recomp.aig.ElementFactory;
import be.ugent.elis.recomp.aig.NodeType;
import be.ugent.elis.recomp.synthesis.BooleanFunction;

public class MappingAIG extends AIG<Node, Edge> {

	private MappingAIG(ElementFactory<Node, Edge> factory,
			String fileName) throws FileNotFoundException {
		super(factory, fileName);
	}

	public MappingAIG(String fileName) throws FileNotFoundException {
		super(new SimpleElementFactory(), fileName);	
	}

	public MappingAIG(SimpleElementFactory simpleElementFactory) {
		super(new SimpleElementFactory());
	}

	public void printMappedBlif(PrintStream stream) {		
		stream.println(".model top");
	
		stream.print(".inputs");		
		for (AbstractNode<Node, Edge> in : getInputs()) {
			stream.print(" "+in.getName());
		}	
		stream.println();
	
		stream.print(".outputs");		
		for (AbstractNode<Node, Edge> out : getOutputs()) {
			stream.print(" "+out.getName());
		}
		stream.println();
		stream.println();
		
		stream.println(".names "+ getConst0().getName());
		stream.println("0");
		stream.println();
				
		for (AbstractNode<Node, Edge> latch : getLatches()) {
			Edge e = latch.getI0().getTail().getI0();
			
			stream.println(".names "+e.getTail().getName()+" "+latch.getName()+"-edge");
			if (e.isInverted()) {
				stream.println("0 1");
			} else {
				stream.println("1 1");
			}
			
			stream.print(".latch");
			stream.print(" "+latch.getName()+"-edge");
			stream.print(" "+latch.getName());
			stream.println (" re pclk 2");
		}
		stream.println();
		
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				Cone bestCone = and.getBestCone();
				BooleanFunction f  = bestCone.getBooleanFunction();
				stream.println(f.getBlifString());
			}
		}
		

		//The BLIF format is a little annoying.
		for (AbstractNode<Node, Edge> out : getOutputs()) {
			Edge e = out.getI0();
			
			
			if (!e.getTail().getName().equals(out.getName())) {
				stream.println(".names "+e.getTail().getName()+" "+out.getName());
				if (e.isInverted()) {
					stream.println("0 1");
				} else {
					stream.println("1 1");
				}
			} else {
				// In some cases a latch has the same name as an output
				// this should solve that problem.
//				System.out.println("Tets");
			}
			
		}
		
		stream.print(".end ");
		
		stream.flush();
		
	}

	public int numLuts() {
		int result=0;
		for (Node node:getAnds()) {
			if (node.isVisible()) {
				result++;
			}
		}
		return result;
	}
	
	public int numTLuts() {
		int result=0;
		for (Node node:getAnds()) {
			if (node.isVisible()) {
				if (node.getBestCone().isTLUT()) {
					result++;
				}
			}
		}
		return result;
	}

	public double getDepth() {
		Vector<Node> PO = new Vector<Node>();
		PO.addAll(getOutputs());
		PO.addAll(getILatches());
		
		double result = 0;
		for (Node node : PO) {
			if (node.getDepth() > result) {
				result = node.getDepth();
			}
		}
		
		return result;
	}


	public AIG<Node, Edge> constructParamConfig_old(int K) {
		AIG<Node, Edge> aig = new MappingAIG(new SimpleElementFactory());
		
		
		Map<Node,Node> parameterCopyMap = new HashMap<Node, Node>();
		for (Node input:this.getInputs()) {
			if (input.isParameter()) {
				Node copy = aig.addNode(input.getName(), NodeType.INPUT);
				parameterCopyMap.put(input, copy);
			}
		}
		
		for (Node and : getAnds()) {
			if (and.isVisible()) {

				ConeInterface bestCone = and.getBestCone();
				
				
				
				Vector<Node> bestConeNodesInToOut = bestCone.getNodes();
				Vector<Node> regularInputs = bestCone.getRegularInputs();

				
				for (int entry=0; entry < Math.pow(2, K); entry++) {
					Vector<Boolean> entryBinairy = new Vector<Boolean>();
					entryBinairy.setSize(K);
					int temp = entry;
					for (int i = 0; i < K; i++) {
						if (temp % 2 == 0) {
							entryBinairy.set(i, false);
						} else {
							entryBinairy.set(i, true);
						}
						temp = temp / 2;
					}
					
					Map<Node,Node>    copyMap    = new HashMap<Node,Node>();
					Map<Node,Boolean> copyInvMap = new HashMap<Node,Boolean>();
					
					for (Node orig: bestConeNodesInToOut) {
						
						Node origI0   = orig.getI0().getTail();
						Node copyI0;
						boolean invI0;
						if (regularInputs.contains(origI0)) {
							copyI0 = aig.getConst0();
							boolean value = entryBinairy.get(regularInputs.indexOf(origI0));
							invI0  = orig.getI0().isInverted() ^ value;
						} else if (parameterCopyMap.containsKey(origI0)) {
							copyI0 = parameterCopyMap.get(origI0);
							invI0  = orig.getI0().isInverted();
						} else {
							copyI0 = copyMap.get(origI0);
							invI0  = orig.getI0().isInverted() ^ copyInvMap.get(origI0);
						}
						
						Node origI1   = orig.getI1().getTail();
						Node copyI1;
						boolean invI1;
						if (regularInputs.contains(origI1)) {
							copyI1 = aig.getConst0();
							boolean value = entryBinairy.get(regularInputs.indexOf(origI1));
							invI1  = orig.getI1().isInverted() ^ value;
						} else if (parameterCopyMap.containsKey(origI1)) {
							copyI1 = parameterCopyMap.get(origI1);
							invI1  = orig.getI1().isInverted();
						} else {
							copyI1 = copyMap.get(origI1);
							invI1  = orig.getI1().isInverted() ^ copyInvMap.get(origI1);
						}
						
//						Constant propagation
						if ((copyI0 == aig.getConst0()) && (copyI1 == aig.getConst0())) {
							copyMap.put(orig, aig.getConst0());
							if (invI0 && invI1) {
								copyInvMap.put(orig, true);
							} else {
								copyInvMap.put(orig, false);
							}
						} else if (copyI0 == aig.getConst0()) {
							if (invI0) {
								copyMap.put(orig, copyI1);
								copyInvMap.put(orig, invI1);
							} else {
								copyMap.put(orig, aig.getConst0());
								copyInvMap.put(orig, false);
							}
						} else if (copyI1 == aig.getConst0()) {
							if (invI1) {
								copyMap.put(orig, copyI0);
								copyInvMap.put(orig, invI0);
							} else {
								copyMap.put(orig, aig.getConst0());
								copyInvMap.put(orig, false);
							}
//						No constant propagation possible
						} else {
							Node copy = aig.findNode(copyI0, invI0, copyI1, invI1);
							if (copy == null) {
								copy = aig.addNode(and.getName()+"_"+entry+"_"+orig.getName(),copyI0, invI0, copyI1, invI1);
							}
							
							copyMap.put(orig, copy);
							copyInvMap.put(orig, false);
						}
					}
					
					Node output = aig.addNode(and.getName()+"_"+entry, NodeType.OUTPUT);
					Node copyI0 = copyMap.get(and);
					Edge e = aig.addEdge(copyI0, output, copyInvMap.get(and));
					output.setI0(e);
					copyI0.addOutput(e);
					
				}
			}
		}
		return aig;
	}

	public AIG<Node, Edge> constructParamConfig(int K) {
		AIG<Node, Edge> aig = new MappingAIG(new SimpleElementFactory());
		
		
		Map<Node,Node> parameterCopyMap = new HashMap<Node, Node>();
		for (Node input:this.getInputs()) {
			if (input.isParameter()) {
				Node copy = aig.addNode(input.getName(), NodeType.INPUT);
				parameterCopyMap.put(input, copy);
			}
		}
		
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				
				ConeInterface bestCone = and.getBestCone();
				Vector<Node> bestConeNodesInToOut = bestCone.getNodes();
				Vector<Node> regularInputs = bestCone.getRegularInputs();
								
				for (int entry=0; entry < Math.pow(2, K); entry++) {
					Vector<Boolean> entryBinairy = new Vector<Boolean>();
					entryBinairy.setSize(K);
					int temp = entry;
					for (int i = 0; i < K; i++) {
						if (temp % 2 == 0) {
							entryBinairy.set(i, false);
						} else {
							entryBinairy.set(i, true);
						}
						temp = temp / 2;
					}
					
					Map<Node,Node>    copyMap    = new HashMap<Node,Node>();
					Map<Node,Boolean> copyInvMap = new HashMap<Node,Boolean>();
					
					for (Node orig: bestConeNodesInToOut) {
						Node origI0   = orig.getI0().getTail();
						Node copyI0;
						boolean invI0;
						//boolean outputLutXorValue0 = checkOutputLutInversion(origI0) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(origI0) == OutputLutInversion.MixedOuts && orig.getI0().isInverted())? true : false;
						boolean outputLutXorValue0 = checkOutputLutInversion(origI0) == OutputLutInversion.AllOutsInverted ? true : false;
						if (regularInputs.contains(origI0)) {
							copyI0 = aig.getConst0();
							boolean value = entryBinairy.get(regularInputs.indexOf(origI0));
							invI0  = (orig.getI0().isInverted() ^ value) ^ outputLutXorValue0;
						} else if (parameterCopyMap.containsKey(origI0)) {
							copyI0 = parameterCopyMap.get(origI0) ;
							invI0  = orig.getI0().isInverted() ;
						} else {
							copyI0 = copyMap.get(origI0);
							invI0  = orig.getI0().isInverted() ^ copyInvMap.get(origI0);
						}
						
						Node origI1   = orig.getI1().getTail();
						Node copyI1;
						boolean invI1;
						//boolean outputLutXorValue1 = checkOutputLutInversion(origI1) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(origI1) == OutputLutInversion.MixedOuts && orig.getI1().isInverted())? true : false;
						boolean outputLutXorValue1 = checkOutputLutInversion(origI1) == OutputLutInversion.AllOutsInverted ? true : false;
						if (regularInputs.contains(origI1)) {
							copyI1 = aig.getConst0();
							boolean value = entryBinairy.get(regularInputs.indexOf(origI1));
							invI1  = orig.getI1().isInverted() ^ value ^ outputLutXorValue1;
						} else if (parameterCopyMap.containsKey(origI1)) {
							copyI1 = parameterCopyMap.get(origI1);
							invI1  = orig.getI1().isInverted() ;
						} else {
							copyI1 = copyMap.get(origI1);
							invI1  = orig.getI1().isInverted() ^ copyInvMap.get(origI1);
						}
						
//						Constant propagation
						if ((copyI0 == aig.getConst0()) && (copyI1 == aig.getConst0())) {
							copyMap.put(orig, aig.getConst0());
							if (invI0 && invI1) {
								copyInvMap.put(orig, true);
							} else {
								copyInvMap.put(orig, false);
							}
						} else if (copyI0 == aig.getConst0()) {
							if (invI0) {
								copyMap.put(orig, copyI1);
								copyInvMap.put(orig, invI1);
							} else {
								copyMap.put(orig, aig.getConst0());
								copyInvMap.put(orig, false);
							}
						} else if (copyI1 == aig.getConst0()) {
							if (invI1) {
								copyMap.put(orig, copyI0);
								copyInvMap.put(orig, invI0);
							} else {
								copyMap.put(orig, aig.getConst0());
								copyInvMap.put(orig, false);
							}
//						No constant propagation possible
						} else {
							Node copy = aig.findNode(copyI0, invI0, copyI1, invI1);
							if (copy == null) {
								copy = aig.addNode(and.getName()+"_"+entry+"_"+orig.getName(),copyI0, invI0, copyI1, invI1);
							}
							
							copyMap.put(orig, copy);
							copyInvMap.put(orig, false);
						}
					}
							
					if(checkOutputLutInversion(and) == OutputLutInversion.AllOutsInverted || checkOutputLutInversion(and) == OutputLutInversion.MixedOuts){
						Node output = aig.addNode(and.getName()+"not"+"_"+entry, NodeType.OUTPUT);
						Node copyI0 = copyMap.get(and);
						Edge e = aig.addEdge(copyI0, output, !copyInvMap.get(and));
						output.setI0(e);
						copyI0.addOutput(e);
					}
					if(checkOutputLutInversion(and) != OutputLutInversion.AllOutsInverted){
						Node output = aig.addNode(and.getName()+"_"+entry, NodeType.OUTPUT);
						Node copyI0 = copyMap.get(and);
						Edge e = aig.addEdge(copyI0, output, copyInvMap.get(and));
						output.setI0(e);
						copyI0.addOutput(e);
					}
					
					
									
				}
			}
		}
		return aig;
	}

		
	
//	public AIG<Node, Edge> constructParamConfig(int K) {
//		AIG<Node, Edge> aig = new MappingAIG(new SimpleElementFactory());
//		Map<Node, Node> parameterCopy = new HashMap<Node,Node>();
//		
//		
//		//Copying the parameter part of the original AIG
//		//Copying the nodes
//		for (Node n: this.getAllNodes()) {
//			if (n.isParameter()) {
//				Node c = aig.addNode(n.getName(),n.getType());
//				parameterCopy.put(n, c);
//			}
//		}
//		//Copying the edges
//		for (Edge e: this.getAllEdges()) {
//			if (e.getTail().isParameter() && e.getHead().isParameter()) {
//				Edge c = aig.addEdge(parameterCopy.get(e.getTail()),parameterCopy.get(e.getHead()), e.isInverted());
//				c.getTail().addOutput(c);
//				c.getHead().setI(e.getHead().inputIndex(e), c);
//			}
//		}
//		
//		
//
//		for (Node and : getAnds()) {
//			if (and.isVisible()) {
////				System.out.println(and.getName());
////				if (and.getName().equals("a25700"))
////					System.out.println("Arrived");
//				Cone bestCone = and.getBestCone();
//				Vector<Edge> bestConeInputEdges = bestCone.getInputEdges();
//				Vector<Node> bestConeNodes = bestCone.getNodes();
//
//
//				
//				Vector<Node> regularInputs = bestCone.getRegularInputs();
//				
//				for (int entry=0; entry < Math.pow(2, K); entry++) {
//	
//					
//					Vector<Boolean> entryBinairy = new Vector<Boolean>();
//					entryBinairy.setSize(K);
//					int temp = entry;
//					for (int i = 0; i < K; i++) {
//						if (temp % 2 == 0) {
//							entryBinairy.set(i, false);
//						} else {
//							entryBinairy.set(i, true);
//						}
//						temp = temp / 2;
//					}
//					
//					Map<Node,Node> coneCopy = new HashMap<Node, Node>();
//
////					System.out.println("Start");
////					System.out.println(bestConeNodes.size());
//					
//					//Copy non-parameter nodes of the cone
//					for (Node n: bestConeNodes) {	
//						if (!n.isParameter()) {
//							Node copy = aig.addNode(n.getName()+"_"+entry, NodeType.AND);
//							coneCopy.put(n, copy);
//						}
//					}
////					System.out.println("Stop");
//
//
//					//Copy internal edges of the cone
//					for (Node n: bestConeNodes) {
//						if (!n.isParameter()) {
//							Vector<Edge> inputEdges = n.getInputEdges();
//							for (int i=0; i<2; i++) {
//								Edge e = inputEdges.get(i);
//								if (e.getTail().isParameter()) {
//									Edge c = aig.addEdge(parameterCopy.get(e.getTail()), coneCopy.get(n), e.isInverted());
//									c.getTail().addOutput(c);
//									c.getHead().setI(e.getHead().inputIndex(e), c);
//								} else {			
//									if (bestCone.isInternalEdge(e)) {
//										Edge c = aig.addEdge(coneCopy.get(e.getTail()), coneCopy.get(n), e.isInverted());
//										c.getTail().addOutput(c);
//										c.getHead().setI(e.getHead().inputIndex(e), c);
//									} else if (bestConeInputEdges.contains(e)) {
//										Edge c = aig.addEdge(aig.getConst0(), coneCopy.get(n), e.isInverted() ^ entryBinairy.get(regularInputs.indexOf(e.getTail())));
//										c.getTail().addOutput(c);
//										c.getHead().setI(e.getHead().inputIndex(e), c);
//									}
//								}
//							}
//						}
//					}
//
//					
//					Node out = aig.addNode(and.getName()+"_"+entry, NodeType.OUTPUT);
//					Edge c = aig.addEdge(coneCopy.get(and), out, false);
//					c.getTail().addOutput(c);
//					c.getHead().setI0(c);
//
//				}
//			}
//		}
//		
//
//		return aig;
//	}
	
	public enum OutputLutInversion{
		notAnOutputLut, AllOutsNotInverted, AllOutsInverted, MixedOuts
	}
	
	// Determine the OutputLutInversion of an output Lut
	public OutputLutInversion checkOutputLutInversion(Node node){
		// Determine whether it is a node and connected with an output
		boolean isOutput = false;
		Edge firstEdge = null;
		for(Edge e : node.getOutputEdges()){
			Node head = e.getHead();
			if (head.isOutput() || head.isILatch()){
				isOutput = true;
				firstEdge = e;
				break;
			}
		}
		if(!isOutput || !node.isGate()){
			return OutputLutInversion.notAnOutputLut; 
		}
		else{
			// Determine the outputLutInversion
			OutputLutInversion outlutInv; 
			outlutInv = (firstEdge.isInverted()) ? OutputLutInversion.AllOutsInverted : OutputLutInversion.AllOutsNotInverted;
			for(Edge e : node.getOutputEdges()){
				Node head = e.getHead();
				if (head.isOutput() || head.isILatch()){
					if (e.isInverted() && outlutInv == OutputLutInversion.AllOutsNotInverted || (!e.isInverted() && outlutInv == OutputLutInversion.AllOutsInverted)){
						outlutInv = OutputLutInversion.MixedOuts;
						break;
					}
				}
			}
			return outlutInv;
		}
	}
	

	
	public void printLutStructureBlif_old(PrintStream stream, int K) {
		stream.println(".model top");
		
		stream.print(".inputs");		
		for (Node in : getInputs()) {
			if (!in.isParameter()) {
				stream.print(" "+in.getName());
			}
		}
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				for (int entry=0; entry < Math.pow(2,K); entry++) {
					stream.print(" "+and.getName()+"_"+entry);
				}
			}
		}
		stream.println();
	
		stream.print(".outputs");		
		for (Node out : getOutputs()) {
			stream.print(" "+out.getName());
		}
		stream.println();
		stream.println();
		
		stream.println(".names "+ getConst0().getName());
		stream.println("0");
		stream.println();
				
		for (Node latch : getLatches()) {
			Edge e = latch.getI0().getTail().getI0();
			stream.println(".names "+e.getTail().getName()+" "+latch.getName()+"-edge");
			if (e.isInverted()) {
				stream.println("0 1");
			} else {
				stream.println("1 1");
			}
			
			stream.print(".latch");
			stream.print(" "+latch.getName()+"-edge");
			stream.print(" "+latch.getName());
			stream.println (" re pclk 2");
		}
		stream.println();
		
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				ConeInterface bestCone = and.getBestCone();
		
				stream.print(".names");
				for (int entry=0; entry < Math.pow(2,K); entry++) {
					stream.print(" "+and.getName()+"_"+entry);
				}
				int j = 0;
				for (Node n:bestCone.getRegularInputs()) {
					stream.print(" "+n.getName());
					j++;
				}
				while (j < K) {
					stream.print(" const0");
					j++;
				}
				stream.println(" "+and.getName());

				for (int entry=0; entry < Math.pow(2,K); entry++) {
					for (int i =0; i < Math.pow(2,K); i++) {
						if (i==entry) {
							stream.print('1');
						} else {
							stream.print('-');
						}
					}
					
					int temp = entry;
					for (int i = 0; i < K; i++) {
						if (temp % 2 == 0) {
							stream.print('0');
						} else {
							stream.print('1');
						}
						temp = temp / 2;
					}
					
					stream.println(" 1");
				}
				
				stream.println();
				
				
			}
		}
		

		//The BLIF format is a little annoying.
		for (AbstractNode<Node, Edge> out : getOutputs()) {
			Edge e = out.getI0();
			
			if (!e.getTail().getName().equals(out.getName())){
                stream.println(".names "+e.getTail().getName()+" "+out.getName());
                if (e.isInverted()) {
                    stream.println("0 1");
                } else {
                    stream.println("1 1");
                }
			}
		}
		
		stream.print(".end");	
		
		stream.flush();
		
	}

	public void printLutStructureBlif(PrintStream stream, int K) {
		stream.println(".model top");
		
		stream.print(".inputs");		
		for (Node in : getInputs()) {
			if (!in.isParameter()) {
				stream.print(" "+in.getName());
			}
		}
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				if(checkOutputLutInversion(and) == OutputLutInversion.AllOutsInverted || checkOutputLutInversion(and) == OutputLutInversion.MixedOuts){
					for (int entry=0; entry < Math.pow(2,K); entry++) {
						stream.print(" "+and.getName()+"not"+"_"+entry);
					}
				}
				if(checkOutputLutInversion(and) != OutputLutInversion.AllOutsInverted){
					for (int entry=0; entry < Math.pow(2,K); entry++) {
						stream.print(" "+and.getName()+"_"+entry);
					}
				}
			}
		}
		stream.println();
	
		stream.print(".outputs");		
		for (Node out : getOutputs()) {
			stream.print(" "+out.getName());
		}
		stream.println();
		stream.println();
		
		stream.println(".names "+ getConst0().getName());
		stream.println("0");
		stream.println();
				
		for (Node latch : getLatches()) {
			Edge e = latch.getI0().getTail().getI0();
			Node node =  e.getTail();
			if(checkOutputLutInversion(node) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(node) == OutputLutInversion.MixedOuts && e.isInverted())){
				stream.println(".names "+node.getName()+"not"+" "+latch.getName()+"-edge");
				stream.println("1 1");
			}
			else{
				stream.println(".names "+node.getName()+" "+latch.getName()+"-edge");
				if (e.isInverted()) {
					stream.println("0 1");
				} else {
					stream.println("1 1");
				}
			}
			stream.print(".latch");
			stream.print(" "+latch.getName()+"-edge");
			stream.print(" "+latch.getName());
			stream.println (" re pclk 2");
		}
		stream.println();
		
		for (Node and : getAnds()) {
			if (and.isVisible()) {
				if(checkOutputLutInversion(and) == OutputLutInversion.AllOutsInverted || checkOutputLutInversion(and) == OutputLutInversion.MixedOuts){
					printLutBlif(and, stream, K, and.getName()+"not");
				}
				if(checkOutputLutInversion(and) != OutputLutInversion.AllOutsInverted){
					printLutBlif(and, stream, K, and.getName());
				}
				
			}
		}
		

		//The BLIF format is a little annoying.
		for (AbstractNode<Node, Edge> out : getOutputs()) {
			Edge e = out.getI0();
			Node node = e.getTail();
			if(checkOutputLutInversion(node) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(node) == OutputLutInversion.MixedOuts && e.isInverted())){
				stream.println(".names "+node.getName()+"not"+" "+out.getName());
				stream.println("1 1");
			}
			else{
				if (!node.getName().equals(out.getName())){
					stream.println(".names "+node.getName()+" "+out.getName());
					if (e.isInverted()) {
						stream.println("0 1");
					} else {
						stream.println("1 1");
					}
				}
			}	
		}
		
		stream.print(".end");	
		
		stream.flush();
		
	}

	public void printLutBlif(Node visibleAnd, PrintStream stream, int K, String lutName){
		ConeInterface bestCone = visibleAnd.getBestCone(); 
		
		stream.print(".names");
		for (int entry=0; entry < Math.pow(2,K); entry++) {
			stream.print(" "+lutName+"_"+entry);
		}
		int j = 0;
		for (Node n:bestCone.getRegularInputs()) {
			if (checkOutputLutInversion(n) == OutputLutInversion.AllOutsInverted){
				stream.print(" "+n.getName()+"not");
			}
			else{
				stream.print(" "+n.getName());
			}
			j++;
		}
		while (j < K) {
			stream.print(" const0");
			j++;
		}
		stream.println(" "+lutName);

		for (int entry=0; entry < Math.pow(2,K); entry++) {
			for (int i =0; i < Math.pow(2,K); i++) {
				if (i==entry) {
					stream.print('1');
				} else {
					stream.print('-');
				}
			}
			
			int temp = entry;
			for (int i = 0; i < K; i++) {
				if (temp % 2 == 0) {
					stream.print('0');
				} else {
					stream.print('1');
				}
				temp = temp / 2;
			}
			
			stream.println(" 1");
		}
		stream.println();
	} 
	
	
	public void printLutStructureVhdl(String inVhdFile, String vhdFile, int K) throws IOException {
		PrintStream stream = new PrintStream(new File(vhdFile));
		writeHeader(stream, inVhdFile, K);		
		String baseName = vhdFile.substring(0,vhdFile.lastIndexOf('.')).substring(vhdFile.lastIndexOf('/')+1);
	    stream.println("\nbegin");
	    
	    for (Node latch : getLatches()) {
			
					printLatchVhdl(baseName, latch ,stream, K, latch.getName().replace("[","").replace("]",""));	 
				
		}
		
	    
	    
	    for (Node and : getAnds()) {
			if (and.isVisible()) {
				if(checkOutputLutInversion(and) == OutputLutInversion.AllOutsInverted || checkOutputLutInversion(and) == OutputLutInversion.MixedOuts){
					printLutVhdl(baseName, and, stream, K, and.getName()+"not");	 
				}
				if(checkOutputLutInversion(and) != OutputLutInversion.AllOutsInverted){
					printLutVhdl(baseName, and, stream, K, and.getName());
				}
			}	
		}
		

		for (AbstractNode<Node, Edge> out : getOutputs()) {
			Edge e = out.getI0();
			Node node = e.getTail();
			if(checkOutputLutInversion(node) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(node) == OutputLutInversion.MixedOuts && e.isInverted())){
				stream.println(out.getName().replace('[', '(').replace(']', ')')+" <= "+node.getName().replace("[","").replace("]","")+"not;");
				//stream.println("1 1");
			}
			else{
				if (e.isInverted()) {
					stream.println(out.getName().replace('[', '(').replace(']', ')')+" <= not("+node.getName().replace("[","").replace("]","")+");");
				} else {
					stream.println(out.getName().replace('[', '(').replace(']', ')')+" <= "+node.getName().replace("[","").replace("]","")+";");
				}		
			}	
		}	
		stream.print("end;");
	    
		//for (Node latch : getLatches()) {
		//	Edge e = latch.getI0().getTail().getI0();
//			
//			stream.println(".names "+e.getTail().getName()+" "+latch.getName()+"-edge");
//			if (e.isInverted()) {
//				stream.println("0 1");
//			} else {
//				stream.println("1 1");
//			}
//			
//			stream.print(".latch");
//			stream.print(" "+latch.getName()+"-edge");
//			stream.print(" "+latch.getName());
//			stream.println (" re pclk 2");
//		}
//		stream.println();
	}
	
	public void printLutVhdl(String baseName, Node visibleAnd, PrintStream stream, int K, String lutName){
		ConeInterface bestCone = visibleAnd.getBestCone();
		Vector<Node> regularInputs = bestCone.getRegularInputs();
		int lutSize = regularInputs.size();
		String lutInstance = "";
		lutInstance = "\n"+baseName+"_LUT"+lutSize+"_"+lutName+": LUT"+lutSize+"\ngeneric map (\n\tINIT =>X\"1\")\nport map (O => "+lutName;
		for (int i = 0; i < lutSize ; i++){
			//lutInstance = lutInstance + ",\n\tI"+Integer.toString(i)+" => "+regularInputs.get(i).getName().replace('[', '(').replace(']', ')');
			if(checkOutputLutInversion(regularInputs.get(i)) == OutputLutInversion.AllOutsInverted || (checkOutputLutInversion(regularInputs.get(i)) == OutputLutInversion.MixedOuts ))
				lutInstance = lutInstance + ",\n\tI"+Integer.toString(i)+" => "+regularInputs.get(i).getName().replace('[', '(').replace(']', ')')+"not";
			else
			    lutInstance = lutInstance + ",\n\tI"+Integer.toString(i)+" => "+regularInputs.get(i).getName().replace('[', '(').replace(']', ')');
		}
		lutInstance = lutInstance + ");\n";
		
		stream.print(lutInstance);
	} 
	
	
	public void printLatchVhdl(String baseName, Node latch, PrintStream stream, int K, String latchName){
		String latchInstance = "";
		latchInstance = "\n"+"FD_"+latchName+": FD"+"\ngeneric map (\n\tINIT =>\'0\')\nport map (Q => "+latchName;
		latchInstance = latchInstance + ",\n\tC"+" => "+ "clk";
				
		Edge e = latch.getI0().getTail().getI0();
		
		if (e.isInverted()) {
			latchInstance = latchInstance + ",\n\tD"+" => "+ e.getTail().getName()+ "not";
		} else {
			latchInstance = latchInstance + ",\n\tD"+" => "+e.getTail().getName();		
		}
		
		latchInstance = latchInstance + ");\n";
		
		stream.print(latchInstance);
	} 
	
	
	
	private void writeHeader(PrintStream stream, String inVhdFile, int K) throws IOException {
		// Read header old vhdl file as a String
		String baseName = inVhdFile.substring(0,inVhdFile.lastIndexOf('.')).substring(inVhdFile.lastIndexOf('/')+1);
	    BufferedReader vhdlFileReader = new BufferedReader( new FileReader(new File(inVhdFile)));
	    String vhdlFileLine = vhdlFileReader.readLine();
	    String header = "";
	    while(vhdlFileLine.indexOf("architecture") == -1){
	        header = header + vhdlFileLine + '\n' ;
	        vhdlFileLine = vhdlFileReader.readLine();    
	    }
	    
	    String [] headerArray;
	    
	    // Insert unisim library declaration if necessary
	    headerArray = header.split("[e|E][n|N][t|T][i|I][t|T][y|Y]");
	    String libraryString = "-- synopsys translate_off\nlibrary UNISIM;\nuse unisim.Vcomponents.all;\n-- synopsys translate_on\n";
	    if (header.indexOf("library UNISIM;")== -1)
	        header = headerArray[0] + libraryString + "\nentity" + headerArray[1];

	    // Remove ports between --param annotations
	    headerArray = header.split("--[p|P][a|A][r|R][a|A][m|M][\n*]");
	    header = "";
	    for (int index=0;index < headerArray.length;index+=2){
	        header = header.trim() + '\n' + headerArray[index];
	    }
	    stream.println(header.trim());
	    
	    
	    stream.println("\narchitecture rtl of "+baseName+" is");
	    
	    // Add LUT templates 
	    for (int i = 1;i<=K;i++){	
	    	String lutComponent = "component LUT"+Integer.toString(i)+"\ngeneric (\n\tINIT : bit_vector := X\""+Integer.toString((int) java.lang.Math.pow(2, i))+"\");\nport   (O : out STD_ULOGIC";
	    	for(int j = 0;j<i;j++){
	    		lutComponent = lutComponent + "; \n\tI"+Integer.toString(j)+": in STD_ULOGIC";
	    	}
	    	lutComponent = lutComponent + ");\nend component;";
	    	stream.println(lutComponent);
	    }
	    // Add FF template 
	    String ffComponent = "component FD\ngeneric (\n\tINIT : bit:= '1');\nport   (Q : out STD_ULOGIC;\n\tC : in STD_ULOGIC;\n\tD : in STD_ULOGIC);\nend component;";
	    stream.println(ffComponent);
	    
	    // Add declaration of signals and init attributes
	    String signalDeclarations = "";
		String initAttributes = "\nattribute INIT : string;";
		
	    for (Node and : getAnds()) {
			if (and.isVisible()) {	
				ConeInterface bestCone = and.getBestCone();
				Vector<Node> regularInputs = bestCone.getRegularInputs();
				int lutSize = regularInputs.size();
				
				if(checkOutputLutInversion(and) == OutputLutInversion.AllOutsInverted || checkOutputLutInversion(and) == OutputLutInversion.MixedOuts){
					signalDeclarations = signalDeclarations + "\nsignal "+and.getName()+"not : STD_ULOGIC ;";
					initAttributes = initAttributes + "\nattribute INIT of "+baseName+"_LUT"+lutSize+"_"+and.getName()+"not: label is \""+Integer.toString((int) java.lang.Math.pow(2, lutSize))+"\";"; 
				}
				if(checkOutputLutInversion(and) != OutputLutInversion.AllOutsInverted){
					signalDeclarations = signalDeclarations + "\nsignal "+and.getName()+" : STD_ULOGIC ;";
					initAttributes = initAttributes + "\nattribute INIT of "+baseName+"_LUT"+lutSize+"_"+and.getName()+": label is \""+Integer.toString((int) java.lang.Math.pow(2, lutSize))+"\";";
				}
			}	
		}
	    
	    for (Node latch : getOLatches()) {
			
				
					signalDeclarations = signalDeclarations + "\nsignal "+latch.getName().replace("[","").replace("]","") +" : STD_ULOGIC ;";
					initAttributes = initAttributes + "\nattribute INIT of "+"FD"+"_"+latch.getName().replace("[","").replace("]","")+" : label is \"0"+"\";"; 

				
		}
	    
	    
	    stream.println(signalDeclarations);
	    stream.println(initAttributes);
		
	    // Add declaration of lock attributes
		String lockAttributes = "\nattribute lock_pins : string;";
		for (int i = 1;i<=K;i++){	
	    	lockAttributes = lockAttributes + "\nattribute lock_pins of LUT"+Integer.toString(i)+": component is \"ALL\";";
	    }
		stream.println(lockAttributes);
	}

	public double avDupl() {
		int dupCount=0;
		for (Node node:getAnds()) {
			if (node.isVisible()) {
				dupCount += node.getBestCone().getNodes().size();
			}
		}
		return (double)dupCount/this.getAnds().size();
	}	
}
