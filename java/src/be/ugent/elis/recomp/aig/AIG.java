package be.ugent.elis.recomp.aig;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Scanner;
import java.util.Set;
import java.util.Vector;
import java.util.ArrayList;

import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.utils.Node;

public class AIG< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {
	
	N         const0;
	
	ArrayList<N> input;
	
	ArrayList<N> ilatch;
	ArrayList<N> latch;
	ArrayList<N> olatch;
	
	ArrayList<N> and;
	
	ArrayList<N> output;
	
	ArrayList<E> edges;
	
	ElementFactory<N,E> factory;
	
	Map<String,N> nodeMap;
	HashMap<StrashKey<N, E>, N> strashMap;

	public AIG(ElementFactory<N,E> factory){
		input  = new ArrayList<N>();
		ilatch = new ArrayList<N>();
		latch  = new ArrayList<N>();
		olatch = new ArrayList<N>();
		and    = new ArrayList<N>();
		output = new ArrayList<N>();
		edges  = new ArrayList<E>();
		this.factory = factory;
		
		strashMap = new HashMap<StrashKey<N,E>,N>();
		
		N con = factory.newConst0(this);
		this.const0 = con;
		con.setName("const0");
	}
	
	public AIG(ElementFactory<N,E> factory, String fileName) throws FileNotFoundException{
		input  = new ArrayList<N>();
		ilatch = new ArrayList<N>();
		latch  = new ArrayList<N>();
		olatch = new ArrayList<N>();
		and    = new ArrayList<N>();
		output = new ArrayList<N>();
		edges  = new ArrayList<E>();
		this.factory = factory;

		strashMap = new HashMap<StrashKey<N,E>,N>();
		
		this.readAAG(fileName);
	}
	
	public AIG( AIG<N,E> aig) {
		input  = new ArrayList<N>();
		ilatch = new ArrayList<N>();
		latch  = new ArrayList<N>();
		olatch = new ArrayList<N>();
		and    = new ArrayList<N>();
		output = new ArrayList<N>();
		edges  = new ArrayList<E>();
		this.factory = aig.factory;
	
		strashMap = new HashMap<StrashKey<N,E>,N>();
		
		Map<N,N> findCopy = new HashMap<N,N>();
		
		N con = factory.newConst0(this);
		this.const0 = con;
		con.setName("const0");
		findCopy.put(aig.getConst0(), con);
		
		for (N node:aig.input) {
			N copy = factory.newInput(this);
			input.add(copy);
			findCopy.put(node, copy);
		}
		for (N node:aig.ilatch) {
			N copy = factory.newILatch(this);
			ilatch.add(copy);
			findCopy.put(node, copy);
		}
		for (N node:aig.latch) {
			N copy = factory.newLatch(this);
			latch.add(copy);
			findCopy.put(node, copy);
		}
		for (N node:aig.olatch) {
			N copy = factory.newOLatch(this);
			olatch.add(copy);
			findCopy.put(node, copy);
		}
		for (N node:aig.and) {
			N copy = factory.newAnd(this);
			and.add(copy);
			findCopy.put(node, copy);
		}
		for (N node:aig.output) {
			N copy = factory.newOutput(this);
			output.add(copy);
			findCopy.put(node, copy);
		}
		
		//Set names of the copies
		for (N node: aig.getAllNodes()) {
			findCopy.get(node).setName(node.getName());
		}
		
		//Copy the edges
		for (E edge: aig.getAllEdges()) {
			N tail = findCopy.get(edge.getTail());
			N head = findCopy.get(edge.getHead());
			
			E copy = factory.newEdge(tail, head, edge.isInverted());
			edges.add(copy);
			
			tail.addOutput(copy);
			head.setI(edge.getInputIndex(), copy);
			
		}
		

	}

	private void readAAG(String filename) throws FileNotFoundException {
		
		FileInputStream stream = new FileInputStream(new File(filename));
		Scanner scan = new Scanner(stream);
		
		scan.next();
		int M = scan.nextInt();
		int I = scan.nextInt();
		int L = scan.nextInt();
		int O = scan.nextInt();
		int A = scan.nextInt();

		Vector<N> variable = new Vector<N>();
		variable.setSize(M+1);
		
		
		N con = factory.newConst0(this);
		this.const0 = con;
		con.setName("const0");
		variable.set(0, con);
				
		for (int i=0; i<I; i++) {
			int var = scan.nextInt()/2;
			N in =  factory.newInput(this);
			input.add(in);
			variable.set(var,in);
		}
		
		for (int l=0;l<L; l++) {
			int lit = scan.nextInt();
			scan.nextInt();
			N ilatch = factory.newILatch(this);
			this.ilatch.add(ilatch);
			N latch  = factory.newLatch(this);
			this.latch.add(latch);			
			N olatch = factory.newOLatch(this);
			this.olatch.add(olatch);
			
			variable.set(lit/2, olatch);
		}
		
		for (int o=0; o<O; o++) {
			scan.nextInt();
			N out = factory.newOutput(this);
			output.add(out);
		}
		
		for (int i=0; i<A; i++) {
			int lit = scan.nextInt();
			scan.nextInt();
			scan.nextInt();
			N and = factory.newAnd(this);
			
			and.setName("a"+Integer.toString(lit));
			
			this.and.add(and);
			variable.set(lit/2, and);
		}
		
		//Setting the symbol names
		String word = scan.next();
		while (word.charAt(0) != 'c') {
			int index = Integer.parseInt( word.substring(1) );
			switch (word.charAt(0)) {
			case 'i':
				variable.get(index+1).setName(scan.next());
				break;
			case 'o':
				output.get(index).setName(scan.next());
				break;
			case 'l':
				String name = scan.next();
				ilatch.get(index).setName(name+"_i");
				latch.get(index).setName(name);
				olatch.get(index).setName(name);
				break;
			default:
				break;
			}
			word = scan.next();
			
		}
		try {
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		//Second pass: setting the edges
		stream = new FileInputStream(new File(filename));
		scan = new Scanner(stream);
		
		scan.next();
		scan.nextInt();
		scan.nextInt();
		scan.nextInt();
		scan.nextInt();
		scan.nextInt();


		for (int i=0; i<I; i++) {
			scan.nextInt();
		}
		
		for (int l=0; l<L; l++) {
			scan.nextInt();
			int lit = scan.nextInt();
			
			N ilatch = this.ilatch.get(l);
			N latch  = this.latch.get(l);
			N olatch = this.olatch.get(l);
			
			E edge = factory.newEdge(variable.get(lit/2), ilatch, literalIsInverted(lit));
			edges.add(edge);
			ilatch.setI0(edge);
			edge.getTail().addOutput(edge);
			
			E iedge = factory.newEdge(ilatch , latch , false);
			edges.add(iedge);
			latch.setI0(iedge);
			ilatch.addOutput(iedge);

			E oedge = factory.newEdge(latch , olatch , false);
			edges.add(oedge);
			olatch.setI0(oedge);
			latch.addOutput(oedge);
		}
		
		for (int o=0; o<O; o++) {
			int lit = scan.nextInt();

			N out = this.output.get(o);
			
			E edge = factory.newEdge(variable.get(lit/2), out, literalIsInverted(lit));
			edges.add(edge);
			
			out.setI0(edge);
			
			edge.getTail().addOutput(edge);

		}
		
		for (int i=0; i<A; i++) {
			scan.nextInt();
			int lit0 = scan.nextInt();
			int lit1 = scan.nextInt();
			
			N and = this.and.get(i);

			E edge0 = factory.newEdge(variable.get(lit0/2), and,literalIsInverted(lit0));
			edges.add(edge0);

			E edge1 = factory.newEdge(variable.get(lit1/2), and,literalIsInverted(lit1));
			edges.add(edge1);
			
			and.setI0(edge0);
			and.setI1(edge1);
			
			edge0.getTail().addOutput(edge0);
			edge1.getTail().addOutput(edge1);
		}
	}

	private boolean literalIsInverted(int lit) {
		boolean inverted;
		if (lit%2 == 1) { 
			inverted = true;
		} else {
			inverted = false;
		}
		return inverted;
	}

	private void setMarkedAll(boolean marked) {
		for (N n: getAllNodes()) {
			n.setMarked(marked);
		}
	}

	public ArrayList<N> getAllNodes() {
		ArrayList<N> all = new ArrayList<N>();
		all.addAll(input);
		all.addAll(and);
		all.addAll(output);
		all.addAll(ilatch);
		all.addAll(latch);
		all.addAll(olatch);
		return all;
	}
	
	public N getNode(String name) {
		if (nodeMap == null) {
			nodeMap = new HashMap<String,N>();
			for (N node: getAllNodes()) {
				nodeMap.put(node.name, node);
			}
		}
		return nodeMap.get(name); 
	}

	public void visitAll(Visitor<N,E> visitor) {
		visitor.init(this);
		for (N node: this.topologicalOrderInToOut(true, true)) {
			visitor.visit(node);			
		}
	}
	
	public void visitAll(Visitor<N,E> visitor1, Visitor<N,E> visitor2, Visitor<N,E> visitor3) {
		visitor1.init(this);
		visitor2.init(this);
		visitor3.init(this);
		for (N node: this.topologicalOrderInToOut(true, true)) {
			visitor1.visit(node);
			visitor2.visit(node);
			visitor3.visit(node);			
		}
	}
	
	Vector<N> topologicalOrderInToOut(boolean includeInputs, boolean includeOutputs ) {
		setMarkedAll(false);
		
		Vector<N> PO=new Vector<N>();
		PO.addAll(output);
		PO.addAll(ilatch);
		
		Vector<N> intoout = new Vector<N>();
		for (N out : PO) {
			inToOut_rec(out, intoout, includeInputs, includeOutputs);
		}
		
		Vector<N> result = new Vector<N>();
		result.addAll(intoout);
		return result;
	}

	Vector<N> inToOut_rec(N node, Vector<N> vec, boolean includeInputs, boolean includeOutputs) {
		if (!node.isMarked()) {
						
			switch (node.getType()) {
			case AND:
				inToOut_rec(node.in0Node(), vec, includeOutputs, includeOutputs);
				inToOut_rec(node.in1Node(), vec, includeOutputs, includeOutputs);
				vec.add(node);
				node.setMarked(true);
				break;
			case INPUT:
			case OLATCH:
				if (includeInputs)
					vec.add(node);
				node.setMarked(true);
				break;
			case OUTPUT:
			case ILATCH:
				inToOut_rec(node.in0Node(), vec, includeOutputs, includeOutputs);
				if (includeOutputs)
					vec.add(node);
				node.setMarked(true);
				break;
			default:
				break;
			}
		}
		return vec;
	}

	public void visitAllInverse(Visitor<N,E> visitor) {
		visitor.init(this);
		for (N node: this.topologicalOrderOutToIn()) {
			visitor.visit(node);			
		}
	}

	Vector<N> topologicalOrderOutToIn() {
		setMarkedAll(false);
		
		Vector<N> PO=new Vector<N>();
		PO.addAll(output);
		PO.addAll(ilatch);
		
		Vector<N> intoout = new Vector<N>();
		for (N out : PO) {
			outToIn_rec(out, intoout);
		}
		
		Vector<N> result = new Vector<N>();
		result.addAll(intoout);
		return result;
	}


	private Vector<N> outToIn_rec(N node, Vector<N> vec) {
		

		if (!node.isMarked()) {
			
			switch (node.getType()) {
			case AND:
				if(node.allFanoutIsMarked()) {
					vec.add(node);
					node.setMarked(true);
					outToIn_rec(node.in0Node(), vec);
					outToIn_rec(node.in1Node(), vec);
				}
				break;
			case INPUT:
			case OLATCH:
				if(node.allFanoutIsMarked()) {
					vec.add(node);
					node.setMarked(true);
				}
				break;
			case OUTPUT:
			case ILATCH:
				vec.add(node);
				node.setMarked(true);
				outToIn_rec(node.in0Node(), vec);
				break;
			default:
				break;
			}	
		}
		return vec;
		
	}

	public ArrayList<N> getInputs() {
		return input;
	}

	public ArrayList<N> getOutputs() {
		return output;
	}

	public ArrayList<N> getAnds() {
		return and;
	}

	public ArrayList<N> getLatches() {
		return latch;
	}

	public ArrayList<N> getILatches() {
		return ilatch;
	}

	public ArrayList<N> getOLatches() {
		return olatch;
	}
	
	public N getConst0() {
		return const0;
	}

	public void setConst0(N const0) {
		this.const0 = const0;
	}
	
	public boolean hasLatch() {
		if (latch.isEmpty())
			return false;
		else
			return true;
	}

	public ArrayList<E> getAllEdges() {
		return edges;
	}
	
	public void printAAG(PrintStream stream) {
		ArrayList<N> variable = new ArrayList<N>();
		variable.add(const0);
		variable.addAll(input);
		variable.addAll(olatch);
		variable.addAll(and);
		
//		Vector<N> andsTopoOrder = this.topologicalOrderInToOut(false, false);
//		variable.addAll(andsTopoOrder);
		
		Map<N,Integer> variableIndex = new HashMap<N,Integer>();
		for (int i=0; i<variable.size(); i++) {
			variableIndex.put(variable.get(i), i);
		}
		
		stream.println("aag "+ (variable.size()-1) + " " + input.size() + " " + latch.size() + " " + output.size() + " " + and.size());
		
		for (N n: input) {
			int var = 2* variableIndex.get(n);
			stream.println(var);
		}
		
		for (N n: olatch) {
			int var = 2* variableIndex.get(n);
			
			N latch = n.getI0().getTail();
			N ilatch = latch.getI0().getTail();
			int lit = 2* variableIndex.get(ilatch.getI0().getTail());
			if (ilatch.getI0().isInverted()) {
				lit += 1; 
			}
			
			stream.println(var+ " " + lit);
		}
		
		for (N n: output) {
			int lit = 2 * variableIndex.get(n.getI0().getTail());
			if (n.getI0().isInverted()) {
				lit += 1;
			}
			
			stream.println(lit);
		}
		
//		for (N n: andsTopoOrder) {
		for (N n: and) {
			int var = 2* variableIndex.get(n);
			
			int lit0 = 2 * variableIndex.get(n.getI0().getTail());
			if (n.getI0().isInverted()) {
				lit0 += 1;
			}
			
			int lit1 = 2 * variableIndex.get(n.getI1().getTail());
			if (n.getI1().isInverted()) {
				lit1 += 1;
			}
			
			if ( lit0 >= lit1)
				stream.println(var+ " " + lit0 + " " + lit1);
			else 
				stream.println(var+ " " + lit1 + " " + lit0);
		}
		
		//Symbol names
		for (int i=0; i<input.size(); i++) {
			stream.println ("i"+ i +" "+ input.get(i).getName());
		}

		for (int l=0; l<latch.size(); l++) {
			stream.println ("l"+ l +" "+ latch.get(l).getName());
		}
		
		for (int o=0; o<output.size(); o++) {
			stream.println("o"+ o + " " + output.get(o).getName());
		}
		
		stream.println("c");
		stream.println();	
		stream.flush();
	}

	public void printGraph(PrintStream stream) {
		
		stream.println("digraph G {");
		
		stream.println("{");
		stream.println("  rank = same;");
		for (N n: input) {
//			stream.println(n.getName()+"[shape = point, style = filled, fillcolor = white, width = 0.3];");
			stream.println(n.getName()+";");
		}
		stream.println("}");		
		
		stream.println("{");
		stream.println("  rank = same;");
		for (N n: output) {
//			stream.println(n.getName()+"[shape = point, style = filled, fillcolor = white, width = 0.3];");
			stream.println(n.getName()+";");
		}
		stream.println("}");		


		for (E e: edges) {
			stream.print(e.getTail().getName() + " -> " + e.getHead().getName());
			if (e.isInverted()) {
				stream.print("[arrowhead = dot]");
			}
			stream.println(";");
		}
		
		stream.println("}");
		stream.flush();
	}
	
	
	public void printAAGevaluator(PrintStream stream) {
		
		Vector<N> variable = new Vector<N>();
		variable.add(const0);
		variable.addAll(input);
		variable.addAll(and);
		
		Map<N,Integer> variableIndex = new HashMap<N,Integer>();
		for (int i=0; i<variable.size(); i++) {
			variableIndex.put(variable.get(i), i);
		}
		
		
		stream.println("void evaluate(int *parameter, int *output) {");
		
		stream.println("	int node["+variable.size()+"];");
		
		stream.println("	node[0] = 0;");
		
		for (int i=0; i<input.size(); i++) {
			N n = input.get(i);
			int current = variableIndex.get(n);
			stream.println("	node["+current+"] = parameter["+i+"];");
		}
		
		
		for (N n: this.topologicalOrderInToOut(false, true)) {
			
			switch (n.getType()) {
			case AND:
				int current = variableIndex.get(n);
				int child0  = variableIndex.get(n.getI0().getTail());
				int child1  = variableIndex.get(n.getI1().getTail());
				
				stream.print("	node["+current+"] = ");

				if (n.getI0().isInverted()) {
					stream.print("!");
				}
				stream.print("node["+child0+"]");
				
				stream.print(" && ");

				if (n.getI1().isInverted()) {
					stream.print("!");
				}
				stream.print("node["+child1+"]");

				stream.println(";");
				
				break;
				
			case OUTPUT:
				int out = this.output.indexOf(n);
				int child  = variableIndex.get(n.getI0().getTail());
				
				stream.println("	output["+out+"] = node["+child+"];");

				break;
				
			default:
				break;
			}
			
		}

		stream.println("}");
		
		stream.println("void main() {");
		stream.println("	int i;");
		stream.println("	int parameter["+this.input.size()+"];");
		stream.println("	int output["+this.output.size()+"];");
		stream.println("	for (i=0;i<1000;i++) {");
		stream.println("		evaluate(parameter,output);");
		stream.println("	}");
		stream.println("}");
		
		
		stream.flush();
	}

	public void printAAGevaluator2(PrintStream stream) {
		int max = 0;
		StringBuilder file = new StringBuilder();
		String newLine = System.getProperty("line.separator");
		Vector<N> inToOut = topologicalOrderInToOut(true, true);
		setMarkedAll(false);
		
		PriorityQueue<Integer> freeVariablePool = new PriorityQueue<Integer>();
		for (int i = 0; i < 2 + input.size() + and.size(); i++) {
			freeVariablePool.add(i);
		}
	
		Map<N,Integer> variableIndex = new HashMap<N,Integer>();
		
		file.append("void evaluate(int *parameter, int *output) {"+newLine);
		
		file.append("	int node[??];"+newLine);

		variableIndex.put(const0, freeVariablePool.poll());
		file.append("	node["+variableIndex.get(const0)+"] = 0;"+newLine);

		
		for (N n: inToOut) {
			System.out.println(n.getName());
			
			switch (n.getType()) {
			case INPUT:
				variableIndex.put(n, freeVariablePool.poll());
				file.append("	node["+variableIndex.get(n)+"] = parameter["+input.indexOf(n)+"];"+newLine);//

				break;
			case AND:
				variableIndex.put(n, freeVariablePool.poll());

				int current = variableIndex.get(n);
				
				
				int child0  = variableIndex.get(n.getI0().getTail());
				int child1  = variableIndex.get(n.getI1().getTail());
				
				file.append("	node["+current+"] = ");

				if (n.getI0().isInverted()) {
					file.append("!");
				}
				file.append("node["+child0+"]");
				
				file.append(" && ");

				if (n.getI1().isInverted()) {
					file.append("!");
				}
				file.append("node["+child1+"]");

				file.append(";"+newLine);
				
				
				n.setMarked(true);
				
				if (n.getI0().getTail().allFanoutIsMarked()) {
					freeVariablePool.add(child0);
					variableIndex.remove(n.getI0().getTail());
				}

				if (n.getI1().getTail().allFanoutIsMarked()) {
					freeVariablePool.add(child1);
					variableIndex.remove(n.getI1().getTail());
				}

				
				break;
				
			case OUTPUT:
				int out = this.output.indexOf(n);
				int child  = variableIndex.get(n.getI0().getTail());
				
				if (n.getI0().isInverted()) {
					file.append("	output["+out+"] = !node["+child+"];"+newLine);
				}else{
					file.append("	output["+out+"] = node["+child+"];"+newLine);
				}
				
				
				
				n.setMarked(true);

				break;
				
			default:
				break;
			}
			
			if (freeVariablePool.peek() > max) {
				max = freeVariablePool.peek();
			}
			
		}
		

		file.append("}"+newLine);
		
		file.append("void main() {"+newLine);
		file.append("	int i;"+newLine);
		file.append("	int parameter["+this.input.size()+"];"+newLine);
		file.append("	int output["+this.output.size()+"];"+newLine);
		file.append("	for (i=0;i<1000;i++) {"+newLine);
		file.append("		evaluate(parameter,output);"+newLine);
		file.append("	}"+newLine);
		file.append("}"+newLine);
		
		stream.print(file.toString().replace("??", ""+max));
		
		stream.flush();
		
		System.out.println("Maximum index: " + max);
	}

	public void printAAGevaluatorXilinx(PrintStream stream) {
		int max = 0;
		StringBuilder file = new StringBuilder();
		String newLine = System.getProperty("line.separator");
		Vector<N> inToOut = topologicalOrderInToOut(true, true);
		setMarkedAll(false);
		
		PriorityQueue<Integer> freeVariablePool = new PriorityQueue<Integer>();
		for (int i = 0; i < 2 + input.size() + and.size(); i++) {
			freeVariablePool.add(i);
		}
	
		Map<N,Integer> variableIndex = new HashMap<N,Integer>();
		
		file.append("#include \"xutil.h\""+newLine+"#include \"xbasic_types.h\""+newLine+newLine);
		file.append("#include <xhwicap_clb_lut.h>"+newLine+"#include <xhwicap_clb_lut_struct.h>"+newLine+newLine);
		file.append("#include <xhwicap.h>"+newLine+"#include <xstatus.h>"+newLine+"#include <xparameters.h>"+newLine+newLine);
		file.append("#include \"locations.h\""+newLine+"#include \"lutlocation_type.h\""+newLine+newLine);
		
		file.append("#define HWICAP_DEVICEID       XPAR_OPB_HWICAP_0_DEVICE_ID"+newLine+"#define XHI_TARGET_DEVICEID   XHI_XC2VP30"+newLine+newLine);
		
		file.append("void evaluate(Xuint8 *parameter, Xuint8 (*output)[16]) {"+newLine);
		
		file.append("	Xuint8 node[??];"+newLine);

		variableIndex.put(const0, freeVariablePool.poll());
		file.append("	node["+variableIndex.get(const0)+"] = 0;"+newLine);

		
		for (N n: inToOut) {
			System.out.println(n.getName());
			
			switch (n.getType()) {
			case INPUT:
				variableIndex.put(n, freeVariablePool.poll());
				file.append("	node["+variableIndex.get(n)+"] = parameter["+input.indexOf(n)+"];"+newLine);//

				break;
			case AND:
				variableIndex.put(n, freeVariablePool.poll());

				int current = variableIndex.get(n);
				
				
				int child0  = variableIndex.get(n.getI0().getTail());
				int child1  = variableIndex.get(n.getI1().getTail());
				
				file.append("	node["+current+"] = ");

				if (n.getI0().isInverted()) {
					file.append("~");
				}
				file.append("node["+child0+"]");
				
				file.append(" & ");

				if (n.getI1().isInverted()) {
					file.append("~");
				}
				file.append("node["+child1+"]");

				file.append(";"+newLine);
				
				
				n.setMarked(true);
				
				if (n.getI0().getTail().allFanoutIsMarked()) {
					freeVariablePool.add(child0);
					variableIndex.remove(n.getI0().getTail());
				}

				if (n.getI1().getTail().allFanoutIsMarked()) {
					freeVariablePool.add(child1);
					variableIndex.remove(n.getI1().getTail());
				}

				
				break;
				
			case OUTPUT:
				int out = this.output.indexOf(n);
				int child  = variableIndex.get(n.getI0().getTail());
				
				if (n.getI0().isInverted()) {
					
					file.append("	output["+(out/16)+"]["+(out%16)+"] = ~node["+child+"] & 1;"+newLine);
				
				} else {
					
					file.append("	output["+(out/16)+"]["+(out%16)+"] = node["+child+"] & 1;"+newLine);
				}
				
				n.setMarked(true);

				break;
				
			default:
				break;
			}
			
			if (freeVariablePool.peek() > max) {
				max = freeVariablePool.peek();
			}
			
		}
		

		file.append("}"+newLine);
		file.append("//reconfigure one (!) instance"+newLine);
		file.append("void reconfigure(XHwIcap *HwIcap, Xuint8 (*newtruthtables)[16], const lutlocation location[] ) {"+newLine);
		file.append("	//reconfigure all the TLUTs one by one"+newLine);
		file.append("	Xuint8 i;"+newLine);
		file.append("	for(i =0;i<"+(this.output.size()/16)+";i++) {"+newLine);
		file.append("		XStatus Status;"+newLine);
		file.append("		Xuint32 ColNum = XHwIcap_mSliceX2Col(location[i].lutCol);"+newLine);
		file.append("		Xuint32 RowNum = XHwIcap_mSliceY2Row(HwIcap, location[i].lutRow);"+newLine);
		file.append("		Xuint32 Slice  = XHwIcap_mSliceXY2Slice(location[i].lutCol, location[i].lutRow);"+newLine);
		file.append("		Status = XHwIcap_SetClbBits(HwIcap, RowNum, ColNum, XHI_CLB_LUT.CONTENTS[Slice][location[i].lutType],newtruthtables[i], 16);"+newLine);
		file.append("	}"+newLine);
		
		file.append("}"+newLine+newLine);
		
		file.append("int main(void) {"+newLine);
		file.append("	static XHwIcap HwIcap;"+newLine);
		file.append("	xil_printf(\"Starting EXOR test...\\n\\r\\n\\r\");"+newLine);
		file.append("	XHwIcap_Initialize(&HwIcap, HWICAP_DEVICEID, XHI_TARGET_DEVICEID);"+newLine);
		file.append("	Xuint8 i;"+newLine);
		file.append("	Xuint8 parameter["+this.input.size()+"];"+newLine);
		file.append("	Xuint8 output["+(this.output.size()/16)+"][16];"+newLine);
		file.append("	xil_printf(\"Configuring the LUTs for p=0...\\n\\r\");"+newLine);
		file.append("	parameter[0]=0;"+newLine);
		file.append("	//reconfigure all the instances once"+newLine);
		file.append("	for (i=0;i<numberOfInstances;i++) {"+newLine);
		file.append("		evaluate(parameter,output);"+newLine);
		file.append("		reconfigure(&HwIcap,output,location_array[i]);"+newLine);
		file.append("		}"+newLine);
		file.append("	xil_printf(\"Configuration Complete!\\n\\r\\n\\r\");"+newLine);
		file.append("	xil_printf(\"Writing 0xDEADBEAF to input register...\\n\\r\");"+newLine);
		file.append("	XIo_Out32(XPAR_OPB_XOR_0_BASEADDR,0xDEADBEAF);"+newLine);
		file.append("	xil_printf(\"Reading output register: %x\\n\\r\\n\\r\",XIo_In32(XPAR_OPB_XOR_0_BASEADDR+4));"+newLine);
		file.append("	xil_printf(\"Configuring the LUTs for p=1...\\n\\r\");"+newLine);
		file.append("	parameter[0]=1;"+newLine);
		file.append("	//reconfigure all the instances once"+newLine);
		file.append("	for (i=0;i<numberOfInstances;i++) {"+newLine);
		file.append("		evaluate(parameter,output);"+newLine);
		file.append("		reconfigure(&HwIcap,output,location_array[i]);"+newLine);
		file.append("		}"+newLine);
		file.append("	xil_printf(\"Configuration Complete!\\n\\r\\n\\r\");"+newLine);
		file.append("	xil_printf(\"Reading output register: %x\\n\\r\\n\\r\",XIo_In32(XPAR_OPB_XOR_0_BASEADDR+4));"+newLine);
		file.append("	xil_printf(\"End EXOR test.\\n\\r\\n\\r\");"+newLine);
		file.append("	return 1;"+newLine);
		file.append("}"+newLine);
		
		stream.print(file.toString().replace("??", ""+max));
		
		stream.flush();
		
		System.out.println("Maximum index: " + max);
	}
	
	public void merge(AIG<N,E> aig ) {
		AIG<N,E> copy = new AIG<N, E>(aig);
		
		this.and.addAll(copy.and);
		this.ilatch.addAll(copy.ilatch);
		this.latch.addAll(copy.latch);
		this.olatch.addAll(copy.olatch);
		copy.and.clear();
		
		
		this.const0.replace(copy.const0);
		
		Set<N> outputSet = new HashSet<N>(this.output);
		outputSet.addAll(copy.output);
		HashSet<N> inputSet = new HashSet<N>(this.input);
		inputSet.addAll(copy.input);
		Set<E> edgesSet = new HashSet<E>(this.edges);
		edgesSet.addAll(copy.edges);
		
		Map<String,N> findOutput = new HashMap<String,N>();
		for (N out:this.output) {
			findOutput.put(out.getName(), out);
		}
		
		Set<N> allInputs = (Set<N>)inputSet.clone();
		for (N in : allInputs) {
			if (findOutput.containsKey(in.getName())) {
				N out = findOutput.get(in.getName());
				E outEdge = out.getI0();
				N outDriver = outEdge.getTail();
				
				out.removeOutput(outEdge);
				
				for (E e: in.getOutputEdges()) {
					e.setTail(outDriver);
					e.setInverted(e.isInverted() ^ outEdge.isInverted());
					outDriver.addOutput(e);
				}
				
				assert outputSet.contains(out);
				outputSet.remove(out);
				inputSet.remove(in);
				edgesSet.remove(outEdge);
			}
		}
		

		this.output = new ArrayList<N>(outputSet);
		this.input = new ArrayList<N>(inputSet);
		this.edges = new ArrayList<E>(edgesSet);
		
	}

	public N addNode(String name, NodeType type) {
		N n = null;
		switch(type) {
		case AND:
			n = factory.newAnd(this);
			and.add(n);
			break;
		case INPUT:
			n = factory.newInput(this);
			input.add(n);
			break;
		case OUTPUT:
			n = factory.newOutput(this);
			output.add(n);
			break;
		case ILATCH:
			n = factory.newILatch(this);
			ilatch.add(n);
			break;
		case LATCH:
			n = factory.newLatch(this);
			latch.add(n);
			break;
		case OLATCH:
			n = factory.newOLatch(this);
			olatch.add(n);
			break;
		default:
			System.out.println("Unknown node type!");
		}
	
		n.setName(name);
		
		return n;
	}

	public E addEdge(N tail, N head, boolean inverted) {
		E e = factory.newEdge(tail, head, inverted);
		edges.add(e);
		return e;
	
	}

	public N findNode(N node0, boolean inv0, N node1, boolean inv1) {
		return strashMap.get(new StrashKey<N,E>(node0, inv0, node1, inv1));
	}

	public N addNode(String name, N node0, boolean inv0, N node1, boolean inv1) {
		N n = factory.newAnd(this);
		and.add(n);
		n.setName(name);
		
		E e = addEdge(node0, n, inv0);
		node0.addOutput(e);
		n.setI0(e);
		
		e = addEdge(node1, n, inv1);
		node1.addOutput(e);
		n.setI1(e);
		
		strashMap.put(new StrashKey<N, E>(node0, inv0, node1, inv1), n);

		return n;
	}

}
