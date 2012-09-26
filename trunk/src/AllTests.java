import junit.framework.Test;
import junit.framework.TestSuite;


public class AllTests {

	public static Test suite() {
		TestSuite suite = new TestSuite("Test for default package");
		//$JUnit-BEGIN$
		suite.addTestSuite(TestMux4ConeEnumerationNoParameters.class);
		suite.addTestSuite(TestMux4ConeRankingNoParameters.class);
		suite.addTestSuite(TestMux4ConeSelectionWithParameters.class);
		suite.addTestSuite(TestMux4ConeSelectionNoParameters.class);
		suite.addTestSuite(TestMux4ConeEnumerationWithParameters.class);
		suite.addTestSuite(TestDominanceConeEnumeration.class);
		suite.addTestSuite(TestMux4ConeRankingWithParameters.class);
		//$JUnit-END$
		return suite;
	}

}
