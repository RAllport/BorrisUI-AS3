/* Author: Rohaan Allport
 * Date Created: 11/11/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import Borris.assets.icons.*;
	
	
	public class BVirtualDPad extends BUIComponent
	{
		// constants
		
		
		
		// assets
		protected var background:Shape;
		
		protected var upButton:BButton;
		protected var downButton:BButton;
		protected var leftButton:BButton;
		protected var rightButton:BButton;
		
		
		// other
		
		
		
		// set and get
		protected var _backgroundColor:uint = 0x000000;
		protected var _backgroundTransparency:Number = 0.3;
		protected var _buttonStyle:String = "gamepadArrow";					// gamepadFull(nintendo style), gamepadarraw (sony), gamepadspace keyboard, 
		protected var _iconStyle:String = "arrowStrokeWithTail";			// arrowStrokeWith, arrowStroke, arrowFill, ArrowFillWithTail 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BVirtualDPad component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BVirtualDPad(parent:DisplayObjectContainer=null, x:Number=0, y:Number=0) 
		{
			super(parent, x, y);
			initialize();
			setSize(120, 120);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var keyboardEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false);
			
			if (event.target == upButton)
			{
				keyboardEvent.charCode = Keyboard.UP;
				keyboardEvent.keyCode = Keyboard.UP;
			}
			else if (event.target == downButton)
			{
				keyboardEvent.charCode = Keyboard.DOWN;
				keyboardEvent.keyCode = Keyboard.DOWN;
			}
			else if (event.target == leftButton)
			{
				keyboardEvent.charCode = Keyboard.LEFT;
				keyboardEvent.keyCode = Keyboard.LEFT;
			}
			else if (event.target == rightButton)
			{
				keyboardEvent.charCode = Keyboard.RIGHT;
				keyboardEvent.keyCode = Keyboard.RIGHT;
			}
			
			dispatchEvent(keyboardEvent);
			
		} // end function mouseDownHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			var keyboardEvent:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_UP, true, false);
			
			if (event.target == upButton)
			{
				keyboardEvent.charCode = Keyboard.UP;
				keyboardEvent.keyCode = Keyboard.UP;
			}
			else if (event.target == downButton)
			{
				keyboardEvent.charCode = Keyboard.DOWN;
				keyboardEvent.keyCode = Keyboard.DOWN;
			}
			else if (event.target == leftButton)
			{
				keyboardEvent.charCode = Keyboard.LEFT;
				keyboardEvent.keyCode = Keyboard.LEFT;
			}
			else if (event.target == rightButton)
			{
				keyboardEvent.charCode = Keyboard.RIGHT;
				keyboardEvent.keyCode = Keyboard.RIGHT;
			}
			
			dispatchEvent(keyboardEvent);
			
		} // end function mouseUpHandler
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize assets
			background = new Shape();
			
			upButton = new BButton();
			downButton = new BButton();
			leftButton = new BButton();
			rightButton = new BButton();
			
			
			upButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
			downButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
			leftButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
			rightButton.setStateColors(0x333333, 0x999999, 0x0099CC, 0x333333);
			
			upButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			downButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			leftButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			rightButton.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			
			upButton.setIcon(new ArrowIcon32x32());
			downButton.setIcon(new ArrowIcon32x32());
			leftButton.setIcon(new ArrowIcon32x32());
			rightButton.setIcon(new ArrowIcon32x32());
			
			
			
			// add assets to respective containers
			addChild(background);
			addChild(upButton);
			addChild(downButton);
			addChild(leftButton);
			addChild(rightButton);
			
			
			// draw
			draw();
			
			
			// event handling
			upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			leftButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rightButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
			downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
			leftButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
			rightButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpHandler);
			
			/*upButton.addEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
			downButton.addEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
			leftButton.addEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
			rightButton.addEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
			
			upButton.addEventListener(TouchEvent.TOUCH_END, mouseUpHandler);
			downButton.addEventListener(TouchEvent.TOUCH_END, mouseUpHandler);
			leftButton.addEventListener(TouchEvent.TOUCH_END, mouseUpHandler);
			rightButton.addEventListener(TouchEvent.TOUCH_END, mouseUpHandler);*/
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
			background.graphics.drawRect(0, 0, _width, _height);
			background.graphics.endFill();
			
			
			// set the size of the buttons
			upButton.setSize(_width/3, _height/3);
			downButton.setSize(_width/3, _height/3);
			leftButton.setSize(_width/3, _height/3);
			rightButton.setSize(_width / 3, _height / 3);
			
			// move the bottons
			upButton.move(_width/3, 0);
			downButton.move(_width/3, _height/3 * 2);
			leftButton.move(0, _height/3);
			rightButton.move(_width/3 * 2, _height/3);
			
			// reposition the icons
			upButton.setIconBounds(0, 0, 16, 16, 0);
			downButton.setIconBounds(0, 0, 16, 16, 180);
			leftButton.setIconBounds(0, 0, 16, 16, -90);
			rightButton.setIconBounds(0, 0, 16, 16, 90);
			
			upButton.iconPlacement = BButtonIconPlacement.CENTER;
			downButton.iconPlacement = BButtonIconPlacement.CENTER;
			leftButton.iconPlacement = BButtonIconPlacement.CENTER;
			rightButton.iconPlacement = BButtonIconPlacement.CENTER;
			
		} // end function draw
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		
	}

}