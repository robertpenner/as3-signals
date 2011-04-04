package org.osflash.signals
{
	import org.osflash.signals.natives.AmbiguousRelationshipInNativeSignalTest;
	import org.osflash.signals.natives.MXMLNativeSignalTest;
	import org.osflash.signals.natives.NativeMappedSignalBoundaryUseTest;
	import org.osflash.signals.natives.NativeMappedSignalDefaultsTest;
	import org.osflash.signals.natives.NativeMappedSignalFunctionArgTest;
	import org.osflash.signals.natives.NativeMappedSignalFunctionNoArgsTest;
	import org.osflash.signals.natives.NativeMappedSignalObjectArgTest;
	import org.osflash.signals.natives.NativeRelaySignalTest;
	import org.osflash.signals.natives.NativeSignalBindingTest;
	import org.osflash.signals.natives.NativeSignalTest;
	import org.osflash.signals.natives.sets.NativeSignalSetTest;

	[Suite]
	public class AllTests
	{
		public var _AmbiguousRelationshipTest:AmbiguousRelationshipTest;
		public var _AmbiguousRelationshipInNativeSignalTest:AmbiguousRelationshipInNativeSignalTest;
		public var _GenericEventTest:GenericEventTest;
		public var _NativeRelaySignalTest:NativeRelaySignalTest;
		public var _NativeSignalTest:NativeSignalTest;
		public var _NativeMappedSignalDefaultsTest:NativeMappedSignalDefaultsTest;
		public var _NativeMappedSignalObjectArgTest:NativeMappedSignalObjectArgTest;
		public var _NativeMappedSignalFunctionNoArgsTest:NativeMappedSignalFunctionNoArgsTest;
		public var _NativeMappedSignalFunctionArgTest:NativeMappedSignalFunctionArgTest;
		public var _NativeMappedSignalBoundaryUseTest:NativeMappedSignalBoundaryUseTest;
		public var _NativeSignalBindingTest:NativeSignalBindingTest;
		public var _PriorityListenersTest:PriorityListenersTest;
		public var _RedispatchedEventTest:RedispatchedEventTest;
		public var _DeluxeSignalAmbiguousRelationshipTest:DeluxeSignalAmbiguousRelationshipTest;
		public var _DeluxeSignalTest:DeluxeSignalTest;
		public var _DeluxeSignalDispatchExtraArgsTest:DeluxeSignalDispatchExtraArgsTest;
		public var _DeluxeSignalDispatchNoArgsTest:DeluxeSignalDispatchNoArgsTest;
		public var _DeluxeSignalDispatchNonEventTest:DeluxeSignalDispatchNonEventTest;
		public var _DeluxeSignalWithBubblingEventTest:DeluxeSignalWithBubblingEventTest;
		public var _DeluxeSignalWithCustomEventTest:DeluxeSignalWithCustomEventTest;
		public var _DeluxeSignalWithGenericEventTest:DeluxeSignalWithGenericEventTest;
		public var _DeluxeSignalBindingTest:DeluxeSignalBindingTest;
		public var _MXMLDeluxeSignalTest:MXMLDeluxeSignalTest;
		public var _MXMLSignalTest:MXMLSignalTest;
		public var _MXMLNativeSignalTest:MXMLNativeSignalTest;
		
		public var _SignalDispatchArgsTest:SignalDispatchArgsTest;
		public var _SignalDispatchExtraArgsTest:SignalDispatchExtraArgsTest;
		public var _SignalDispatchNoArgsTest:SignalDispatchNoArgsTest;
		public var _SignalDispatchNonEventTest:SignalDispatchNonEventTest;
		public var _SignalTest:SignalTest;
		public var _SignalWithCustomEventTest:SignalWithCustomEventTest;
		public var _SignalBindingTest:SignalBindingTest;
		
		public var _SingleSignalTest:SingleSignalTest;
		public var _SingleSignalDispatchArgsTest:SingleSignalDispatchArgsTest;
		public var _SingleSignalDispatchExtraArgsTest:SingleSignalDispatchExtraArgsTest;
		public var _SingleSignalDispatchNoArgsTest:SingleSignalDispatchNoArgsTest;
		public var _SingleSignalDispatchNonEventTest:SingleSignalDispatchNonEventTest;
		public var _SingleSignalBindingTest:SingleSignalBindingTest;
		
		public var _NativeSignalSetTest:NativeSignalSetTest;
	}
}
