/* Author: Rohaan Allport
 * Date Created: 11/07/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BNativeMenu class contains methods and properties for defining native menus.
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
 *					- Use more constandes
 *					- Events to dispatch:
 *						- displaying
 *						- preparing
 *						- select
 *						-
 * 
 * Note: 
 
 * Errors: 	- 
			- 
			- 
			- 
*/


package Borris.menus
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.display.BStyle;
	import Borris.menus.*;
	
	
	public class BNativeMenu extends EventDispatcher
	{
		// constants
		public static const APPLICATION_MENU_HEIGHT:int = 25;	// 
		internal static const BORDER_WIDTH:int = 4;				// 
		internal static const ITEM_PADDING:int = 4;				// 
		
		protected static var applicationMenuSet:Boolean = false;
		
		// asset variabes
		internal var container:Sprite;						// 
		protected var _style:BStyle;
		protected var iconSeparator:Sprite;					// 
		
		// other
		protected var _isApplicationMenu:Boolean;
		internal var _width:int;
		internal var _height:int;
		protected var parentStage:Stage;
		internal var isFocused:Boolean = false;
		internal var applMenuClicked:Boolean = false;
		
		
		
		// set and get private variables
		protected var _items:Array;				// The array of NativeMenuItem objects in this menu.
		internal var _parent:BNativeMenu;		// [read-only] The parent menu.
		
		
		public function BNativeMenu() 
		{
			// constructor code
			
			
			// create the container sprite
			container = new Sprite();
			container.scaleX = container.scaleY = 1;
			container.focusRect = false;
			_width = 0;
			_height = 0;
			
			iconSeparator = new Sprite();
			iconSeparator.graphics.beginFill(0x222222, 1);
			iconSeparator.graphics.drawRect(0, 0, 1, 100);
			iconSeparator.graphics.beginFill(0x666666, 1);
			iconSeparator.graphics.drawRect(1, 0, 1, 100);
			iconSeparator.graphics.endFill();
			
			// create and array to hole the items
			_items = [];
			
			
			// initialize the style object
			_style = new BStyle(container);
			_style.backgroundColor = 0x222222;
			
		}
		
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function mouseHandler
		// 
		protected function mouseHandler(event:MouseEvent = null):void
		{
			// event.currentTarget is the stage (parentStage)
			// event.target can be any object of This BNativeMenu or the BNativeMenuItem that was clicked on
			
			// override this function	
			
		} //  end function mouseHandler
		
		
		// function deactivateHandler
		// 
		protected function deactivateHandler(event:Event):void
		{
			// override this function
			hide();
		} // end function deactivateHandler
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Hide the the menu and remove it from the stage.
		 */
		internal function hide():void
		{
			// check for parent stage and isApplicationMenu
			if(parentStage)
			{
				container.visible = false;
				
				// check to see if the parent stage contains the container
				if(parentStage.contains(container)) 
				{
					parentStage.removeChild(container);
				}
				if(parentStage.hasEventListener(MouseEvent.MOUSE_DOWN))
					parentStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				
				parentStage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
				//trace("BNativeMenu | hide()");
			} // end if
			
			
			// this works the same way as above ._. 
			/*if(container.parent && !this.isApplicationMenu)
			{
				container.parent.removeChild(container);
				trace("BNativeMenu | hiding context menu");
				
				if(parentStage.hasEventListener(MouseEvent.MOUSE_DOWN))
					parentStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			} // end if*/
			
		} // end function hide
		
		
		/**
		 * 
		 */
		internal function draw():void
		{
			// override this function in a subclass
		} // end function draw
		
		
		/**
		 * Adds a menu item at the bottom of the menu.
		 * 
		 * @param item
		 * @return
		 */
		public function addItem(item:BNativeMenuItem):BNativeMenuItem
		{
			// check to see if there is an _items array and create a new one if there isn't
			if(!_items)
			{
				_items = new Array();
			} // end if
			
			// check to see if item is already in this menu
			if(containsItem(item))
			{
				//throw new Error("The specified item is alread contained in this menu.");
				trace("The specified item is already contained in this menu.");
				return item;
			} // end if
			
			item._menu = this;
			item.display(container);
			_items.push(item);
			
			// redraw the menu
			draw();
			
			return item;
			
		} // end function addItem
		
		
		/**
		 * Inserts a menu item at the specified position.
		 * 
		 * @param item
		 * @param index
		 * @return
		 */
		public function addItemAt(item:BNativeMenuItem, index:int):BNativeMenuItem
		{
			// check to see if there is an _items array and create a new one if there isn't
			if(!_items)
			{
				_items = new Array();
			} // end if
			
			// check to see if item is already in this menu
			if(containsItem(item))
			{
				//throw new Error("The specified item is alread contained in this menu.");
				trace("The specified item is already contained in this menu.");
				return item;
			} // end if
			
			item._menu = this;
			item.display(container);
			_items.splice(index, 0, item);
			
			// redraw the menu
			draw();
			
			return item;
		
		} // end function addItemAt
		
		
		/**
		 * Adds a submenu to the menu by inserting a new menu item.
		 * 
		 * @param submenu
		 * @param label
		 * @return
		 */
		public function addSubmenu(submenu:BNativeMenu, label:String):BNativeMenuItem
		{
			var item:BNativeMenuItem = new BNativeMenuItem(label, false);
			item.submenu = submenu;
			
			addItem(item);
			
			// assign the submenu's parent this this
			submenu._parent = this; //item.menu;
			
			// redraw the menu
			draw();
			
			return item;
		
		} // end function addSubmenu

		
		/**
		 * Adds a submenu to the menu by inserting a new menu item at the specified position.
		 * 
		 * @param submenu
		 * @param index
		 * @param label
		 * @return
		 */
		public function addSubmenuAt(submenu:BNativeMenu, index:int, label:String):BNativeMenuItem
		{
			var item:BNativeMenuItem = new BNativeMenuItem(label, false);
			item.submenu = submenu;
			
			addItemAt(item, index);
			
			// assign the submenu's parent this this
			submenu._parent = this; //item.menu;
			
			// redraw the menu
			draw();
			
			return item;
		} // end function addSubmenuAt
		
		
		/**
		 * Creates a copy of the menu and all items.
		 * 
		 * @return
		 */
		public function clone():BNativeMenu
		{
			var menu:BNativeMenu = new BNativeMenu();
			
			// loop through all its items and clone them
			for (var i:int = 0; i < this.numItems; i++)
			{
				menu.addItem(this.getItemAt(i).clone());
			} // end for 
			
			return menu;
			
		} // end function clone
		
		
		/**
		 * Reports whether this menu contains the specified menu item.
		 * 
		 * @param item
		 * @return
		 */
		public function containsItem(item:BNativeMenuItem):Boolean
		{
			// something wrong
			
			var value:Boolean = false;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				if(item == _items[i])
				{
					//trace("found item");
					return true;
				}
				
			} // end for
			
			return false;
		} // end function containsItem
		
		
		/**
		 * Pops up this menu at the specified location.
		 * 
		 * @param stage
		 * @param stageX
		 * @param stageY
		 * @param animate
		 */
		public function display(stage:Stage, stageX:int = 0, stageY:int = 0, animate:Boolean = true):void
		{
			// Note: In a flash player application, the stage, might not be ready, when the display is called.
			// need to find a way to get around this.
			
			// quick fix the make all the menu items go back to their original state
			//draw(); sigh, causes another drawing error. makes all menus the same length. the length of the longest menu.
			
			// dispatch a new Event.DISPLAYING Event object
			//this.dispatchEvent(new Event(Event.DISPLAYING, false, false));
			
			parentStage = stage; // set parentStage property to stage
			
			// add an event listener to parentStage
			parentStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			parentStage.addEventListener(Event.DEACTIVATE, deactivateHandler);
			//trace("BNativeMenu | MouseEvent.MOUSE_DOWN event added to stage");
			
			
			container.visible = true; // make the container (that holds all the assets) visible
			
			
			container.x = stageX;
			container.y = stageY;
			
			if (animate)
			{
				var tween1:Tween = new Tween(container, "x", Regular.easeOut, stageX - 100, stageX, 0.2, true);
				//var tween2:Tween = new Tween(container, "y", Regular.easeOut, stageY - 100, stageY, 0.2, true);
				var tween3:Tween = new Tween(container, "alpha", Regular.easeOut, 0, 1, 0.2, true);
				container.y = stageY;
			}
			else
			{
				container.x = stageX;
				container.y = stageY;
			}
			
			// add the container to the stage
			stage.addChildAt(container, stage.numChildren);
			
		} // end function display
		
		
		/**
		 * Gets the menu item at the specified index.
		 * 
		 * @param index
		 * @return
		 */
		public function getItemAt(index:int):BNativeMenuItem
		{
			if(_items.length - 1 >= index)
			{
				return _items[index];
			}
			else
			{
				throw new Error("The suplied index is out of bounds.", 0);
			}
			
		} // end function getItemAt
		
		
		/**
		 * Gets the menu item with the specified name.
		 * 
		 * @param name
		 * @return
		 */
		public function getItemByName(name:String):BNativeMenuItem
		{
			var item:BNativeMenuItem;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				if(item.name == name)
				{
					return item;
				} // end if
				
			} //  end for
			
			return null;
			
		} // end function getItemByName
		
		
		/**
		 * Gets the menu item with the specified label.
		 * 
		 * @param label
		 * @return
		 */
		public function getItemByLabel(label:String):BNativeMenuItem
		{
			var item:BNativeMenuItem;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				if(item.label == label)
				{
					return item;
				} // end if
				
			} //  end for
			
			return null;
			
		} // end function getItemByLabel
		
		
		/**
		 * Gets the position of the specified item.
		 * 
		 * @param item
		 * @return
		 */
		public function getItemIndex(item:BNativeMenuItem):int
		{
			
			if(containsItem(item))
			{
				return _items.indexOf(item);
			}
			else
				throw new Error("The specified index was not found.");
			
			//trace("BNativeMenu | getItemIndex(): " + _items.indexOf(item));

		} // end function getItemIndex
		
		
		/**
		 * Removes all items from the menu.
		 */
		public function removeAllItems():void
		{
			
			var item:BNativeMenuItem;
			
			// loop backwards
			for(var i:int = _items.length - 1; i >= 0; i--)
			{
				this.removeItemAt(i);
			} // end for
			//trace("removeAllItems function incomplete.");
			
		} // end function removeAllItems
		
		
		/**
		 * Removes the specified menu item.
		 * 
		 * @param item
		 * @return
		 */
		public function removeItem(item:BNativeMenuItem):BNativeMenuItem
		{
			if(containsItem(item))
			{
				_items.splice(this.getItemIndex(item), 1);
				
				// remove the item container from its parent
				//item.container.parent.removeChild(item.container);
				
				// redraw the menu
				draw();
			}
			else
				throw new Error("The specified BNativeMenuItem is not contained within this BNativeMenu.");
			
			// redraw the menu
			draw();
			
			return item;
			
		} // end function removeItem
		
		
		/**
		 * Removes and returns the menu item at the specified index.
		 * 
		 * @param index
		 * @return
		 */
		public function removeItemAt(index:int):BNativeMenuItem
		{	
			var item:BNativeMenuItem = _items[index];
			if(containsItem(item))
			{
				_items.splice(index, 1);
				
				// remove the item container from its parent
				//item.container.parent.removeChild(item.container);
				
				// redraw the menu
				draw();
			}
			else
				throw new Error("The specified BNativeMenuItem is not contained within this BNativeMenu.");
			
			// redraw the menu
			draw();
			
			return item;
			
		} // end function removeItemAt
		
		
		/**
		 * Moves a menu item to the specified position.
		 * 
		 * @param item
		 * @param index
		 */
		public function setItemIndex(item:BNativeMenuItem, index:int):void
		{
			if(containsItem(item))
			{
				_items.splice(index, 0, item);
				
				// redraw the menu
				draw();
			}
			else
				throw new Error("The specified BNativeMenuItem is not contained within this BNativeMenu.");
			
		} // end function setItemIndex
		
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * 
		 */
		public function set items(value:Array):void
		{
			if(_items)
			{
				removeAllItems();
			}
			
			_items = value;
		}
		
		public function get items():Array
		{
			return _items;
		} 
		
		
		/**
		 * 
		 */
		public function get numItems():int
		{
			return _items.length;
		} // 
		
		
		/**
		 * 
		 */
		public function get parent():BNativeMenu
		{
			return _parent;
		}
		
		
		/**
		 * 
		 */
		internal function set x(value:int):void
		{
			container.x = value;
		}
		internal function get x():int
		{
			return container.x;
		}
		
		
		/**
		 * 
		 */
		internal function set y(value:int):void
		{
			container.y = value;
		}
		internal function get y():int
		{
			return container.y;
		}
		
		
		
	}
	
}
