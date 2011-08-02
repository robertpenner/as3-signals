package org.osflash.signals
{
	import asunit.asserts.*;

	import org.osflash.signals.support.SpriteWithSignals;

	public class MXMLSignalTest
	{	
		private var mxmlSprite:SpriteWithSignals;
		
		[Before]
		public function setUp():void
		{
			mxmlSprite = new SpriteWithSignals();
		}

		[After]
		public function tearDown():void
		{
			mxmlSprite = null;
		}

		[Test]
		public function mxml_object_has_Signals_after_creation():void
		{
			assertTrue(mxmlSprite.numChildrenChanged is Signal);
			assertTrue(mxmlSprite.nameChanged is Signal);
			assertTrue(mxmlSprite.tabEnabledChanged is Signal);
		}
		
		[Test]
		public function has_single_value_class_from_mxml_default_property():void
		{
			var valueClasses:Array = mxmlSprite.numChildrenChanged.valueClasses;
			assertEquals(1, valueClasses.length);
			assertEquals(uint, valueClasses[0]);
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
