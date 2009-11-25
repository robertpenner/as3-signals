package org.osflash.signals
{
	import org.osflash.signals.natives.AmbiguousRelationshipInNativeSignalTest;
	import org.osflash.signals.natives.NativeRelaySignalTest;
	import org.osflash.signals.natives.NativeSignalTest;
	
	[Suite]
	public class AllTests
	{
		public var _AmbiguousRelationshipInNativeSignalTest:AmbiguousRelationshipInNativeSignalTest;
		public var _AmbiguousRelationshipTest:AmbiguousRelationshipTest;
		public var _GenericEventTest:GenericEventTest;
		public var _NativeRelaySignalTest:NativeRelaySignalTest;
		public var _NativeSignalTest:NativeSignalTest;
		public var _PriorityListenersTest:PriorityListenersTest;
		public var _RedispatchedEventTest:RedispatchedEventTest;
		public var _SignalDispatchExtraArgsTest:DeluxeSignalDispatchExtraArgsTest;
		public var _SignalDispatchNoArgsTest:DeluxeSignalDispatchNoArgsTest;
		public var _SignalDispatchNonEventTest:DeluxeSignalDispatchNonEventTest;
		public var _SignalSplitInterfacesTest:DeluxeSignalSplitInterfacesTest;
		public var _SignalWithBubblingEventTest:DeluxeSignalWithBubblingEventTest;
		public var _SignalWithCustomEventTest:DeluxeSignalWithCustomEventTest;
		public var _SignalWithGenericEventTest:DeluxeSignalWithGenericEventTest;
		
		public var _SimpleSignalDispatchExtraArgsTest:SignalDispatchExtraArgsTest;
		public var _SimpleSignalDispatchNoArgsTest:SignalDispatchNoArgsTest;
		public var _SimpleSignalDispatchNonEventTest:SignalDispatchNonEventTest;
		public var _SimpleSignalSplitInterfacesTest:SignalSplitInterfacesTest;
		public var _SimpleSignalTest:SignalTest;
		public var _SimpleSignalWithCustomEventTest:SignalWithCustomEventTest;
	}
}
