package org.osflash.signals.natives
{
	import asunit.asserts.assertFalse;
	import asunit.asserts.assertTrue;

	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.ISignalBindingTest;
	import org.osflash.signals.events.GenericEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class NativeSignalBindingTest extends ISignalBindingTest
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
