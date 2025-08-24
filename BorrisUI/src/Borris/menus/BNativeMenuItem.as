/* Author: Rohaan Allport
 * Date Created: 03/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The NativeMenuItem class represents a single item in a menu.
 *			A menu item can be a command, a submenu, or a separator line:
 *			
 *			To create a command item, call the NativeMenuItem constructor, passing in a string for the label and false for the isSeparator parameter.
 *			To create a submenu, create a command item for the parent menu and assign the NativeMenu object of the submenu to the item's submenu property. You can also call the addSubmenu() method of the parent NativeMenu object to create the item and set the submenu property at the same time.
 *			To create a separator, call the NativeMenuItem constructor, passing in an empty string for the label and true for the isSeparator parameter.
 * 
 *	todo/imporovemtns: 
 *					- Use more constandes, for like text x, text y, text height. item width, item height
 *					- Events to dispatch:
 *						- displaying
 *						- preparing
 *						- select
 *						-
 * 
 * Note: KeyEquivalentModifier property must be set b4 keyEqivalent, both in and out of class.
 * 		- enabled, checked, and submenu should be/ are all connected
 *		- icon and checked are connected
 *		- checked and submenu are connected
 * 
 * Erros: 
	 * - somewhere in clone() function
*/


package Borris.menus
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.geom.Matrix;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.*;
	import Borris.assets.icons.MenuArrowIcon10x10;
	import Borris.assets.icons.TickIconFlat256_256;
	import Borris.assets.icons.ArrowIcon02_32x32;
	
	
	public class BNativeMenuItem extends EventDispatcher
	{
		// constants
		internal static const TOP_MARGIN:int = 0;				//
		internal static const BOTTOM_MARGIN:int = 1;			//
		internal static const ITEM_HEIGHT:int = 40;
		
		internal static const SEPARATOR_TOP_MARGIN:int = 2;		// 
		internal static const SEPARATOR_BOTTOM_MARGIN:int = 2;	// 
		internal static const SEPARATOR_HEIGHT:int = 2;
		
		internal static const LEFT_BORDER_WIDTH:int = 2;		// 
		internal static const RIGHT_BORDER_WIDTH:int = 2;		// 
		
		internal static const ICON_WIDTH:int = 40;				// 
		internal static const TEXT_ICON_SPACING:int = 8;		// 
		internal static const ARROW_ICON_SPACING:int = 16;		// 
		internal static const TEXT_SPACING:int = 32;			// 
		
		
		// assets
		internal var container:Sprite;
		protected var button:BLabelButton;
		
		// context menu assets
		private var arrowIcon:DisplayObject;
		protected var tickIcon:DisplayObject;
		
		// text fields and formats
		private var keyEquivalentText:BLabel;
		
		
		// other
		internal static var longestTotalWidth:int = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING;
		private var totalWidth:int = 340;
		internal var submenuRolledOver:Boolean = false;	// 
		protected var offset:Number = 0;
		
		
		// Set and get
		private var _checked:Boolean;				// Controls whether this menu item displays a checkmark.
		private var _data:Object;					// An arbitrary data object associated with this menu item.
		private var _isSeparator:Boolean; 			// [read-only] Reports whether this item is a menu separator line.
		private var _keyEquivalent:String;			// The key equivalent for this menu item.
		private var _keyEquivalentModifiers:Array;	// The array of key codes for the key equivalent modifiers.
		internal var _menu:BNativeMenu;				// [read-only] The menu that contains this item.
		private var _mnemonicIndex:int;				// The position of the mnemonic character in the menu item label.
		private var _name:String;					// The name of this menu item.
		private var _submenu:BNativeMenu;			// The submenu associated with this menu item.
		
		
		// set and get (for internal properties)
		private var _width:int;							// [read-only] The width of this item
		private var _height:int;						// [read-only] The height of this item
		

		public function BNativeMenuItem(label:String = "", isSeparator:Boolean = false, enabled:Boolean = true) 
		{
			// constructor code
			container = new Sprite();
			
			button = new BLabelButton(container, 0, 0, label);
			button.autoSize = false;
			
			// do setters
			this.data = null;
			_isSeparator = isSeparator;
			this.label = label;
			// menu
			//this.mnemonicIndex = 0;
			// name
			// submenu
			
			
			keyEquivalentText = new BLabel(null, 0, 0, "");
			keyEquivalentText.autoSize = TextFieldAutoSize.LEFT;
			
			
			// calculate the width of this menu item
			//totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} //  end if
			
			
			// create the assets
			arrowIcon = new MenuArrowIcon10x10();
			arrowIcon.visible = false;
			
			tickIcon = new TickIconFlat256_256();
			
			// if label is empty and _separetor is false
			if(label != "" && !_isSeparator)
			{
				// don't make this item a separator
				this.setSeparator(false);
			} 
			else
			{
				// make this item a separator
				this.setSeparator(true);
			} // end else
			
			// more setters
			this.checked = false;
			this.enabled = enabled;
			_keyEquivalentModifiers = [Keyboard.SHIFT];
			this.keyEquivalent = "";
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function mouseHandler
		// this is for context menus
		/**
		 * 
		 * @param event
		 */
		private function mouseHandler(event:MouseEvent):void
		{
			// if this item was clicked on, and it does NOT have a a submenu.
			// The CLICK listener is added and removed in the "set enabled" function
			if(event.type == MouseEvent.CLICK && !this.submenu)
			{
				// dispatch a new Event.SELECT object
				this.dispatchEvent(new Event(Event.SELECT, true, false));
				
				// set checked to not checked
				this.checked = !this.checked;
				
				// hide the menu that contains this item
				if(!(this.menu is BApplicationMenu))
					this.menu.hide();
					
				return;
			} // end if
			
			
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
					if(enabled)
					{
						showSubmenu();
					}
					
					// this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
					for (var i:int = 0; i < this.menu.numItems; i++ )
					{
						if (this.menu.getItemAt(i).submenuRolledOver && this.menu.getItemAt(i) != this)
						{
							this.menu.getItemAt(i).submenuRolledOver = false;
							this.menu.getItemAt(i).hideSubmenu();
							
						}
					} // end for
					
					break;
				
			} // end switch
			
		} // end function mouseHandler
		
		
		// function mouseHandler2
		// this is for application menus
		/**
		 * 
		 * @param event
		 */
		private function mouseHandler2(event:MouseEvent):void
		{
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.menu.applMenuClicked = true;
					
					if(this.submenu)
					{
						this.submenu.display(container.parent.stage, this.menu.x + this.x, this.menu.y + this.y + this.height, false);
					} // end if
					
					break;
				
				case MouseEvent.ROLL_OVER:
					if(enabled)
					{
						if(this.submenu && this.menu.applMenuClicked == true)
						{
							this.submenu.display(container.parent.stage, this.menu.x + this.x, this.menu.y + this.y + this.height, false);
							submenuRolledOver = true;
						} // endn if
					}
					
					// this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
					for (var i:int = 0; i < this.menu.numItems; i++ )
					{
						if (this.menu.getItemAt(i) != this)
						{
							this.menu.getItemAt(i).hideSubmenu();
						}
					} // end for
					
					break;
				
			} // end switch
			
		} // end function mouseHandler2
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 * @return
		 */
		public function clone():BNativeMenuItem
		{
			var newItem:BNativeMenuItem = new BNativeMenuItem(this.label, this.isSeparator);
			/*if (newItem.isSeparator)
			{
				return newItem;
			}*/
			//newItem.label = this.label;
			if(this.data) newItem.data = this.data;
			newItem.enabled = this.enabled;
			if(this.keyEquivalent) newItem.keyEquivalent = this.keyEquivalent;
			newItem.keyEquivalentModifiers = this.keyEquivalentModifiers;
			//newItem.menu = this.menu; [read-only]
			if(this.mnemonicIndex) newItem.mnemonicIndex = this.mnemonicIndex;
			if(this.name) newItem.name = this.name;
			if(this.submenu) newItem.submenu = this.submenu.clone();
			
			return newItem;
		} // end function clone
		
		
		/**
		 * [override] Returns a string containing all the properties of the BNativeMenuItem object.
		 * 
		 * @return
		 */
		override public function toString():String
		{
			var s:String = "BNativeMenuItem | \n";
			//s += "\t: " + this + "\n";
			s += "\tchecked: " + this.checked + "\n";
			s += "\tdata: " + this.data + "\n";
			s += "\tenabled: " + this.enabled + "\n";
			s += "\tisSeparator: " + this.isSeparator + "\n";
			s += "\tkeyEquivalent: " + this.keyEquivalent + "\n";
			s += "\tkeyEquivalentModifiers: " + this.keyEquivalentModifiers + "\n";
			s += "\tlabel: " + this.label + "\n";
			s += "\tmenu: " + this.menu.toString() + "\n";
			s += "\tmnemonicIndex: " + this.mnemonicIndex + "\n";
			s += "\tname: " + this.name + "\n";
			s += "\tsubmenu: " + this.submenu + "\n";
			
			
			return s;
		} // end function toString
		
		
		/**
		 * 
		 */
		public function draw():void
		{
			// calculate the width of this menu item
			// this SHIT cost me like 10 hours to fix!
			//totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} // end if
			
			
			if(this.isSeparator)
			{
				keyEquivalentText.visible = false;
				
				button.x = 10;
				button.width = longestTotalWidth - 20;
				button.height = 1;
				button.setStateColors(0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC, 0xCCCCCC);
				button.setIcon(null);
				
				return;
			}
			else if(!this.isSeparator)
			{
				var buttonWidth:int = longestTotalWidth;
				var buttonHeight:int = ITEM_HEIGHT;
				
				button.x = 0;
				button.width = buttonWidth;
				button.height = buttonHeight;
				button.textField.x = 30;
				button.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
				button.setStateAlphas(0, 0.5, 0.5, 0, 0.5, 0.5, 0.5, 0);
				button.setIcon(null, null, null, null, null, new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256());
				//button.setIcon(null, null, null, null, null, tickIcon, tickIcon, tickIcon, tickIcon);
				button.setIconBounds(10, 10, 16, 16);
				button.toggle = true;
				
				button.addChild(keyEquivalentText);
				keyEquivalentText.x = longestTotalWidth - keyEquivalentText.width - RIGHT_BORDER_WIDTH - ARROW_ICON_SPACING;
				keyEquivalentText.y = button.height / 2 - keyEquivalentText.height / 2;
				
				
				button.addChild(arrowIcon);
				//arrowIcon.x = longestTotalWidth - buttonHeight/2;
				arrowIcon.x = longestTotalWidth - arrowIcon.width - RIGHT_BORDER_WIDTH - int(ARROW_ICON_SPACING/2);
				arrowIcon.y = button.height / 2;
				
			}
			
			
			if(!container.hasEventListener(MouseEvent.ROLL_OVER))
				container.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
				
			if(!container.hasEventListener(MouseEvent.ROLL_OUT))
				container.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
			
		} // end function draw
		
		
		/**
		 * 
		 * @param width
		 * @param height
		 */
		public function drawForAppMenu(width:int = 100, height:int = 0):void
		{
			button.autoSize = true;
			button.height = _height = 30;
			button.setIcon(null);
			
			_width = button.width;
			
			// events handling
			if(!container.hasEventListener(MouseEvent.ROLL_OVER))
				container.addEventListener(MouseEvent.ROLL_OVER, mouseHandler2);
				
			if(!container.hasEventListener(MouseEvent.ROLL_OUT))
			container.addEventListener(MouseEvent.ROLL_OUT, mouseHandler2);
			
			if(!container.hasEventListener(MouseEvent.MOUSE_DOWN))
				container.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler2);
			
		} // end function drawForAppMenu
		
		
		/**
		 * 
		 */
		public function drawForCircleMenu():void
		{
			
		} // end function drawForCircleMenu
		
		
		/**
		 * 
		 */
		internal function showSubmenu():void
		{
			if(this.submenu)
			{
				submenuRolledOver = true;
				//this.submenu.display(container.parent.stage, this.menu.x + this.menu._width, this.menu.y + this.y, false);
				this.submenu.display(container.parent.stage, this.menu.x + this.menu._width - 1, this.menu.y + this.y, false);
				
			} // end if
		} // end function showSubmenu
		
		
		/**
		 * 
		 */
		internal function hideSubmenu():void
		{
			if(this.submenu)
			{
				this.submenu.hide();
			} // end if
		} // end function hideSubmenu
		
		
		// function setSeparator
		// call the once in the contructor.
		// this function sets the visibility if the appropriate assets. aka, if it's a separator, everything invisible yo! (except for line)
		/**
		 * 
		 * @param value
		 */
		private function setSeparator(value:Boolean):void
		{
			
			if(!value)
			{
				container.mouseEnabled = container.mouseChildren = true;
				container.tabEnabled = container.tabChildren = true;
				button.enabled = true;
			} 
			else
			{
				arrowIcon.visible = false;
				
				container.mouseEnabled = container.mouseChildren = false;
				container.tabEnabled = container.tabChildren = false;
				button.enabled = false;
			} // end else
			
			
		} // end function setSeparator
		
		
		/**
		 * 
		 * @param container
		 */
		public function display(container:DisplayObjectContainer):void
		{
			// add the container of this items assets to the DisplayObjectContainer passed as the argument
			container.addChild(this.container);
		} // end function display
		

		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * 
		 */
		public function get checked():Boolean
		{
			//return button.selected;
			return _checked;
		}
		
		public function set checked(value:Boolean):void
		{
			button.toggle = value;
			button.selected = value;
			_checked = value;
		}
		
		
		/**
		 * 
		 */
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		/**
		 * 
		 */
		public function get enabled():Boolean
		{
			return button.enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(value)
			{
				if(!this.submenu)
				{
					container.addEventListener(MouseEvent.CLICK, mouseHandler);
				} // end if
			} // end if
			else
			{
				container.removeEventListener(MouseEvent.CLICK, mouseHandler);
			} // end else
			
			button.enabled = value;
		}
		
		
		/**
		 * 
		 */
		public function get isSeparator():Boolean
		{
			return _isSeparator;
		}
		
		
		// keyEquivalent
		// Set the keyEquivalent with a lowercase letter to assign a shortcut without a Shift-key modifier. Set with an uppercase letter to assign a shortcut with the Shift-key modifier.
		// By default, a key equivalent modifier (Ctrl on Windows or Linux and Command on Mac OS X) is included as part of the key equivalent. If you want the key equivalent to be a key with no modifier, set the keyEquivalentModifiers property to an empty array.
		/**
		 * 
		 */
		public function get keyEquivalent():String
		{
			return _keyEquivalent;
		}
		
		public function set keyEquivalent(value:String):void
		{
			if(value != "")
			{
				// check length of string
				if(value.length > 1)
				{
					//throw new Error("The keyEquivalent should only be 1 character long.");
					trace("BNativeMenuItem | The keyEquivalent should only be 1 character long.\n");
					value = value.slice(0, 1);
				} // end if
				
				
				// check for modifiers
				if(keyEquivalentModifiers)
				{
					
					keyEquivalentText.text = "";
					
					for(var i:int = 0; i < keyEquivalentModifiers.length; i++)
					{
						if(keyEquivalentModifiers[i] == Keyboard.CONTROL)
						{
							keyEquivalentText.textField.appendText("Ctrl+");
						}
						if(keyEquivalentModifiers[i] == Keyboard.SHIFT)
						{
							keyEquivalentText.textField.appendText("Shift+");
						}
						if(keyEquivalentModifiers[i] == Keyboard.ALTERNATE)
						{
							keyEquivalentText.textField.appendText("Alt+");
						}
					} // end for
					
				} // end if
				
			} // end if
			
			value = value.toUpperCase();
			keyEquivalentText.textField.appendText(value);
			_keyEquivalent = value;
			
			// calculate the width of this menu item
			// this SHIT cost me like 10 hours to fix!
			//totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} // end if
			
			if (this.menu)
			{
				this.menu.draw();
			}
			
		}
		
		
		/**
		 * 
		 */
		public function get keyEquivalentModifiers():Array
		{
			return _keyEquivalentModifiers;
		}
		
		public function set keyEquivalentModifiers(value:Array):void
		{
			if(value)
			{
				if(value.length > 3)
				{
					throw new Error("The keyEquivalentModifiers can have no more than 3 values.");
				}
				
				for(var i:int = 0; i < keyEquivalentModifiers.length; i++)
				{
					if(keyEquivalentModifiers[i] != Keyboard.SHIFT || keyEquivalentModifiers[i] != Keyboard.ALTERNATE || keyEquivalentModifiers[i] != Keyboard.CONTROL)
					{
						//trace("The keyEquivalentModifiers can have no more than 3 values containing Shift, Ctrll or Alt");
						//throw new Error("The keyEquivalentModifiers can have no more than 3 values containing Shift, Ctrll or Alt");
					}
				} // end for
			}
			
			_keyEquivalentModifiers = value;
			
			// set keyEquivalent (setter) to _keyEquivalent to redraw and update text
			keyEquivalent = _keyEquivalent;
		}
		
		
		/**
		 * 
		 */
		public function get label():String
		{
			return button.label;
		}
		
		public function set label(value:String):void
		{
			button.label = value;
		}
		
		
		/**
		 * 
		 */
		public function get menu():BNativeMenu
		{
			return _menu;
		}
		
		
		/**
		 * 
		 */
		public function get mnemonicIndex():int
		{
			return _mnemonicIndex;
		}
		
		public function set mnemonicIndex(value:int):void
		{
			_mnemonicIndex = value;
		}
		
		
		/**
		 * 
		 */
		internal function get name():String
		{
			return _name;
		}
		
		internal function set name(value:String):void
		{
			name = value;
		}
		
		
		/**
		 * 
		 */
		public function get submenu():BNativeMenu
		{
			return _submenu;
		}
		
		public function set submenu(value:BNativeMenu):void
		{
			if(!this.isSeparator)
			{
				if(value)
				{
					arrowIcon.visible = true;
					this.keyEquivalent = "";
					this.keyEquivalentModifiers = [];
					this.checked = false;
				}
				else
				{
					arrowIcon.visible = false;
				}
			}
			
			// assign the submenu's parent this items menu
			value._parent = this.menu;
			
			_submenu = value;
		}
		
		
		/**
		 * 
		 */
		public function get icon():DisplayObject
		{
			return button.icon;
		}
		
		public function set icon(value:DisplayObject):void
		{
			button.icon = value;
		}
		
		
		
		
		
		//********************************** INTERNAL SETTER AND GETTERS *******************************************
		
		/**
		 * 
		 */
		public function get x():int
		{
			return container.x;
		}
		
		public function set x(value:int):void
		{
			container.x = value;
		}
		
		
		/**
		 * 
		 */
		public function get y():int
		{
			return container.y;
		}
		
		public function set y(value:int):void
		{
			container.y = value;
		}
		
		
		/**
		 * 
		 */
		public function get width():int
		{
			return _width;
			//return container.width;
		}
		
		/*internal function set width(value:int):void
		{
			_width = value;
		}*/
		
		
		/**
		 * 
		 */
		public function get height():int
		{
			return _height;
			//return container.height;
		}
		
		/*internal function set height(value:int):void
		{
			_height = value;
		}*/
		
		
		
		
		
		//************************ overriding EventDispatcher functions (for reasons :P) ********************************
		
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			// Used to make sure that separators cannot have listeners or if the item contains a submenu.
			// Also, it adds the listener to the container, rather than the actual object.
			
			if (submenu || isSeparator)
				return;
			
			container.addEventListener(type, listener, useCapture, priority, useWeakReference);
		} // end function addEventListener
		
		
		/**
		 * @inheritDoc
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			return container.dispatchEvent(event);
			
		} // end function dispatchEvent
		
		
		/**
		 * @inheritDoc
		 */
		override public function hasEventListener(type:String):Boolean
		{
			return container.hasEventListener(type);
			
		} // end function hasEventListener
		
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			container.removeEventListener(type, listener, useCapture);
			
		} // end function removeEventListener
		
		
		/**
		 * @inheritDoc
		 */
		override public function willTrigger(type:String):Boolean
		{
			return container.willTrigger(type);
			
		} // end function willTrigger
		
		
	}
	
}
