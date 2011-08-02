package org.osflash.signals.natives
{
	import org.osflash.signals.ISlotTestBase;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class NativeSignalSlotTest extends ISlotTestBase
	{
		private var sprite:IEventDispatcher;
		
		[Before]
		public function setUp():void
		{
			sprite = new Sprite();
			signal = new NativeSignal(sprite, 'click', Event);
		}
	}
}
