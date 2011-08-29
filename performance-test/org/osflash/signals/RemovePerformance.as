/**
 * Created by IntelliJ IDEA.
 * User: joa
 * Date: 11/22/10
 * Time: 4:34 PM
 * To change this template use File | Settings | File Templates.
 */
package org.osflash.signals
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	[SWF(width=800, height=600, frameRate=64, backgroundColor=0x333333)]
	public class RemovePerformance extends Sprite
	{
		private var _out0: TextField;
		private var _out1: TextField;
		private var _s: ISignal;
		private var _t0: int;

		private var _f: int;
		private var _min:int;
		private var _max:int;

		public function RemovePerformance()
		{
			_out0 = new TextField();
			_out0.defaultTextFormat = new TextFormat('arial', 24, 0xff00ff);
			_out0.autoSize = TextFieldAutoSize.LEFT;
			_out0.x = 0x20;
			_out0.y = 0x20;

			_out1 = new TextField();
			_out1.defaultTextFormat = new TextFormat('arial', 24, 0xff00ff);
			_out1.autoSize = TextFieldAutoSize.LEFT;
			_out1.x = 0x200;
			_out1.y = 0x20;

			_s = new Signal();

			addChild(_out0);
			addChild(_out1);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event: Event): void
		{
			var t1: int = getTimer();
			if((t1 - _t0) >= 1000) {
				_out0.text = _f+'fps\n'+(System.totalMemory >> 20)+'mb\n'+_min+'ms\n'+_max+'ms';
				_f = 0;
				_t0 = t1;
			}

			_f++;
			var n: int = 5000/4;
			var m0: int = getTimer();
			while(--n != 0) {
				_s.dispatch();
				_s.add(l0);//2**(4-1)=8
				_s.add(l1);
				_s.add(l2);
				_s.add(l3);
				_s.add(l4);
				_s.add(l5);
				_s.add(l6);
				_s.add(l7);
			}
			var dt: int = (getTimer() - m0);
			if(dt < _min) _min = dt;
			if(dt > _max) _max = dt;
			_out1.text = dt+'ms';
		}

		private function l0(): void {
			_s.remove(l0);
		}

		private function l1(): void {
			_s.remove(l1);
		}

		private function l2(): void {
			_s.remove(l2);
		}

		private function l3(): void {
			_s.remove(l3);
		}

		private function l4(): void {
			_s.remove(l4);
		}

		private function l5(): void {
			_s.remove(l5);
		}

		private function l6(): void {
			_s.remove(l6);
		}

		private function l7(): void {
			_s.remove(l7);
		}
	}
}
