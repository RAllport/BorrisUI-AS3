/* Author: Rohaan Allport
 * Date Created: 12/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BApplicationMenu class contains methods and properties for defining native context menus.
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
	import Borris.managers.BStyleManager;
	
	
	public class BContextMenu extends BNativeMenu
	{
		// constants
		private static const BORDER_WIDTH:int = 1;				// 
		private static const ITEM_PADDING:int = 0;				// 
		
		
		// asset variabes
		// All assets are already in super class
		
		public function BContextMenu() 
		{
			// constructor code
			super();
		}
		
		
		// function mouseHandler
		// 
		override protected function mouseHandler(event:MouseEvent = null):void
		{
			// event.currentTarget is the stage (parentStage)
			// event.target can be any object of This BNativeMenu or the BNativeMenuItem that was clicked on
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					// hide the menu if it was NOT clicked on
					if(!container.hitTestPoint(event.stageX, event.stageY))
					{
						// the following is "shit code", quick, dirty, half asses quick fix to make the menu NOT hide if this menu's parent is an Application menu
						if (this.parent)
						{
							//trace("BContextMenu | has parent");
							if (this.parent is BApplicationMenu)
							{
								//trace("BContextMenu | Parent is BApplicationMenu");
								if (this.parent.isFocused)
								{
									//trace("BContextMenu | Parent is focus");
									return;
								}
								//return;
							}
						} // end shit code
						
						hide();
					}
					break;
				
			} // end switch
			
		} //  end function mouseHandler
		
		
		// function deactivateHandler
		// 
		override protected function deactivateHandler(event:Event):void
		{
			hide();
			
		} // end function deactivateHandler
		
		
		// function draw
		// 
		override internal function draw():void
		{
			//trace("BNativeMenu | Drawing menu\n");
			var item:BNativeMenuItem;
			var prevItem:BNativeMenuItem;
			
			
			//********************************* DRAWING FOR CONTEXT MENU ************************************************ 
			
			_height = BORDER_WIDTH * 2;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.draw();
				item.x = BORDER_WIDTH;
				item.y = BORDER_WIDTH;
				
				// find the previous item if there is 1
				if(i > 0)
				{
					prevItem = _items[i - 1];
				} // end if
				
				if(!item.isSeparator)
				{
					_height += BNativeMenuItem.TOP_MARGIN + BNativeMenuItem.ITEM_HEIGHT;
					if(prevItem)
					{
						item.y = prevItem.y + BNativeMenuItem.TOP_MARGIN + BNativeMenuItem.ITEM_HEIGHT;
						if (prevItem.isSeparator)
						{
							item.y = prevItem.y + BNativeMenuItem.SEPARATOR_TOP_MARGIN + BNativeMenuItem.SEPARATOR_HEIGHT + BNativeMenuItem.SEPARATOR_BOTTOM_MARGIN;
						}
					}
				} // end if
				else if(item.isSeparator) // if it is a separator
				{
					_height += BNativeMenuItem.SEPARATOR_TOP_MARGIN + BNativeMenuItem.SEPARATOR_HEIGHT + BNativeMenuItem.SEPARATOR_BOTTOM_MARGIN;
					if(prevItem)
					{
						item.y = prevItem.y + BNativeMenuItem.ITEM_HEIGHT + BNativeMenuItem.SEPARATOR_TOP_MARGIN;// + BNativeMenuItem.SEPARATOR_HEIGHT;
						if (prevItem.isSeparator)
						{
							item.y = prevItem.y + BNativeMenuItem.SEPARATOR_TOP_MARGIN + BNativeMenuItem.ITEM_HEIGHT;
						}
					}
				} //  end else if
				
				
				
			} // end for
			
			
			// set x, y, width, height
			_width = BORDER_WIDTH * 2 + BNativeMenuItem.longestTotalWidth;
			// _height
			
			
			iconSeparator.x = BORDER_WIDTH + BNativeMenuItem.ICON_WIDTH + int(BNativeMenuItem.TEXT_ICON_SPACING/2); // 26;
			iconSeparator.y = Math.round(BORDER_WIDTH/2);
			iconSeparator.height = _height - (BORDER_WIDTH);
			
			_style.backgroundColor = 0x222222;
			_style.borderColor = 0x666666;
			_style.borderWidth = 1;
			//_style.borderRadius = 8;
			
		} // end function draw
		
		
	}

}