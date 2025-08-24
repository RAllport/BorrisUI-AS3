/* Author: Rohaan Allport
 * Date Created: 18/02/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls.windowClasses 
{
	import flash.display.*;
	import flash.text.*;
	
	import Borris.display.BStyle;
	import Borris.controls.*;
	import Borris.assets.icons.MoreIcon24x24;
	
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BTitleBar extends BUIComponent
	{
		// assets 
		protected var _container:Sprite;
		protected var titleText:BLabel;
		protected var dotsText:BLabel;
		protected var dotsIcon:DisplayObject;
		protected var _containerMask:Shape;
		
		// other
		protected var buttonsWidth:int = 0;						// the width of the buttons and icons in the the titlebar. used for calucating the title text width
		protected var textWidth:int = 0;
		
		
		// set and get
		protected var _titleBarMode:String = "compactText"; 			// The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
		//protected var _titleBarHeight:int; 							// [read-only] The height of the title bar after calculating the titleBar height and mode, etc
		protected var _buttons:Vector.<BLabelButton> = new Vector.<BLabelButton>();
		protected var _icon:Class;
		
		
		public function BTitleBar(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, title:String = "") 
		{
			super(parent, x, y);
			initialize();
			//setSize(100, 24);
			
			// initialize assets
			_container = new Sprite();
			_container.mouseEnabled = false;
			_container.tabEnabled = false;
			
			
			titleText = new BLabel(_container, _height, _height / 2, title);
			titleText.autoSize = TextFieldAutoSize.LEFT;
			
			dotsText = new BLabel(_container, _width / 2, _height / 2, "...");
			dotsText.autoSize = TextFieldAutoSize.LEFT;
			
			dotsIcon = new MoreIcon24x24();
			
			_containerMask = new Shape();
			_containerMask.graphics.beginFill(0xff00ff, 1);
			_containerMask.graphics.drawRect(0, 0, 100, 100);
			_containerMask.graphics.endFill();
			_container.mask = _containerMask;
			
			// set mode after all assest are created.
			mode = _titleBarMode;
			textWidth = titleText.width;
			
			// add assets to repective containers
			_container.addChild(dotsIcon);
			addChild(_container);
			addChild(_containerMask);
			
			_style.backgroundColor = 0x006699;
			_style.backgroundOpacity = 1;
			_style.borderColor = 0x00CCFF;
			_style.borderOpacity = 0.8;
			_style.borderWidth = 0;
			
			_style.borderTopWidth = 0;
			_style.borderLeftWidth = 0;
			_style.borderRightWidth = 0;
			_style.borderBottomWidth = 1;
			
			//draw();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			//trace("BTitleBar | draw()");
			
			titleText.x = _height;
			titleText.y = _height / 2 - titleText.height / 2;
			
			//dotsText.x = _width - dotsText.width;
			//dotsText.y = _height / 2 - dotsText.height / 2;
			
			dotsIcon.x = _width / 2 - dotsIcon.width / 2;
			dotsIcon.y = _height / 2 - dotsIcon.height / 2;
			
			
			// change the width of the title text lable id the buttons are getting too close
			if (_width - int(_style.borderWidth) * 2 <= textWidth + buttonsWidth)
			{
				dotsText.x = _width - dotsText.width - (_buttons.length) * _height;
				dotsText.y = titleText.y;
				dotsText.visible = true;
				titleText.autoSize = TextFieldAutoSize.NONE;
				titleText.width = _width - int(_style.borderWidth) * 2 - buttonsWidth;
			}
			else
			{
				dotsText.visible = false;
				titleText.autoSize = TextFieldAutoSize.LEFT;
			}
			
			// position the buttons
			for (var i:int = 0; i < _buttons.length; i++ )
			{
				//_buttons[i].move(_width - (i + 1) * _height, 0);
				//_buttons[i].x = Math.max(int(_style.borderWidth), int(_style.borderTopWidth));
				_buttons[i].x = _width - (i + 1) * (_height - int(_style.borderBottomWidth));
			}
			
			_containerMask.width = _width;
			_containerMask.height = _height;
			
			super.draw();
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
		} // end function initialize
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * 
		 */
		public function get buttons():Vector.<BLabelButton>
		{
			return _buttons;
		}
		
		public function set buttons(value:Vector.<BLabelButton>):void
		{
			//var buttonHeight:int = _height - int(_style.borderBottomWidth); 
			
			if (_buttons.length > 0)
			{
				for (var i:int = 0; i < _buttons.length; i++ )
				{
					if (_container.contains(_buttons[i]))
						_container.removeChild(_buttons[i]);
				}
			}
			
			_buttons = value;
			
			for (i = 0; i < _buttons.length; i++ )
			{
				_buttons[i].move(_width - (i + 1) * _height, 0);
				_buttons[i].setSize(_height, _height);
				_container.addChild(_buttons[i]);
			}
			
			// calculate buttons' width
			buttonsWidth = _height * (_buttons.length + 1) + dotsText.width; 
			//buttonsWidth = buttonHeight * (_buttons.length + 1) + dotsText.width; 
		}
		
		
		/**
		 * Gets or sets the text title for the component. By default, the title text appears to the left of the title bar.
		 * 
		 * @default ""
		 */
		public function get title():String
		{
			return titleText.text;
		}
		public function set title(value:String):void
		{
			titleText.text = value;
			textWidth = titleText.width;
		}
		
		
		/**
		 * 
		 */
		public function get icon():Class
		{
			return _icon;
		}
		
		public function set icon(value:Class):void
		{
			_icon = new value();
			var ic:DisplayObject = _icon as DisplayObject;
			ic.width = _height;
			ic.height = _height;
			ic.x = ic.y = Number(_style.borderWidth);
		}
		
		
		/**
		 * 
		 */
		public function get mode():String
		{
			return _titleBarMode;
		}
		
		public function set mode(value:String):void
		{
			_titleBarMode = value;
			
			//var buttonHeight:int = _height - int(_style.borderBottomWidth); 
			
			if (_titleBarMode != "none")
			{
				scaleY = 1;
				visible = true;
				
				if (_titleBarMode != "minimal")
				{
					titleText.visible = true;
					dotsText.visible = true;
					dotsIcon.visible = false;
				}
			}
			
			
			switch(_titleBarMode)
			{
				case "compactText":
					_height = 30;
					break;
					
				case "compactIcon":
					_height = 40;
					break;
					
				case "fullText":
					_height = 30;
					break;
					
				case "fullIcon":
					_height = 48;
					break;
					
				case "minimal":
					_height = 10;
					titleText.visible = false;
					dotsText.visible = false;
					dotsIcon.visible = true;
					break;
					
				case "none":
					scaleY = 0; 		// scale is changed so the the height becomes 0 and makes the content position change when drawn
					visible = false;
					
					titleText.visible = false;
					dotsText.visible = false;
					break;
					
			} // end switch
			
			// calculate buttons' width
			buttonsWidth = _height * (_buttons.length + 1) + dotsText.width; 
			//buttonsWidth = buttonHeight * (_buttons.length + 1) + dotsText.width; 
			
			draw();
		}
		
		
		/**
		 * A reference to the internal label component.
		 */
		public function get label():BLabel
		{
			return titleText;
		}
	}

}