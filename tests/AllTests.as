package {
	import asunit.framework.TestSuite;
	import org.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new org.AllTests());
		}
	}
}
