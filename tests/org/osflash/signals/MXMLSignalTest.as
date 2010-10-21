package org.osflash.signals
{
	import asunit.asserts.*;
	import org.osflash.signals.support.SpriteWithSignals;

	import flash.display.Sprite;

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
		}
		
		[Test]
		public function mxml_Signal_has_single_value_class_from_mxml_default_property():void
		{
			var valueClasses:Array = mxmlSprite.numChildrenChanged.valueClasses;
			assertEquals(1, valueClasses.length);
			assertEquals(uint, valueClasses[0]);
		}
		
		[Test]
		public function mxml_Signal_has_multiple_value_classes_from_mxml_default_property():void
		{
			var valueClasses:Array = mxmlSprite.nameChanged.valueClasses;
			assertEquals(2, valueClasses.length);
			assertEquals(String, valueClasses[0]);
			assertEquals(String, valueClasses[1]);
		}
	}
}
