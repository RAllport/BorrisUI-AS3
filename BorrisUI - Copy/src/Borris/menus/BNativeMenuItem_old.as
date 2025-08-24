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
	
	
	public class BNativeMenuItem_old extends EventDispatcher
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
		
		
		// application menu assets
		private var appMenuUpSkin:Sprite;
		private var appMenuDownSkin:Sprite;
		private var appMenuOverSkin:Sprite;
		private var appMenuDisabledSkin:Sprite;
		
		private var appSeparatorSkin:Sprite;
		
		
		// context menu assets
		private var upSkin:Sprite;
		private var enabledOverSkin:Sprite;
		private var disabledOverSkin:Sprite;
		
		private var separatorSkin:Sprite;
		
		private var selectedTick:Sprite;
		private var arrowIcon:Sprite;
		
		private var disabledTextAlpha:Number = 0.5;
		
		// text fields and formats
		private var labelText:TextField;
		private var keyEquivalentText:TextField;
		private var upTF:TextFormat;
		private var overTF:TextFormat;
		
		
		// other
		internal static var longestTotalWidth:int = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING;
		private var totalWidth:int;
		private var states:Array;
		internal var submenuRolledOver:Boolean = false;	// 
		protected var offset:Number = 0;
		
		
		// Set and get
		private var _checked:Boolean;				// Controls whether this menu item displays a checkmark.
		private var _data:Object;					// An arbitrary data object associated with this menu item.
		private var _enabled:Boolean;				// Controls whether this menu item is enabled.
		private var _isSeparator:Boolean; 			// [read-only] Reports whether this item is a menu separator line.
		private var _keyEquivalent:String;			// The key equivalent for this menu item.
		private var _keyEquivalentModifiers:Array;	// The array of key codes for the key equivalent modifiers.
		private var _label:String;					// The display string of this menu item.
		internal var _menu:BNativeMenu;				// [read-only] The menu that contains this item.
		private var _mnemonicIndex:int;				// The position of the mnemonic character in the menu item label.
		private var _name:String;					// The name of this menu item.
		private var _submenu:BNativeMenu;			// The submenu associated with this menu item.
		
		private var _icon:DisplayObject;			// 
		
		// set and get (for internal properties)
		//private var _x:int;							// The x possition of this item
		//private var _y:int;							// The y possition of this item
		private var _width:int;							// [read-only] The width of this item
		private var _height:int;						// [read-only] The height of this item
		

		public function BNativeMenuItem_old(label:String = "", isSeparator:Boolean = false, enabled:Boolean = true) 
		{
			// constructor code
			container = new Sprite();
			container.x = 0;
			container.y = 0;
			
			button = new BLabelButton(container, 0, 0, label);
			
			// do setters
			//this.checked = false;
			this.data = null;
			_isSeparator = isSeparator;
			//this.keyEquivalent = "";
			//this.keyEquivalentModifiers = [Keyboard.SHIFT] // valid it for mac
			this.label = label;
			// menu
			//this.mnemonicIndex = 0;
			// name
			// submenu
			
			
			// initialize the text feilds and formats
			upTF = new TextFormat("Calibri", 16, 0xFFFFFF, false);
			overTF = new TextFormat("Calibri", 16, 0x000000, false);
			
			
			labelText = new TextField();
			labelText.text = _label;
			labelText.type = TextFieldType.DYNAMIC;
			labelText.selectable = false;
			labelText.x = LEFT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING;
			labelText.y = 1;
			//labelText.width = 50;
			labelText.height = 20;
			labelText.setTextFormat(upTF);
			labelText.defaultTextFormat = upTF;
			labelText.mouseEnabled = false;
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelText.antiAliasType = AntiAliasType.NORMAL;
			
			keyEquivalentText = new TextField();
			keyEquivalentText.text = "";
			keyEquivalentText.type = TextFieldType.DYNAMIC;
			keyEquivalentText.selectable = false;
			keyEquivalentText.x = 5;
			keyEquivalentText.y = 1;
			//keyEquivalentText.width = 50;
			keyEquivalentText.height = 20;
			keyEquivalentText.setTextFormat(upTF);
			keyEquivalentText.defaultTextFormat = upTF;
			keyEquivalentText.mouseEnabled = false;
			keyEquivalentText.autoSize = TextFieldAutoSize.LEFT;
			keyEquivalentText.antiAliasType = AntiAliasType.ADVANCED;
			
			
			// calculate the width of this menu item
			totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} //  end if
			
			
			// create the assets
			// application menu assets
			appMenuUpSkin = new Sprite();
			appMenuDownSkin = new Sprite();
			appMenuOverSkin = new Sprite();
			appMenuDisabledSkin = new Sprite();
			
			
			appSeparatorSkin = new Sprite();
			appSeparatorSkin.graphics.beginFill(0x666666, 0.8);
			appSeparatorSkin.graphics.drawRect(0, 0, 1, ITEM_HEIGHT - 2);
			appSeparatorSkin.graphics.endFill();
			
			// context menu assets
			upSkin = new Sprite();
			enabledOverSkin = new Sprite();
			disabledOverSkin = new Sprite();
			disabledOverSkin.alpha = 0.5;
			
			
			selectedTick = new Sprite();
			selectedTick.graphics.lineStyle(2, 0xFFFFFF, 1, false, "normal", "none", "bevel", 3);
			selectedTick.graphics.moveTo(0, 10);
			selectedTick.graphics.lineTo(5, 15);
			selectedTick.graphics.lineTo(15, 5);
			
			//arrowIcon = new MenuItemArrowIcon();
			arrowIcon = new Sprite();
			arrowIcon.graphics.lineStyle(1, 0xFFFFFF, 1, false, "normal", null, "bevel", 3);
			arrowIcon.graphics.lineTo(5, 5);
			arrowIcon.graphics.lineTo(0, 10);
			
			// make this a separator
			separatorSkin = new Sprite();
			separatorSkin.graphics.beginFill(0x222222, 1);
			separatorSkin.graphics.drawRect(0, 0, 100, 1);
			separatorSkin.graphics.beginFill(0x666666, 1);
			separatorSkin.graphics.drawRect(0, 1, 100, 1);
			separatorSkin.graphics.endFill();
			
			
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
			
			//states = new Array(upSkin, enabledOverSkin, disabledOverSkin);
			states = new Array(upSkin, enabledOverSkin, disabledOverSkin, appMenuUpSkin, appMenuOverSkin, appMenuDownSkin);
			changeState(upSkin);
			changeState(appMenuDownSkin);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * @param event
		 */
		protected function enterFrameHandler(event:Event):void
		{
			//offset++;
			//drawForCircleMenu();
		} 
		
		
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
					//changeState(enabledOverSkin);
					if(enabled)
					{
						changeState(enabledOverSkin);
						labelText.setTextFormat(overTF);
						keyEquivalentText.setTextFormat(overTF);
						showSubmenu();
					}
					else
						changeState(disabledOverSkin);
					
					// this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
					for (var i:int = 0; i < this.menu.numItems; i++ )
					{
						if (this.menu.getItemAt(i).submenuRolledOver && this.menu.getItemAt(i) != this)
						{
							this.menu.getItemAt(i).submenuRolledOver = false;
							this.menu.getItemAt(i).hideSubmenu();
							this.menu.getItemAt(i).changeState(upSkin);
							//labelText.setTextFormat(upTF);			// placed in hidesubmenu() function
							//keyEquivalentText.setTextFormat(upTF);
							
						}
					} // end for
					
					break;
				
				case MouseEvent.ROLL_OUT:
					changeState(upSkin);
					labelText.setTextFormat(upTF);
					keyEquivalentText.setTextFormat(upTF);
					if (submenuRolledOver)
					{
						changeState(enabledOverSkin);
						labelText.setTextFormat(overTF);
						keyEquivalentText.setTextFormat(overTF);
					}
					
					//hideSubmenu();
					break;
				
				//case default:
					//break;
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
			labelText.setTextFormat(upTF);
			keyEquivalentText.setTextFormat(upTF);
			
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					changeState(appMenuDownSkin);
					this.menu.applMenuClicked = true;
					
					if(this.submenu)
					{
						this.submenu.display(container.parent.stage, this.menu.x + this.x, this.menu.y + this.y + this.height);
					} // end if
					
					break;
				
				case MouseEvent.ROLL_OVER:
					if(enabled)
					{
						changeState(appMenuOverSkin);
						if(this.submenu && this.menu.applMenuClicked == true)
						{
							this.submenu.display(container.parent.stage, this.menu.x + this.x, this.menu.y + this.y + this.height);
							submenuRolledOver = true;
						} // endn if
					}
					else
						changeState(appMenuOverSkin);
						
					// this loops through all the items in the menu and hides their submenu if it's not this menu that the mouse is over
					for (var i:int = 0; i < this.menu.numItems; i++ )
					{
						if (this.menu.getItemAt(i) != this)
						{
							this.menu.getItemAt(i).hideSubmenu();
						}
					} // end for
					
					// if the app menu has been clicked, then items go to down state
					if(this.menu.applMenuClicked)
					{
						changeState(appMenuDownSkin);
					}
					
					break;
				
				case MouseEvent.ROLL_OUT:
					changeState(appMenuUpSkin);
					//hideSubmenu();
					break;
				
				//case default:
					//break;
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
		private function initializeAssets():void
		{
			
		} // end function initializeAssets
		
		
		/**
		 * 
		 */
		public function draw():void
		{
			// add assets to container
			container.addChild(upSkin);
			container.addChild(enabledOverSkin);
			container.addChild(disabledOverSkin);
			
			container.addChild(labelText);
			container.addChild(keyEquivalentText);
			
			container.addChild(selectedTick);
			container.addChild(arrowIcon);
			
			container.addChild(separatorSkin);
			
			if (this.icon)
				container.addChild(icon);
			
			container.scaleX = container.scaleY = 1;
			
			
			// calculate the width of this menu item
			// this SHIT cost me like 10 hours to fix!
			totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} // end if
			
			 // if separator
			if(this.isSeparator)
			{
				separatorSkin.x = 10;
				separatorSkin.y = SEPARATOR_TOP_MARGIN;
				separatorSkin.width = longestTotalWidth - 20;
				
				
				keyEquivalentText.visible = false;
				return;
			}
			else if(!this.isSeparator)
			{
				// draw skins
				var roundNess:Number = 4;
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(longestTotalWidth - 2, ITEM_HEIGHT - 2, Math.PI / 2, 0, 0);
				var buttonWidth:int = longestTotalWidth;
				var buttonHeight:int = ITEM_HEIGHT;
				
				upSkin.graphics.clear();
				upSkin.graphics.beginFill(0x000000, 0);
				upSkin.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
				upSkin.graphics.endFill();
				
				enabledOverSkin.graphics.clear();
				enabledOverSkin.graphics.beginFill(0x00CCFF, 0.8);
				enabledOverSkin.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
				enabledOverSkin.graphics.endFill();
				
				disabledOverSkin.graphics.clear();
				disabledOverSkin.graphics.beginFill(0x454545, 0.8);
				disabledOverSkin.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
				disabledOverSkin.graphics.endFill();
				
				
				labelText.x = LEFT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING;
				labelText.y = 1;
				
				keyEquivalentText.x = longestTotalWidth - keyEquivalentText.width - RIGHT_BORDER_WIDTH - ARROW_ICON_SPACING;
				keyEquivalentText.y = 1;
				
				selectedTick.x = 10;
				selectedTick.y = int((ITEM_HEIGHT - selectedTick.height)/2);
				
				arrowIcon.x = longestTotalWidth - arrowIcon.width - RIGHT_BORDER_WIDTH - int(ARROW_ICON_SPACING/2);
				arrowIcon.y = int((ITEM_HEIGHT-arrowIcon.height)/2) + 1;
				
				/*if (_submenu)
				{
					trace("has submenu");
					button.toggle = false;
					button.setIcon(null);
					
					//button.addChild(arrowIcon);
					container.addChild(arrowIcon);
					arrowIcon.x = longestTotalWidth - 30;
					arrowIcon.y = button.height / 2;
					arrowIcon.parent.setChildIndex(arrowIcon, arrowIcon.parent.numChildren - 1);
				}
				else
				{
					button.toggle = true;
					button.setIcon(null, null, null, null, null, new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256());
					button.setIconBounds(10, 10, 16, 16);
					/*if (button.contains(arrowIcon))
					{
						button.removeChild(arrowIcon);
					}*/
				//}
				
			} // end if
			
			changeState(upSkin);
			
			// events handling
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
			// add assets to container
			container.addChild(appMenuUpSkin);
			container.addChild(appMenuDownSkin);
			container.addChild(appMenuOverSkin);
			container.addChild(appMenuDisabledSkin);
			
			container.addChild(appSeparatorSkin);
			
			container.addChild(labelText);
			
			container.scaleX = container.scaleY = 1;
			
			if(this.isSeparator)
			{
				_width = 10;
				appSeparatorSkin.visible = true;
				appSeparatorSkin.x = _width/2 - 1;
				appSeparatorSkin.y = 0;
				
				appMenuUpSkin.visible = false;
				appMenuDownSkin.visible = false;
				appMenuOverSkin.visible = false;
				appMenuDisabledSkin.visible = false;
				return;
			}
			
			labelText.x = 5;
			labelText.y = 0;
			labelText.height = 30;
			
			appSeparatorSkin.visible = false;
			
			// draw skins
			var roundNess:Number = 4;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_width - 2, _height - 2, Math.PI / 2, 0, 0);
			var buttonWidth:int = this.labelText.width + 10;
			var buttonHeight:int = 30;
			
			appMenuUpSkin.graphics.clear();
			appMenuUpSkin.graphics.beginFill(0X000000, 0);
			appMenuUpSkin.graphics.drawRect(0, 0, _width, _height); 
			appMenuUpSkin.graphics.endFill();
			
			appMenuOverSkin.graphics.clear();
			appMenuOverSkin.graphics.beginFill(0x666666, 1);
			appMenuOverSkin.graphics.drawRect(0, 0, _width, _height);
			appMenuOverSkin.graphics.endFill();
			
			appMenuDownSkin.graphics.clear();
			appMenuDownSkin.graphics.beginFill(0x333333, 1);
			appMenuDownSkin.graphics.drawRect(0, 0, _width, _height); 
			appMenuDownSkin.graphics.endFill();
			
			/*appMenuDisabledSkin.graphics.clear();
			appMenuDisabledSkin.graphics.beginFill(0x000000, 0.8);
			appMenuDisabledSkin.graphics.drawRect(0, 0, _width, _height);
			appMenuDisabledSkin.graphics.endFill();*/
			
			
			_width = this.labelText.width + 10;
			if (_width < 40)
			{
				_width = 40; 
			}
			_height = 30;
			
			
			this.icon = null;
			
			changeState(appMenuUpSkin);
			
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
			// add assets to container
			container.addChild(upSkin);
			container.addChild(enabledOverSkin);
			container.addChild(disabledOverSkin);
			
			container.addChild(labelText);
			//container.addChild(keyEquivalentText);
			
			//container.addChild(selectedTick);
			//container.addChild(arrowIcon);
			
			//container.addChild(separatorSkin);
			
			if (this.icon)
				//container.addChild(icon);
			
			container.scaleX = container.scaleY = 1;
			
			// if separator
			if(this.isSeparator)
			{
				// do nothing
			}
			else if(!this.isSeparator)
			{
				// draw skins
				var arc:Number = 90;
				var _innerRadius:int = 14;
				var _outerRadius:int = 76;
				var i:Number = 0;
				
				// check for other menu items
				if (this.menu)
				{
					arc = 360 / menu.numItems;
					container.rotation = arc * menu.getItemIndex(this) + offset;
					labelText.rotation = -arc * menu.getItemIndex(this) - offset;
					
				}
				
				upSkin.graphics.clear();
				upSkin.graphics.lineStyle(1, 0x222222, 1); // border colour
				upSkin.graphics.beginFill(0x454545, 1);
				upSkin.graphics.moveTo(_innerRadius, 0);
				
				for (i = 0; i < arc; i++)
				{
					upSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _innerRadius, Math.sin(i * (Math.PI/180)) * _innerRadius);
				}
				
				upSkin.graphics.lineTo(Math.cos(arc * (Math.PI/180)) * _outerRadius, Math.sin(arc * (Math.PI/180)) * _outerRadius);
				
				for (i = arc; i > 0; i--)
				{
					upSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _outerRadius, Math.sin(i * (Math.PI/180)) * _outerRadius);
				}
				upSkin.graphics.lineTo(_outerRadius, 0);
				upSkin.graphics.lineTo(_innerRadius, 0);
				upSkin.graphics.endFill();
				
				//
				enabledOverSkin.graphics.clear();
				enabledOverSkin.graphics.lineStyle(1, 0x0099FF, 1); // border colour
				enabledOverSkin.graphics.beginFill(0x0099ff, 0.7);
				enabledOverSkin.graphics.moveTo(_innerRadius, 0);
				
				for (i = 0; i < arc; i++)
				{
					enabledOverSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _innerRadius, Math.sin(i * (Math.PI/180)) * _innerRadius);
				}
				
				enabledOverSkin.graphics.lineTo(Math.cos(arc * (Math.PI/180)) * _outerRadius, Math.sin(arc * (Math.PI/180)) * _outerRadius);
				for (i = arc; i > 0; i--)
				{
					enabledOverSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _outerRadius, Math.sin(i * (Math.PI/180)) * _outerRadius);
				}
				enabledOverSkin.graphics.lineTo(_outerRadius, 0);
				enabledOverSkin.graphics.lineTo(_innerRadius, 0);
				enabledOverSkin.graphics.endFill();
				
				
				//
				disabledOverSkin.graphics.clear();
				disabledOverSkin.graphics.lineStyle(1, 0x222222, 1); // border colour
				disabledOverSkin.graphics.beginFill(0x454545, 1);
				disabledOverSkin.graphics.moveTo(_innerRadius, 0);
				
				for (i = 0; i < arc; i++)
				{
					disabledOverSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _innerRadius, Math.sin(i * (Math.PI/180)) * _innerRadius);
				}
				
				disabledOverSkin.graphics.lineTo(Math.cos(arc * (Math.PI/180)) * _outerRadius, Math.sin(arc * (Math.PI/180)) * _outerRadius);
				for (i = arc; i > 0; i--)
				{
					disabledOverSkin.graphics.lineTo(Math.cos(i * (Math.PI/180)) * _outerRadius, Math.sin(i * (Math.PI/180)) * _outerRadius);
				}
				disabledOverSkin.graphics.lineTo(_outerRadius, 0);
				disabledOverSkin.graphics.lineTo(_innerRadius, 0);
				disabledOverSkin.graphics.endFill();
				
				
				// check for other menu items
				if (this.menu)
				{
					/*if (container.rotation >= 0 && container.rotation < 90)
					{
						labelText.x = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.width/2);
						labelText.y = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.height/2);
					}
					else if(container.rotation >= 90 && container.rotation < 180)
					{
						labelText.x = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.width/2);
						labelText.y = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.height/2);
					}
					else if(container.rotation >= 180 && container.rotation < 270)
					{
						labelText.x = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.width/2);
						labelText.y = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.height/2);
					}
					else if(container.rotation >= -90 && container.rotation < 0)
					{
						labelText.x = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.width/2);
						labelText.y = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.height/2);
					}*/
					
					//labelText.x = ((_innerRadius + _outerRadius)/2);
					//labelText.y = ((_innerRadius + _outerRadius)/2);
						
					//labelText.x = ((_innerRadius + _outerRadius)/2 - labelText.width/2);
					//labelText.y = ((_innerRadius + _outerRadius)/2 - labelText.height/2);
					
					//labelText.x = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2);
					//labelText.y = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius) / 2);
					
					labelText.x = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.width/2);
					labelText.y = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 - labelText.height/2);
					
					if (container.rotation > 90)
					{
						labelText.x = Math.cos((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.width/2);
						labelText.y = Math.sin((arc / 2) * (Math.PI / 180)) * ((_innerRadius + _outerRadius)/2 + labelText.height/2);
					}
						
					//labelText.x = Math.cos(arc * (Math.PI / 180)) * (container.width/2 - labelText.width/2);
					//labelText.y = Math.sin(arc * (Math.PI / 180)) * (container.height/2 - labelText.height/2);
					
					//labelText.x = (container.width/2);
					//labelText.y = (container.height/2);
					
				} // 
				
				//
				keyEquivalentText.x = longestTotalWidth - keyEquivalentText.width - RIGHT_BORDER_WIDTH - ARROW_ICON_SPACING;
				keyEquivalentText.y = 1;
				
				selectedTick.x = LEFT_BORDER_WIDTH;
				selectedTick.y = int((ITEM_HEIGHT - selectedTick.height)/2);
				
				arrowIcon.x = longestTotalWidth - arrowIcon.width - RIGHT_BORDER_WIDTH - int(ARROW_ICON_SPACING/2);
				arrowIcon.y = int((ITEM_HEIGHT-arrowIcon.height)/2) + 1;
				
			} // end if
			
			changeState(upSkin);
			
			// events handling
			if(!container.hasEventListener(MouseEvent.ROLL_OVER))
				container.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
				
			if(!container.hasEventListener(MouseEvent.ROLL_OUT))
				container.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
		} // end function drawForCircleMenu
		
		
		/**
		 * 
		 * @param state
		 */
		private function changeState(state:DisplayObject):void
		{
			if(!this.isSeparator)
			{
				var newTween:Tween;
			
				for(var i:int = 0; i < states.length; i++)
				{
					var tempState:DisplayObject = states[i]; 
					
					if(state == tempState && state != upSkin)
					{
						newTween = new Tween(state, "alpha", Regular.easeOut, 0, 1, 0.4, true);
					}
					else
					{
						newTween = new Tween(tempState, "alpha", Regular.easeOut, tempState.alpha, 0, 0.4, true);
					}
				} // end for
				
			} // end if
		} // end function changeState
		
		
		
		/**
		 * 
		 */
		internal function showSubmenu():void
		{
			if(this.submenu)
			{
				submenuRolledOver = true;
				this.submenu.display(container.parent.stage, this.menu.x + this.menu._width, this.menu.y + this.y);
				
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
				labelText.setTextFormat(upTF);
				keyEquivalentText.setTextFormat(upTF);
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
				upSkin.visible = true;

				enabledOverSkin.visible = true;
				disabledOverSkin.visible = true;
				disabledOverSkin.alpha = 0.5;
				
				selectedTick.visible = false;
				
				arrowIcon.visible = false;
				
				separatorSkin.visible = false;
				
				container.mouseEnabled = container.mouseChildren = true;
				container.tabEnabled = container.tabChildren = true;
			} 
			else
			{
				upSkin.visible = false;

				enabledOverSkin.visible = false;
				disabledOverSkin.visible = false;
				disabledOverSkin.alpha = 0.5;
				
				selectedTick.visible = false;
				
				arrowIcon.visible = false;
				
				separatorSkin.visible = true;
				
				this.label = "separator";
				
				container.mouseEnabled = container.mouseChildren = false;
				container.tabEnabled = container.tabChildren = false;
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
			return _checked;
		}
		
		public function set checked(value:Boolean):void
		{
			if(!this.isSeparator)
			{
				if(value && this.enabled && !this.submenu && !this.icon)
				{
					selectedTick.visible = true;
				}
				else
				{
					selectedTick.visible = false;
				}
			}
			
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
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(value)
			{
				labelText.alpha = 1;
				keyEquivalentText.alpha = 1;
				
				if(!this.submenu)
				{
					container.addEventListener(MouseEvent.CLICK, mouseHandler);
				} // end if
			} // end if
			else
			{
				labelText.alpha = disabledTextAlpha;
				keyEquivalentText.alpha = disabledTextAlpha;
				this.checked = false;
				container.removeEventListener(MouseEvent.CLICK, mouseHandler);
			} // end else
			
			_enabled = value;
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
							keyEquivalentText.appendText("Ctrl+");
						}
						if(keyEquivalentModifiers[i] == Keyboard.SHIFT)
						{
							keyEquivalentText.appendText("Shift+");
						}
						if(keyEquivalentModifiers[i] == Keyboard.ALTERNATE)
						{
							keyEquivalentText.appendText("Alt+");
						}
					} // end for
					
				} // end if
				
			} // end if
			
			value = value.toUpperCase();
			keyEquivalentText.appendText(value);
			_keyEquivalent = value;
			
			// calculate the width of this menu item
			// this SHIT cost me like 10 hours to fix!
			totalWidth = LEFT_BORDER_WIDTH + RIGHT_BORDER_WIDTH + ICON_WIDTH + TEXT_ICON_SPACING + TEXT_SPACING + ARROW_ICON_SPACING + Math.ceil(labelText.width) + Math.ceil(keyEquivalentText.width);
			
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
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
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
			return _icon;
		}
		
		public function set icon(value:DisplayObject):void
		{
			// check if icon not null
				// if not null
					// remove
				// if null
					// add
			// check icon size
			// add icon;
			
			// if the set newly set icon is the current icon, then skip
			if (value == _icon)
			{
				return;
			}
			
			// if value is null, remove the icon
			if(value == null)
			{
				if(_icon)
				{
					if(_icon.parent)
						_icon.parent.removeChild(_icon);
				} // end if 
				
				return;
			} // end if
			else
			{
				this.selectedTick.visible = false;
			}
			
			// if the is already an icon, remove the current one.
			if(_icon)
			{
				_icon.parent.removeChild(_icon);
			} // end if 
			
			
			var size:int = 20;
			// 
			var longerSide:int = 0;
			
			// 
			if(value.height >= value.width)
			{
				longerSide = value.height;
				if(longerSide > size)
				{
					value.height = value.height - (longerSide - size);
					value.scaleX = value.scaleY;
				} // end if
			} // end if
			else
			{
				longerSide = value.width;
				if(longerSide > size)
				{
					value.width = value.width - (longerSide - size);
					value.scaleY = value.scaleX;
				} // end if
			} // end else
			
			
			// center the icon
			var difference:int = (22 - size)/2;
			
			value.x = LEFT_BORDER_WIDTH + int((22 - value.width)/2) + difference; 
			value.y = int((22 - value.height) / 2) + difference;
			container.addChild(value);
			
			_icon = value;
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
