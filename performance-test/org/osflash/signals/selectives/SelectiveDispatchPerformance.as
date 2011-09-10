package org.osflash.signals.selectives {

	import flash.system.System;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
			
	/**
	 * Tests performance for selective dispatching
	 * 
	 * On initialization (GROUPS * NUM_LISTENERS) listeners will be attached to the 
	 * signal, however not all of these will be executed during dispatch. Each group 
	 * of listeners only listens for a special value: the selectivity-value.
	 * 
	 * This value is determined (if needed) on dispatch by calling the provider of 
	 * the SelectiveSignal. In this test all listeners listen for their group-id.
	 * 
	 * Each frame, the test will move on to the next group and therefore invoke a 
	 * different set of listeners.
	 * 
	 * @author  Tim Kurvers <tim@moonsphere.net>
	 */
	[SWF(width=800, height=600, frameRate=64, backgroundColor=0x333333)]
	public class SelectiveDispatchPerformance extends Sprite {
		
		private const FPS: int = 64;
		
		private const GROUPS: int = 50;
		private const NUM_LISTENERS: int = 5000;
		private const MAX_SCORE: int = NUM_LISTENERS * FPS;

		private var _out0: TextField;
		private var _out1: TextField;
		private var _t0: int;

		private var _s: ISelectiveSignal;
		public var _d: int;
		private var _f: int;
		private var _min:int;
		private var _max:int;
		private var _c: int;
		private var _g: int;

		public function SelectiveDispatchPerformance() {
			setTimeout(init, 1);
		}
		
		private function init(): void {
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

			_s = new SelectiveSignal(function(group:int):int {
				return group;
			}, int);
			
			var t1: int = getTimer();
			for(var i:int=0; i<GROUPS; ++i) {
				for(var j:int=1; j<=NUM_LISTENERS; ++j) {
					_s.addWithPriorityFor(i, new Target(this).l, i * NUM_LISTENERS + j);
				}
			}
			_c = (getTimer() - t1);

			addChild(_out0);
			addChild(_out1);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event: Event): void {
			var t1: int = getTimer();
			if((t1 - _t0) >= 1000) {
				_out0.text = _d+'/'+MAX_SCORE+' = '+Math.round(_d/MAX_SCORE*100.0)+'%\n'+_f+
						'fps\n'+(System.totalMemory >> 20)+'mb\n'+_min+'ms\n'+_max+'ms\n-> '+_c;
				_d = 0;
				_f = 0;
				_t0 = t1;
			}
			
			++_g;
			
			_f++;
			var m0: int = getTimer();
			_s.dispatch(_g % GROUPS);
			var dt: int = (getTimer() - m0);
			if(dt < _min) _min = dt;
			if(dt > _max) _max = dt;
			_out1.text = dt+'ms';
		
		}
	}
}

import org.osflash.signals.selectives.SelectiveDispatchPerformance;

class Target {
	
	public var sdp: SelectiveDispatchPerformance;

	public function Target(sdp: SelectiveDispatchPerformance) {
		this.sdp = sdp;
	}

	public function l(group:int): void {
		sdp._d++;
	}
}
