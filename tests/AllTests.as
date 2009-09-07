package {
	import asunit.framework.TestSuite;
	import com.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.AllTests());
		}
	}
}
