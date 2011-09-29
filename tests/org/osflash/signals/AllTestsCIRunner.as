package org.osflash.signals
{
	import asunit.core.FlexUnitCICore;
	import asunit.core.TextCore;

	import flash.display.MovieClip;

	[SWF(width='1000', height='800', backgroundColor='#333333', frameRate='31')]
	public class AllTestsCIRunner extends MovieClip
	{
		private var core:TextCore;

		public function AllTestsCIRunner()
		{
			core = new FlexUnitCICore();
			core.start(AllTests, null, this);
		}
	}
}

