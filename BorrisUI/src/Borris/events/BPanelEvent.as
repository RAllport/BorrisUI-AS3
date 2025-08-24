/* Author: Rohaan Allport
 * Date Created: 10/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * 
*/


package Borris.events
{
	import flash.events.Event;
	import Borris.panels.*;
	import flash.geom.Rectangle;
	
	
	public class BPanelEvent extends Event
	{
		public static const ACTIVATE:String = "activate";
		public static const CLOSE:String = "close";
		public static const CLOSING:String = "closing";
		public static const DEACTIVATE:String = "deactivate";
		public static const DISPLAY_STATE_CHANGE:String = "displayStateChange";
		public static const DISPLAY_STAGE_CHANGING:String = "displayStateChanging";
		public static const MOVE:String = "move";
		public static const MOVING:String = "moving";
		public static const RESIZE:String = "resize";
		public static const RESIZING:String = "resizing";
		
		//public static const DRAG:String = "drag";
		//public static const DRAGGING:String = "dragging";
		//public static const DROP:String = "drop";
		//public static const DROPPING:String = "dropping";
		
		
		private var _afterBounds:Rectangle;
		private var _beforeBounds:Rectangle;
		

		public function BPanelEvent() 
		{
			// constructor code
		}

	}
	
}
