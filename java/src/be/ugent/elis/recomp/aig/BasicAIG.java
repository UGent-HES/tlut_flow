package be.ugent.elis.recomp.aig;

import java.io.FileNotFoundException;

public class BasicAIG extends AIG<BasicNode, BasicEdge> {

	public BasicAIG(String fileName) throws FileNotFoundException {
		super(new BasicElementFactory(), fileName);
	}



}
