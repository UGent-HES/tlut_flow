package be.ugent.elis.recomp.mapping.utils;

import java.util.Set;
import java.util.Vector;

public interface ConeInterface {

	public abstract int getSignature();

	public abstract void setSignature(int signature);

	public abstract void setRoot(Node root);

	public abstract Node getRoot();

	public abstract Set<Node> getParameterLeaves();

	public abstract Set<Node> getRegularLeaves();

	public abstract void addLeave(Node node);

	public abstract void addLeaves(Cone cone0);

	public abstract void setDepth(double depth);

	public abstract double getDepth();

	public abstract void setAreaflow(double areaflow);

	public abstract double getAreaflow();

	public abstract boolean isTrivial();

	public abstract boolean isTLUT();

	//TODO: Migration to TMapCone
	public abstract Vector<Node> getNodes();

	public abstract Vector<Node> getRegularInputs();

	public abstract int size();

	public abstract String toString();

	public abstract double getMaximumInputDepth();

}