/* Author: Rohaan Allport
 * Date Created: 09/03/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * 
*/


package Borris.events 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import Borris.display.*;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BStyleEvent extends Event
	{
		// constants
		public static const STYLE_CHANGE:String = "styleChange";
		public static const STYLE_CLEAR:String = "styleClear";
		//public static const SET:String = "set";
		//public static const REMOVE:String = "remove";
		
		
		//private var _styleOwner:DisplayObjectContainer;
		
		
		
		//public function BStyleEvent(type:String, styleOwner:DisplayObjectContainer) 
		public function BStyleEvent(type:String) 
		{
			super(type, false, false);
			
			//_styleOwner = styleOwner;
		}
		
		
		/**
		 * [read-only] gets the owner DisplayObjectContainer for the BStyle object.
		 * This property is set when the BStyleEvent is instantiated and cannot be changed.
		 * 
		 * @see BUIComponent.style
		 * @see BElement.style
		 * 
		 * @private make setter eventually
		 */
		public function get styleOwner():DisplayObjectContainer
		{
			//return _styleOwner;
			return BStyle(target).owner;
		}
		
	}

}