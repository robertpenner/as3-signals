package org.osflash.signals 
{
<<<<<<< Updated upstream
	import asunit4.ui.MinimalRunnerUI;
=======
	import asunit.ui.TextRunnerUI;
>>>>>>> Stashed changes

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsRunner extends MinimalRunnerUI
	{
		public function AllTestsRunner()
		{
			run(org.osflash.signals.AllTests);
		}
	}
}

