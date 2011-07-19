package org.osflash.signals
{
	
	/**
	 * <p>ReplaySignal captures the dispatch history of the Signal and replays the
	 * events for its observers. ReplaySignal has the option to automatically
	 * play back the event history for new observers when they're added, or to
	 * replay the history only when needed.</p>
	 *
	 * <p>This signal is inspired by Rx.NET's IObservable.Replay() extension method.
	 * For more information, see Lee Campbell's description of Replay()
	 * <a href="http://leecampbell.blogspot.com/2010/08/rx-part-7-hot-and-cold-observables.html">here</a>.</p>
	 *
	 * <p>Note: if autoReplay is true, listeners passed to addConditionally and
	 * addOnce can be invoked multiple times, for as many historical dispatches
	 * as exist in the cache. After the entire history has been dispatched to
	 * the listener, the normal addConditionally and addOnce functionality
	 * resumes, and the listeners will be (conditionally) removed the next time
	 * the signal is dispatched.</p>
	 *
	 * <p>Also note: calling replay() does not add items to the dispatch history
	 * cache. In the case of listeners added with addConditionally and addOnce,
	 * replay() will not trigger listener removal.</p>
	 */
	public class ReplaySignal extends Signal
	{
		public function ReplaySignal(autoReplay:Boolean = true, ... valueClasses)
		{
			auto = autoReplay;
			
			super(valueClasses);
		}
		
		private var auto:Boolean = true;
		
		/**
		 * <p>Defines whether the signal replays its history for each new observer
		 * when the observer is added.</p>
		 *
		 * <p>If autoReplay is true, each function passed to ISignal#add,
		 * ISignal#addConditionally, and ISignal#addOnce will be immediately
		 * invoked, once for each entry in the dispatch history.</p>
		 *
		 * <p>After the history has been played back, the listener is added
		 * normally, per the method that was called.</p>
		 *
		 * @default true
		 */
		public function get autoReplay():Boolean
		{
			return auto;
		}
		
		public function set autoReplay(value:Boolean):void
		{
			if(value == auto)
				return;
			
			auto = value;
		}
		
		/**
		 * Replays the signal's dispatch history to all observers. Does not add
		 * to the signal's dispatch history cache.
		 */
		public function replay():void
		{
			// Clone the SignalBindingList in order to keep the list the same
			// after each dispatch, in case some of the listeners were added
			// with addConditionally or addOnce.
			
			var bindingsToProcess:SignalBindingList = bindings;
			var list:SignalBindingList = SignalBindingList.NIL;
			while(bindingsToProcess.nonEmpty)
			{
				list = list.prepend(bindingsToProcess.head);
				bindingsToProcess = bindingsToProcess.tail;
			}
			
			const superDispatch:Function = super.dispatch;
			
			dispatchCache.forEach(function(params:Array, ... args):void{
				// Dispatch to the bindings list
				superDispatch.apply(null, params);
				
				// Reset the bindings list to its original value before the
				// replay() call.
				bindings = list;
			});
		}
		
		/**
		 * Clears the signal's dispatch history.
		 */
		public function clear():void
		{
			dispatchCache.length = 0;
		}
		
		private const dispatchCache:Array = [];
		
		/** @inheritDoc */
		override public function dispatch(... valueObjects):void
		{
			dispatchCache.unshift(valueObjects);
			
			super.dispatch.apply(null, valueObjects);
		}
		
		/** @inheritDoc */
		override public function add(listener:Function):ISignalBinding
		{
			dispatchHistory(listener);
			
			return super.add(listener);
		}
		
		/** @inheritDoc */
		override public function addConditionally(listener:Function):ISignalBinding
		{
			dispatchHistory(listener);
			
			return super.addConditionally(listener);
		}
		
		/** @inheritDoc */
		override public function addOnce(listener:Function):ISignalBinding
		{
			dispatchHistory(listener);
			
			return super.addOnce(listener);
		}
		
		protected function dispatchHistory(listener:Function):void
		{
			if(!autoReplay)
				return;
			
			const binding:ISignalBinding = bindings.find(listener) || new SignalBinding(listener, this);
			
			dispatchCache.forEach(function(params:Array, ... args):void{
				binding.execute(params);
			});
		}
	}
}