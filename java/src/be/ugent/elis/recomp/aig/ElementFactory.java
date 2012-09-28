package be.ugent.elis.recomp.aig;

public interface ElementFactory< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {

	public N newConst0(AIG<N, E> aig);
	
	public N newInput(AIG<N, E> aig);
	
	public N newILatch(AIG<N, E> aig);
	
	public N newLatch(AIG<N, E> aig);
	
	public N newOLatch(AIG<N, E> aig);
	
	public N newAnd(AIG<N, E> aig);
	
	public N newOutput(AIG<N, E> aig);
	
	public E newEdge(N tail, N head, boolean inverted);
	
}
