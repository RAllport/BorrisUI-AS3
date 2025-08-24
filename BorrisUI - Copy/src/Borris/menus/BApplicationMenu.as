/* Author: Rohaan Allport
 * Date Created: 12/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BApplicationMenu class contains methods and properties for defining native application menus.
 *				A menu object contains menu items. A menu item can represent a command, a submenu, or a separator line. Add menu items to a menu using the addItem() or addItemAt() method. The display order of the menu items matches the order of the items in the menu's items array.
 *
 *				To create a submenu, add a menu item to the parent menu object. Assign the menu object representing the submenu to the submenu property of the matching menu item in the parent menu.
 *
 *				Note: The root menu of window and application menus must contain only submenu items; items that do not represent submenus may not be displayed and are contrary to user expectation for these types of menus.
 *
 *				Menus dispatch select events when a command item in the menu or one of its submenus is selected. (Submenu and separator items are not selectable.) The target property of the event object references the selected item.
 *
 *				Menus dispatch preparing events just before the menu is displayed and when a key equivalent attached to one of the items in the menu is pressed. You can use this event to update the contents of the menu based on the current state of the application.
 *
 * 
 *	todo/imporovemtns: 
 *					- Use more constants
 *					- Events to dispatch:
 *						- displaying
 *						- preparing
 *						- select
 *						-
 * 
 * Note: 
 
 * Errors: 	- 
*/


package Borris.menus 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import Borris.menus.*;
	import Borris.managers.*;
	
	
	public class BApplicationMenu extends BNativeMenu
	{
		
		// constants
		public static const APPLICATION_MENU_HEIGHT:int = 32;	// 
		private static const BORDER_WIDTH:int = 4;				// 
		private static const ITEM_PADDING:int = 4;				// 
		
		
		
		// asset variabes
		// All assets are already in super class
		
		
		public function BApplicationMenu(hasBackground:Boolean = true) 
		{
			// constructor code
			super();
			
			if (hasBackground) 
			{
				_style.backgroundColor = 0x222222;
			}
			
			// event handling
			container.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			container.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			container.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
			container.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
			// add a listener to resize with the stage
			
		}
		
		
		// function focusInHandler
		// 
		private function focusInHandler(event:FocusEvent):void
		{
			//trace("Focused in.");
			isFocused = true;
		} // end function focusInHandler
		
		
		// function focusOutHandler
		// 
		private function focusOutHandler(event:FocusEvent):void
		{
			//trace("Focused out.");
			isFocused = false;
		} // end function focusOutHandler
		
		
		// function mouseFocusChangeHandler
		// 
		private function mouseFocusChangeHandler(event:FocusEvent):void
		{
			//trace("mouse focus change.");
			
		} // end function mouseFocusChangeHandler
		
		
		// function keyFocusChangeHandler
		// 
		private function keyFocusChangeHandler(event:FocusEvent):void
		{
			//trace("key focus change.");
			
		} // end function keyFocusChangeHandler
		
		
		// function mouseHandler
		// 
		override protected function mouseHandler(event:MouseEvent = null):void
		{
			// event.currentTarget is the stage (parentStage)
			// event.target can be any object of This BNativeMenu or the BNativeMenuItem that was clicked on
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					case MouseEvent.MOUSE_DOWN:
					if(container.hitTestPoint(event.stageX, event.stageY))
					{
						//trace("container hit down.");
						if(container.stage) 
						{
							container.stage.focus = container;
						}
					}
					if(!container.hitTestPoint(event.stageX, event.stageY))
					{
						//trace("container not hit.");
						if(container.stage) 
						{
							container.stage.focus = null;
						}
						applMenuClicked = false;
					}
					break;
			} // end switch
			
		} //  end function mouseHandler
		
		
		// function deactivateHandler
		// 
		override protected function deactivateHandler(event:Event):void
		{
			// hide all its visible submenus
			// though, the submenus will prob handle that on their own anyway
			
		} // end function deactivateHandler
		
		
		// function draw
		// 
		override internal function draw():void
		{
			
			//trace("BNativeMenu | Drawing menu\n");
			var item:BNativeMenuItem;
			var prevItem:BNativeMenuItem;
			var rightMargin:int = 0;
			
			
			//********************************* DRAWING FOR APPLICATION MENU ************************************************ 
			
			var xPos:int = 0;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.drawForAppMenu();
				
				// find the previous item if there is 1
				if(i > 0)
				{
					prevItem = _items[i - 1];
				} // end if
				
				if(prevItem)
				{
					// set xPos to 2px to the right of the previous item. (place the new item 2px to the right of the previous item)
					xPos = prevItem.x + prevItem.width + rightMargin;
				}
				//trace("BApplicationMenu | Drawing item: " + item.label);
				
				item.x = xPos;
				item.y = 0;
				
			} // end for
			//trace("BNativeMenu | draw(): Drawing for application menu.");
			
			
		} // end function draw
		
		
		// function display
		// Pops up this menu at the specified location.
		override public function display(stage:Stage, stageX:int = 0, stageY:int = 0, animate:Boolean = false):void
		{
			//super.display(stage, 0, 0);
			super.display(stage, stageX, stageY, false);
		} // end function display
		
		
	}

}