import java.io.FileNotFoundException;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.utils.Cone;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;
import junit.framework.TestCase;


public class TestMux4ConeEnumerationNoParameters extends TestCase {
	
	AIG<Node, Edge> a;
	
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		
		// Read AIG file
		a = new MappingAIG("tests/mux4.aag");

		// Cone enumeration
		ConeEnumeration enumerator = new ConeEnumeration(3); 
        a.visitAll(enumerator);
	}

	public void testI0() {
        assertEquals(1, a.getNode("i0").getConeSet().size());
		assertTrue(a.getNode("i0").getConeSet().contains(Cone.createCone(a, "i0", "i0", "")));
	}
	
	public void testI1() {
        assertEquals(1, a.getNode("i1").getConeSet().size());
		assertTrue(a.getNode("i1").getConeSet().contains(Cone.createCone(a, "i1", "i1", "")));
	}

	public void testI2() {
		assertEquals(1, a.getNode("i2").getConeSet().size());
		assertTrue(a.getNode("i2").getConeSet().contains(Cone.createCone(a, "i2", "i2", "")));
	}

	public void testI3() {
	    assertEquals(1, a.getNode("i3").getConeSet().size());
	    assertTrue(a.getNode("i3").getConeSet().contains(Cone.createCone(a, "i3", "i3", "")));
	}

    public void testS0() {
        assertEquals(1, a.getNode("s0").getConeSet().size());
        assertTrue(a.getNode("s0").getConeSet().contains(Cone.createCone(a, "s0", "s0", "")));
	}

    public void testS1() {
        assertEquals(1, a.getNode("s1").getConeSet().size());
        assertTrue(a.getNode("s1").getConeSet().contains(Cone.createCone(a, "s1", "s1", "")));
	}
    
    public void testA14() {
        assertEquals(2, a.getNode("a14").getConeSet().size());
		assertTrue(a.getNode("a14").getConeSet().contains(Cone.createCone(a, "a14", "a14", "")));
		assertTrue(a.getNode("a14").getConeSet().contains(Cone.createCone(a, "a14", "i0 s0", "")));    	
    }
    public void testA16() {
        assertEquals(2, a.getNode("a16").getConeSet().size());
		assertTrue(a.getNode("a16").getConeSet().contains(Cone.createCone(a, "a16", "a16", "")));
		assertTrue(a.getNode("a16").getConeSet().contains(Cone.createCone(a, "a16", "i1 s0", "")));
    }
    public void testA18() {
        assertEquals(2, a.getNode("a18").getConeSet().size());
		assertTrue(a.getNode("a18").getConeSet().contains(Cone.createCone(a, "a18", "a18", "")));
		assertTrue(a.getNode("a18").getConeSet().contains(Cone.createCone(a, "a18", "i2 s0", "")));
    }
    public void testA20() {
        assertEquals(2, a.getNode("a20").getConeSet().size());
		assertTrue(a.getNode("a20").getConeSet().contains(Cone.createCone(a, "a20", "a20", "")));
		assertTrue(a.getNode("a20").getConeSet().contains(Cone.createCone(a, "a20", "i3 s0", "")));
    }
    public void testA22() {
        assertEquals(5, a.getNode("a22").getConeSet().size());
		assertTrue(a.getNode("a22").getConeSet().contains(Cone.createCone(a, "a22", "a22", "")));
		assertTrue(a.getNode("a22").getConeSet().contains(Cone.createCone(a, "a22", "a14 a16", "")));
		assertTrue(a.getNode("a22").getConeSet().contains(Cone.createCone(a, "a22", "i0 i1 s0", "")));
		assertTrue(a.getNode("a22").getConeSet().contains(Cone.createCone(a, "a22", "a14 i1 s0", "")));
		assertTrue(a.getNode("a22").getConeSet().contains(Cone.createCone(a, "a22", "a16 i0 s0", "")));
    }
    public void testA24() {
        assertEquals(5, a.getNode("a24").getConeSet().size());
		assertTrue(a.getNode("a24").getConeSet().contains(Cone.createCone(a, "a24", "a24", "")));
		assertTrue(a.getNode("a24").getConeSet().contains(Cone.createCone(a, "a24", "a18 a20", "")));
		assertTrue(a.getNode("a24").getConeSet().contains(Cone.createCone(a, "a24", "i2 i3 s0", "")));
		assertTrue(a.getNode("a24").getConeSet().contains(Cone.createCone(a, "a24", "a18 i3 s0", "")));
		assertTrue(a.getNode("a24").getConeSet().contains(Cone.createCone(a, "a24", "a20 i2 s0", "")));
    }
    public void testA26() {
        assertEquals(3, a.getNode("a26").getConeSet().size());
		assertTrue(a.getNode("a26").getConeSet().contains(Cone.createCone(a, "a26", "a26", "")));        
		assertTrue(a.getNode("a26").getConeSet().contains(Cone.createCone(a, "a26", "a22 s1", "")));        
		assertTrue(a.getNode("a26").getConeSet().contains(Cone.createCone(a, "a26", "a14 a16 s1", "")));        
    }
    public void testA28() {
        assertEquals(3, a.getNode("a28").getConeSet().size());
		assertTrue(a.getNode("a28").getConeSet().contains(Cone.createCone(a, "a28", "a28", "")));        
		assertTrue(a.getNode("a28").getConeSet().contains(Cone.createCone(a, "a28", "a24 s1", "")));        
		assertTrue(a.getNode("a28").getConeSet().contains(Cone.createCone(a, "a28", "a18 a20 s1", "")));        
    }
    public void testA30() {
        assertEquals(5, a.getNode("a30").getConeSet().size());
		assertTrue(a.getNode("a30").getConeSet().contains(Cone.createCone(a, "a30", "a30", "")));        
		assertTrue(a.getNode("a30").getConeSet().contains(Cone.createCone(a, "a30", "a26 a28", "")));        
		assertTrue(a.getNode("a30").getConeSet().contains(Cone.createCone(a, "a30", "a24 a26 s1", "")));        
		assertTrue(a.getNode("a30").getConeSet().contains(Cone.createCone(a, "a30", "a22 a28 s1", "")));        
		assertTrue(a.getNode("a30").getConeSet().contains(Cone.createCone(a, "a30", "a22 a24 s1", "")));
    }
	
	public void testO0() throws FileNotFoundException {
        assertEquals(0, a.getNode("o0").getConeSet().size());
	}
	
}
