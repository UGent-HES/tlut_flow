import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.simple.ConeSelection;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;
import junit.framework.TestCase;


public class TestMux4ConeSelectionNoParameters extends TestCase {

	
	AIG<Node, Edge> a;
	
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		
		// Read AIG file
		a = new MappingAIG("tests/mux4.aag");

		// Cone enumeration
		ConeEnumeration enumerator = new ConeEnumeration(3); 
        a.visitAll(enumerator);
        a.visitAll(new ConeRanking());
        a.visitAllInverse(new ConeSelection());
	}

	public void test() {
		Node n;
		
		n = a.getNode("i0");
		assertTrue(n.isVisible());
		
		n = a.getNode("i1");
		assertTrue(n.isVisible());
		
		n = a.getNode("i2");
		assertTrue(n.isVisible());
		
		n = a.getNode("i3");
		assertTrue(n.isVisible());
		
		n = a.getNode("s0");
		assertTrue(n.isVisible());
		
		n = a.getNode("s1");
		assertTrue(n.isVisible());

		n = a.getNode("a14");
		assertFalse(n.isVisible());
		n = a.getNode("a16");
		assertFalse(n.isVisible());
		n = a.getNode("a18");
		assertFalse(n.isVisible());
		n = a.getNode("a20");
		assertFalse(n.isVisible());
		n = a.getNode("a22");
		assertTrue(n.isVisible());
		n = a.getNode("a24");
		assertTrue(n.isVisible());
		n = a.getNode("a26");
		assertFalse(n.isVisible());
		n = a.getNode("a28");
		assertFalse(n.isVisible());
		n = a.getNode("a30");
		assertTrue(n.isVisible());
		
		n = a.getNode("o0");
		assertFalse(n.isVisible());


	}
	
}
