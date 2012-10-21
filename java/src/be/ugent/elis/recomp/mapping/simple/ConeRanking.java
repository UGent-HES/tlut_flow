package be.ugent.elis.recomp.mapping.simple;

import java.util.Collections;
import java.util.Comparator;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class ConeRanking implements Visitor<Node, Edge> {

	private Comparator<Cone> coneComparator;
	private boolean areaCalculation;
	private boolean areaFlowCalculation;

	public ConeRanking(Comparator<Cone> coneComparator, 
			boolean areaFlowCalculation,
			boolean areaCalculation) {
		this.coneComparator = coneComparator;
		this.areaFlowCalculation = areaFlowCalculation;
		this.areaCalculation = areaCalculation;
	}
	public ConeRanking(Comparator<Cone> coneComparator) {
		this(coneComparator,false,false);
	}

	public void init(AIG<Node, Edge> aig) {
		if (areaFlowCalculation || areaCalculation) {
			for(Node n:aig.getAllNodes())
				n.resetReferences();
			for (Node n : aig.getOutputs()) {
				n.getI0().getTail().incrementReferences();
				referenceCone(n.getI0().getTail());
			}
			for (Node n : aig.getILatches()) {
				n.getI0().getTail().incrementReferences();
				referenceCone(n.getI0().getTail());
			}
			for (Node node : aig.getAllNodes())
				node.setEstimatedFanout((2. * node.getEstimatedFanout() + node.getReferences()) / 3.);
		}
	}

	public void visit(Node node) {

		// Set the area flow and the depth of the
		// primary inputs and there output edges.
		if (node.isInput() || node.isOLatch()) {

			node.setDepth(0.0);
			node.setAreaflow(0.0);

			for (Edge e : node.fanOut()) {
				e.setDepth(0.0);
				e.setAreaflow(0);
			}

			// Set the area flow and the depth of the gates
			// and their output edges
		} else if (node.isGate()) {

			// prepare for exact area calculation
			if (areaCalculation && node.getReferences() != 0)
				dereferenceCone(node);

			// Calculate depth, exact area and area flow for each cone.
			for (Cone c : node.getConeSet()) {
				if(areaCalculation)
					c.setArea(calculateAreaOfCone(c));
				calculateDepth(c);
				calculateAreaflow(c);
			}

			// Select the best cone in the coneset.
			Cone bestCone = bestCone(node);
			node.setBestCone(bestCone);
			node.setDepth(bestCone.getDepth());
			node.setAreaflow(bestCone.getAreaflow());

			// Set the depth and area flow of the edges
			for (Edge e : node.fanOut()) {
				e.setDepth(bestCone.getDepth());
				e.setAreaflow(bestCone.getAreaflow() / node.getEstimatedFanout());
			}

			// reset environment for exact area calculation
			if (areaCalculation && node.getReferences() != 0)
				referenceCone(node);

			// Set the area flow and the depth of the
			// primary outputs.
		} else if (node.isOutput() || node.isILatch()) {
			node.setDepth(node.getI0().getDepth());
			node.setAreaflow(node.getI0().getAreaflow());
		}

		// System.out.println(node.getName());
	}

	protected Cone bestCone(Node node) {
		return Collections.min(node.getConeSet().getCones(), coneComparator);
	}

	private void calculateAreaflow(ConeInterface cone) {

		// Trivial cones should never be chosen they are only used
		// for cone enumeration.
		if (cone.isTrivial()) {

			cone.setAreaflow(Double.POSITIVE_INFINITY);

		} else {

			double areaflow = 0;
			for (Node n: cone.getRegularLeaves())
				areaflow += n.getAreaflow()/n.getEstimatedFanout();

			cone.setAreaflow(areaflow + 1);

		}
	}

	private void calculateDepth(ConeInterface c) {

		// Trivial cones should never be chosen they are only used
		// for cone enumeration.
		if (c.isTrivial()) {

			c.setDepth(Double.POSITIVE_INFINITY);

		} else {
			// Edge maxDepthEdge = Collections.max(c.getInputEdges(), new
			// DepthEdgeComparator());
			// c.setDepth(maxDepthEdge.getDepth());

			c.setDepth(c.getMaximumInputDepth() + 1);

		}
	}

	/* exact area calculation algorithm:
	 * calculating the number of LUTs used in the fanin cone of a node/cone, 
	 * that are NOT used in the fanin of any other currently "visible" (selected) node
	 * 
	 * Start by calculating the number of references/uses of all nodes for the current mapping
	 * In the cone ranking stage: if the current node is part of the mapping, dereference its fanin
	 * for every feasible cone, reference the nodes in its fanin and count those that are not used
	 * by any other node
	 */
	private int dereferenceCone(Node node) {
		int a = 1;
		if (node.isGate()) {
			for (Node n : node.getBestCone().getRegularLeaves()) {
				int r = n.decrementReferences();
				if (r == 0)
					a += dereferenceCone(n);
			}
		}
		return a;
	}

	private int referenceCone(Node node) {
		int a = 1;
		if (node.isGate()) {
			for (Node n : node.getBestCone().getRegularLeaves()) {
				int r = n.incrementReferences();
				if (r == 1)
					a += referenceCone(n);
			}
		}
		return a;
	}

	private int calculateAreaOfCone(ConeInterface c) {
		int a = 1;
		for (Node n : c.getRegularLeaves()) {
			int r = n.incrementReferences();
			if (r == 1)
				a += referenceCone(n);
		}
		int a2 = 1;
		for (Node n : c.getRegularLeaves()) {
			int r = n.decrementReferences();
			if (r == 0)
				a2 += dereferenceCone(n);
		}
		assert (a == a2);
		return a;
	}

}
