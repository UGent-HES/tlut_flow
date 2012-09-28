package be.ugent.elis.recomp.synthesis;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class TruthTable {
	
	Vector<TruthAssignment> assignments;
	Map<TruthAssignment, Boolean> table; 
	

	public TruthTable(BooleanFunction f) {
		assignments = new Vector<TruthAssignment>();
		table = new HashMap<TruthAssignment, Boolean>();
		
		TruthAssignment assignment = new TruthAssignment(f);
		assignments.add(assignment);
		table.put(assignment, f.evaluate(assignment));
		while (assignment.hasNext()) {
			assignment = assignment.next();
			assignments.add(assignment);
			table.put(assignment, f.evaluate(assignment));
		}
	}


	public  Vector<TruthAssignment> getAssignments() {
		return assignments;
	}


	public boolean get(TruthAssignment assignment) {
		return table.get(assignment);
	}

}
