package be.ugent.elis.recomp.aig;

public class BasicElementFactory implements ElementFactory<BasicNode, BasicEdge> {

	public BasicNode newAnd(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.AND);
	}

	public BasicNode newConst0(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.CONST0);
	}

	public BasicEdge newEdge(BasicNode tail, BasicNode head, boolean inverted) {
		return new BasicEdge(tail, head, inverted);
	}

	public BasicNode newILatch(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.ILATCH);
	}

	public BasicNode newInput(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.INPUT);
	}

	public BasicNode newLatch(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.LATCH);
	}

	public BasicNode newOLatch(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.OLATCH);
	}

	public BasicNode newOutput(AIG<BasicNode, BasicEdge> aig) {
		return new BasicNode(aig, NodeType.OUTPUT);
	}

	
	
	
}
