package org.osflash.signals {
	
	/**
	 * Implement IBubbler to enable bubbling events on
	 * non-display objects (eg Sprite, UIComponent)
	 * Useful when having a 'parent' attribute disrupts your abstraction model
	 * Be careful not to create bubbling loops where:
	 * this === this.parent.parent
	 * Returning a a display object in the display heirarchy
	 * allows bubbling up to the top.
	 * 
	 * Example implementation:
	 * <pre><code>
	 * public function get parent():Object {
	 *     // return the object we want to bubble
	 *     // as3-signals events to.
	 * 
	 *     return this.displayObject;
	 * }
	 * </code></pre>
	 * 
	 */

    public interface IBubbler {
        function get parent():Object;
    }
}
