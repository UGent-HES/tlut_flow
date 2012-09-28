package be.ugent.elis.recomp.synthesis;

import java.util.Scanner;
import java.util.Stack;
import java.util.Vector;

public class BooleanFunction {
	private Vector<String> inputVariable;
	private String outputVariable;
	private String expression;
	
	
	public BooleanFunction(String outputVariable, String inputVariables, String expression) {
		this.outputVariable = outputVariable;
		
		this.inputVariable = new Vector<String>();
		Scanner scan = new Scanner(inputVariables);
		while(scan.hasNext()) {
			String var = scan.next();
			this.inputVariable.add(var);
		}
		
		this.expression = expression;
		
	}

	public BooleanFunction(String outputVariable, Vector<String> inputVariables, String expression) {
		this.outputVariable = outputVariable;
		this.inputVariable = inputVariables;
		
		this.expression = expression;
		
	}
	
	public Boolean evaluate(TruthAssignment assignment) {
		Stack<Boolean> stack = new Stack<Boolean>();
		
		Scanner scan = new Scanner(expression);
		while (scan.hasNext()) {
			String next = scan.next();
			if (assignment.contains(next)) {
				stack.push(assignment.get(next));
			} else if ( next.equals("+")) {
				Boolean arg0 = stack.pop();
				Boolean arg1 = stack.pop();
				stack.push(arg0 || arg1);
			} else if ( next.equals("*")) {
				Boolean arg0 = stack.pop();
				Boolean arg1 = stack.pop();
				stack.push(arg0 && arg1);
			} else if ( next.equals("-")) {
				Boolean arg0 = stack.pop();
				stack.push(!arg0);
			} else {
				System.err.println("Error: Bad Boolean expression!");
			}
		}
		
		return stack.pop();
	}


	private Vector<Minterm> getMinterms() {
		Vector<Minterm> result = new Vector<Minterm>();
		TruthTable table = new TruthTable(this);
		
		for (TruthAssignment assignment: table.getAssignments()) {
			if (table.get(assignment)) {
				result.add(assignment.minterm());
			}
		}

		return result;
	}


	public Vector<String> getInputVariable() {
		return inputVariable;
	}


	public void setInputVariable(Vector<String> inputVariable) {
		this.inputVariable = inputVariable;
	}


	public String getOutputVariable() {
		return outputVariable;
	}


	public void setOutputVariable(String outputVariable) {
		this.outputVariable = outputVariable;
	}


	public String getExpression() {
		return expression;
	}


	public void setExpression(String expression) {
		this.expression = expression;
	}


	public BooleanFunction invert() {
		BooleanFunction result = new BooleanFunction(outputVariable + "_n", inputVariable, expression+ " -");
		return result;
	}

	public String getBlifString(String name) {
		String temp = this.outputVariable;
		this.outputVariable = name;
		String result = getBlifString();
		this.outputVariable = temp;
		return result;
	}
	


	public String getBlifString() {
		String result = new String();
		
		result += ".names";
		for (String in : inputVariable) {
			result += " " + in;
		}
		result += " " + outputVariable;
		result += "\n";
		
		Vector<Minterm> minterms = this.getMinterms();
		
		for (Minterm m:minterms) {
			result += m + " 1\n"; 
		}
		
		return result;
	}

	
	
	

}
