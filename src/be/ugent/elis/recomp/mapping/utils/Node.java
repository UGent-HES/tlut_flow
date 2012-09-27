package be.ugent.elis.recomp.mapping.utils;
import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.AbstractNode;
import be.ugent.elis.recomp.aig.NodeType;


public class Node extends AbstractNode<Node,Edge> {

	ConeSet coneSet;
	

	private Cone  bestCone;
	
	double depth;
	private double areaflow;
	private double hight;
	
	private boolean visible;
	
	private boolean parameter;
	
	public Node(AIG<Node, Edge> aig, NodeType type) {
		super(aig, type);
		this.coneSet = new ConeSet(this);
		this.depth = 0;
		this.areaflow = 0;
		this.setVisible(false);
		this.setParameter(false);
	}

	public void setConeSet(ConeSet coneSet) {
		this.coneSet = coneSet;
	}

	
	public void setDepth(double depth) {
		this.depth = depth;
	}

	public void setAreaflow(double areaflow) {
		this.areaflow = areaflow;
	}

	public double getDepth() {
		return depth;
	}

	public double getAreaflow() {
		return areaflow;
	}

	public void addCone(SimpleCone cone) {
		coneSet.add(cone);
	}

	public void addAllCones(ConeSet cones) {
		coneSet.addAll(cones);
	}

	public ConeSet getConeSet() {
		return coneSet;
	}

	public void setVisible(boolean visable) {
		this.visible = visable;
	}

	public boolean isVisible() {
		return visible;
	}

	public void setBestCone(Cone bestCone) {
		this.bestCone = bestCone;
	}

	public Cone getBestCone() {
		return bestCone;
	}

	public void setParameter(boolean parameter) {
		this.parameter = parameter;
	}

	public boolean isParameter() {
		return parameter;
	}
	
	public boolean isParameterInput() {
		
		return isParameter() && isInput();
	}

	public void setHight(double hight) {
		this.hight = hight;
	}

	public double getHight() {
		return hight;
	}

	public void removeConeSet() {
		this.coneSet = null;
	}





}
