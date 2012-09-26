package be.ugent.elis.recomp.aig;

public class StrashKey < N extends AbstractNode<N,E>, E extends AbstractEdge<N,E>> {
	N node0;
	boolean inv0;
	N node1;
	boolean inv1;
	public StrashKey(N node0, boolean inv0, N node1, boolean inv1) {
		super();
		this.node0 = node0;
		this.inv0 = inv0;
		this.node1 = node1;
		this.inv1 = inv1;
	}
	@Override
	public boolean equals(Object obj) {
		
		if (this == obj)
			return true;
		if (!(obj instanceof StrashKey<?,?>))
		      return false;
		
		StrashKey<N,E> other = (StrashKey) obj;
		
		return (this.node0 == other.node0) && (this.inv0 == other.inv0) && (this.node1 == other.node1) && (this.inv1 == other.inv1); 

	}
	@Override
	public int hashCode() {
	    int hash = 1;
	    hash = hash * 31 + (node0 == null ? 0 : node0.hashCode());
	    hash = hash * 31 + (inv0 ? 0 : 1);
	    hash = hash * 31 + (node1 == null ? 0 : node1.hashCode());
	    hash = hash * 31 + (inv1 ? 0 : 1);
		return hash;
	}
	
	

}
