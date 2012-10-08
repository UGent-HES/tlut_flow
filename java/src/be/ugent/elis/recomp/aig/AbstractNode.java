package be.ugent.elis.recomp.aig;

import java.util.ArrayList;

public abstract class AbstractNode< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {

	protected String name = null;
	private   NodeType type;
	
	private   ArrayList<E> input;
	private   ArrayList<E> output;
	
	//protected AIG<N,E> aig;

	private boolean marked;
	
	public AbstractNode(AIG<N,E> aig, NodeType type) {
		//this.aig = aig;
		this.type = type;
		input  = new ArrayList<E>(2);
		//input.setSize(2);
		input.add(null);
		input.add(null);
		output = new ArrayList<E>(1);
	}

	public void setName(String name) {
		this.name=name;
		
	}

	public String getName() {
		return name;
	}

	public NodeType getType() {
		return type;
	}

	public boolean isGate() {
		if (type == NodeType.AND)
			return true;
		else 
			return false;
	}

	public boolean isInput() {
		if (type == NodeType.INPUT)
			return true;
		else
			return false;
	}

	public double fanout() {
		return output.size();
	}

	public void addInput(E edge) {
		input.add(edge);
	}

	
	public void addOutput(E edge) {
		output.add(edge);
	}
	
	public void removeOutput(E edge) {
		output.remove(edge);
	}

	public ArrayList<E> fanOut() {
		return output;
	}

	public boolean isOutput() {
		if (type == NodeType.OUTPUT)
			return true;
		else
			return false;
	}
	
	public boolean isLatch() {
		if (type == NodeType.LATCH)
			return true;
		else
			return false;
	}

	public boolean isILatch() {
		if (type == NodeType.ILATCH)
			return true;
		else
			return false;
	}

	public boolean isOLatch() {
		if (type == NodeType.OLATCH)
			return true;
		else
			return false;
	}
	
	
	N in0Node() {
		return this.getI0().getTail();
	}

	@Override
	public String toString() {
		return name;
	}

	N in1Node() {
		return this.getI1().getTail();
	}

	public void setI0(E i0) {
		input.set(0, i0);
	}
	
	public void setI(int i, E e) {
		input.set(i, e);
	}
	

	public E getI0() {
		return input.get(0);
	}

	public void setI1(E i1) {
		input.set(1, i1);
	}

	public E getI1() {
		return input.get(1);
	}

	public void setMarked(boolean marked) {
		this.marked = marked;
	}

	public boolean isMarked() {
		return marked;
	}

	public boolean allFanoutIsMarked() {
		boolean result = true;
		for (E edge:output) {
			if (edge.getHead().isMarked()) {
				result = result && true;
			} else {
				result = result && false;				
			}
		}
		return result;
	}

	public ArrayList<E> getInputEdges() {
		return input;
	}
	
	public ArrayList<E> getOutputEdges() {
		return output;
	}
	
	public int inputIndex(E e) {
		return input.indexOf(e);
	}

	public void replace(N node) {
		for (E out: node.output) {
			out.setTail( (N) this);
			this.addOutput(out);
		}
	}
	
}
