package org.osflash.signals
{
	import asunit.core.TextCore;

	import flash.display.MovieClip;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class PrioritySignalTestsRunner extends MovieClip
	{
        private var core:TextCore;

		public function PrioritySignalTestsRunner()
		{
            core = new TextCore();
			core.textPrinter.hideLocalPaths = true;
			core.start(PrioritySignalTestSuite, null, this);
		}
	}
}

