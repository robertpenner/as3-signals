package 
{
    import org.osflash.signals.AllTests;
	import asunit4.ui.MinimalRunnerUI;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsRunner extends MinimalRunnerUI
	{
		public function AllTestsRunner()
		{
			run(org.osflash.signals.AllTests);
		}
	}
}


