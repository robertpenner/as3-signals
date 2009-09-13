package org.osflash.signals
{
	import asunit.framework.TestCase;

	public class GenericEventTest extends TestCase
	{
		private var instance:GenericEvent;

		public function GenericEventTest(testMethod:String = null)
		{
			super(testMethod);
		}

		protected override function setUp():void
		{
			instance = new GenericEvent();
		}

		protected override function tearDown():void
		{
			instance = null;
		}

		public function testInstantiated():void
		{
			assertTrue("GenericEvent instantiated", instance is GenericEvent);
			assertNull('target is null by default', instance.target);
			assertFalse('bubbles is false by default', instance.bubbles);
		}
		
		public function test_bubbles_roundtrips_through_constructor():void
		{
			var bubblingEvent:GenericEvent = new GenericEvent(true);
			assertTrue(bubblingEvent.bubbles);
		}
		
		public function test_clone_should_be_instance_of_original_event_class():void
		{
			var theClone:IEvent = instance.clone();
			assertTrue(theClone is GenericEvent);
		}
		
		public function test_clone_non_bubbling_event_should_have_bubbles_false():void
		{
			var theClone:GenericEvent = GenericEvent(instance.clone());
			assertFalse(theClone.bubbles);
		}
		
		public function test_clone_bubbling_event_should_have_bubbles_true():void
		{
			var bubblingEvent:GenericEvent = new GenericEvent(true);
			var theClone:IEvent = bubblingEvent.clone();
			assertTrue(theClone.bubbles);
		}


	}
}
