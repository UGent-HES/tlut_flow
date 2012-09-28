import java.io.StringBufferInputStream;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.tmapSimple.ParameterMarker;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;
import junit.framework.TestCase;


public class TestDominanceConeEnumeration extends TestCase {

	
	AIG<Node, Edge> a;
	
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		
		// Read AIG file
		a = new MappingAIG("tests/dominance.aag");
		a.visitAll(new ParameterMarker(new StringBufferInputStream("p0 p1 p2 p3")));

		// Cone enumeration
		ConeEnumeration enumerator = new ConeEnumeration(3); 
        a.visitAll(enumerator);
	}

	public void testP0() {
        Node node = a.getNode("p0");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "p0", "", "p0")));
	}

	public void testP1() {
        Node node = a.getNode("p1");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "p1", "", "p1")));
	}

	public void testP2() {
        Node node = a.getNode("p2");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "p2", "", "p2")));
	}

	public void testP3() {
        Node node = a.getNode("p3");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "p3", "", "p3")));
	}

	public void testI0() {
        Node node = a.getNode("i0");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "i0", "i0", "")));
	}
	
	public void testA12() {
        Node node = a.getNode("a12");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a12", "i0", "p0")));
	}

	public void testA14() {
        Node node = a.getNode("a14");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a14", "i0", "p1")));
	}

	public void testA16() {
        Node node = a.getNode("a16");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a16", "i0", "p2")));
	}

	public void testA18() {
        Node node = a.getNode("a18");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a18", "i0", "p3")));
	}

	public void testA20() {
        Node node = a.getNode("a20");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a20", "a20", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a20", "i0", "p0 p1")));
	}

	public void testA22() {
        Node node = a.getNode("a22");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a22", "a22", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a22", "i0", "p2 p3")));

	}

	public void testA24() {
        Node node = a.getNode("a24");
		assertEquals(3, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a24", "a24", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a24", "a20 a22", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a24", "i0", "p0 p1 p2 p3")));
	}


}
