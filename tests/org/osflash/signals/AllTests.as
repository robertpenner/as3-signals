package org.osflash.signals {
	import asunit.framework.TestSuite;
	import org.osflash.signals.GenericEventTest;
	import org.osflash.signals.PriorityListenersTest;
	import org.osflash.signals.NativeRelaySignalTest;
	import org.osflash.signals.NativeSignalTest;
	import org.osflash.signals.SignalDispatchExtraArgsTest;
	import org.osflash.signals.SignalSplitInterfacesTest;
	import org.osflash.signals.SignalWithBubblingEventTest;
	import org.osflash.signals.SignalWithCustomEventTest;
	import org.osflash.signals.SignalWithGenericEventTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new org.osflash.signals.GenericEventTest());
			addTest(new org.osflash.signals.PriorityListenersTest());
			addTest(new org.osflash.signals.NativeRelaySignalTest());
			addTest(new org.osflash.signals.NativeSignalTest());
			addTest(new org.osflash.signals.SignalDispatchExtraArgsTest());
			addTest(new org.osflash.signals.SignalDispatchNoArgsTest());
			addTest(new org.osflash.signals.SignalSplitInterfacesTest());
			addTest(new org.osflash.signals.SignalWithBubblingEventTest());
			addTest(new org.osflash.signals.SignalWithCustomEventTest());
			addTest(new org.osflash.signals.SignalWithGenericEventTest());
		}
	}
}
