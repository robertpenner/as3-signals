package org.osflash.signals
{
	import asunit.asserts.*;

	import org.osflash.signals.events.IEvent;
	import org.osflash.signals.support.SpriteWithDeluxeSignals;

	public class MXMLDeluxeSignalTest
	{	
		private var mxmlSprite:SpriteWithDeluxeSignals;
		
		[Before]
		public function setUp():void
		{
			mxmlSprite = new SpriteWithDeluxeSignals();
		}

		[After]
		public function tearDown():void
		{
			mxmlSprite = null;
		}

		[Test]
		public function mxml_object_has_DeluxeSignals_after_creation():void
		{
			assertTrue(mxmlSprite.numChildrenChanged is DeluxeSignal);
			assertTrue(mxmlSprite.nameChanged is DeluxeSignal);
			assertTrue(mxmlSprite.tabEnabledChanged is DeluxeSignal);
			assertTrue(mxmlSprite.tabIndexChanged is DeluxeSignal);
		}
		
		[Test]
		public function has_single_value_class_from_mxml_default_property():void
		{
			var valueClasses:Array = mxmlSprite.numChildrenChanged.valueClasses;
			assertEquals(1, valueClasses.length);
			assertEquals(IEvent, valueClasses[0]);
		}
		
		[Test]
		public function has_multiple_value_classes_from_mxml_default_property():void
		{
			var valueClasses:Array = mxmlSprite.nameChanged.valueClasses;
			assertEquals(2, valueClasses.length);
			assertEquals(String, valueClasses[0]);
			assertEquals(uint, valueClasses[1]);
		}
		
		[Test]
		public function has_target_from_mxml_attribute():void
		{
			assertSame(mxmlSprite, mxmlSprite.numChildrenChanged.target);
		}
		
		[Test]
		public function has_single_value_class_from_mxml_attribute():void
		{
			var valueClasses:Array = mxmlSprite.tabEnabledChanged.valueClasses;
			assertEquals(1, valueClasses.length);
			assertEquals(Boolean, valueClasses[0]);
		}
		
		[Test]
		public function has_multiple_value_classes_from_mxml_attribute():void
		{
			var valueClasses:Array = mxmlSprite.tabIndexChanged.valueClasses;
			assertEquals(2, valueClasses.length);
			assertEquals(int, valueClasses[0]);
			assertEquals(Boolean, valueClasses[1]);
		}

		[Test]
		public function add_listener_then_dispatch_calls_listener():void
		{
			var called:Boolean = false;
			var handler:Function = function(newValue:Boolean):void { called = true; };
			mxmlSprite.tabEnabledChanged.addOnce(handler);
			// when
			mxmlSprite.tabEnabledChanged.dispatch(true);
			// then
			assertTrue(called);
		}		
	}
}
