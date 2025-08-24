/* Author: Rohaan Allport
 * Date Created: 21/11/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.containers 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	import Borris.assets.cursors.CursorPanelResizeHeight;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import Borris.assets.icons.*;
	import Borris.controls.*;
	import Borris.controls.windowClasses.*;
	import Borris.display.*;
	import Borris.events.*;
	import Borris.menus.*;
	import Borris.ui.BMouseCursor;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	
	public class BPanel extends BUIComponent//Sprite
	{
		// constants
		
		
		// static 
		protected static var _panels:Vector.<BPanel> = new Vector.<BPanel>;
		
		
		// assets
		protected var _drawElement:BElement;
		protected var _titleBar:BTitleBar;
		protected var _minimizedButton:BLabelButton;
		
		protected var _content:Sprite;
		protected var contentMask:Shape;
		
		protected var closeButton:BLabelButton;
		protected var minimizeButton:BLabelButton;
		protected var maximizeButton:BLabelButton;
		protected var colapseButton:BLabelButton;
		//protected var contextMenu:BContextMenu;
		
		// icons
		protected var xIcon:DisplayObject;
		protected var maximizeIcon:DisplayObject;
		protected var minimizeIcon:DisplayObject;
		protected var windowIcon:DisplayObject;
		protected var arrowIcon:DisplayObject;
		
		// resize grabbers
		protected var resizeGrabberTL:Sprite;
		protected var resizeGrabberTR:Sprite;
		protected var resizeGrabberBL:Sprite;
		protected var resizeGrabberBR:Sprite;
		protected var resizeGrabberTE:Sprite;
		protected var resizeGrabberBE:Sprite;
		protected var resizeGrabberLE:Sprite;
		protected var resizeGrabberRE:Sprite;
		
		
		// resizing and mouse variables
		//protected var beginMouseX:int;								// Not actually used for anything.
		//protected var beginMouseY:int;								// Not actually used for anything.
		//protected var endMouseX:int;								// Not actually used for anything.
		//protected var endMouseY:int;								// Not actually used for anything.
		//protected var beginMousePoint:Point;						// Not actually used for anything.
		//protected var endMousePoint:Point;							// Not actually used for anything.
		//protected var mouseIsDown:Boolean;							// Not actually used for anything.
		protected var mouseEventTarget:Sprite;						// 
		protected var registrationPoint:Point = new Point(0, 0);
		
		
		// other
		protected var padding:Number = 2;							// This is not the same as the BNativeWindow padding, but similar.
		protected var activatedTF:TextFormat;						// 
		protected var deactivatedTF:TextFormat;						// 
		protected var tempX:int;										// A holder for previous state x position
		protected var tempY:int;										// A holder for previous state y position
		protected var tempWidth:int;									// A holder for previous state width
		protected var tempHeight:int;									// A holder for previous state height
		protected var resizeToWidth:int;								// 
		protected var resizeToHeight:int;								// 
		protected var resizeGrabberThickness:int = 5;				// The thickness of the resize grabbers. It would be wise to change this on mobile devices, or when a touch event is detected.
		
		protected var _resizePosition:String = "";					// The position that the user is resizing the panel from. (topLeft, topRight, left, etc)
		
		
		// set and get
		protected var _active:Boolean;								// [read-only]
		protected var _alwaysInFroint:Boolean;						// Set or get
		protected var _closed:Boolean;								// [read-only]
		protected var _displayState:String = "normal";				// [read-only]
		
		protected var _maxSize:Point = new Point(2048, 2048);		//
		protected var _minSize:Point = new Point(100, 100);			// 
		
		protected var _maximizable:Boolean = true;					// 
		protected var _minimizable:Boolean =  true;					// 
		protected var _resizable:Boolean = true;					// Get or set whether this Panel is resizable.
		protected var _closable:Boolean = true;						// Get or set whether this Panel is closable.
		protected var _draggable:Boolean = true;					// Get or set whether this Panel is draggable.
		protected var _colapsable:Boolean = true;					// Get or set whether this Panel is colapable.
		protected var _panelBounds:BPanelBounds;
		
		
		protected var _titleTextColor:uint = 0xFFFFFF;
		
		//protected var _bMenu:BNativeMenu;							// 
		protected var _backgroundDrag:Boolean = false;				// 
		
		protected var _titleBarMode:String = "minimal"; 			// The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
		protected var _titleBarHeight:int; 							// [read-only] The height of the title bar after calculating the titleBar height and mode, etc
		
		
		//protected var _style:BStyle;
		
		
		public function BPanel(title:String = "") 
		{
			// constructor code
			_width = 500;
			_height = 500;
			
			// assets
			_drawElement = new BElement();
			_drawElement.style.backgroundColor = 0x000000;
			_drawElement.style.backgroundOpacity = 1;
			_drawElement.style.borderColor = 0x00CCFF;
			_drawElement.style.borderOpacity = 0.8;
			_drawElement.style.borderWidth = 2;
			addChild(_drawElement);
			_style = _drawElement.style;
			
			//
			_titleBar = new BTitleBar(this, 0, 0, title);
			_titleBar.width = _width;
			_titleBar.height = 30;
			_titleBar.focusEnabled = false;
			
			_minimizedButton = new BLabelButton();
			_minimizedButton.setStateColors(0x000000, 0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000); 
			_minimizedButton.setStateAlphas(0.1, 0.4, 0.2, 0, 0, 0, 0, 0);
			BElement(_minimizedButton.getSkin("upSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("overSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("downSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("disabledSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("selectedUpSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("selectedOverSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("selectedDownSkin")).style.borderBottomWidth = 
			BElement(_minimizedButton.getSkin("selectedDisabledSkin")).style.borderBottomWidth = 2;
			BElement(_minimizedButton.getSkin("upSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("overSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("downSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("disabledSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("selectedUpSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("selectedOverSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("selectedDownSkin")).style.borderColor = 
			BElement(_minimizedButton.getSkin("selectedDisabledSkin")).style.borderColor = 0x3399CC;
			_minimizedButton.setSize(40, 40);
			
			// content
			_content = new Sprite();
			
			contentMask = new Shape();
			contentMask.graphics.beginFill(0XFF00FF, 1);
			contentMask.graphics.drawRect(0, 0, 100, 100);
			contentMask.graphics.endFill();
			_content.mask = contentMask;
			
			
			// initialize Panel buttons
			closeButton = new BLabelButton();
			minimizeButton = new BLabelButton();
			maximizeButton = new BLabelButton();
			colapseButton = new BLabelButton();
			
			closeButton.setStateColors(0x000000, 0xCC0000, 0xFF6666, 0x000000, 0x000000, 0xCC0000, 0xFF6666, 0x000000); 
			minimizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000); 
			maximizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000);
			colapseButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x000000, 0x00CCFF, 0x999999, 0x000000);
			
			closeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
			minimizeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
			maximizeButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
			colapseButton.setStateAlphas(0, 0.8, 0.8, 0.8, 0, 0.8, 0.8, 0.8);
			
			closeButton.iconPlacement = 
			minimizeButton.iconPlacement = 
			maximizeButton.iconPlacement = 
			colapseButton.iconPlacement = BButtonIconPlacement.CENTER;
			
			//closeButton.setSize(30, 30);
			//minimizeButton.setSize(30, 30);
			//maximizeButton.setSize(30, 30);
			var buttons:Vector.<BLabelButton> = new Vector.<BLabelButton>();
			buttons.push(closeButton, minimizeButton, maximizeButton, colapseButton);
			_titleBar.buttons = buttons;
			
			// icons
			xIcon = new XIcon10x10();
			minimizeIcon = new MinimizeIcon10x10();
			maximizeIcon = new MaximizeIcon10x10();
			windowIcon = new WindowIcon10x10();
			arrowIcon = new ArrowIcon02_32x32();
			
			closeButton.icon = xIcon;
			minimizeButton.icon = minimizeIcon;
			maximizeButton.icon = maximizeIcon;
			colapseButton.icon = arrowIcon;
			
			
			// resize grabbers
			resizeGrabberTL = new Sprite();
			resizeGrabberTR = new Sprite();
			resizeGrabberBL = new Sprite();
			resizeGrabberBR = new Sprite();
			resizeGrabberTE = new Sprite();
			resizeGrabberBE = new Sprite();
			resizeGrabberLE = new Sprite();
			resizeGrabberRE = new Sprite();
			
			
			// title text
			activatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
			deactivatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
			
			
			// add assets to respective containers
			
			//addChild(closeButton);
			//addChild(minimizeButton);
			//addChild(maximizeButton);
			//addChild(colapseButton);
			addChild(_content);
			addChild(contentMask);
			
			addChild(resizeGrabberTL);
			addChild(resizeGrabberTR);
			addChild(resizeGrabberBL);
			addChild(resizeGrabberBR);
			addChild(resizeGrabberTE);
			addChild(resizeGrabberBE);
			addChild(resizeGrabberLE);
			addChild(resizeGrabberRE);
			
			
			// 
			titleBarMode = BTitleBarMode.COMPACT_TEXT;
			//snappable = _snappable;
			
			
			drawResizeGrabber();
			draw();
			checkWithinBounderies();
			
			
			// add the panels to the array
			_panels.push(this);
			trace("BPanel | _panels.length: " + _panels.length);
			
			
			// event handling
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			
			closeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			minimizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			maximizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			colapseButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
			_titleBar.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			
			resizeGrabberTL.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberTR.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberBL.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberBR.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberTE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberBE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberLE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			resizeGrabberRE.addEventListener(MouseEvent.MOUSE_DOWN, startResizePanel);
			
			resizeGrabberTL.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberTR.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberBL.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberBR.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberTE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberBE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberLE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			resizeGrabberRE.addEventListener(MouseEvent.MOUSE_UP, stopResizePanel);
			
			/*resizeGrabberTL.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberTR.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberBL.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberBR.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberTE.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberBE.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberLE.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);
			resizeGrabberRE.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopResizePanel);*/
			
			resizeGrabberTL.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberTR.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberBL.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberBR.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberTE.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberBE.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberLE.addEventListener("releaseOutside", stopResizePanel);
			resizeGrabberRE.addEventListener("releaseOutside", stopResizePanel);
			
			initializeCursorEvent();
			
			// woot the fucks?
			_style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
			_titleBar.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
			
		}
		
		
		
		
		//**************************************** HANDLERS *********************************************
		
		
		protected function styleChangeHandler(event:BStyleEvent):void 
		{
			//draw();
		} // end function styleChangeHandler
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function mouseHandler(event:MouseEvent):void
		{
			//activate();
			
			// quick fix
			/*if (_panelBounds)
			{
				if (_panelBounds.getSnappedPosition(this) == "")
				{
					activate();
				}
				
			} // end if*/
			orderToFront();
			
			if (event.currentTarget == closeButton)
			{
				close();
			}
			else if (event.currentTarget == maximizeButton)
			{
				if (_displayState == "normal")
				{
					maximize();
				}
				else if (_displayState == "maximized")
				{
					restore();
				}
			}
			else if (event.currentTarget == minimizeButton)
			{
				minimize();
			}
			else if (event.currentTarget == colapseButton)
			{
				if (_displayState == "normal")
				{
					colapse();
				}
				else if (_displayState == "colapsed")
				{
					restoreSize();
				}
			}
			else if (event.currentTarget == _minimizedButton)
			{
				restore();
				orderToFront();
			}
			
			
		} // end 
		
		
		/**
		 * Drag the Panel by holding the mouse down on the appropriate asset.
		 * 
		 * @param	event
		 */
		protected function startDragPanel(event:MouseEvent):void
		{
			orderToFront();
			
			this.startDrag();
			if (_displayState == "maximized")
			{
				_displayState = "normal";
				padding = 10;
				_width = tempWidth;
				_height = tempHeight;
				x = parent.mouseX - _width/2;
				maximizeButton.icon = maximizeIcon;
				
				// testing (needs work)
				restoreSize();
				x = parent.mouseX - _width / 2;
				y = parent.mouseY - _titleBarHeight / 2;
				
				dispatchEvent(new Event(Event.RESIZE, false, false));
				draw();
			}
			//dispatchEvent(new BPanelEvent(BPanelEvent.MOVING, false, false);
		} // end function startDragPanel
		
		
		/**
		 * Stop dragging the Panel by releasing the mouse from the asset.
		 * 
		 * @param	event
		 */
		protected function stopDragPanel(event:MouseEvent):void
		{
			this.stopDrag();
			//dispatchEvent(new BPanelEvent(BPanelEvent.MOVE, false, false);
			
			checkWithinBounderies();
			
		} // end function stopDragPanel
		
		
		/**
		 * Sets variables and and event listeners for resizing and snapping.
		 * 
		 * @param	event
		 */
		protected function startResizePanel(event:MouseEvent):void
		{
			
			var resizeGrabber:Sprite = event.currentTarget as Sprite;
			
			mouseEventTarget = resizeGrabber;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
			
			
			// set the position that the panel is to be resized.
			// Also used for snapping.
			switch(mouseEventTarget)
			{
				case resizeGrabberTL:
					_resizePosition = "topLeft";
					break;
				
				case resizeGrabberTR:
					_resizePosition = "topRight";
					break;
				
				case resizeGrabberBL:
					_resizePosition = "bottomLeft";
					break;
				
				case resizeGrabberBR:
					_resizePosition = "bottomRight";
					break;
				
				case resizeGrabberTE:
					_resizePosition = "top";
					break;
				
				case resizeGrabberBE:
					_resizePosition = "bottom";
					break;
				
				case resizeGrabberLE:
					_resizePosition = "left";
					break;
				
				case resizeGrabberRE:
					_resizePosition = "right";
					break;
				
			} // end switch
			
			
		} // end function startResizePanel
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function stopResizePanel(event:MouseEvent = null):void
		{
			var extra:int =  - padding + resizeGrabberThickness;
			
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			
			if (event.target == resizeGrabberTL)
			{
				this.x = this.x + resizeGrabberTL.x + extra;
				this.y = this.y + resizeGrabberTL.y + extra;
			}
			else if(event.target == resizeGrabberTE)
			{
				this.x = this.x + resizeGrabberTL.x + extra;
				this.y = this.y + resizeGrabberTE.y + extra;
			}
			else if(event.target == resizeGrabberLE)
			{
				this.x = this.x + resizeGrabberLE.x + extra;
				this.y = this.y + resizeGrabberTL.y + extra;
			}
			else if(event.target == resizeGrabberBL)
			{
				this.x = this.x + resizeGrabberBL.x + extra;
				this.y = this.y + resizeGrabberTL.y + extra;
			}
			else if(event.target == resizeGrabberTR)
			{
				this.x = this.x + resizeGrabberTL.x + extra;
				this.y = this.y + resizeGrabberTR.y + extra;
			}
			
			// draw the Panel
			draw();
			
			checkWithinBounderies();
			
		} // end function stopResizePanel
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function enterFrameHandler(event:Event):void
		{
			// some of this can be set in startResizeHandler
			
			// 
			var extra:int = (padding * 2) - resizeGrabberThickness;
			
			_width = resizeGrabberRE.x - resizeGrabberLE.x + extra; 	// the width of the Panel
			_height = resizeGrabberBE.y - resizeGrabberTE.y + extra; 	// the height of the Panel
			
			registrationPoint.x = 0;
			registrationPoint.y = 0;
			
			// Set the panelWidth and panelHeight properties
			// 4 conditions needed to accomodate for all 4 edges of the panel
			if(mouseEventTarget == resizeGrabberTR || mouseEventTarget == resizeGrabberTL)
			{
				_width = resizeGrabberTR.x - resizeGrabberTL.x + extra;
				_height = resizeGrabberBE.y - mouseEventTarget.y + extra;
			}
			else if(mouseEventTarget == resizeGrabberLE || mouseEventTarget == resizeGrabberRE)
			{
				_width = resizeGrabberRE.x - resizeGrabberLE.x + extra;
				_height = resizeGrabberBE.y - resizeGrabberTE.y + extra;
			}
			else if(mouseEventTarget == resizeGrabberTE || mouseEventTarget == resizeGrabberBE)
			{
				_width = resizeGrabberTR.x - resizeGrabberTL.x + extra;
				_height = resizeGrabberBE.y - resizeGrabberTE.y + extra;
			}
			else if(mouseEventTarget == resizeGrabberBL || mouseEventTarget == resizeGrabberBR)
			{
				_width = resizeGrabberBR.x - resizeGrabberBL.x + extra;
				_height = mouseEventTarget.y - resizeGrabberTE.y + extra;
			}
			
			// make sure _width and _height are not greater the or less then the max width/min width and max height/min height
			_width = Math.min(_maxSize.x, _width);
			_width = Math.max(_minSize.x, _width);
			
			_height = Math.min(_maxSize.y, _height);
			_height = Math.max(_minSize.y, _height);
			
			// set the mouseEventTarget to the mouse position
			mouseEventTarget.x = mouseX;
			mouseEventTarget.y = mouseY;
			
			
			// align the assets
			
			// top resizers
			if(mouseEventTarget == resizeGrabberTL || mouseEventTarget == resizeGrabberTR || mouseEventTarget == resizeGrabberTE)
			{
				registrationPoint.y = mouseEventTarget.y - resizeGrabberThickness;
			} 
			// left resizers
			if(mouseEventTarget == resizeGrabberTL || mouseEventTarget == resizeGrabberLE || mouseEventTarget == resizeGrabberBL)
			{
				registrationPoint.x = mouseEventTarget.x - resizeGrabberThickness;
			}
			// right resizers
			else if(mouseEventTarget == resizeGrabberTR || mouseEventTarget == resizeGrabberRE || mouseEventTarget == resizeGrabberBR)
			{
				registrationPoint.x = 0;
			}
			// bottom resizers
			else if(mouseEventTarget == resizeGrabberBL || mouseEventTarget == resizeGrabberBE || mouseEventTarget == resizeGrabberBR)
			{
				registrationPoint.y = 0;
			}
			
			
			// 
			_content.x = registrationPoint.x + padding;
			_content.y = registrationPoint.y + padding + _titleBar.height;
			
			// mask
			contentMask.x = registrationPoint.x + padding;
			contentMask.y = registrationPoint.y + padding + _titleBar.height;
			contentMask.width = _width - padding * 2; 
			contentMask.height = _height - _titleBar.height - padding * 2;
			
			
			
			//
			_drawElement.width = _width;
			_drawElement.height = _height;
			_drawElement.x = registrationPoint.x;
			_drawElement.y = registrationPoint.y;
			
			_titleBar.width = (_width - int(_drawElement.style.borderWidth) * 2);
			_titleBar.x = registrationPoint.x + int(_drawElement.style.borderWidth);
			_titleBar.y = registrationPoint.y + int(_drawElement.style.borderWidth);
			
			
			// 
			_content.dispatchEvent(new Event(Event.RESIZE));
			
		} // end function enterFrameHandler
		
		
		/**
		 * 
		 * @param	event
		 */
		private function closeTimerHandler(event:TimerEvent):void
		{
			Timer(event.target).stop();
			event.target.removeEventListener(TimerEvent.TIMER, closeTimerHandler);
			this.visible = false;
			
			this.dispatchEvent(new Event(Event.CLOSE, false, false));
			
		} // end function closeTimerHandler
		
		
		
		
		
		/**
		 * Change the cursor based on the event type, and event target
		 * 
		 * @param	event
		 */
		private function changeCursor(event:MouseEvent):void
		{
			
			if(event.type == MouseEvent.ROLL_OVER)
			{
				switch(event.currentTarget)
				{
					case _titleBar:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
					case resizeGrabberTL:
						Mouse.cursor = BMouseCursor.RESIZE_TOP_LEFT;
						break;
					
					case resizeGrabberTR:
						Mouse.cursor = BMouseCursor.RESIZE_TOP_RIGHT;
						break;
					
					case resizeGrabberTE:
						Mouse.cursor = BMouseCursor.RESIZE_TOP;
						break;
					
					case resizeGrabberBL:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_LEFT;
						break;
					
					case resizeGrabberBR:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_RIGHT;
						break;
					
					case resizeGrabberBE:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM;
						break;
					
					case resizeGrabberLE:
						Mouse.cursor = BMouseCursor.RESIZE_LEFT;
						break;
					
					case resizeGrabberRE:
						Mouse.cursor = BMouseCursor.RESIZE_RIGHT;
						break;
					
				}
			}
			else if(event.type == MouseEvent.ROLL_OUT)
				Mouse.cursor = MouseCursor.AUTO;
			
			
		} // end function changeCursor
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 */
		protected function initializeCursorEvent():void
		{
			_titleBar.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			_titleBar.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			
			if (_resizable)
			{
				resizeGrabberTL.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberTR.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberBL.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberBR.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberTE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberBE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberLE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberRE.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				resizeGrabberTL.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberTR.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberBL.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberBR.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberTE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberBE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberLE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				resizeGrabberRE.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			}
		} // end function initializeCursorEvent
		
		
		/**
		 * Draws the panel.
		 */
		//protected function draw():void
		override protected function draw():void
		{
			// check to see if the displayState of the panel is "normal".
			if (_displayState == "normal")
			{
				// make sure _width and _height are not greater than or less than the max width/min width and max height/min height
				_width = Math.min(_maxSize.x, _width);
				_width = Math.max(_minSize.x, _width);
				
				_height = Math.min(_maxSize.y, _height);
				_height = Math.max(_minSize.y, _height);
			}
			
			
			// resize grabbers
			resizeGrabberTL.x = padding - resizeGrabberThickness;
			resizeGrabberTL.y = padding - resizeGrabberThickness;
			resizeGrabberTR.x = _width - padding;
			resizeGrabberTR.y = padding - resizeGrabberThickness;
			resizeGrabberBL.x = padding - resizeGrabberThickness;
			resizeGrabberBL.y = _height - padding;
			resizeGrabberBR.x = _width - padding;
			resizeGrabberBR.y = _height - padding;
			
			resizeGrabberTE.x = padding;
			resizeGrabberTE.y = padding - resizeGrabberThickness;
			resizeGrabberBE.x = padding;
			resizeGrabberBE.y = _height - padding;
			resizeGrabberLE.x = padding - resizeGrabberThickness;
			resizeGrabberLE.y = padding;
			resizeGrabberRE.x = _width - padding;
			resizeGrabberRE.y = padding;
			
			resizeGrabberTE.width = _width - (padding * 2);
			resizeGrabberBE.width = _width - (padding * 2);
			resizeGrabberLE.height = _height - (padding * 2);
			resizeGrabberRE.height = _height - (padding * 2);
			
			
			//var borderAndPaddingWidth:int = padding + int(_drawElement.style.borderWidth);
			
			// buttons
			/*closeButton.x = _width - closeButton.width - padding;
			closeButton.y = padding;
			maximizeButton.x = closeButton.x - maximizeButton.width;
			maximizeButton.y = padding;
			minimizeButton.x = maximizeButton.x - minimizeButton.width;
			minimizeButton.y = padding;
			colapseButton.x = minimizeButton.x - colapseButton.width;
			colapseButton.y = padding;*/
			
			
			// 
			_content.x = padding;
			_content.y = padding + _titleBar.height;
			
			// mask
			contentMask.x = padding;
			contentMask.y = padding + _titleBar.height;
			contentMask.width = _width - padding * 2; 
			contentMask.height = _height - _titleBar.height - padding * 2;
			
			
			
			// 
			_drawElement.width = _width;
			_drawElement.height = _height;
			_drawElement.x = 0;
			_drawElement.y = 0;
			
			_titleBar.width = (_width - int(_drawElement.style.borderWidth) * 2);
			_titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;
			_titleBar.x = int(_drawElement.style.borderWidth);
			_titleBar.y = int(_drawElement.style.borderWidth);
			
		} // end function draw
		
		
		/**
		 * Draws the resize grabbers.
		 * Can be rectangular or circular
		 */
		protected function drawResizeGrabber():void
		{
			var color:uint = 0x00FF00;
			var alpha:Number = 0;
			
			resizeGrabberTL.scaleX = 
			resizeGrabberTR.scaleX = 
			resizeGrabberBL.scaleX = 
			resizeGrabberBR.scaleX = 
			resizeGrabberTE.scaleX = 
			resizeGrabberBE.scaleX = 
			resizeGrabberLE.scaleX = 
			resizeGrabberRE.scaleX = 
			
			resizeGrabberTL.scaleY = 
			resizeGrabberTR.scaleY = 
			resizeGrabberBL.scaleY = 
			resizeGrabberBR.scaleY = 
			resizeGrabberTE.scaleY = 
			resizeGrabberBE.scaleY = 
			resizeGrabberLE.scaleY = 
			resizeGrabberRE.scaleY = 1;
			
			resizeGrabberTL.alpha = 
			resizeGrabberTR.alpha = 
			resizeGrabberBL.alpha = 
			resizeGrabberBR.alpha = 
			resizeGrabberTE.alpha = 
			resizeGrabberBE.alpha = 
			resizeGrabberLE.alpha = 
			resizeGrabberRE.alpha = alpha;
			
			resizeGrabberTL.graphics.clear();
			resizeGrabberTR.graphics.clear();
			resizeGrabberBL.graphics.clear();
			resizeGrabberBR.graphics.clear();
			resizeGrabberTE.graphics.clear();
			resizeGrabberBE.graphics.clear();
			resizeGrabberLE.graphics.clear();
			resizeGrabberRE.graphics.clear();
			
			
			var grabbersWidth:int = _width - padding * 2;		// 
			var grabbersHeight:int = _height - padding * 2;		// 
			
			resizeGrabberTL.graphics.beginFill(color, 1);
			resizeGrabberTR.graphics.beginFill(color, 1);
			resizeGrabberBL.graphics.beginFill(color, 1);
			resizeGrabberBR.graphics.beginFill(color, 1);
			resizeGrabberTE.graphics.beginFill(color, 1);
			resizeGrabberBE.graphics.beginFill(color, 1);
			resizeGrabberLE.graphics.beginFill(color, 1);
			resizeGrabberRE.graphics.beginFill(color, 1);
			
			resizeGrabberTL.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
			resizeGrabberTR.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
			resizeGrabberBL.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
			resizeGrabberBR.graphics.drawRect(0, 0, resizeGrabberThickness, resizeGrabberThickness);
			resizeGrabberTE.graphics.drawRect(0, 0, grabbersWidth, resizeGrabberThickness);
			resizeGrabberBE.graphics.drawRect(0, 0, grabbersWidth, resizeGrabberThickness);
			resizeGrabberLE.graphics.drawRect(0, 0, resizeGrabberThickness, grabbersHeight);
			resizeGrabberRE.graphics.drawRect(0, 0, resizeGrabberThickness, grabbersHeight);
			
			resizeGrabberTL.graphics.endFill();
			resizeGrabberTR.graphics.endFill();
			resizeGrabberBL.graphics.endFill();
			resizeGrabberBR.graphics.endFill();
			resizeGrabberTE.graphics.endFill();
			resizeGrabberBE.graphics.endFill();
			resizeGrabberLE.graphics.endFill();
			resizeGrabberRE.graphics.endFill();
			
			
			resizeGrabberTL.x = padding - resizeGrabberThickness;
			resizeGrabberTL.y = padding - resizeGrabberThickness;
			resizeGrabberTR.x = _width - padding;
			resizeGrabberTR.y = padding - resizeGrabberThickness;
			resizeGrabberBL.x = padding - resizeGrabberThickness;
			resizeGrabberBL.y = _height - padding;
			resizeGrabberBR.x = _width - padding;
			resizeGrabberBR.y = _height - padding;
			
			resizeGrabberTE.x = padding;
			resizeGrabberTE.y = padding - resizeGrabberThickness;
			resizeGrabberBE.x = padding;
			resizeGrabberBE.y = _height - padding;
			resizeGrabberLE.x = padding - resizeGrabberThickness;
			resizeGrabberLE.y = padding;
			resizeGrabberRE.x = _width - padding;
			resizeGrabberRE.y = padding;
			
			
		} // function drawResizeGrabber
		
		
		/**
		 * Activates this panel.
		 * - Make the panel visible
		 * - Bring the panel to the front
		 */
		public function activate():void
		{
			_active = true;
			_closed = false;
			visible = true;
			alpha = 1;
			scaleX = scaleY = 1;
			
			orderToFront();
			
			dispatchEvent(new Event(Event.ACTIVATE, false, false));
			
		} // end function activate
			
		
		/**
		 * Closes this panel.
		 */
		public function close():void
		{
			_active = false;
			_closed = true;
			
			var tween:Tween = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.3, true);
			var tween2:Tween = new Tween(this, "scaleX", Regular.easeOut, 1, 0.5, 0.3, true);
			var tween3:Tween = new Tween(this, "scaleY", Regular.easeOut, 1, 0.5, 0.3, true);
			
			
			var closeTimer:Timer = new Timer(300, 1);
			closeTimer.addEventListener(TimerEvent.TIMER, closeTimerHandler);
			closeTimer.start();
			
			//this.dispatchEvent(new Event(Event.CLOSING, false, false));
			this.dispatchEvent(new Event("closing", false, false));
			
		} // end function close
		
		
		/**
		 * 
		 */
		public function maximize():void
		{
			// check if panel is maximizable
			if (_maximizable)
			{
				_displayState = "maximized";
				
				padding = 0;
				
				tempX = x;
				tempY = y;
				tempWidth = _width;
				tempHeight = height;
				
				
				x = 0;
				y = 0;
				if (root)
				{
					resize(DisplayObjectContainer(root).stage.stageWidth, DisplayObjectContainer(root).stage.stageHeight);
				}
				
				maximizeButton.icon = windowIcon;
				draw();
				dispatchEvent(new Event(Event.RESIZE, false, false));
				
			} // end if
			
		} // end function maximize
		
		
		/**
		 * 
		 */
		public function minimize():void
		{
			// check if panel is minimizable
			if (_minimizable)
			{
				_displayState = "minimized";
				
				padding = 0;
				
				tempX = x;
				tempY = y;
				tempWidth = _width;
				tempHeight = _height;
				
				resize(_minimizedButton.width, _minimizedButton.height, true);
				
				var timer:Timer = new Timer(333, 1)
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
				function(event:TimerEvent):void
				{
					_drawElement.visible = false;
					_titleBar.visible = false;
					addChild(_minimizedButton);
				});
				timer.start();
				
				draw();
				
				dispatchEvent(new Event(Event.RESIZE, false, false));
				_minimizedButton.addEventListener(MouseEvent.CLICK, mouseHandler);
				
			} // end if
			
		} // end function minimize
		
		
		/**
		 * 
		 * @return
		 */
		public function orderInBackOf(panel:BPanel):Boolean
		{
			// check if has a parent
			if (parent)
			{
				if (_displayState == "minimized" || _closed)
				{
					return false;
				}
				
				parent.setChildIndex(this, parent.getChildIndex(panel) - 1);
			}
			else
			{
				return false;
			} // end if else
			
			return true;
			
		} // end function orderInBackOf
		
		
		/**
		 * 
		 * @return
		 */
		public function orderInFrontOf(panel:BPanel):Boolean
		{
			// check if has a parent
			if (parent)
			{
				if (_displayState == "minimized" || _closed)
				{
					return false;
				}
				
				parent.setChildIndex(this, parent.getChildIndex(panel) + 1);
			}
			else
			{
				return false;
			} // end if else
			
			return true;
			
		} // end function orderInFrontOf
		
		
		/**
		 * 
		 * @return
		 */
		public function orderToBack():Boolean
		{
			// check if has a parent
			if (parent)
			{
				if (_displayState == "minimized" || _closed)
				{
					return false;
				}
				
				parent.setChildIndex(this, 0);
			}
			else
			{
				return false;
			} // end if else
			
			return true;
			
		} // end function 
		
		
		/**
		 * 
		 * @return
		 */
		public function orderToFront():Boolean
		{
			// check if has a parent
			if (parent)
			{
				if (_displayState == "minimized" || _closed)
				{
					return false;
				}
				
				parent.setChildIndex(this, parent.numChildren - 1);
			}
			else
			{
				return false;
			} // end if else
			
			return true;
			
		} // end function
		
		
		/**
		 * 
		 */
		protected function restoreSize():void
		{
			orderToFront();
			trace("restoring");
			_displayState = "normal";
			
			padding = 2;
			
			resize(tempWidth, tempHeight, true)
			
			var iconTween:Tween = new Tween(colapseButton.icon, "rotation", Regular.easeOut, 0, 180, 0.3, true);
			
			_drawElement.visible = true;
			_titleBar.visible = true;
			
			maximizeButton.icon = maximizeIcon;
			if (_minimizedButton.parent)
			{
				_minimizedButton.parent.removeChild(_minimizedButton);
			}
			
			draw();
			
			dispatchEvent(new Event(Event.RESIZE, false, false));
			_minimizedButton.removeEventListener(MouseEvent.CLICK, mouseHandler);
		} // end function restoreSize
		
		
		/**
		 * 
		 */
		public function restore():void
		{
			x = tempX;
			y = tempY;
			
			restoreSize();
		} // end function restore
		
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @param animate
		 */
		public function resize(width:int, height:int, animate:Boolean = true):void
		{
			
			// check to see if window is open
			if (!_closed)
			{
				if (animate)
				{
					
					var timerResizeHandler:Function = function(event:TimerEvent):void 
					{
						if (Math.abs(resizeToWidth - _width) <= 1)
						{
							_width = resizeToWidth;
						}
						else
						{
							_width += (resizeToWidth - _width) * 0.3;
						}
						
						if (Math.abs(resizeToHeight - _height) <= 1)
						{
							_height = resizeToHeight;
						}
						else
						{
							_height += (resizeToHeight - _height) * 0.3;
						}
						
						_content.dispatchEvent(new Event(Event.RESIZE));
						draw();
					} // end function timerResizeHandler
					
					var timer:Timer = new Timer(1000 / 60, 20);
					
					timer.addEventListener(TimerEvent.TIMER, timerResizeHandler);
					timer.start();
					resizeToWidth = width;
					resizeToHeight = height;
				}
				else
				{
					_width = width;
					_height = height;
					draw();
				}
			}
		} // end function resize
		
		
		/*// 
		// 
		public function startMove():Boolean
		{
			
		} // end 
		
		
		// 
		// 
		public function startResize(edgeOrCorner:String = "BR"):Boolean
		{
			
		} // end 
		*/
		
		
		/**
		 * 
		 */
		public function colapse():void
		{
			if (_colapsable)
			{
				trace("colapsing");
				_displayState = "colapsed";
				
				//padding = 0;
				tempX = x;
				tempY = y;
				tempWidth = _width;
				tempHeight = _height;
				
				resize(_width, (titleBarHight + padding * 2));
				var iconTween:Tween = new Tween(colapseButton.icon, "rotation", Regular.easeOut, 180, 0, 0.3, true);
				
				dispatchEvent(new Event(Event.RESIZE, false, false));
			}
			
		} // end 
			
		
		/**
		 * Checks to see if the panel is within its bounderies and keeps in within the bounderies.
		 * Also checks the size of the panel and makes sure the panel is not larger than its bounderis.
		 * This will not chaneg the minSize or maxSize properties.
		 */
		protected function checkWithinBounderies():void
		{
			// check if panels has bounderies.
			if (panelBounds)
			{
				// test width
				if (_width > panelBounds.innerWidth)
				{
					width = panelBounds.innerWidth;
				}
				
				// test height
				if (_height > panelBounds.innerHeight)
				{
					height = panelBounds.innerHeight;
				}
				
				// test left
				if (this.x < panelBounds.left)
				{
					this.x = panelBounds.left;
				} // end if
				
				// test right
				if (this.x > panelBounds.right - _width)
				{
					this.x = panelBounds.right - _width;
				} // end if
				
				// test top
				if (this.y < panelBounds.top)
				{
					this.y = panelBounds.top;
				} // end if
				
				// test bottom
				if (this.y > panelBounds.bottom - _height)
				{
					this.y = panelBounds.bottom - _height;
				} // end if
				
			} // end if
			
		} // end function checkWithinBounderies
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * [read-only] A reference to the internal title bar.
		 */
		public function get titleBar():BTitleBar
		{
			return _titleBar;
		}
		
		
		/**
		 * 
		 */
		public function get titleTextColor():uint
		{
			return uint(activatedTF.color);
		}
		
		public function set titleTextColor(value:uint):void
		{
			activatedTF.color = value;
			_titleBar.label.textField.setTextFormat(activatedTF);
			//_titleBar.label.textField.setTextFormat(activatedTF);
			//titleText.setTextFormat(activatedTF);
			//dotsText.setTextFormat(activatedTF);
		}
		
		
		/**
		 * [read-only] 
		 */
		public function get  titleBarHight():Number
		{
			return _titleBar.height;
		}
		
		
		/**
		 * 
		 */
		public function get titleBarMode():String
		{
			return _titleBarMode;
		}
		
		public function set titleBarMode(value:String):void
		{
			_titleBarMode = value;
			_titleBar.mode = _titleBarMode;
			
			if (_titleBarMode != "none")
			{
				closeButton.visible = true;
				maximizeButton.visible = true;
				minimizeButton.visible = true;
				colapseButton.visible = true;
				
				if (_titleBarMode != "minimal")
				{
					closeButton.icon = xIcon;
					maximizeButton.icon = maximizeIcon;
					minimizeButton.icon = minimizeIcon;
					colapseButton.icon = arrowIcon;
					colapseButton.setIconBounds(15, 15, 10,10);
					
				}
			}
			
			
			switch(_titleBarMode)
			{
				case "compactText":
					_titleBarHeight = 30;
					break;
					
				case "compactIcon":
					_titleBarHeight = 40;
					break;
					
				case "fullText":
					_titleBarHeight = 30;
					break;
					
				case "fullIcon":
					_titleBarHeight = 48;
					break;
					
				case "minimal":
					_titleBarHeight = 10;
					closeButton.icon = null;
					maximizeButton.icon = null;
					minimizeButton.icon = null;
					colapseButton.icon = null;
					break;
					
				case "none":
					closeButton.visible = false;
					maximizeButton.visible = false;
					minimizeButton.visible = false;
					colapseButton.visible = false;
					break;
					
			} // end switch
			
			
			closeButton.setSize(_titleBarHeight, _titleBarHeight);
			maximizeButton.setSize(_titleBarHeight, _titleBarHeight);
			minimizeButton.setSize(_titleBarHeight, _titleBarHeight);
			colapseButton.setSize(_titleBarHeight, _titleBarHeight);
			
			//buttonsWidth = _titleBarHeight * 5 + dotsText.width; 
			
			draw();
			
		} 
		
		
		/*
		// bMenu
		public function set bMenu(value:BNativeMenu):void
		{
			if (_bMenu)
			{
				trace("This window already has a menu.");
				return;
			}
			_bMenu = value;
			_bMenu.display(container.stage, padding, padding);
		}
		
		public function get bMenu():BNativeMenu
		{
			return _bMenu;
		}
		
		*/
		/**
		 * 
		 */
		public function get backgroundDrag():Boolean
		{
			return _backgroundDrag;
		}
		
		public function set backgroundDrag(value:Boolean):void
		{
			_backgroundDrag = value;
			if (value)
			{
				_drawElement.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
				_drawElement.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			}
			else
			{
				if (_drawElement.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					_drawElement.removeEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
				}
				if (_drawElement.hasEventListener(MouseEvent.MOUSE_UP))
				{
					_drawElement.removeEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
				}
			}
		}
		
		
		/**
		 * [read-only] 
		 */
		public function get content():DisplayObjectContainer
		{
			return _content
		}
		
		
		/**
		 * 
		 */
		public function get title():String
		{
			return _titleBar.title;
		}
		
		public function set title(value:String):void
		{
			_titleBar.title = value;
		}
		
		
		
		
		/**
		 * 
		 */
		public function get active():Boolean
		{
			return _active;
		}
		
		
		// alwaysInFront
		/*public function set alwaysInFront(value:Boolean):void
		{
			_alwaysInFroint = value;
		}
		
		public function get alwaysInFront():Boolean
		{
			return _alwaysInFroint;
		}
		*/
		
		
		
		/**
		 * 
		 */
		public function get maxWidth():int
		{
			return _maxSize.x;
		}
		
		public function set maxWidth(value:int):void
		{
			_maxSize.x = value;
			_width = Math.min(_maxSize.x, _width);
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get maxHeight():int
		{
			return _maxSize.y;
		}
		
		public function set maxHeight(value:int):void
		{
			_maxSize.y = value;
			_height = Math.min(_maxSize.y, _height);
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get minWidth():int
		{
			return _minSize.x;
		}
		
		public function set minWidth(value:int):void
		{
			_minSize.x = value;
			_width = Math.max(_minSize.x, _width);
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get minHeight():int
		{
			return _minSize.y;
		}
		
		public function set minHeight(value:int):void
		{
			_minSize.y = value;
			_height = Math.max(_minSize.y, _height);
			draw();
		}
		 
		
		/**
		 * 
		 */
		public function get maxSize():Point
		{
			return _maxSize;
		}
		
		public function set maxSize(value:Point):void
		{
			_maxSize = value;
			_width = Math.min(_maxSize.x, _width);
			_height = Math.min(_maxSize.y, _height);
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get minSize():Point
		{
			return _minSize;
		}
		
		public function set minSize(value:Point):void
		{
			_minSize = value;
			_width = Math.max(_minSize.x, _width);
			_height = Math.max(_minSize.y, _height);
			draw();
		}
		
		
		
		
		
		/**
		 * 
		 */
		public function get maximizable():Boolean
		{
			return _maximizable;
		}
		
		public function set maximizable(value:Boolean):void
		{
			_maximizable = value;
			
			if(value)
			{
				maximizeButton.scaleX = 1;
				maximizeButton.visible = true;
			}
			else
			{
				maximizeButton.scaleX = 0;
				maximizeButton.visible = false;
			}
			
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get minimizable():Boolean
		{
			return _minimizable;
		}
		
		public function set minimizable(value:Boolean):void
		{
			_minimizable = value;
			
			if(value)
			{
				minimizeButton.scaleX = 1;
				minimizeButton.visible = true;
			}
			else
			{
				minimizeButton.scaleX = 0;
				minimizeButton.visible = false;
			}
			
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get resizable():Boolean
		{
			return _resizable;
		}
		
		public function set resizable(value:Boolean):void
		{
			_resizable = value;
			
			if(value)
			{	
				resizeGrabberTL.mouseEnabled = true;
				resizeGrabberTR.mouseEnabled = true;
				resizeGrabberBL.mouseEnabled = true;
				resizeGrabberBR.mouseEnabled = true;
				resizeGrabberTE.mouseEnabled = true;
				resizeGrabberBE.mouseEnabled = true;
				resizeGrabberLE.mouseEnabled = true;
				resizeGrabberRE.mouseEnabled = true;
			}
			else
			{
				resizeGrabberTL.mouseEnabled = false;
				resizeGrabberTR.mouseEnabled = false;
				resizeGrabberBL.mouseEnabled = false;
				resizeGrabberBR.mouseEnabled = false;
				resizeGrabberTE.mouseEnabled = false;
				resizeGrabberBE.mouseEnabled = false;
				resizeGrabberLE.mouseEnabled = false;
				resizeGrabberRE.mouseEnabled = false;
			}
		}
		
		
		/**
		 * 
		 */
		public function get closable():Boolean
		{
			return _closable;
		}
		
		public function set closable(value:Boolean):void
		{
			_closable = value;
			
			if(value)
			{
				closeButton.scaleX = 1;
				closeButton.visible = true;
			}
			else
			{
				closeButton.scaleX = 0;
				closeButton.visible = false;
			}
			
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get draggable():Boolean
		{
			return _draggable
		}
		
		public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if(value)
			{
				_titleBar.mouseEnabled = true;
			}
			else
			{
				_titleBar.mouseEnabled = false;
			}
		}
		
		
		/**
		 * 
		 */
		public function get colapsable():Boolean
		{
			return _colapsable;
		}
		
		public function set colapsable(value:Boolean):void
		{
			_colapsable = value;
			
			if(value)
			{
				colapseButton.scaleX = 1;
				colapseButton.visible = true;
			}
			else
			{
				colapseButton.scaleX = 0;
				colapseButton.visible = false;
			}
			
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get panelBounds():BPanelBounds
		{
			return _panelBounds;
		}
		
		public function set panelBounds(value:BPanelBounds):void
		{
			_panelBounds = value;
			checkWithinBounderies();
		}
		
		
		
		/*
		 * overriding to make sure panel is within its bounderies.
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			checkWithinBounderies();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			checkWithinBounderies();
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			checkWithinBounderies();
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			checkWithinBounderies();
		}
		
	}

}