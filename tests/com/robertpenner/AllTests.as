package com.robertpenner {
	import asunit.framework.TestSuite;
	import com.robertpenner.signals.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.robertpenner.signals.AllTests());
		}
	}
}
