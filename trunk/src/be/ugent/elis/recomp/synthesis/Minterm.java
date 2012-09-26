package be.ugent.elis.recomp.synthesis;

public class Minterm {

	String literals;
	
	public Minterm(TruthAssignment truthAssignment) {
		
		literals = new String();
		
		for (String var:truthAssignment.getVariables()) {
			if (truthAssignment.get(var)) {
				literals += '1';
			} else {
				literals += '0';
			}
		}
	}

	@Override
	public String toString() {
		return literals;
	}


	
	
	

}
