package org {
	import asunit.framework.TestSuite;
	import org.osflash.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new org.osflash.AllTests());
		}
	}
}
