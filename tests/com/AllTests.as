package com
{
	import asunit.framework.TestSuite;
	import com.robertpenner.AllTests;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.robertpenner.AllTests());
		}
	}
}
