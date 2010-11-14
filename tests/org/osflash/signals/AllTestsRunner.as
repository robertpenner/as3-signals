package org.osflash.signals
{
	import asunit.core.TextCore;

	import flash.display.MovieClip;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsRunner extends MovieClip
	{
        private var core:TextCore;

		public function AllTestsRunner()
		{
            core = new TextCore();
			core.textPrinter.hideLocalPaths = true;
			core.start(AllTests, null, this);
		}
	}
}

