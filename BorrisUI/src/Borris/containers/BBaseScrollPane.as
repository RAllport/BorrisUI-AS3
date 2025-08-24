/* Author: Rohaan Allport
 * Date Created: 24/09/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BBaseScrollPane class handles basic scroll pane functionality including events, styling, drawing the mask and background, the layout of scroll bars, and the handling of scroll positions.
 * 
 * 
*/


package Borris.containers 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.*;
	
	
	
	public class BBaseScrollPane extends BUIComponent
	{
		// assets
		protected var container:Sprite;
		protected var containerMask:Shape;
		
		protected var hScrollBar:BScrollBar;						// 
		protected var vScrollBar:BScrollBar;						// 
		
		
		// other
		protected var _contendPadding:Number = 10;					// The amount of padding to put around the content in the scroll pane, in pixels. The default value is 0.
		protected var disabledAlpha:Number = 0.5;					// When the enabled property is set to false, interaction with the component is prevented and a white overlay is displayed over the component, dimming the component contents.
		protected var repeatDelay:Number = 1000;					// The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.
		protected var repeatInterval:Number = 100;					// The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay style.
		
		
		// set and get
		protected var _horizontalLineScrollSize:Number;				// Gets or sets a value that describes the amount of content to be scrolled, horizontally, when a scroll arrow is clicked.
		protected var _horizontalPageScrollSize:Number;				// Gets or sets the count of pixels by which to move the scroll thumb on the horizontal scroll bar when the scroll bar track is pressed.
		//protected var _horizontalScrollBar:BScrollBar;			// [read-only] Gets a reference to the horizontal scroll bar.
		protected var _horizontalScrollPolicy:String;				// Gets or sets a value that indicates the state of the horizontal scroll bar.
		protected var _horizontalScrollPosition:Number;				// Gets or sets a value that describes the horizontal position of the horizontal scroll bar in the scroll pane, in pixels.
		protected var _maxHorizontalScrollPosition:Number;			// [read-only] Gets the maximum horizontal scroll position for the current content, in pixels.
		
		protected var _maxVerticalScrollPosition:Number;			// [read-only] Gets the maximum vertical scroll position for the current content, in pixels.
		protected var _verticalLineScrollSize:Number;				// Gets or sets a value that describes how many pixels to scroll vertically when a scroll arrow is clicked.
		protected var _verticalPageScrollSive:Number;				// Gets or sets the count of pixels by which to move the scroll thumb on the vertical scroll bar when the scroll bar track is pressed.
		//protected var _verticalScrollBar:BScrollBar;				// [read-only] Gets a reference to the vertical scroll bar.
		protected var _verticalScrollPolicy:String;					// Gets or sets a value that indicates the state of the vertical scroll bar.
		protected var _verticalScrollPosition:Number;				// Gets or sets a value that describes the vertical position of the vertical scroll bar in the scroll pane, in pixels.
		
		protected var _useBitmapScrolling:Boolean;					// When set to true, the cacheAsBitmap property for the scrolling content is set to true; when set to false this value is turned off.
		
		protected var _backgroundColor:uint = 0x454545;				// 
		protected var _backgroundTransparency:Number = 0;			// 
		
		
		public function BBaseScrollPane(parent:DisplayObjectContainer=null, x:Number=0, y:Number=0) 
		{
			super(parent, x, y);
			initialize();
			setSize(100, 100);
		}
		
		
		// function scrollBarChangeHandler
		// 
		protected function scrollBarChangeHandler(event:Event):void
		{
			update();
		} // end function scrollBarChangeHandler
		
		
		// function mouseWheelHandler
		// Handles scrolling via mouse wheel
		// Calls BScrollBar.doScroll()
		protected function mouseWheelHandler(event:MouseEvent):void
		{	
			if (vScrollBar.visible)
			{
				vScrollBar.doScroll((event.delta >= 1 ? "up" : "down"));
			}
			else if (hScrollBar.visible)
			{
				hScrollBar.doScroll((event.delta >= 1 ? "up" : "down"));
			}
			
		} // end function mouseWheelHandler
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize assets
			container = new Sprite();
			
			
			containerMask = new Shape();
			containerMask.graphics.beginFill(0xFF00FF, 1);
			containerMask.graphics.drawRect(0, 0, 100, 100);
			containerMask.graphics.endFill();
			containerMask.x = 0;
			containerMask.y = 0;
			
			hScrollBar = new BScrollBar(BScrollBarOrientation.HORIZONTAL, this);
			hScrollBar.x = 0;
			hScrollBar.y = _height - hScrollBar.height;
			hScrollBar.autoHide = true;
			
			vScrollBar = new BScrollBar(BScrollBarOrientation.VERTICAL, this);
			vScrollBar.x = _width - vScrollBar.width;
			vScrollBar.y = 0;
			vScrollBar.autoHide = true;
			
			addChild(containerMask);
			addChild(container);
			addChild(hScrollBar);
			addChild(vScrollBar);
			
			container.mask = containerMask;
			
			draw();
			update();
			
			// event handling
			hScrollBar.addEventListener(Event.CHANGE, scrollBarChangeHandler);
			vScrollBar.addEventListener(Event.CHANGE, scrollBarChangeHandler);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
			
			hScrollBar.visible = (container.width + contentPadding * 2 > _width);
			vScrollBar.visible = (container.height + contentPadding * 2 > _height);
			
			
			// position and resize the horizontal scroll bar
			hScrollBar.x = 0;
			hScrollBar.y =  _height - hScrollBar.height;
			hScrollBar.width = vScrollBar.visible ? ( _width - vScrollBar.width) : _width;
			
			// position and resize the vertical scroll bar
			vScrollBar.x = _width - vScrollBar.width;
			vScrollBar.y = 0;
			vScrollBar.height = hScrollBar.visible ? (_height - hScrollBar.height) : _height;
			
			
			// 
			//hScrollBar.lineScrollSize = 0.1;
			//vScrollBar.lineScrollSize = 0.1;
			
			// 
			hScrollBar.setThumbPercent((_width - _contendPadding * 2) / container.width);
			vScrollBar.setThumbPercent((_height - _contendPadding * 2) / container.height);
			 
			
			// 
			containerMask.width = _width;
			containerMask.height = _height;
			
			//vScrollBar.drawNow();
			//hScrollBar.drawNow();
			
			update();
			
		} // end function draw
		
		
		/**
		 * 
		 */
		protected function update():void
		{
			//container.x = hScrollBar.scrollPosition * (containerMask.width - container.width);
			//container.x = hScrollBar.scrollPosition * (containerMask.width - container.width) - (container.getBounds(this).left - container.x);
				
			//container.y = vScrollBar.scrollPosition * (containerMask.height - container.height);
			//container.y = vScrollBar.scrollPosition * (containerMask.height - container.height) - (container.getBounds(this).top - container.y);
				
			//var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, (vScrollBar.scrollPosition * (containerMask.height - container.height)), 0.3, true);
			//var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, (vScrollBar.scrollPosition * (containerMask.height - container.height)), 0.3, true);
			
			container.x = hScrollBar.scrollPosition * (containerMask.width - (container.width + _contendPadding * 2)) - (container.getBounds(this).left - container.x) + _contendPadding;
			container.y = vScrollBar.scrollPosition * (containerMask.height - (container.height + _contendPadding * 2)) - (container.getBounds(this).top - container.y) + _contendPadding;
			
		} // end function update
		
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * 
		 */
		public function get horizontalScrollBar():BScrollBar
		{
			return hScrollBar;
		}
		
		
		/**
		 * 
		 */
		public function get verticalScrollBar():BScrollBar
		{
			return vScrollBar;
		}
	
		
		/**
		 * 
		 */
		public function set contentPadding(value:Number):void
		{
			_contendPadding = value;
			draw();
		}
		
		public function get contentPadding():Number
		{
			return _contendPadding;
		}
		
		
		
	}

}