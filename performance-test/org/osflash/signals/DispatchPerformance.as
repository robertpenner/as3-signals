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
	public class DispatchPerformance extends Sprite
	{
		private const FPS: int = 64;
		private const N: int = 4;
		private const NUM_LISTENERS: int = 1 << (N - 1);
		private const NUM_ITERATIONS: int = 80000/N;
		private const MAX_SCORE: int = NUM_LISTENERS * NUM_ITERATIONS * FPS;

		private var _out0: TextField;
		private var _out1: TextField;
		private var _t0: int;

		private var _s: ISignal;
		private var _d: int;
		private var _f: int;
		private var _min:int;
		private var _max:int;
		public function DispatchPerformance()
		{
			stage.frameRate = FPS;
			
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
			for(var i: int = 0; i < NUM_LISTENERS; ++i) _s.add(function(): void { _d++; });
			
			addChild(_out0);
			addChild(_out1);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event: Event): void
		{
			var t1: int = getTimer();
			if((t1 - _t0) >= 1000) {
				_out0.text = _d+'/'+MAX_SCORE+' = '+Math.round(_d/MAX_SCORE*100.0)+'%\n'+_f+
						'fps\n'+(System.totalMemory >> 20)+'mb\n'+_min+'ms\n'+_max+'ms';
				_d = 0;
				_f = 0;
				_t0 = t1;
			}

			_f++;
			var n: int = NUM_ITERATIONS + 1;
			var m0: int = getTimer();
			while(--n != 0) _s.dispatch();
			var dt: int = (getTimer() - m0);
			if(dt < _min) _min = dt;
			if(dt > _max) _max = dt;
			_out1.text = dt+'ms';
		}
	}
}
