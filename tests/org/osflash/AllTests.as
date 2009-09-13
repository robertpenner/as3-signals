package org.osflash {
	import asunit.framework.TestSuite;
	import org.osflash.signals.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new org.osflash.signals.AllTests());
		}
	}
}
