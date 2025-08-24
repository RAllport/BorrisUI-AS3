/* Author: Rohaan Allport
 * Date Created: 12/10/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 *
 * Todos: 
 * 
 *
 *
 */


package Borris.desktop 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import Borris.desktop.BNativeWindow;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.desktop.*;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.ui.*;
	
	import Borris.display.*;
	import Borris.controls.*;
	import Borris.menus.*;
	import Borris.ui.BMouseCursor;
	import Borris.controls.windowClasses.*;
	import Borris.assets.icons.*;
	import Borris.containers.BPanelBounds;;
	
	
	public class BMainWindow extends BNativeWindow
	{
		
		public function BMainWindow() 
		{
			// constructor code
			
			var newWindowInitOption:NativeWindowInitOptions = new NativeWindowInitOptions();
			newWindowInitOption.maximizable = true;
			newWindowInitOption.minimizable = true;
			newWindowInitOption.renderMode = NativeWindowRenderMode.AUTO;
			newWindowInitOption.resizable = true;
			newWindowInitOption.systemChrome = NativeWindowSystemChrome.NONE;
			newWindowInitOption.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
			newWindowInitOption.type = NativeWindowType.NORMAL;
		
			super(newWindowInitOption);
			thisWindow.close();
			
			thisWindow = NativeApplication.nativeApplication.openedWindows[0];
			
			initialize(thisWindow.bounds);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		/**
		 * 
		 * @param	bounds
		 */
		override protected function initialize(bounds:Rectangle = null):void
		{
			
			super.initialize(bounds);
			_titleBar.title = thisWindow.title;
			
			// if the system chrome is not none, then 
			if (thisWindow.systemChrome != NativeWindowSystemChrome.NONE)
			{
				padding = 0; // set paddig to 0;
				
				// make every child not visible except background and content
				for (var i:int = 0; i < container.numChildren; i++ )
				{
					container.getChildAt(i).visible = false;
				}
				_drawElement.visible = true;
				_content.visible = true;
				
			}
			
		} // end function initialize
		
		
		/**
		 * 
		 * @param event
		 */
		override protected function draw(event:Event = null):void
		{
			super.draw();
			if (thisWindow.systemChrome != NativeWindowSystemChrome.NONE)
			{
				//container.x = 0;
				//container.y = 0;
				_content.x = padding;
				_content.y = padding + _titleBar.height;
			}
		} // end 
		
		
		// ************************************************* SET AND GET **************************************************
		
		
		override public function set width(value:Number):void
		{
			thisWindow.width = value;
			resizeAlign();
		}
		
		override public function get width():Number
		{
			return thisWindow.bounds.width;
		}
		
		override public function set height(value:Number):void
		{
			thisWindow.height = value;
			resizeAlign();
		}
		
		override public function get height():Number
		{
			return thisWindow.bounds.height;
		}
		
		
	}

}