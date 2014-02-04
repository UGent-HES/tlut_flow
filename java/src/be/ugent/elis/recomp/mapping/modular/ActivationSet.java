package be.ugent.elis.recomp.mapping.modular;

import java.util.HashSet;
import java.util.Set;

import net.sf.javabdd.BDD;
import be.ugent.elis.recomp.mapping.utils.MappingAIG;
import be.ugent.elis.recomp.mapping.utils.Node;

class ActivationSet {
	
	boolean short_activation_function = true;
	
	final private MappingAIG aig;
	final private BDD activationFunction;
	private Set<Node> nodes;
	private Set<ActivationSet> sharingOpportunities;
	
	ActivationSet(MappingAIG aig, BDD activationFunction) {
		this.aig = aig;
		this.activationFunction = activationFunction;
		nodes = new HashSet<Node>();
		sharingOpportunities = new HashSet<ActivationSet>();
	}
	
	public boolean disjunctWithSet(ActivationSet otherSet) {
		BDD bdd = getActivationFunction().and(otherSet.getActivationFunction());
		boolean res = bdd.isZero();
		bdd.free();
		return res;
	}
	
	public BDD getActivationFunction() {
		return activationFunction;
	}
	
	public void addNode(Node node) {
		if(!(node.isVisible() && node.getBestCone().usesLUTResource()))
			throw new RuntimeException("Not a valid node for an activationset");
		nodes.add(node);
	}
	
	public Set<Node> getNodes() {
		return nodes;
	}
	
	public Set<ActivationSet> getSharingOpportunities() {
		return sharingOpportunities;
	}
	
	public void setSharingOpportunities(Set<ActivationSet> sharingOpportunities) {
		this.sharingOpportunities = sharingOpportunities;
	}
	
	public void addSharingOpportunity(ActivationSet sharingOpportunity) {
		this.sharingOpportunities.add(sharingOpportunity);
	}
	
	public boolean canShareWith(ActivationSet set) {
		return getSharingOpportunities().contains(set);
	}
	
	public boolean sanityCheck() {
		if(getSharingOpportunities() != null) {
			for(ActivationSet child : getSharingOpportunities())
				if(!disjunctWithSet(child)) return false;
		}
		return true;
	}
	
	public int numLUTResources() {
		return getNodes().size();
	}
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("ActivationSet(");
		sb.append("activation_function{");
		if(short_activation_function)
			sb.append(getActivationFunction().hashCode());
		else
			sb.append(getActivationFunction().toString());
		sb.append("},share_with{");
		for(ActivationSet set : getSharingOpportunities()) {
			if(short_activation_function)
				sb.append(set.getActivationFunction().hashCode());
			else
				sb.append(set.getActivationFunction().toString());
			sb.append(',');
		}
		sb.append("},num_luts{"+numLUTResources());
//			sb.append("},nodes{");
//			for(Node node : getNodes()) {
//				sb.append(node.getName());
//				sb.append(',');
//			}
		sb.append("},bdd_vars{");
		int varProfile[] = getActivationFunction().varProfile();
		for(int id = 0; id < varProfile.length; id++)
			if(varProfile[id] != 0)
				sb.append(""+aig.getBDDidMapping().getNode(id).getName()+",");
		sb.append("})");
		return sb.toString();
	}
	public MappingAIG getAIG() {
		return aig;
	}
}