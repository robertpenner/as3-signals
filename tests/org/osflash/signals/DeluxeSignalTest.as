package org.osflash.signals
{
	import asunit.asserts.*;
	import asunit.framework.IAsync;

	public class DeluxeSignalTest extends ISignalTestBase
	{	    		
		[Before]
		public function setUp():void
		{
			signal = new DeluxeSignal(this);
		}
		
	}
}
