/* Author: Rohaan Allport
 * Date Created:  (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The ScrollPane component displays display objects and JPEG, GIF, and PNG files, as well as SWF files, in a scrollable area.
 * 
 * 
*/


package Borris.containers 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.*;
	
	
	
	public class BScrollPane extends BBaseScrollPane
	{
		// assets
		
		
		// other
		
		
		// set and get
		//protected var _scrollDrag:Boolean;						// Gets or sets a value that indicates whether scrolling occurs when a user drags on content within the scroll pane.
		//protected var _content:DisplayObject;						// [read-only] Gets a reference to the content loaded into the scroll pane.
		
		
		public function BScrollPane(parent:DisplayObjectContainer=null, x:Number=0, y:Number=0) 
		{
			super(parent, x, y);
		}
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		/*
		
		// function load
		// The request parameter of this method accepts only a URLRequest object whose source property contains a string, a class, or a URLRequest object.
		public function load(request:URLRequest, context:LoaderContext = null):void
		{
			
		} // end function load
		
		
		// function refreshPane
		// Reloads the contents of the scroll pane.
		public function refreshPane():void
		{
			
		} // end function refreshPane
		
		
		// function update
		// Refreshes the scroll bar properties based on the width and height of the content.
		public function update():void
		{
			
		} // end function update
		
		*/
		
		//***************************************** SET AND GET *****************************************
		
		// content
		public function get content():DisplayObjectContainer
		{
			update();
			draw();
			return container;
		}
		
		
		
	}

}