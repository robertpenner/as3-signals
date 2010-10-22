package org.osflash.signals.natives
{
	import asunit.asserts.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.support.SpriteWithNativeSignals;

	import flash.display.Sprite;

	public class MXMLNativeSignalTest
	{	
		private var mxmlSprite:SpriteWithNativeSignals;
		
		[Before]
		public function setUp():void
		{
			mxmlSprite = new SpriteWithNativeSignals();
		}

		[After]
		public function tearDown():void
		{
			mxmlSprite = null;
		}

		[Test]
		public function mxml_object_has_NativeSignals_after_creation():void
		{
			assertTrue(mxmlSprite.clicked is NativeSignal);
		}
		
		[Test]
		public function has_eventClass_from_mxml_default_property():void
		{
			assertEquals(MouseEvent, mxmlSprite.clicked.eventClass);
		}

		[Test]
		public function has_eventType_from_mxml_attribute():void
		{
			assertEquals(MouseEvent.CLICK, mxmlSprite.clicked.eventType);
		}	
		
		[Test]
		public function has_target_from_mxml_attribute():void
		{
			assertEquals(mxmlSprite, mxmlSprite.clicked.target);
		}	
		
		[Test]
		public function has_eventClass_from_mxml_attribute():void
		{
			assertEquals(MouseEvent, mxmlSprite.doubleClicked.eventClass);
		}
		
		[Test]
		public function omitted_eventClass_defaults_to_Event():void
		{
			assertEquals(Event, mxmlSprite.addedToStage.eventClass);
		}			
	}
}
