package org.osflash.signals {
	import asunit4.ui.MinimalRunnerUI;
	import org.osflash.signals.AllTests;
	
	public class AllTestsRunner extends MinimalRunnerUI
	{
		public function AllTestsRunner()
		{
			run(org.osflash.signals.AllTests);
		}
	}
}

