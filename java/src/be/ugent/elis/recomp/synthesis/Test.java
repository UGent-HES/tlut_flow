package be.ugent.elis.recomp.synthesis;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		BooleanFunction f = new BooleanFunction("f","a b c","b c + a +");
		
		
		TruthTable table = new TruthTable(f);
		
		
		TruthAssignment assignment = new TruthAssignment(f);
		

		
		System.out.println(f.evaluate(assignment));

	}

}
