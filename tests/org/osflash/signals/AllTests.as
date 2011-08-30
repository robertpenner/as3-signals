package org.osflash.signals
{
	import org.osflash.signals.binding.BinderTest;
	import org.osflash.signals.natives.AmbiguousRelationshipInNativeSignalTest;
	import org.osflash.signals.natives.MXMLNativeSignalTest;
	import org.osflash.signals.natives.NativeMappedSignalBoundaryUseTest;
	import org.osflash.signals.natives.NativeMappedSignalDefaultsTest;
	import org.osflash.signals.natives.NativeMappedSignalFunctionArgTest;
	import org.osflash.signals.natives.NativeMappedSignalFunctionNoArgsTest;
	import org.osflash.signals.natives.NativeMappedSignalObjectArgTest;
	import org.osflash.signals.natives.NativeRelaySignalTest;
	import org.osflash.signals.natives.NativeSignalSlotTest;
	import org.osflash.signals.natives.NativeSignalTest;
	import org.osflash.signals.natives.sets.DisplayObjectSignalSetTest;
	import org.osflash.signals.natives.sets.EventDispatcherSignalSetTest;
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
		public var _NativeSlotTest:NativeSignalSlotTest;
		
		public var _PriorityListenersTest:PriorityListenersTest;
		public var _RedispatchedEventTest:RedispatchedEventTest;
		
		public var _DeluxeSignalWithBubblingEventTest:DeluxeSignalWithBubblingEventTest;
		public var _DeluxeSignalWithGenericEventTest:DeluxeSignalWithGenericEventTest;
		
		public var _MXMLDeluxeSignalTest:MXMLDeluxeSignalTest;
		public var _MXMLSignalTest:MXMLSignalTest;
		public var _MXMLNativeSignalTest:MXMLNativeSignalTest;
		
		public var _SignalDispatchArgsTest:SignalDispatchArgsTest;
		public var _SignalDispatchExtraArgsTest:SignalDispatchExtraArgsTest;
		public var _SignalDispatchNoArgsTest:SignalDispatchNoArgsTest;
		public var _SignalDispatchNonEventTest:SignalDispatchNonEventTest;
		public var _SignalTest:SignalTest;
		public var _SignalWithCustomEventTest:SignalWithCustomEventTest;
		public var _SlotTest:SlotTest;
		public var _SlotListTest:SlotListTest;
		
		public var _SignalDispatchVarArgsTest:SignalDispatchVarArgsTest;
		
		public var _SingleSignalTest:SingleSignalTest;
		public var _SingleSignalDispatchArgsTest:SingleSignalDispatchArgsTest;
		public var _SingleSignalDispatchExtraArgsTest:SingleSignalDispatchExtraArgsTest;
		public var _SingleSignalDispatchNoArgsTest:SingleSignalDispatchNoArgsTest;
		public var _SingleSignalDispatchNonEventTest:SingleSignalDispatchNonEventTest;
		public var _SingleSignalSlotTest:SingleSignalSlotTest;
		public var _SingleSignalDispatchVarArgsTest:SingleSignalDispatchVarArgsTest;
		
		public var _NativeSignalSetTest:NativeSignalSetTest;
		public var _EventDispatcherSignalSetTest:EventDispatcherSignalSetTest;
		public var _DisplayObjectSignalSetTest:DisplayObjectSignalSetTest;
		public var _BinderTest:BinderTest;	}}
