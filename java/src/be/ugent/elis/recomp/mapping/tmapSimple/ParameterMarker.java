package be.ugent.elis.recomp.mapping.tmapSimple;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.aig.Visitor;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.Node;

public class ParameterMarker implements Visitor<Node, Edge> {
	
	Set<String> parameter;

	public ParameterMarker(InputStream stream) throws FileNotFoundException {
		parameter = new HashSet<String>();
		Scanner  parameter = new Scanner(stream);
		while (parameter.hasNext()) {
			this.parameter.add(parameter.next());
		}
	}
	
	public void init(AIG<Node, Edge> aig) {
	}

	public void visit(Node node) {
		if (node.isInput()) {
			if (parameter.contains(node.getName())) {
				node.setParameter(true);
			} else {
				node.setParameter(false);
			}
			
		} else if (node.isGate()) {
			Node node0 = node.getI0().getTail();
			Node node1 = node.getI1().getTail();
			
			if (node0.isParameter() && node1.isParameter()) {
				node.setParameter(true);
			} else {
				node.setParameter(false);
			}
		}
	}

}
