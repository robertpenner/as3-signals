package com.robertpenner.signals {
	import asunit.framework.TestSuite;
	import com.robertpenner.signals.EventDispatcherSignalTest;
	import com.robertpenner.signals.GenericEventTest;
	import com.robertpenner.signals.SignalDispatchNoArgsTest;
	import com.robertpenner.signals.SignalSplitInterfacesTest;
	import com.robertpenner.signals.SignalWithBubblingEventTest;
	import com.robertpenner.signals.SignalWithCustomEventTest;
	import com.robertpenner.signals.SignalWithGenericEventTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new com.robertpenner.signals.EventDispatcherSignalTest());
			addTest(new com.robertpenner.signals.GenericEventTest());
			addTest(new com.robertpenner.signals.SignalDispatchNoArgsTest());
			addTest(new com.robertpenner.signals.SignalSplitInterfacesTest());
			addTest(new com.robertpenner.signals.SignalWithBubblingEventTest());
			addTest(new com.robertpenner.signals.SignalWithCustomEventTest());
			addTest(new com.robertpenner.signals.SignalWithGenericEventTest());
		}
	}
}
