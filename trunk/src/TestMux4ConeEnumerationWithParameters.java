import java.io.FileNotFoundException;
import java.io.StringBufferInputStream;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.tmapSimple.ParameterMarker;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;
import junit.framework.TestCase;


@SuppressWarnings("deprecation")
public class TestMux4ConeEnumerationWithParameters extends TestCase {
	
	AIG<Node, Edge> a;
	
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		
		// Read AIG file
		a = new MappingAIG("mux4.aag");
		a.visitAll(new ParameterMarker(new StringBufferInputStream("s0 s1")));

		// Cone enumeration
		ConeEnumeration enumerator = new ConeEnumeration(3); 
        a.visitAll(enumerator);
	}

	public void testI0() {
        Node node = a.getNode("i0");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "i0", "i0", "")));
	}
	
	public void testI1() {
        Node node = a.getNode("i1");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "i1", "i1", "")));
	}

	public void testI2() {
		Node node = a.getNode("i2");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "i2", "i2", "")));
	}

	public void testI3() {
	    Node node = a.getNode("i3");
		assertEquals(1, node.getConeSet().size());
	    assertTrue(node.getConeSet().contains(Cone.createCone(a, "i3", "i3", "")));
	}

    public void testS0() {
        Node node = a.getNode("s0");
		assertEquals(1, node.getConeSet().size());
        assertTrue(node.getConeSet().contains(Cone.createCone(a, "s0", "", "s0")));
	}

    public void testS1() {
        Node node = a.getNode("s1");
		assertEquals(1, node.getConeSet().size());
        assertTrue(node.getConeSet().contains(Cone.createCone(a, "s1", "", "s1")));
	}
    
    public void testA14() {
        Node node = a.getNode("a14");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a14", "i0", "s0")));    	
    }
    public void testA16() {
        Node node = a.getNode("a16");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a16", "i1", "s0")));
    }
    public void testA18() {
        Node node = a.getNode("a18");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a18", "i2", "s0")));
    }
    public void testA20() {
        Node node = a.getNode("a20");
		assertEquals(1, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a20", "i3", "s0")));
    }
    public void testA22() {
        Node node = a.getNode("a22");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a22", "a22", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a22", "i0 i1", "s0")));
    }
    public void testA24() {
        Node node = a.getNode("a24");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a24", "a24", "")));
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a24", "i2 i3", "s0")));
    }
    public void testA26() {
        Node node = a.getNode("a26");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a26", "a22", "s1")));        
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a26", "i0 i1", "s0 s1")));        
    }
    public void testA28() {
        Node node = a.getNode("a28");
		assertEquals(2, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a28", "a24", "s1")));        
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a28", "i2 i3", "s0 s1")));        
    }
    public void testA30() {
        Node node = a.getNode("a30");
		assertEquals(4, node.getConeSet().size());
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a30", "a30", "")));        
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a30", "a24 i0 i1", "s0 s1")));        
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a30", "a22 i2 i3", "s0 s1")));        
		assertTrue(node.getConeSet().contains(Cone.createCone(a, "a30", "a22 a24", "s1")));
    }
	
	public void testO0() throws FileNotFoundException {
        Node node = a.getNode("o0");
		assertEquals(0, node.getConeSet().size());
	}

}
