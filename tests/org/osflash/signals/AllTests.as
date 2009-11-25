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
		public var _SignalDispatchExtraArgsTest:SignalDispatchExtraArgsTest;
		public var _SignalDispatchNoArgsTest:SignalDispatchNoArgsTest;
		public var _SignalDispatchNonEventTest:SignalDispatchNonEventTest;
		public var _SignalSplitInterfacesTest:SignalSplitInterfacesTest;
		public var _SignalWithBubblingEventTest:SignalWithBubblingEventTest;
		public var _SignalWithCustomEventTest:SignalWithCustomEventTest;
		public var _SignalWithGenericEventTest:SignalWithGenericEventTest;
		
		public var _SimpleSignalDispatchExtraArgsTest:SimpleSignalDispatchExtraArgsTest;
		public var _SimpleSignalDispatchNoArgsTest:SimpleSignalDispatchNoArgsTest;
		public var _SimpleSignalDispatchNonEventTest:SimpleSignalDispatchNonEventTest;
		public var _SimpleSignalSplitInterfacesTest:SimpleSignalSplitInterfacesTest;
		public var _SimpleSignalTest:SimpleSignalTest;
		public var _SimpleSignalWithCustomEventTest:SimpleSignalWithCustomEventTest;
	}
}
