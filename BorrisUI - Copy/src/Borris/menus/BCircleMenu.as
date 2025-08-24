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
	
	
	public class BCircleMenu extends BNativeMenu
	{
		// constants
		private static const BORDER_WIDTH:int = 4;				// 
		private static const ITEM_PADDING:int = 4;				// 
		
		
		// asset variabes
		// All assets are already in super class
		
		// other
		protected var _innerRadius:Number = 10;
		protected var _outerRadius:Number = 80;
		
		
		public function BCircleMenu() 
		{
			// constructor code
			super();
			
			// define asset variables
			// context menu assets
			// All assets are already defined in super class
			
			//container.addChild(contextMenuBackground);
			//container.addChild(iconSeparator);
			
			container.filters = new Array(new DropShadowFilter(4, 45, 0x000000, 1, 4, 4, 1, 1, false, false));
			
			// event handling
			
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
							if (this.parent is BApplicationMenu)
							{
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
			
		} // end function draw
		
	}

}