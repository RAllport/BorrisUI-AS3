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
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import Borris.assets.icons.*;
	import Borris.controls.*;
	import Borris.display.*;
	import Borris.menus.*;
	import Borris.ui.BMouseCursor;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	
	public class BPanel_old extends Sprite
	{
		// constants
		
		
		// assets
		protected var _content:Sprite;
		protected var contentMask:Shape;
		
		protected var background:Sprite;
		protected var border:Sprite;
		protected var titleBar:Sprite;
		protected var titleText:TextField;
		protected var dotsText:TextField;
		
		protected var titleBarBackground:Shape;
		protected var titleBarBorder:Shape;
		protected var titleBarBackgroundMask:Shape;
		protected var titleBarBorderMask:Shape;
		
		protected var closeButton:BLabelButton;
		protected var minimizeButton:BLabelButton;
		protected var maximizeButton:BLabelButton;
		protected var colapseButton:BLabelButton;
		//protected var contextMenu:BContextMenu;
		//protected var nativeMenu:BNativeMenu;
		
		// icons
		protected var xIcon:DisplayObject;
		protected var maximizeIcon:DisplayObject;
		protected var minimizeIcon:DisplayObject;
		protected var windowIcon:DisplayObject;
		protected var arrowIcon:DisplayObject;
		protected var dotsIcon:DisplayObject;
		
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
		protected var beginMouseX:int;								// Not actually used for anything.
		protected var beginMouseY:int;								// Not actually used for anything.
		protected var endMouseX:int;								// Not actually used for anything.
		protected var endMouseY:int;								// Not actually used for anything.
		protected var beginMousePoint:Point;						// Not actually used for anything.
		protected var endMousePoint:Point;							// Not actually used for anything.
		protected var mouseIsDown:Boolean;							// Not actually used for anything.
		protected var mouseEventTarget:Sprite;						// 
		
		protected var registrationPoint:Point = new Point(0, 0);
		
		
		// other
		protected var padding:Number = 10;							// 
		private var borderMaxThickness:int = 10;					// 
		private var borderMinThickness:int = 1;						// 
		protected var activatedTF:TextFormat;						// 
		protected var deactivatedTF:TextFormat;						// 
		private var tempX:int;
		private var tempY:int;
		private var tempWidth:int;									// a holder for previous state widths
		private var tempHeight:int;									// 
		private var resizeToWidth:int;
		private var resizeToHeight:int;
		protected var buttonsWidth:int = 150;						// the width of the buttons and icons in the the titlebar. used for calucating the title text width
		protected var resizeGrabberThickness:int = 5;
		
		// set and get
		protected var _active:Boolean;								// [read-only]
		protected var _alwaysInFroint:Boolean;						// Set or get
		protected var _closed:Boolean;								// [read-only]
		protected var _displayState:String = "normal";				// 
		
		protected var _width:int = 500;								// 
		protected var _height:int = 500;							// 
		protected var _maxSize:Point = new Point(2048, 2048);		//
		protected var _minSize:Point = new Point(100, 100);			// 
		
		protected var _maximizable:Boolean = true;					// 
		protected var _minimizable:Boolean =  true;					// 
		protected var _resizable:Boolean = true;					// Set or get whether this Panel is resizable.
		protected var _closable:Boolean = true;						// Set or get whether this Panel is closable.
		protected var _draggable:Boolean = true;					// Set or get whether this Panel is draggable.
		protected var _colapsable:Boolean = false;					// Set or get whether this Panel is colapable.
		//protected var _detachable:Boolean = true;					// Set or get whether this Panel is detachable.
		//protected var _attached:Boolean = true;						// [read-only] Whether or not this panel is attached to the main panel.
		//protected var _freeMove:Boolean = true;						// Set or get whether this Panel can be freely dragged around.
		
		protected var _backgroundColor:uint = 0x000000;				// 
		protected var _backgroundTransparency:Number = 1;			// 
		protected var _borderColor:uint = 0x00CCFF;					// 
		protected var _borderTransparency:Number = 0.8;				// 
		protected var _borderThickness:int = 2;						// 
		protected var _titleBarBackgroundColor:uint = 0x006699;		// 
		protected var _titleBarBackgroundTransparency:Number = 1;	// 
		protected var _titleBarBorderColor:uint = 0x00CCFF;			// 
		protected var _titleBarBorderTransparency:Number = 0.8;		// 
		protected var _titleBarBorderThickness:int = 1;				// 
		protected var _titleTextColor:uint = 0xFFFFFF;
		
		//protected var _bMenu:BNativeMenu;							// 
		protected var _backgroundDrag:Boolean = false;				// 
		protected var _windowShape:String = "rectangular";			// 
		
		protected var _titleBarMode:String = "minimal"; 			// The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
		protected var _titleBarHeight:int; 							// [read-only] The height of the title bar after calculating the titleBar height and mode, etc
		
		
		
		public function BPanel_old(title:String = "") 
		{
			// constructor code
			
			// assets
			background = new Sprite();
			border = new Sprite();
			titleBar = new Sprite();
			
			// content
			_content = new Sprite();
			
			contentMask = new Shape();
			contentMask.graphics.beginFill(0XFF00FF, 1);
			contentMask.graphics.drawRect(0, 0, 100, 100);
			contentMask.graphics.endFill();
			_content.mask = contentMask;
			
			titleBarBackground = new Shape();
			titleBarBorder = new Shape();
			titleBarBackgroundMask = new Shape();
			titleBarBorderMask = new Shape();
			
			//
			titleBarBackground.mask = titleBarBackgroundMask;
			titleBarBorder.mask = titleBarBorderMask;
			
			//
			titleBar.x = titleBar.y = padding;
			
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
			
			// icons
			xIcon = new XIcon10x10();
			minimizeIcon = new MinimizeIcon10x10();
			maximizeIcon = new MaximizeIcon10x10();
			windowIcon = new WindowIcon10x10();
			arrowIcon = new ArrowIcon02_32x32();
			dotsIcon = new MoreIcon24x24();
			
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
			activatedTF = new TextFormat("Calibri", 14, _titleTextColor, false);
			deactivatedTF = new TextFormat("Calibri", 14, _titleTextColor, false);
			
			titleText = new TextField();
			titleText.text = title;
			titleText.type = TextFieldType.DYNAMIC;
			titleText.wordWrap = false;
			titleText.multiline = false;
			titleText.selectable = false;
			titleText.x = padding + 30;
			titleText.y = padding + 5;
			titleText.height = 30;
			titleText.setTextFormat(activatedTF);
			titleText.defaultTextFormat = activatedTF;
			titleText.mouseEnabled = false;
			titleText.autoSize = TextFieldAutoSize.LEFT;
			titleText.antiAliasType = AntiAliasType.ADVANCED;
			
			dotsText = new TextField();
			dotsText.text = "...";
			dotsText.type = TextFieldType.DYNAMIC;
			dotsText.wordWrap = false;
			dotsText.multiline = false;
			dotsText.selectable = false;
			dotsText.x = padding + 30;
			dotsText.y = padding + 5;
			//dotsText.width = 30;
			dotsText.height = 30;
			dotsText.setTextFormat(activatedTF);
			dotsText.defaultTextFormat = activatedTF;
			dotsText.mouseEnabled = false;
			dotsText.autoSize = TextFieldAutoSize.LEFT;
			dotsText.antiAliasType = AntiAliasType.ADVANCED;
			dotsText.visible = false;
			
			
			// add assets to respective containers
			addChild(background);
			addChild(border);
			addChild(titleBar);
			
			addChild(closeButton);
			addChild(minimizeButton);
			addChild(maximizeButton);
			addChild(colapseButton);
			addChild(titleText);
			addChild(dotsText);
			addChild(_content);
			addChild(contentMask);
			
			titleBar.addChild(titleBarBorder);
			titleBar.addChild(titleBarBackground);
			titleBar.addChild(titleBarBackgroundMask);
			titleBar.addChild(titleBarBorderMask);
			titleBar.addChild(dotsIcon);
			
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
			
			drawResizeGrabber();
			draw();
			
			// event handling
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			
			closeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			minimizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			maximizeButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			colapseButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
			titleBar.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			
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
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * 
		 * @param	event
		 */
		protected function mouseHandler(event:MouseEvent):void
		{
			
			activate();
			
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
					restore();
				}
			}
			
			
		} // end 
		
		
		/**
		 * Drag the Panel by holding the mouse down on the appropriate asset.
		 * 
		 * @param	event
		 */
		protected function startDragPanel(event:MouseEvent):void
		{
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
				//restore();
				//x = parent.mouseX - _width / 2;
				//y = parent.mouseY - _titleBarHeight / 2;
				
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
		} // end function stopDragPanel
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function startResizePanel(event:MouseEvent):void
		{
			
			var resizeGrabber:Sprite = event.currentTarget as Sprite;
			
			//mouseIsDown = true;
			
			//beginMouseX = resizeGrabber.x;
			//beginMouseY = resizeGrabber.y;
			mouseEventTarget = resizeGrabber;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
			
		} // end function startResizePanel
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function stopResizePanel(event:MouseEvent = null):void
		{
			var extra:int =  - padding + resizeGrabberThickness;
			
			mouseIsDown = false;
			
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
			
		} // end function stopResizePanel
		
		
		/**
		 * 
		 * @param	event
		 */
		protected function enterFrameHandler(event:Event):void
		{
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
			
			
			// buttons
			closeButton.x = registrationPoint.x + _width - closeButton.width - padding;
			closeButton.y = registrationPoint.y + padding;
			maximizeButton.x = closeButton.x - maximizeButton.width;
			maximizeButton.y = registrationPoint.y + padding;
			minimizeButton.x = maximizeButton.x - minimizeButton.width;
			minimizeButton.y = registrationPoint.y + padding;
			colapseButton.x = minimizeButton.x - colapseButton.width;
			colapseButton.y = registrationPoint.y + padding;
			
			// background
			background.width = _width - padding * 2;
			background.height = _height - padding * 2;
			background.x = registrationPoint.x + padding;
			background.y = registrationPoint.y + padding;
			
			// draw the border
			border.graphics.clear();
			border.graphics.beginFill(_borderColor, _borderTransparency);
			border.graphics.drawRect(0, 0, _width - (padding * 2) + (_borderThickness * 2), _height - (padding * 2) + (_borderThickness * 2)); // draw the rectangle
			border.graphics.drawRect(_borderThickness, _borderThickness, _width - (padding * 2), _height - (padding * 2)); // create a hole in the rectangle
			border.graphics.endFill();
			border.x = registrationPoint.x + padding - _borderThickness;
			border.y = registrationPoint.y + padding - _borderThickness;
			
			// titleBar
			titleBar.graphics.clear();
			titleBar.graphics.beginFill(_titleBarBackgroundColor, _titleBarBackgroundTransparency); // draw the titleBar background
			titleBar.graphics.drawRect(0, 0, _width - (padding * 2), _titleBarHeight);
			titleBar.graphics.beginFill(_titleBarBorderColor, _titleBarBorderTransparency);
			titleBar.graphics.drawRect(0, _titleBarHeight, _width - (padding * 2), _titleBarBorderThickness);
			titleBar.graphics.endFill();
			titleBar.x = registrationPoint.x + padding;
			titleBar.y = registrationPoint.y + padding;
			
			// titleText
			titleText.x = registrationPoint.x + padding + _titleBarHeight;
			titleText.y = registrationPoint.y + padding + 5;
			
			// 
			dotsIcon.x = titleBar.width / 2 - dotsIcon.width / 2;
			//dotsIcon.y = _titleBarHeight/2 - dotsIcon.height/2;
			
			if (_width - padding * 2 <= titleText.width + buttonsWidth)
			{
				dotsText.x = minimizeButton.x - dotsText.width;
				dotsText.y = titleText.y;
				dotsText.visible = true;
				titleText.autoSize = TextFieldAutoSize.NONE;
				titleText.width = _width - padding * 2 - buttonsWidth;
			}
			else
			{
				dotsText.visible = false;
				titleText.autoSize = TextFieldAutoSize.LEFT;
			}
			
			// 
			_content.x = registrationPoint.x + padding;
			_content.y = registrationPoint.y + padding + titleBar.height;
			
			// mask
			contentMask.x = registrationPoint.x + padding ;
			contentMask.y = registrationPoint.y + padding + titleBar.height;
			contentMask.width = _width - padding * 2; 
			contentMask.height = _height - titleBar.height - padding * 2;
			
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
		 * 
		 * @param	event
		 */
		private function timerResizeHandler(event:TimerEvent):void 
		{
			//Timer(event.target).removeEventListener(TimerEvent.TIMER, timerResizeHandler);
			
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
			
			draw();
		} // end function timerResizeHandler
		
		
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
					case titleBar:
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
			titleBar.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			titleBar.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			
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
		protected function draw():void
		{
			//registrationPoint.x = 0;
			//registrationPoint.y = 0;
			
			// check to see if the displayState of the panel is "normal".
			if (_displayState == "normal")
			{
				// make sure _width and _height are not greater the or less then the max width/min width and max height/min height
				_width = Math.min(_maxSize.x, _width);
				_width = Math.max(_minSize.x, _width);
				
				_height = Math.min(_maxSize.y, _height);
				_height = Math.max(_minSize.y, _height);
			}
			
			
			if (_windowShape == BNativeWindowShape.RECTANGULAR)
			{
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
				
				// buttons
				closeButton.x = _width - closeButton.width - padding;
				closeButton.y = padding;
				maximizeButton.x = closeButton.x - maximizeButton.width;
				maximizeButton.y = padding;
				minimizeButton.x = maximizeButton.x - minimizeButton.width;
				minimizeButton.y = padding;
				colapseButton.x = minimizeButton.x - colapseButton.width;
				colapseButton.y = padding;
				
				// draw background
				background.graphics.clear();
				background.graphics.beginFill(_backgroundColor, 1);
				background.graphics.drawRect(0, 0, 100, 100);
				background.graphics.endFill();
				background.alpha = _backgroundTransparency;
				background.width = _width - padding * 2;
				background.height = _height - padding * 2;
				background.x = padding;
				background.y = padding;
				
				// draw the border
				border.graphics.clear();
				border.graphics.beginFill(_borderColor, _borderTransparency);
				border.graphics.drawRect(0, 0, _width - (padding * 2) + (_borderThickness * 2), _height - (padding * 2) + (_borderThickness * 2)); // draw the rectangle
				border.graphics.drawRect(_borderThickness, _borderThickness, _width - (padding * 2), _height - (padding * 2)); // create a hole in the rectangle
				border.graphics.endFill();
				border.x = padding - _borderThickness;
				border.y = padding - _borderThickness;
				
				// draw the titleBar
				titleBar.graphics.clear();
				titleBar.graphics.beginFill(_titleBarBackgroundColor, _titleBarBackgroundTransparency); // draw the titleBar background
				titleBar.graphics.drawRect(0, 0, _width - (padding * 2), _titleBarHeight);
				titleBar.graphics.beginFill(_titleBarBorderColor, _titleBarBorderTransparency);
				titleBar.graphics.drawRect(0, _titleBarHeight, _width - (padding * 2), _titleBarBorderThickness);
				titleBar.graphics.endFill();
				titleBar.x = padding;
				titleBar.y = padding;
				
				// titleText
				titleText.x = padding + _titleBarHeight;
				titleText.y = padding + 5;
				
				// 
				dotsIcon.x = titleBar.width / 2 - dotsIcon.width / 2;
				//dotsIcon.y = _titleBarHeight / 2 - dotsIcon.height / 2;
				
				// 
				if (_width - padding * 2 <= titleText.width + buttonsWidth)
				{
					dotsText.x = minimizeButton.x - dotsText.width;
					dotsText.y = titleText.y;
					dotsText.visible = true;
					titleText.autoSize = TextFieldAutoSize.NONE;
					titleText.width = _width - padding * 2 - buttonsWidth;
				}
				else
				{
					dotsText.visible = false;
					titleText.autoSize = TextFieldAutoSize.LEFT;
				}
				
				// 
				_content.x = padding;
				_content.y = padding + titleBar.height;
				
				// mask
				contentMask.x = padding;
				contentMask.y = padding + titleBar.height;
				contentMask.width = _width - padding * 2; 
				contentMask.height = _height - titleBar.height - padding * 2;
				
			}
			else if (_windowShape == BNativeWindowShape.CIRCULAR)
			{
				// draw background
				background.graphics.clear();
				background.graphics.beginFill(_backgroundColor, 1);
				background.graphics.drawCircle(50, 50, 50);
				background.graphics.endFill();
				background.width = _width - padding * 2;
				background.height = background.width;
				background.x = padding;
				background.y = padding;
				background.alpha = _backgroundTransparency;
				
				// draw the border
				border.graphics.clear();
				border.graphics.beginFill(_borderColor, _borderTransparency);
				border.graphics.drawCircle(_width / 2 - padding + _borderThickness, _width / 2 - padding + _borderThickness, _width / 2 - padding + _borderThickness); // draw the circle
				border.graphics.drawCircle(_width / 2 - padding + _borderThickness, _width / 2 - padding + _borderThickness, _width / 2 - padding); // create a hole on the circle
				border.graphics.endFill();
				border.x = padding - _borderThickness;
				border.y = padding - _borderThickness;
				
				// draw the titleBar
				titleBar.graphics.clear();
				titleBarBorder.graphics.clear();
				titleBarBackground.graphics.clear();
				
				titleBarBorder.graphics.beginFill(_titleBarBorderColor, _titleBarBorderTransparency);
				titleBarBorder.graphics.drawCircle(_width / 2 - padding, _width / 2 - padding, _width / 2 - padding);
				titleBarBorder.graphics.endFill();
				
				titleBarBackground.graphics.beginFill(_titleBarBackgroundColor, _titleBarBackgroundTransparency);
				titleBarBackground.graphics.drawCircle(_width / 2 - padding, _width / 2 - padding, _width / 2 - padding);
				titleBarBackground.graphics.endFill();
				
				//titleBar.x = padding;
				//titleBar.y = padding;
				
				// titleBar masks
				titleBarBackgroundMask.graphics.beginFill(0xFF00FF, 1);
				titleBarBackgroundMask.graphics.drawRect(0, 0, 2000, 30);
				titleBarBackgroundMask.graphics.endFill();
				
				titleBarBorderMask.graphics.beginFill(0xFF00FF, 1);
				titleBarBorderMask.graphics.drawRect(0, 30, 2000, _titleBarBorderThickness);
				titleBarBorderMask.graphics.endFill();
				
				
				// need to redraw the content mask
				_content.y = padding + titleBar.height;
				contentMask.y = padding + titleBar.height;
				contentMask.width = _width - padding * 2; 
				contentMask.height = _height - titleBar.height - padding * 2;
			}
			
			
		} // end function draw
		
		
		/**
		 * 
		 */
		protected function drawResizeGrabber():void
		{
			var color:uint = 0x00FF00;
			var alpha:Number = 0.5;
			
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
			
			if (_windowShape == BNativeWindowShape.RECTANGULAR)
			{
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
				
			}
			else if (_windowShape == BNativeWindowShape.CIRCULAR)
			{
				var radius:Number = _width / 2 - padding;
				var segmentAngle:Number = Math.PI / 40;
				
				resizeGrabberTL.x = _width/2;
				resizeGrabberTR.x = _width/2;
				resizeGrabberBL.x = _width/2;
				resizeGrabberBR.x = _width/2;
				resizeGrabberTE.x = _width/2;
				resizeGrabberBE.x = _width/2;
				resizeGrabberLE.x = _width/2;
				resizeGrabberRE.x = _width/2;
				
				resizeGrabberTL.y = _width/2;
				resizeGrabberTR.y = _width/2;
				resizeGrabberBL.y = _width/2;
				resizeGrabberBR.y = _width/2;
				resizeGrabberTE.y = _width/2;
				resizeGrabberBE.y = _width/2;
				resizeGrabberLE.y = _width/2;
				resizeGrabberRE.y = _width/2;
				
				resizeGrabberTL.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberTR.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberBL.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberBR.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberTE.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberBE.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberLE.graphics.lineStyle(resizeGrabberThickness, color, 1);
				resizeGrabberRE.graphics.lineStyle(resizeGrabberThickness, color, 1);
				
				
				resizeGrabberTL.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberTR.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberBL.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberBR.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberTE.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberBE.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberLE.graphics.moveTo(_width/2 - padding, 0);
				resizeGrabberRE.graphics.moveTo(_width/2 - padding, 0);
				
				for (var i:int = 1; i <= 10; i++)
				{
					/* calculation:
					 * full circle = 2PI
					 * 8 grabbers
					 * 10 lines per grabber
					 * ... 2PI/ (8 * 10) = 2PI/80 = PI/40
					 */
					resizeGrabberTL.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberTR.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberBL.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberBR.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberTE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberBE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberLE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
					resizeGrabberRE.graphics.lineTo(Math.cos(i * segmentAngle) * radius, Math.sin(i * segmentAngle) * radius);
				}
				
			}
			
			
			
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
			parent.setChildIndex(this, (parent.numChildren - 1));
			
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
			if (_windowShape == BNativeWindowShape.CIRCULAR)
			{
				var tween4:Tween = new Tween(this, "x", Regular.easeOut, 0, width/4, 0.3, true);
				var tween5:Tween = new Tween(this, "y", Regular.easeOut, 0, width/4, 0.3, true);
			}
			
			var closeTimer:Timer = new Timer(300, 1);
			closeTimer.addEventListener(TimerEvent.TIMER, closeTimerHandler);
			closeTimer.start();
			
			this.dispatchEvent(new Event(Event.CLOSING, false, false));
			
		} // end function close
		
		
		/**
		 * 
		 */
		public function maximize():void
		{
			if (_maximizable)
			{
				_displayState = "maximized";
				
				padding = 0;
				
				tempX = x;
				tempY = y;
				tempWidth = _width;
				tempHeight = height;
				
				/*x = 0;
				y = 0;
				if (root)
				{
					_width = DisplayObjectContainer(root).stage.stageWidth;
					_height = DisplayObjectContainer(root).stage.stageHeight;
				}*/
				
				x = 0;
				y = 0;
				if (root)
				{
					resize(DisplayObjectContainer(root).stage.stageWidth, DisplayObjectContainer(root).stage.stageHeight);
				}
				
				maximizeButton.icon = windowIcon;
				draw();
				dispatchEvent(new Event(Event.RESIZE, false, false));
			}
			
		} // end function maximize
		
		
		/**
		 * 
		 */
		public function minimize():void
		{
			if (_minimizable)
			{
				_displayState = "maximized";
				
				padding = 0;
				
				tempX = x;
				tempY = y;
				tempWidth = _width;
				tempHeight = height;
				
				/*x = 0;
				y = 0;
				if (root)
				{
					_width = DisplayObjectContainer(root).stage.stageWidth;
					_height = DisplayObjectContainer(root).stage.stageHeight;
				}*/
				
				if (root)
				{
					x = 100;
					y = DisplayObjectContainer(root).stage.stageHeight - 40 - 100;
					
					var timer:Timer = new Timer(1000 / 60, 20);
					
					timer.addEventListener(TimerEvent.TIMER, timerResizeHandler);
					timer.start();
					resizeToWidth = 40;
					resizeToHeight = 40;
				}
				
				
				draw();
				dispatchEvent(new Event(Event.RESIZE, false, false));
			}
			
		} // end function minimize
		
		
		/**
		 * 
		 * @return
		 */
		/*public function orderInBackOf():Boolean
		{
			
		} // end */
		
		
		/**
		 * 
		 * @return
		 */
		/*public function orderInFrontOf():Boolean
		{
			
		} // end */
		
		
		/**
		 * 
		 * @return
		 */
		/*public function orderToBack():Boolean
		{
			
		} // end */
		
		
		/**
		 * 
		 * @return
		 */
		/*public function orderToFront():Boolean
		{
			
		} // end */
		
		
		/**
		 * 
		 */
		public function restore():void
		{
			_displayState = "normal";
			
			padding = 10;
			x = tempX;
			y = tempY;
			/*_width = tempWidth;
			_height = tempHeight;*/
			
			var timer:Timer = new Timer(1000 / 60, 20);
					
			timer.addEventListener(TimerEvent.TIMER, timerResizeHandler);
			timer.start();
			resizeToWidth = tempWidth;
			resizeToHeight = tempHeight;
			
			var iconTween:Tween = new Tween(colapseButton.icon, "rotation", Regular.easeOut, 0, 180, 0.3, true);
			
			
			maximizeButton.icon = maximizeIcon;
			draw();
			dispatchEvent(new Event(Event.RESIZE, false, false));
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
				tempHeight = height;
				
				resize(_width, (titleBarHight + padding * 2));
				var iconTween:Tween = new Tween(colapseButton.icon, "rotation", Regular.easeOut, 180, 0, 0.3, true);
				
				dispatchEvent(new Event(Event.RESIZE, false, false));
			}
			
		} // end 
			
		
		//**************************************** SET AND GET ******************************************
		
		
		// backgroundColor
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			draw();
		}
		
		
		// backgroundTransparency
		public function get backgroundTransparency():Number
		{
			return _backgroundTransparency;
		}
		
		public function set backgroundTransparency(value:Number):void
		{
			_backgroundTransparency = value;
			draw();
		}
		
		
		// borderColor
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			draw();
		}
		
		
		// borderTransparency
		public function get borderTransparency():Number
		{
			return _borderTransparency;
		}
		
		public function set borderTransparency(value:Number):void
		{
			_borderTransparency = value;
			draw();
		}
		
		
		// borderThickness
		public function get borderThickness():int
		{
			return _borderThickness;
		}
		
		public function set borderThickness(value:int):void
		{
			_borderThickness = value;
			draw();
		}
		
		
		// titleBarBackgroundColor
		public function get titleBarBackgroundColor():uint
		{
			return _titleBarBackgroundColor;
		}
		
		public function set titleBarBackgroundColor(value:uint):void
		{
			_titleBarBackgroundColor = value;
			draw();
		}
		
		
		// titleBarBackgroundTransparency
		public function get titleBarBackgroundTransparency():Number
		{
			return _titleBarBackgroundTransparency;
		}
		
		public function set titleBarBackgroundTransparency(value:Number):void
		{
			_titleBarBackgroundTransparency = value;
			draw();
		}
		
		
		// titleBarBorderColor
		public function get titleBarBorderColor():uint
		{
			return _titleBarBorderColor;
		}
		
		public function set titleBarBorderColor(value:uint):void
		{
			_titleBarBorderColor = value;
			draw();
		}
		
		
		// titleBarBorderColor
		public function get titleBarBorderTransparency():Number
		{
			return _titleBarBorderTransparency;
		}
		
		public function set titleBarBorderTransparency(value:Number):void
		{
			_titleBarBorderTransparency = value;
			draw();
		}
		
		
		// titleBarBorderThickness
		public function get titleBarBorderThickness():int
		{
			return _titleBarBorderThickness;
		}
		
		public function set titleBarBorderThickness(value:int):void
		{
			_titleBarBorderThickness = value;
			draw();
		}
		
		
		// titleTextColor
		public function set titleTextColor(value:uint):void
		{
			activatedTF.color = value;
			titleText.setTextFormat(activatedTF);
			dotsText.setTextFormat(activatedTF);
		}
		
		
		// 
		public function get titleTextColor():uint
		{
			return uint(activatedTF.color);
		}
		
		
		// 
		public function get  titleBarHight():Number
		{
			return titleBar.height;
		}
		
		
		// titleBarMode
		public function get titleBarMode():String
		{
			return _titleBarMode;
		}
		
		public function set titleBarMode(value:String):void
		{
			_titleBarMode = value;
			
			if (_titleBarMode != "none")
			{
				titleBar.scaleY = 1;
				titleBar.visible = true;
				closeButton.visible = true;
				maximizeButton.visible = true;
				minimizeButton.visible = true;
				colapseButton.visible = true;
				
				if (_titleBarMode != "minimal")
				{
					titleText.visible = true;
					dotsText.visible = true;
					
					closeButton.icon = xIcon;
					maximizeButton.icon = maximizeIcon;
					minimizeButton.icon = minimizeIcon;
					colapseButton.icon = arrowIcon;
					colapseButton.setIconBounds(15, 15, 10,10);
					
					dotsIcon.visible = false;
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
					titleText.visible = false;
					dotsText.visible = false;
					
					closeButton.icon = null;
					maximizeButton.icon = null;
					minimizeButton.icon = null;
					colapseButton.icon = null;
					
					dotsIcon.visible = true;
					dotsIcon.y = _titleBarHeight/2 - dotsIcon.height/2;
					break;
					
				case "none":
					titleBar.scaleY = 0; 		// scale is changed so the the height becomes 0 and makes the content position change when drawn
					titleBar.visible = false;
					
					titleText.visible = false;
					dotsText.visible = false;
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
			
			titleText.x = padding + _titleBarHeight;
			buttonsWidth = _titleBarHeight * 5 + dotsText.width; 
			
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
		// backgroundDrag
		public function get backgroundDrag():Boolean
		{
			return _backgroundDrag;
		}
		
		public function set backgroundDrag(value:Boolean):void
		{
			_backgroundDrag = value;
			if (value)
			{
				background.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
				background.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			}
			else
			{
				if (background.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					background.removeEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
				}
				if (background.hasEventListener(MouseEvent.MOUSE_UP))
				{
					background.removeEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
				}
			}
		}
		
		
		// shape
		public function get windowShape():String
		{
			return _windowShape
		}
		
		public function set windowShape(value:String):void
		{
			_windowShape = value;
			
			if (value == BNativeWindowShape.RECTANGULAR)
			{
				titleBarBorder.visible = false;
				titleBarBackground.visible = false;
				
				// redraw mask
				
				
				// redraw grabbers
				resizeGrabberTL.rotation = 0;
				resizeGrabberTR.rotation = 0;
				resizeGrabberBL.rotation = 0;
				resizeGrabberBR.rotation = 0;
				resizeGrabberTE.rotation = 0;
				resizeGrabberBE.rotation = 0;
				resizeGrabberLE.rotation = 0;
				resizeGrabberRE.rotation = 0;
			}
			else if (value == BNativeWindowShape.CIRCULAR)
			{
				titleBarBorder.visible = true;
				titleBarBackground.visible = true;
				
				// redraw mask
				
				
				// redraw grabbers
				resizeGrabberTL.rotation = -360/16 * 7;
				resizeGrabberTR.rotation = -360/16 * 3;
				resizeGrabberBL.rotation = 360/16 * 5;
				resizeGrabberBR.rotation = 360/16 * 1;
				resizeGrabberTE.rotation = -360/16 * 5;
				resizeGrabberBE.rotation = 360/16 * 3;
				resizeGrabberLE.rotation = 360/16 * 7;
				resizeGrabberRE.rotation = -360/16 * 1;
			}
			
			drawResizeGrabber();
			draw();
		}
		
		
		// content 
		public function get content():DisplayObjectContainer
		{
			return _content
		}
		
		
		/**
		 * 
		 */
		public function get title():String
		{
			return titleText.text;
		}
		
		public function set title(value:String):void
		{
			titleText.text = value;
		}
		
		
		
		
		// active
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
		
		
		
		// maxWidth
		
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
		
		
		// maxHeight
		
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
		
		
		// minWidth
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
		
		
		// minHeight
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
		 
		
		// maxSize
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
		
		
		// minSize
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
		
		
		
		
		
		// maximizable
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
		
		
		// minimizable
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
		
		
		// resizable
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
		
		
		// closable
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
		
		
		// draggable
		public function get draggable():Boolean
		{
			return _draggable
		}
		
		public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if(value)
			{
				titleBar.mouseEnabled = true;
			}
			else
			{
				titleBar.mouseEnabled = false;
			}
		}
		
		
		// colapsable
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
		
		
		/*// detachable
		public function set detachable(value:Boolean):void
		{
			_detachable = value;
			
			if(value)
			{
				windowBtn.visible = true;
			}
			else
			{
				windowBtn.visible = false;
			}
			
		}
		
		public function get detachable():Boolean
		{
			return _detachable;
		}
		*/
		
		
	}

}