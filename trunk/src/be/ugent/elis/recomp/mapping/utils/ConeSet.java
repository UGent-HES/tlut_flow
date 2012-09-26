package be.ugent.elis.recomp.mapping.utils;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;



public class ConeSet implements Iterable<Cone> {

	protected Node node;
	
	protected Set<Cone> cones;

	public ConeSet(Node node) {
		
		cones = new HashSet<Cone>();
		this.node = node;
	}

	public ConeSet(ConeSet input) {
		super();
		this.node=input.getNode();
		cones.addAll(input.cones);
	}

	public Node getNode() {
		return node;
	}

	public void setNode(Node node) {
		this.node = node;
	}

	public void add(Cone cone) {
		cones.add(cone);
	}

	public void addAll(ConeSet coneSet) {
		cones.addAll(coneSet.cones);
	}

	public Iterator<Cone> iterator() {
		return cones.iterator();
	}

	public int size() {
		return cones.size();
	}

	public Set<Cone> getCones() {
		return cones;
	}

	public void setCones(Set<Cone> cones) {
		this.cones = cones;
	}

	public void removeAll(Set<Cone> cones) {
		this.cones.removeAll(cones);
	}

	public boolean contains(ConeInterface cone) {
		return this.cones.contains(cone);
	}

	public ConeInterface getCone(String root, String rleaves, String pleaves) {
		for (Cone c:this.cones) {
			if (c.equals(root, rleaves, pleaves)) {
				return c;
			}
		}
		
		return null;
	}
	
	
}
