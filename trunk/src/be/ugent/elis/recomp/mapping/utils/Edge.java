package be.ugent.elis.recomp.mapping.utils;

import be.ugent.elis.recomp.aig.AbstractEdge;
import be.ugent.elis.recomp.aig.AbstractNode;

public class Edge extends AbstractEdge<Node,Edge> {

	double depth;
	private double areaflow;
	private double height;
	
	public Edge(Node tail, Node head, boolean inverted) {
		super(tail, head, inverted);
	}
	
	public void setDepth(double depth) {
		this.depth = depth;
	}
	
	public double getDepth() {
		return depth;
	}
	
	public void setAreaflow(double areaflow) {
		this.areaflow = areaflow;
	}
	
	public double getAreaflow() {
		return areaflow;
	}
	
	public void setHeight(double height) {
		this.height = height;
	}
	
	public double getHeight() {
		return height;
	}

}
