package be.ugent.elis.recomp.synthesis;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class TruthAssignment{

	Vector<String> inputVariables;
	Map<String,Boolean> assignmentMap;

	@Override
	public String toString() {
		String result = new String();
		result += "{";
		result += inputVariables.get(0) + "=" + assignmentMap.get(inputVariables.get(0));

		for (int i = 1; i < inputVariables.size(); i++) {
			result += ", " + inputVariables.get(i) + "=" + assignmentMap.get(inputVariables.get(i));
		}
		result += "}";
		return result;
	}

	public TruthAssignment(BooleanFunction f) {
		inputVariables = f.getInputVariable();
		assignmentMap = new HashMap<String, Boolean>();
		
		for (String in:this.inputVariables) {
			assignmentMap.put(in, false);
		}
	}

	public TruthAssignment(TruthAssignment truthAssignment) {
		inputVariables = truthAssignment.inputVariables;
		assignmentMap = new HashMap<String, Boolean>();
		for (String in:this.inputVariables) {
			assignmentMap.put(in, new Boolean(truthAssignment.get(in)));
		}
	}

	public boolean hasNext() {
		boolean result = true;
		for (Boolean b:assignmentMap.values()) {
			result = result && b;
		}
		return !result;
	}

	public TruthAssignment next() {
		TruthAssignment result = new TruthAssignment(this);
		
		for (String in:this.inputVariables) {
			if (result.get(in).booleanValue() == true) {
				result.put(in, false);
			} else {
				result.put(in, true);
				break;
			}
		}
		return result;
	}

	private void put(String variable, boolean b) {
		if (inputVariables.contains(variable)) {
			assignmentMap.put(variable, b);
		}
	}

	public boolean contains(String variable) {
		return assignmentMap.containsKey(variable);
	}

	public Boolean get(String variable) {
		return assignmentMap.get(variable);
	}

	public Minterm minterm() {
		return new Minterm(this);
	}

	public  Vector<String> getVariables() {
		return inputVariables;
	}
	
	

	

}
