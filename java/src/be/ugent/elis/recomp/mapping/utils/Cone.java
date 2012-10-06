package be.ugent.elis.recomp.mapping.utils;


import java.util.Collections;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;
import java.util.Vector;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.synthesis.BooleanFunction;

public class Cone implements Comparable<Cone>, ConeInterface {
	
	private Node root;
	protected Set<Node> regularLeaves;
//	protected Set<Node> parameterLeaves;

	
	private Vector <Edge> inputEdges;
	private Vector <Node> nodes;
	
	protected int signature;
	
	private double depth;
	private double areaflow;
	private double area;


	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getSignature()
	 */
	public int getSignature() {
		return signature;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#setSignature(int)
	 */
	public void setSignature(int signature) {
		this.signature = signature;
	}


	public Cone() {
		this.root = null;
		this.regularLeaves = new HashSet<Node>();
//		this.parameterLeaves = new HashSet<Node>();
		
		this.inputEdges = null;
		
		this.areaflow = 0;
		this.depth = 0;

	}

	
	public Cone(Node node) {
		this.root = node;
		this.regularLeaves = new HashSet<Node>();
//		this.parameterLeaves = new HashSet<Node>();
		
		this.inputEdges = null;
		
		this.areaflow = 0;
		this.depth = 0;

	}
	
	public static ConeInterface createCone(AIG<Node, Edge> aig, String root, String rleaves, String pLeaves) {
		Cone result = new Cone(aig.getNode(root));
		
		Scanner scan;
		
		scan = new Scanner(rleaves);
		while (scan.hasNext()) {
			result.addRegularLeave(aig.getNode(scan.next()));
		}

		scan = new Scanner(pLeaves);
		while (scan.hasNext()) {
			result.addParameterLeave(aig.getNode(scan.next()));
		}
		
		return result;
	}

	public static Cone mergeCones(Node node, Cone cone0, Cone cone1) {
		Cone result = new Cone(node);
		
		result.signature = cone0.signature | cone1.signature;
		
		result.addLeaves(cone0);
		result.addLeaves(cone1);

		//		BROL
//		if (cone0.isTrivial()) {
//			result.inputEdges.add(node.getI0());
//		} else {
//			result.inputEdges.addAll(cone0.inputEdges);
//		}
//		
//		if (cone1.isTrivial()) {
//			result.inputEdges.add(node.getI1());
//		} else {
//			result.inputEdges.addAll(cone1.inputEdges);
//		}
	
		return result;
	}

	public static Cone trivialCone(Node node) {
		Cone result = new Cone(node);
		result.addLeave(node);
		result.calculateSignature();
		return result;
	}
	
	public static Cone emptyCone(Node node) {
		Cone result = new Cone(node);
		result.calculateSignature();
		return result;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#setRoot(be.ugent.elis.recomp.mapping.utils.Node)
	 */
	public void setRoot(Node root) {
		this.root = root;
		inputEdges = null;
		nodes = null;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getRoot()
	 */
	public Node getRoot() {
		return root;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getParameterLeaves()
	 */
	public Set<Node> getParameterLeaves() {
		Set<Node> result = new HashSet<Node>();
		HashSet<Node> nodesTest = new HashSet<Node>();
		
		nodesTest.addAll(getNodes());
		
		for (Node node: nodesTest) {
			if (node.getI0().getTail().isParameterInput()) {
				result.add(node.getI0().getTail());
			}
			if (node.getI1().getTail().isParameterInput()) {
				result.add(node.getI1().getTail());
			}
		}
		return result;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getRegularLeaves()
	 */
	public Set<Node> getRegularLeaves() {
		return regularLeaves;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#addLeave(be.ugent.elis.recomp.mapping.utils.Node)
	 */
	public void addLeave(Node node) {
		inputEdges = null;
		nodes = null;

		if (node.isParameter() && node.isInput()) {
//			parameterLeaves.add(node);
		} else {
			regularLeaves.add(node);
		}
	}

	public void addRegularLeave(Node node) {
		inputEdges = null;
		nodes = null;

		regularLeaves.add(node);
	}

	public void addParameterLeave(Node node) {
		inputEdges = null;
		nodes = null;

//		parameterLeaves.add(node);
	}

	
	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#addLeaves(be.ugent.elis.recomp.mapping.utils.Cone)
	 */
	public void addLeaves(Cone cone0) {
		inputEdges = null;
		nodes = null;

		this.regularLeaves.addAll(cone0.regularLeaves);
//		this.parameterLeaves.addAll(cone0.parameterLeaves);
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#setDepth(double)
	 */
	public void setDepth(double depth) {
		this.depth = depth;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getDepth()
	 */
	public double getDepth() {
		return depth;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#setAreaflow(double)
	 */
	public void setAreaflow(double areaflow) {
		this.areaflow = areaflow;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getAreaflow()
	 */
	public double getAreaflow() {
		return areaflow;
	}

	protected void calculateSignature() {
		signature = 0;
		for (Node n: regularLeaves) {
			signature |= (1 << (n.hashCode() & 0x1F));
		}
	}
	
	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#isTrivial()
	 */
	public boolean isTrivial() {
		
//		if ((regularLeaves.size() + parameterLeaves.size()) == 1) {
//			if (regularLeaves.contains(this.root) || parameterLeaves.contains(this.root))
		if (regularLeaves.size() == 1) {
			if (regularLeaves.contains(this.root))

				return true;
			else 
				return false;
		} else {
			return false;
		}
	}
	
	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#isTLUT()
	 */
	public boolean isTLUT() {
		if (getParameterLeaves().size()==0) {
			return false;
		}
		
		return true;
	}

//	public Vector<Node> getNodesInToOut() {
//		// TODO Auto-generated method stub
//		return null;
//	}

	//TODO: Migration to TMapCone
	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getNodes()
	 */
	public Vector<Node> getNodes() {
		if (nodes == null) {
			Vector<Node> result = new Vector<Node>();
			Set<Node> visited = new HashSet<Node>();
			nodes = getNodesRec(result,visited, root);
		}
		return nodes;
	}

	//TODO: Migration to TMapCone
	private Vector<Node> getNodesRec(Vector<Node> result, Set<Node> visited, Node node) {
		
		if (!regularLeaves.contains(node) && !node.isParameterInput() && !visited.contains(node)) {
			
			visited.add(node);
//			result.add(node);
			

			switch (node.getType()) {
			case AND:
				getNodesRec(result, visited, node.getI0().getTail());
				getNodesRec(result, visited, node.getI1().getTail());
				break;
			default:
				break;
			}
			
			result.add(node);

		}
		return result;
	}

	//TODO: Migration to TMapCone
//	public Vector<Edge> getInputEdges() {
//		if (inputEdges == null) {
//			Set<Edge> result = new HashSet<Edge>();
//			Set<Node> visited = new HashSet<Node>();
//			result = getInputEdgesRec(result, visited,root);
//			inputEdges = new Vector<Edge>();
//			inputEdges.addAll(result);
//		}
//		return inputEdges;
//	}
	
	//TODO: Migration to TMapCone
//	private Set<Edge> getInputEdgesRec(Set<Edge> set, Set<Node> visited, Node node) {
//		
//		if (!regularLeaves.contains(node) && !parameterLeaves.contains(node) && !visited.contains(node)) {
//			switch (node.getType()) {
//			case AND:
//				if (regularLeaves.contains(node.getI0().getTail()) || parameterLeaves.contains(node.getI0().getTail())) {
//					set.add(node.getI0());
//				} 
//				if (regularLeaves.contains(node.getI1().getTail()) || parameterLeaves.contains(node.getI1().getTail())) {
//					set.add(node.getI1());
//				}
//				visited.add(node);
//				getInputEdgesRec(set, visited, node.getI0().getTail());
//				getInputEdgesRec(set, visited, node.getI1().getTail());			
//			}
//		}
//		
//		return set;	
//	}

//	//TODO: Migration to TMapCone
//	public boolean isInternalEdge(Edge e) {
//		Vector<Node> nodes = getNodes();
//		
//		if (nodes.contains(e.getTail()) && nodes.contains(e.getHead())) {
//			return true;
//		} else { 
//			return false;
//		}
//	}

	//TODO: Migration to TMapCone
//	public boolean isInputEdge(Edge e) {
//		Vector<Edge> edges = getInputEdges();
//		if (edges.contains(e)) {
//			return true;
//		} else { 
//			return false;
//		}
//	}

	
	//TODO: Migration to TMapCone	
	public BooleanFunction getBooleanFunction() {
	
		String inputVariables = new String();
		Vector<Node> allNodes = new Vector<Node>();
		allNodes.addAll(regularLeaves);
//		allNodes.addAll(parameterLeaves);
		for (Node n : allNodes) {
			inputVariables += " "+n.getName();
		}
		
		String outputVariable = root.getName();
		
		String expression = getExpressionRec(root.getI0()) + " " + getExpressionRec( root.getI1()) + " *"; 
			
		BooleanFunction result = new BooleanFunction(outputVariable,inputVariables,expression);
		
		return result;
	}

	//TODO: Migration to TMapCone
	private String getExpressionRec(Edge e) {
		String result = new String();
		Node source = e.getTail();
		
		if (regularLeaves.contains(source)) {
//		if (regularLeaves.contains(source) || parameterLeaves.contains(source)) {
			result += source.getName();
		} else {
			result += getExpressionRec( source.getI0()) + " " + getExpressionRec( source.getI1()) + " *";
		}	
			
		if (e.isInverted()) {
			result += " -";
		}
		
		return result;
	}

	public boolean dominates(Cone cone) {
		int test = this.signature & (~ cone.signature);
		if (test==0)
			return cone.regularLeaves.containsAll(this.regularLeaves);
		else
			return false;
	}

//	public int numParameters() {
//		return parameterLeaves.size();
//	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getRegularInputs()
	 */
	public Vector<Node> getRegularInputs() {
		Vector<Node> result = new Vector<Node>();

		result.addAll(regularLeaves);
		
		return result;
	}
	
//	public Vector<Node> getParameterInputs() {
//		Vector<Node> result = new Vector<Node>();
//		
//		result.addAll(parameterLeaves);
//		
//		return result;
//	}
	
//	public Vector<Node> getLeaves() {
//		if (nodes == null) {
//			Vector<Node> result = new Vector<Node>();
//			Set<Node> visited = new HashSet<Node>();
//			nodes = getNodesRec(result,visited, root);
//		}
//		return nodes;
//	}
//
//
//	private Vector<Node> getLeavesRec(Vector<Node> result, Set<Node> visited, Node node) {
//		
//		if (!regularLeaves.contains(node) && !node.isParameterInput() && !visited.contains(node)) {
//			
//			visited.add(node);
//			
//
//			switch (node.getType()) {
//			case AND:
//				getNodesRec(result, visited, node.getI0().getTail());
//				getNodesRec(result, visited, node.getI1().getTail());
//				break;
//			default:
//				break;
//			}
//			
//			result.add(node);
//
//		}
//		return result;
//	}


	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#size()
	 */
	public int size() {
		return regularLeaves.size();
	}


	
	
	public int compareTo(Cone o) {
		if (this.root == o.root) {
			if (this.regularLeaves.equals(o.regularLeaves)) {
//				if (this.parameterLeaves.equals(o.parameterLeaves)) {
					return 0;
//				}
			}
		}
		return -1;
	}

	@Override
	public boolean equals(Object obj) {
		Cone o = (Cone) obj;
		if (this.root == o.root) {
			if (this.regularLeaves.equals(o.regularLeaves)) {
//				if (this.parameterLeaves.equals(o.parameterLeaves)) {
					return true;
//				}
			}
		}
		return false;
	}

	public boolean equals(String root, String rleaves, String pleaves) {
		
		Scanner scan;
		
		Set<String> regularLeaveNames = new HashSet<String>();
		for (Node n:this.regularLeaves) {
			regularLeaveNames.add(n.getName());
		}
		
		Set<String> rLeaveNames = new HashSet<String>();		
		scan = new Scanner(rleaves);
		while (scan.hasNext()) {
			rLeaveNames.add(scan.next());
		}
		
//		Set<String> parameterLeaveNames = new HashSet<String>();
//		for (Node n:this.parameterLeaves) {
//			parameterLeaveNames.add(n.getName());
//		}
		
		Set<String> pLeaveNames = new HashSet<String>();		
		scan = new Scanner(pleaves);
		while (scan.hasNext()) {
			pLeaveNames.add(scan.next());
		}
		
//		if (this.root.getName().equals(root)) {
//			if (regularLeaveNames.equals(rLeaveNames) && parameterLeaveNames.equals(pLeaveNames)) {
//				return true;
//			}
//		} 

		return false;
		
	}

	

	@Override
	public int hashCode() {
		int result = this.root.hashCode();
		for (Node n:regularLeaves)
			result ^= n.hashCode();
//		for (Node n:parameterLeaves)
//			result ^= n.hashCode();	
		return result;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#toString()
	 */
	@Override
	public String toString() {
		String result = new String();
		result  = "(" + this.root.getName() + ",";
		
		result += "{";
		
		Vector<String> nodesNames = new Vector<String>();
		for (Node n:regularLeaves) {
			nodesNames.add(n.getName());
		}
		Collections.sort(nodesNames);
		
		for (int i=0; i < nodesNames.size(); i++) {
			if (i !=0)
				result += ",";
			result += nodesNames.get(i);
		}
//		result += "},";
//
//		result += "{";
//
//		nodesNames = new Vector<String>();
//		for (Node n:parameterLeaves) {
//			nodesNames.add(n.getName());
//		}
//		Collections.sort(nodesNames);
//		for (int i=0; i < nodesNames.size(); i++) {
//			if (i !=0)
//				result += ",";
//			result += nodesNames.get(i);
//		}
		result += "})";

		return result;
	}

	/* (non-Javadoc)
	 * @see be.ugent.elis.recomp.mapping.utils.ConeInterface#getMaximumInputDepth()
	 */
	public double getMaximumInputDepth() {
		double result=0;
		
		for (Node n: regularLeaves) {
			if (n.depth>result)
				result = n.depth;
		}
		return result;
	}

	public double getArea() {
		return area;
	}

	public void setArea(double area) {
		this.area = area;
	}

	
	
	
}
