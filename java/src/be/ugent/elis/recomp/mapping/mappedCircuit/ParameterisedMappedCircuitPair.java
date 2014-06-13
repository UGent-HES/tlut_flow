package be.ugent.elis.recomp.mapping.mappedCircuit;

public class ParameterisedMappedCircuitPair {
	private final MappedCircuit circuit;
	private final MappedCircuit configuration;
	public ParameterisedMappedCircuitPair(MappedCircuit circuit,
			MappedCircuit configuration) {
		this.circuit = circuit;
		this.configuration = configuration;
	}
	public MappedCircuit getCircuit() {
		return circuit;
	}
	public MappedCircuit getConfiguration() {
		return configuration;
	}
}