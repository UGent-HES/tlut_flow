package be.ugent.elis.recomp.aig;

public abstract class AbstractEdge< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {

	@Override
	public String toString() {
		
		return "(" + getTail().getName() + ", " + getHead().getName() + ")";
	}

	private N tail;
	private N head;
	private boolean inverted;

	public AbstractEdge(N tail, N head, boolean inverted) {
		this.setTail(tail);
		this.setHead(head);
		this.setInverted(inverted);
	}

	public void setTail(N tail) {
		this.tail = tail;
	}

	public N getTail() {
		return (N) tail;
	}

	public void setHead(N head) {
		this.head = (N) head;
	}

	public N getHead() {
		return head;
	}

	public void setInverted(boolean inverted) {
		this.inverted = inverted;
	}

	public boolean isInverted() {
		return inverted;
	}
	
	public int getInputIndex() {
		return head.inputIndex((E) this);
	}

	
}
