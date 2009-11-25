package org.osflash.signals {
	import asunit4.ui.MinimalRunnerUI;
	import org.osflash.signals.AllTests;
	
	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsRunner extends MinimalRunnerUI
	{
		public function AllTestsRunner()
		{
			run(org.osflash.signals.AllTests);
		}
	}
}

