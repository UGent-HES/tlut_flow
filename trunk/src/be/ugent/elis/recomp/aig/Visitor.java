package be.ugent.elis.recomp.aig;

public interface Visitor< N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {

	void visit(N node);

	void init(AIG<N,E> aig);

}
