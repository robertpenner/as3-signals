package org.osflash.signals
{
	import asunit.asserts.*;

	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.events.IEvent;

	public class GenericEventTest
	{
		private var instance:GenericEvent;

		[Before]
		public function setUp():void
		{
			instance = new GenericEvent();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		public function testInstantiated():void
		{
			assertTrue("GenericEvent instantiated", instance is GenericEvent);
			assertNull('target is null by default', instance.target);
			assertFalse('bubbles is false by default', instance.bubbles);
		}
		
		[Test]
		public function bubbles_roundtrips_through_constructor():void
		{
			var bubblingEvent:GenericEvent = new GenericEvent(true);
			assertTrue(bubblingEvent.bubbles);
		}
		
		[Test]
		public function clone_should_be_instance_of_original_event_class():void
		{
			var theClone:IEvent = instance.clone();
			assertTrue(theClone is GenericEvent);
		}
		
		[Test]
		public function clone_non_bubbling_event_should_have_bubbles_false():void
		{
			var theClone:GenericEvent = GenericEvent(instance.clone());
			assertFalse(theClone.bubbles);
		}
		
		[Test]
		public function clone_bubbling_event_should_have_bubbles_true():void
		{
			var bubblingEvent:GenericEvent = new GenericEvent(true);
			var theClone:IEvent = bubblingEvent.clone();
			assertTrue(theClone.bubbles);
		}


	}
}
