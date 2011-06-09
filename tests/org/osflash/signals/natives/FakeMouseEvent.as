package org.osflash.signals.natives
{

import flash.events.Event;


public class FakeMouseEvent extends Event
{

    public static const CLICK:String = "click";

    public function FakeMouseEvent (type:String)
    {
        super(type);
    }
}
}

