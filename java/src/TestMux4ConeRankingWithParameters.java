import java.io.FileNotFoundException;
import java.io.StringBufferInputStream;

import be.ugent.elis.recomp.aig.AIG;
import be.ugent.elis.recomp.mapping.simple.ConeEnumeration;
import be.ugent.elis.recomp.mapping.simple.ConeRanking;
import be.ugent.elis.recomp.mapping.tmapSimple.ParameterMarker;
import be.ugent.elis.recomp.mapping.utils.ConeInterface;
import be.ugent.elis.recomp.mapping.utils.Edge;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;
import junit.framework.TestCase;


public class TestMux4ConeRankingWithParameters extends TestCase {
	
	AIG<Node, Edge> a;
	
	@SuppressWarnings("deprecation")
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		
		// Read AIG file
		a = new MappingAIG("mux4.aag");
		a.visitAll(new ParameterMarker(new StringBufferInputStream("s0 s1")));

		// Cone enumeration
		ConeEnumeration enumerator = new ConeEnumeration(3); 
        a.visitAll(enumerator);
        a.visitAll(new ConeRanking());

	}

	public void testI0() {
		Node n = a.getNode("i0");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("i0", "i0", "");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());
	}
	
	public void testI1() {
		Node n = a.getNode("i1");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("i1", "i1", "");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());	
	}

	public void testI2() {
		Node n = a.getNode("i2");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("i2", "i2", "");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());
	}

	public void testI3() {
		Node n = a.getNode("i3");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("i3", "i3", "");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());
	}

    public void testS0() {
		Node n = a.getNode("s0");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("s0", "", "s0");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());
	}

    public void testS1() {
		Node n = a.getNode("s1");
		assertEquals(0.0, n.getDepth());
		assertEquals(0.0, n.getAreaflow());
		
		ConeInterface c = n.getConeSet().getCone("s1", "", "s1");
		assertEquals(0.0, c.getDepth());
		assertEquals(0.0, c.getAreaflow());
	}
    
    public void testA14() {
        Node n = a.getNode("a14");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a14", "i0", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    
    public void testA16() {	
        Node n = a.getNode("a16");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a16", "i1", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());

    }
    
    public void testA18() {
        Node n = a.getNode("a18");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a18", "i2", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    
    public void testA20() {
        Node n = a.getNode("a20");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a20", "i3", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    
    public void testA22() {
        Node n = a.getNode("a22");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a22", "a22", "");
		assertEquals(Double.POSITIVE_INFINITY, c.getDepth());
		assertEquals(Double.POSITIVE_INFINITY, c.getAreaflow());
		
		c = n.getConeSet().getCone("a22", "i0 i1", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    public void testA24() {
        Node n = a.getNode("a24");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a24", "a24", "");
		assertEquals(Double.POSITIVE_INFINITY, c.getDepth());
		assertEquals(Double.POSITIVE_INFINITY, c.getAreaflow());
		
		c = n.getConeSet().getCone("a24", "i2 i3", "s0");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    public void testA26() {
        Node n = a.getNode("a26");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a26", "a22", "s1");
		assertEquals(2.0, c.getDepth());
		assertEquals(2.0, c.getAreaflow());
		
		c = n.getConeSet().getCone("a26", "i0 i1", "s0 s1");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    
    public void testA28() {
        Node n = a.getNode("a28");
		assertEquals(1.0, n.getDepth());
		assertEquals(1.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a28", "a24", "s1");
		assertEquals(2.0, c.getDepth());
		assertEquals(2.0, c.getAreaflow());
		
		c = n.getConeSet().getCone("a28", "i2 i3", "s0 s1");
		assertEquals(1.0, c.getDepth());
		assertEquals(1.0, c.getAreaflow());
    }
    
    public void testA30() {
        Node n = a.getNode("a30");
		assertEquals(2.0, n.getDepth());
		assertEquals(2.0, n.getAreaflow());
		
		ConeInterface c;
		c = n.getConeSet().getCone("a30", "a30", "");
		assertEquals(Double.POSITIVE_INFINITY, c.getDepth());
		assertEquals(Double.POSITIVE_INFINITY, c.getAreaflow());	

		c = n.getConeSet().getCone("a30", "a24 i0 i1", "s0 s1");
		assertEquals(2.0, c.getDepth());
		assertEquals(2.0, c.getAreaflow());
		
		c = n.getConeSet().getCone("a30", "a22 i2 i3", "s0 s1");
		assertEquals(2.0, c.getDepth());
		assertEquals(2.0, c.getAreaflow());
		
		c = n.getConeSet().getCone("a30", "a22 a24", "s1");
		assertEquals(2.0, c.getDepth());
		assertEquals(3.0, c.getAreaflow());

    }
	
	public void testO0() throws FileNotFoundException {
        Node n = a.getNode("o0");
		assertEquals(3.0, n.getDepth());
		assertEquals(2.0, n.getAreaflow());
	}

}
