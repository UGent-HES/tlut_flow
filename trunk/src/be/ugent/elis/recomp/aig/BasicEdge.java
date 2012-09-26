package be.ugent.elis.recomp.aig;

public class BasicEdge extends AbstractEdge<BasicNode, BasicEdge> {

	public BasicEdge(BasicNode tail, BasicNode head, boolean inverted) {
		super(tail, head, inverted);
	}

}
