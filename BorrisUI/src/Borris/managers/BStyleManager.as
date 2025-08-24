/* Author: Rohaan Allport
 * Date Created: 07/08/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BStyle manager class contains useful constants and function for styling BComponents
 * 
 *	todo/imporovemtns: 
 *						-
 * 
 * Note: 
 
 * Errors: 	- 
*/


package Borris.managers 
{
	import Borris.display.*;
	import Borris.controls.*;
	import Borris.menus.*;
	import Borris.panels.*;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	
	
	public class BStyleManager 
	{
		// constants
		public static const THEME_BORRIS_DARK:String = "borrisDark";
		public static const THEME_AERO_LIGHT:String = "aeroLight";
		public static const THEME_AERO_DARK:String = "aeroDark";
		public static const THEME_MORDERN_UI_LIGHT:String = "modernUILight";
		public static const THEME_MODERN_UI_DARK:String = "modernUIDark";
		
		
		// other
		private static var components:Array = new Array();
		
		
		//  set and get
		private static var _theme:String = THEME_BORRIS_DARK;
		private var _aeroMenuOverColor:uint = 0x006699;
		private var _modernUIMenuOverColor:uint = 0x006699;
		
		//public static const ;
		
		
		// function registerBUIComponent
		// resgisters a component and pushes it in the components array.
		// called in the contructor of the BUIComponent class.
		// used for applying styles and themes
		public static function registerBUIComponent(component:BUIComponent = null):void
		{
			if (!components)
			{
				components = new Array();
			}
			
			// check to see if the component was already added to the array.
			// if so then return
			for (var i:int = 0; i < components.length; i++)
			{
				if (components[i] == component)
				{
					return;
				}
			}
			components.push(component);
		} // end function registerBUIComponent
		
		
		// function unRegisterBUIComponent
		// unregisters a component
		public static function unRegisterBUIComponent(component:BUIComponent):void
		{
			components.splice(components.indexOf(component), 1);
			/*for (var i:int = 0; i < components.length; i++)
			{
				if (components[i] == component)
				{
					components.splice(i, 1);
				}
			}*/
		} // end function unRegisterBUIComponent
		
		
		// function setTheme
		// Sets the theme of the UI
		public static function setTheme(theme:String):void
		{
			if (_theme == theme)
			{
				return;
			}
			
			for (var i:int = 0; i < components.length; i++)
			{
				//components[i].draw();
				components[i].style.draw();
			}
			
			_theme = theme;
		} // end function setTheme
		
		
		// function getTheme
		// 
		public static function getTheme():String
		{
			return _theme;
		} // end function getTheme
		
		
		/*************************************** Borris theme functions ********************************************/
		
		// function 
		// 
		public static function drawBorrisAppMenu(_items:Array):void
		{
			//trace("BNativeMenu | Drawing menu\n");
			var item:BNativeMenuItem;
			var prevItem:BNativeMenuItem;
			
			
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
					xPos = prevItem.x + prevItem.width + 2;
				}
				//trace("BApplicationMenu | Drawing item: " + item.label);
				
				item.x = xPos;
				item.y = 0;
				
			} // end for
			//trace("BNativeMenu | draw(): Drawing for application menu.");
			
		} // end function 
		
		
		private static var longestTotalWidth:int = 100;
		private var totalWidth:int;
		
		// function 
		// 
		public static function drawBorrisContextMenu(_items:Array, _width:Number, _height:Number, contextMenuBackground:Sprite, iconSeparator:Sprite, labelTextWidth:Number, keyEquivalentTextWidth:Number):void
		{
			//trace("BNativeMenu | Drawing menu\n");
			var item:BNativeMenuItem;
			var prevItem:BNativeMenuItem;
			
			
			var borderWidth:int = 0;
			var borderHeight:int = 0;
			
			var topMargin:int = 1;
			var bottomMargin:int = 1;
			var itemHeight:int = 30;
			
			var separatorTopMargin:int = 2;
			var separatorBottomMargin:int = 2;
			var separatorHeight:int = 2;
			
			var leftBorderWidth:int = 2;
			var rightBorderWidth:int = 2;
			
			var iconWidth:int = 22;
			var textIconSpacing:int = 8;
			var arrowIconSpacing:int = 16;
			var textSpacing:int = 32;
			
			
			//********************************* DRAWING FOR CONTEXT MENU ************************************************ 
			
			_height = borderWidth * 2;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.draw();
				item.x = borderWidth;
				item.y = borderHeight;
				
				// find the previous item if there is 1
				if(i > 0)
				{
					prevItem = _items[i - 1];
				} // end if
				
				if(!item.isSeparator)
				{
					_height += topMargin + itemHeight;
					if(prevItem)
					{
						item.y = prevItem.y + topMargin + itemHeight;
						if (prevItem.isSeparator)
						{
							item.y = prevItem.y + separatorTopMargin + separatorHeight + separatorBottomMargin;
						}
					}
				} // end if
				else if(item.isSeparator) // if it is a separator
				{
					_height += separatorTopMargin + separatorHeight + separatorBottomMargin;
					if(prevItem)
					{
						item.y = prevItem.y + itemHeight + separatorTopMargin;
						if (prevItem.isSeparator)
						{
							item.y = prevItem.y + separatorTopMargin + itemHeight;
						}
					}
				} //  end else if
							
			} // end for
			
			
			// set x, y, width, height
			var totalWidth:int = leftBorderWidth + rightBorderWidth + iconWidth + textIconSpacing + textSpacing + arrowIconSpacing + Math.ceil(labelTextWidth) + Math.ceil(keyEquivalentTextWidth);
			if(longestTotalWidth < totalWidth)
			{
				longestTotalWidth = totalWidth;
			} //  end if
			
			_width = borderWidth * 2 + longestTotalWidth;
			
			
			contextMenuBackground.x = 0;
			contextMenuBackground.y = 0;
			contextMenuBackground.graphics.clear();
			contextMenuBackground.graphics.beginFill(0x666666, 1);
			contextMenuBackground.graphics.drawRect(0, 0, _width, _height);
			contextMenuBackground.graphics.beginFill(0x222222, 1);
			contextMenuBackground.graphics.drawRect(2, 2, _width - 4, _height - 4);
			
			iconSeparator.x = borderWidth + iconWidth + int(textIconSpacing/2);
			iconSeparator.y = Math.round(borderWidth/2);
			iconSeparator.height = _height - (borderWidth);
		} // end function 
		
		
		// function 
		// 
		public static function drawBorrisCircleMenu():void
		{
			
		} // end function 
		
		
		// function 
		// 
		public static function drawBorrisButton():void
		{
			
		} // end function 
		
		
		
		
		/***********************************************************************************************************/
		
		
		// function 
		// 
		public static function drawAeroContextMenu():void
		{
			
		} // end function 
		
		
		// function 
		// 
		public static function drawModernUIContextMenu():void
		{
			
		} // end function 
		
		
		// function 
		// 
		public static function drawAeroAppMenu(_items:Array):void
		{
			//trace("BNativeMenu | Drawing menu\n");
			var item:BNativeMenuItem;
			var prevItem:BNativeMenuItem;
			
			
			//********************************* DRAWING FOR APPLICATION MENU ************************************************ 
			
			var xPos:int = 5;
			
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
					xPos = prevItem.x + prevItem.width + 2;
				}
				//trace("BApplicationMenu | Drawing item: " + item.label);
				
				item.x = xPos;
				item.y = 2;
				
			} // end for
			//trace("BNativeMenu | draw(): Drawing for application menu.");
			
		} // end function 
		
		
		// function 
		// 
		public static function drawModernUIAppMenu(_items:Array):void
		{
			
		} // end function 
		
		
		// function 
		// 
		public static function drawAeroButton():void
		{
			
		} // end function 
		
		
		// function 
		// 
		public static function drawModernUIButton():void
		{
			
		} // end function 
		
	}

}