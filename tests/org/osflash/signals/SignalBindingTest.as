package org.osflash.signals
{
	import org.osflash.signals.events.GenericEvent;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalBindingTest extends ISignalBindingTestBase
	{

		[Before]
		public function setUp():void
		{
			signal = new Signal();
		}
		
		[Test]
		public function add_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = signal.add(async.add(checkGenericEvent, 10));
			binding.enabled = false;
			binding.enabled = true;
			
			signal.dispatch(new GenericEvent());
		}
		
		[Test]
		public function addOnce_listener_pause_then_resume_on_binding_should_dispatch() : void
		{
			var binding : ISignalBinding = signal.addOnce(async.add(checkGenericEvent, 10));
			binding.enabled = false;
			binding.enabled = true;
			
			signal.dispatch(new GenericEvent());
		}
	}
}
