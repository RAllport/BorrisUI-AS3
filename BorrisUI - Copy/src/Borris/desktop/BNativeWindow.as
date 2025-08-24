/* Author: Rohaan Allport
 * Date Created: 31/07/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BNativeWindow class provides an interface for creating and controlling native desktop windows.
 *
 * Todos: 
 * - create a title bar and title bar modes. the title bar is to change height and width depending on mode.
 * - create different window shapes. eg. rectangular, circular, polygonal. (in progress)
 * - add different closeButton styles.
 *
 *
 */


package Borris.desktop
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	import Borris.containers.BPanelBounds;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.desktop.*;
	import flash.geom.*;
	import flash.utils.Timer;
	import flash.ui.*;
	
	import Borris.display.*;
	import Borris.events.*;
	import Borris.controls.*;
	import Borris.menus.*;
	import Borris.ui.BMouseCursor;
	import Borris.controls.windowClasses.*;
	import Borris.assets.icons.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	
	
	public class BNativeWindow extends NativeWindow
	{
		// assets
		protected var container:Sprite;
		protected var _content:Sprite;
		protected var contentMask:Shape;
		
		protected var _titleBar:BTitleBar;
		protected var _drawElement:BElement;
		
		protected var closeButton:BLabelButton;
		protected var minimizeButton:BLabelButton;
		protected var maximizeButton:BLabelButton;
		//protected var contextMenu:BContextMenu;
		//protected var nativeMenu:BNativeMenu;
		public var panelBounds:BPanelBounds;
		
		
		// icons
		protected var xIcon:DisplayObject;
		protected var maximizeIcon:DisplayObject;
		protected var minimizeIcon:DisplayObject;
		protected var windowIcon:DisplayObject;
		
		
		// resize grabbers
		protected var resizeGrabberTL:Sprite;
		protected var resizeGrabberTR:Sprite;
		protected var resizeGrabberBL:Sprite;
		protected var resizeGrabberBR:Sprite;
		protected var resizeGrabberTE:Sprite;
		protected var resizeGrabberBE:Sprite;
		protected var resizeGrabberLE:Sprite;
		protected var resizeGrabberRE:Sprite;
		
		
		// other
		protected var thisWindow:NativeWindow;
		protected var padding:Number = 10;							// 
		private var borderMaxThickness:int = 10;					// 
		private var borderMinThickness:int = 1;						// 
		protected var activatedTF:TextFormat;						// 
		protected var deactivatedTF:TextFormat;						// 
		private var tempWidth:int;									// 
		private var tempHeight:int;									// 
		protected var buttonsWidth:int = 150;						// the width of the buttons and icons in the the titlebar. used for calucating the title text width
		protected var resizeGrabberThickness:int = 5;
		
		
		// set and get
		protected var _titleTextColor:uint = 0xFFFFFF;
		
		protected var _bMenu:BNativeMenu;							// 
		protected var _backgroundDrag:Boolean = false;				// 
		protected var _windowShape:String = "rectangular";			// 
		
		protected var _titleBarMode:String = "minimalText"; 		// The mode of the title bar. 4 modes in total. minimal (3 dots), compact (text or icon), full (text and icon)
		protected var _titleBarHeight:int; 							// [read-only] The height of th title bar after calculating the titleBar height and mode, etc
		
		
		public function BNativeWindow(initOptions:NativeWindowInitOptions = null, bounds:Rectangle = null) 
		{
			// constructor code
			
			if (!initOptions)
			{
				var newWindowInitOption:NativeWindowInitOptions;
				newWindowInitOption = new NativeWindowInitOptions();
				newWindowInitOption.maximizable = true;
				newWindowInitOption.minimizable = true;
				newWindowInitOption.renderMode = NativeWindowRenderMode.AUTO;
				newWindowInitOption.resizable = true;
				newWindowInitOption.systemChrome = NativeWindowSystemChrome.NONE;
				newWindowInitOption.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
				newWindowInitOption.type = NativeWindowType.NORMAL;
				initOptions =  newWindowInitOption;
			}
			
			// call the super() (NativeWinodw) contructor
			super(initOptions);
			thisWindow = this;
			
			initialize(bounds);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		protected function styleChangeHandler(event:BStyleEvent):void 
		{
			//draw();
		} // end function
		
		
		/**
		 * 
		 * @param event
		 */
		protected function closeWindow(event:MouseEvent):void
		{
			var tween:Tween = new Tween(container, "alpha", Regular.easeOut, 1, 0, 0.3, true);
			var tween2:Tween = new Tween(container, "scaleX", Regular.easeOut, 1, 0.5, 0.3, true);
			var tween3:Tween = new Tween(container, "scaleY", Regular.easeOut, 1, 0.5, 0.3, true);
			if (_windowShape == BNativeWindowShape.CIRCULAR)
			{
				var tween4:Tween = new Tween(container, "x", Regular.easeOut, 0, width/4, 0.3, true);
				var tween5:Tween = new Tween(container, "y", Regular.easeOut, 0, width/4, 0.3, true);
			}
			
			var closeTimer:Timer = new Timer(334);
			closeTimer.addEventListener(TimerEvent.TIMER, closeTimerHandler);
			closeTimer.start();
		} // end function closeWindow
		
		
		/**
		 * 
		 * @param event
		 */
		protected function minimizeWindow(event:MouseEvent):void
		{
			thisWindow.minimize();
		} // end function minimizeWindow
		
		
		/**
		 * 
		 * @param event
		 */
		protected function maximizeWindow(event:MouseEvent = null):void
		{
			if(thisWindow.displayState == NativeWindowDisplayState.NORMAL)
			{
				padding = 8;
				thisWindow.maximize();
				maximizeButton.icon = windowIcon;
			}
			else if(thisWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
			{
				padding = 10;
				thisWindow.restore();
				maximizeButton.icon = maximizeIcon;
			}
			draw();
			//resizeAlign();
			
		} // end function maximizeWindow
		
		
		/**
		 * 
		 * @param event
		 */
		protected function moveWindow(event:MouseEvent):void
		{
			thisWindow.startMove();
			// for when maximized
			/*if (thisWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
			{
				titleBar.addEventListener(MouseEvent.MOUSE_MOVE, moveWindow);
				
				if (titleBar.hasEventListener(MouseEvent.MOUSE_MOVE))
				{
					titleBar.removeEventListener(MouseEvent.MOUSE_MOVE, moveWindow);
					thisWindow.restore();
					thisWindow.m
					maximizeButton.icon = maximizeIcon;
					//thisWindow.x = stage.mouseX;
					//thisWindow.y = stage.mouseY;
					//thisWindow.startMove();
					moveWindow(event);
				}
			}*/
			
		} // end function moveWindow
		
		
		/**
		 * 
		 * @param event
		 */
		protected function resizeWindow(event:MouseEvent):void
		{
			if(event.target == resizeGrabberTL)
			{
				thisWindow.startResize(NativeWindowResize.TOP_LEFT);
			}
			if(event.target == resizeGrabberTR)
			{
				thisWindow.startResize(NativeWindowResize.TOP_RIGHT);
			}
			if(event.target == resizeGrabberBL)
			{
				thisWindow.startResize(NativeWindowResize.BOTTOM_LEFT);
			}
			if(event.target == resizeGrabberBR)
			{
				thisWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
			}
			
			if(event.target == resizeGrabberTE)
			{
				thisWindow.startResize(NativeWindowResize.TOP);
			}
			if(event.target == resizeGrabberBE)
			{
				thisWindow.startResize(NativeWindowResize.BOTTOM);
			}
			if(event.target == resizeGrabberLE)
			{
				thisWindow.startResize(NativeWindowResize.LEFT);
			}
			if(event.target == resizeGrabberRE)
			{
				thisWindow.startResize(NativeWindowResize.RIGHT);
			}
			
		} // end resizeWindow
		
		
		/**
		 * 
		 * @param event
		 */
		protected function resizeAlign(event:Event = null):void
		{
			//trace("window closed: " + thisWindow.closed);
			//trace("Window title: " + thisWindow.title);
			var borderAndPaddingWidth:int = padding + int(_drawElement.style.borderWidth);
			
			closeButton.x = thisWindow.width - closeButton.width - borderAndPaddingWidth;
			closeButton.y = borderAndPaddingWidth;
			maximizeButton.x = closeButton.x - maximizeButton.width;
			maximizeButton.y = borderAndPaddingWidth;
			minimizeButton.x = maximizeButton.x - minimizeButton.width;
			minimizeButton.y = borderAndPaddingWidth;
			
			
			_drawElement.width = thisWindow.width - padding * 2;
			_drawElement.height = thisWindow.height - padding * 2;
			//_drawElement.x = 0;
			//_drawElement.y = 0;
			
			_titleBar.width = thisWindow.width - borderAndPaddingWidth * 2;
			_titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;
			_titleBar.x = borderAndPaddingWidth;
			_titleBar.y = borderAndPaddingWidth;
			
			
			contentMask.width = thisWindow.width - borderAndPaddingWidth * 2;
			contentMask.height = thisWindow.height - _titleBar.height - borderAndPaddingWidth * 2;
			
			drawResizeGrabber();
			
			// 
			panelBounds.width = contentMask.width;
			panelBounds.height = contentMask.height;
			
		} // end function resizeAlign
		
		
		/**
		 * 
		 * @param event
		 */
		private function closeTimerHandler(event:TimerEvent):void
		{
			Timer(event.target).stop();
			event.target.removeEventListener(TimerEvent.TIMER, closeTimerHandler);
			thisWindow.close();
			
		} // end function closeTimerHandler
		
		 
		/**
		 * Change the cursor based on the event type, and event target.
		 * 
		 * @param event
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
		
		
		/**
		 * 
		 * @param	event
		 */
		private function timerResizeHandler(event:TimerEvent):void 
		{
			//Timer(event.target).removeEventListener(TimerEvent.TIMER, timerResizeHandler);
			
			if (Math.abs(tempWidth - thisWindow.width) <= 1)
			{
				thisWindow.width = tempWidth;
			}
			else
			{
				thisWindow.width += (tempWidth - thisWindow.width) * 0.3;
			}
			
			if (Math.abs(tempHeight - thisWindow.height) <= 1)
			{
				thisWindow.height = tempHeight;
			}
			else
			{
				thisWindow.height += (tempHeight - thisWindow.height) * 0.3;
			}
			
			resizeAlign();
		} // end function timerResizeHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function draw(event:Event = null):void
		{
			trace("BNativeWindow | draw()");
			var borderAndPaddingWidth:int = padding + int(_drawElement.style.borderWidth);
			
			_drawElement.width = thisWindow.width - padding * 2;
			_drawElement.height = thisWindow.height - padding * 2;
			_drawElement.x = padding;
			_drawElement.y = padding;
			
			// draw the titleBar
			_titleBar.width = thisWindow.width - borderAndPaddingWidth * 2;
			_titleBar.height = _titleBarHeight + _titleBar.style.borderBottomWidth;
			titleBar.x = borderAndPaddingWidth;
			titleBar.y = borderAndPaddingWidth;
			
			// 
			_content.x = borderAndPaddingWidth;
			_content.y = _titleBar.height + borderAndPaddingWidth;
			
			// 
			contentMask.x = borderAndPaddingWidth;
			contentMask.y = _titleBar.height + borderAndPaddingWidth;
			contentMask.width = thisWindow.width - borderAndPaddingWidth * 2; 
			contentMask.height = thisWindow.height - _titleBar.height - borderAndPaddingWidth * 2;
			
			// 
			panelBounds.width = contentMask.width;
			panelBounds.height = contentMask.height;
			
		} // end function draw
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * 
		 */
		protected function initialize(bounds:Rectangle = null):void
		{
			// set the scale mode to 'no scale' so that the application does not change scale when resizing
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left
			
			
			// set some essentail NativeWindow properties
			thisWindow.bounds = bounds ? bounds : new Rectangle(0, 0, 800, 600);
			thisWindow.maxSize = new Point(NativeWindow.systemMaxSize.x, NativeWindow.systemMaxSize.y);
			//this.minSize = new Point(300, 300); 
			
			
			// create and add assets
			container = new Sprite();
			thisWindow.stage.addChild(container);
			
			
			// drawing element for styling
			_drawElement = new BElement();
			_drawElement.style.backgroundColor = 0x000000;
			_drawElement.style.backgroundOpacity = 1;
			_drawElement.style.borderColor = 0x00CCFF;
			_drawElement.style.borderOpacity = 0.8;
			_drawElement.style.borderWidth = 2;
			_drawElement.x = padding;
			_drawElement.y = padding;
			container.addChild(_drawElement);
			
			
			// titleBar
			_titleBar = new BTitleBar(container, padding, padding, super.title);
			_titleBar.width = thisWindow.width - int(_drawElement.style.borderWidth) * 2 - padding * 2;
			_titleBar.height = 30;
			_titleBar.focusEnabled = false;
			
			
			// resize grabbers
			resizeGrabberTL = new Sprite();
			resizeGrabberTR = new Sprite();
			resizeGrabberBL = new Sprite();
			resizeGrabberBR = new Sprite();
			resizeGrabberTE = new Sprite();
			resizeGrabberBE = new Sprite();
			resizeGrabberLE = new Sprite();
			resizeGrabberRE = new Sprite();
			
			container.addChild(resizeGrabberTL);
			container.addChild(resizeGrabberTR);
			container.addChild(resizeGrabberBL);
			container.addChild(resizeGrabberBR);
			container.addChild(resizeGrabberTE);
			container.addChild(resizeGrabberBE);
			container.addChild(resizeGrabberLE);
			container.addChild(resizeGrabberRE);
			
			
			// initialize window buttons
			closeButton = new BLabelButton();
			minimizeButton = new BLabelButton();
			maximizeButton = new BLabelButton();
			
			closeButton.setStateColors(0x00000000, 0xCC0000, 0xFF6666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC); 
			minimizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC); 
			maximizeButton.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x0099CC, 0x00CCFF, 0x006699, 0x0099CC);
			
			closeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);
			minimizeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);
			maximizeButton.setStateAlphas(0, 1, 1, 1, 0, 0, 0, 0);
			
			
			// icons
			xIcon = new XIcon10x10();
			minimizeIcon = new MinimizeIcon10x10();
			maximizeIcon = new MaximizeIcon10x10();
			windowIcon = new WindowIcon10x10();
			
			closeButton.icon = xIcon;
			minimizeButton.icon = minimizeIcon;
			maximizeButton.icon = maximizeIcon;
			
			
			// title text
			activatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
			deactivatedTF = new TextFormat("Calibri", 16, _titleTextColor, false);
			
			
			// content
			_content = new Sprite();
			_content.x = padding;
			_content.y = padding + _titleBar.height;
			
			contentMask = new Shape();
			contentMask.graphics.beginFill(0XFF00FF, 1);
			contentMask.graphics.drawRect(0, 0, 100, 100);
			contentMask.graphics.endFill();
			contentMask.x = padding;
			contentMask.y = padding + _titleBar.height;
			container.addChild(contentMask);
			_content.mask = contentMask;
			
			
			// add assets to container
			container.addChild(closeButton);
			//container.addChild(minimizeButton);
			//container.addChild(maximizeButton);
			container.addChild(_content);
			
			if (thisWindow.maximizable)
			{
				container.addChild(maximizeButton);
			}
			if (minimizable)
			{
				container.addChild(minimizeButton);
			}
			
			// testing
			panelBounds = new BPanelBounds(_content);
			
			// 
			titleBarMode = BTitleBarMode.COMPACT_TEXT;
			drawResizeGrabber();
			draw();
			resizeAlign();
			
			
			// event handling
			closeButton.addEventListener(MouseEvent.CLICK, closeWindow);
			minimizeButton.addEventListener(MouseEvent.CLICK, minimizeWindow);
			maximizeButton.addEventListener(MouseEvent.CLICK, maximizeWindow);
			
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			
			if (thisWindow.resizable)
			{
				resizeGrabberTL.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberTR.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberBL.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberBR.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberTE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberBE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberLE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				resizeGrabberRE.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				thisWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
				thisWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);
				
				//thisWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, draw);
				//thisWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, draw);
			}
			
			initializeCursorEvent();
			
			// woot the fucks?
			_drawElement.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
			_titleBar.style.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
			
		} // end function initialize
		
		
		/**
		 * 
		 */
		protected function drawResizeGrabber():void
		{
			var color:uint = 0x000000;
			var alpha:Number = 0.01;
			//var alpha:Number = 0.5;
			
			resizeGrabberTL.scaleX = 1
			resizeGrabberTR.scaleX = 1
			resizeGrabberBL.scaleX = 1
			resizeGrabberBR.scaleX = 1
			resizeGrabberTE.scaleX = 1
			resizeGrabberBE.scaleX = 1
			resizeGrabberLE.scaleX = 1
			resizeGrabberRE.scaleX = 1
			
			resizeGrabberTL.scaleY = 1
			resizeGrabberTR.scaleY = 1
			resizeGrabberBL.scaleY = 1
			resizeGrabberBR.scaleY = 1
			resizeGrabberTE.scaleY = 1
			resizeGrabberBE.scaleY = 1
			resizeGrabberLE.scaleY = 1
			resizeGrabberRE.scaleY = 1
			
			
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
				var grabbersWidth:int = thisWindow.width - padding * 2;
				var grabbersHeight:int = thisWindow.height - padding * 2;
				
				resizeGrabberTL.graphics.beginFill(color, alpha);
				resizeGrabberTR.graphics.beginFill(color, alpha);
				resizeGrabberBL.graphics.beginFill(color, alpha);
				resizeGrabberBR.graphics.beginFill(color, alpha);
				resizeGrabberTE.graphics.beginFill(color, alpha);
				resizeGrabberBE.graphics.beginFill(color, alpha);
				resizeGrabberLE.graphics.beginFill(color, alpha);
				resizeGrabberRE.graphics.beginFill(color, alpha);
				
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
				resizeGrabberTR.x = thisWindow.width - padding;
				resizeGrabberTR.y = padding - resizeGrabberThickness;
				resizeGrabberBL.x = padding - resizeGrabberThickness;
				resizeGrabberBL.y = thisWindow.height - padding;
				resizeGrabberBR.x = thisWindow.width - padding;
				resizeGrabberBR.y = thisWindow.height - padding;
				
				resizeGrabberTE.x = padding;
				resizeGrabberTE.y = padding - resizeGrabberThickness;
				resizeGrabberBE.x = padding;
				resizeGrabberBE.y = thisWindow.height - padding;
				resizeGrabberLE.x = padding - resizeGrabberThickness;
				resizeGrabberLE.y = padding;
				resizeGrabberRE.x = thisWindow.width - padding;
				resizeGrabberRE.y = padding;
				
			}
			else if (_windowShape == BNativeWindowShape.CIRCULAR)
			{
				var radius:Number = thisWindow.width / 2 - padding;
				var segmentAngle:Number = Math.PI / 40;
				
				resizeGrabberTL.x = thisWindow.width/2;
				resizeGrabberTR.x = thisWindow.width/2;
				resizeGrabberBL.x = thisWindow.width/2;
				resizeGrabberBR.x = thisWindow.width/2;
				resizeGrabberTE.x = thisWindow.width/2;
				resizeGrabberBE.x = thisWindow.width/2;
				resizeGrabberLE.x = thisWindow.width/2;
				resizeGrabberRE.x = thisWindow.width/2;
				
				resizeGrabberTL.y = thisWindow.width/2;
				resizeGrabberTR.y = thisWindow.width/2;
				resizeGrabberBL.y = thisWindow.width/2;
				resizeGrabberBR.y = thisWindow.width/2;
				resizeGrabberTE.y = thisWindow.width/2;
				resizeGrabberBE.y = thisWindow.width/2;
				resizeGrabberLE.y = thisWindow.width/2;
				resizeGrabberRE.y = thisWindow.width/2;
				
				resizeGrabberTL.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberTR.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberBL.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberBR.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberTE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberBE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberLE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				resizeGrabberRE.graphics.lineStyle(resizeGrabberThickness, color, alpha);
				
				
				resizeGrabberTL.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberTR.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberBL.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberBR.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberTE.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberBE.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberLE.graphics.moveTo(thisWindow.width/2 - padding, 0);
				resizeGrabberRE.graphics.moveTo(thisWindow.width/2 - padding, 0);
				
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
		 * 
		 */
		protected function initializeCursorEvent():void
		{
			_titleBar.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			_titleBar.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			
			if (resizable)
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
		 * 
		 * @param _width
		 * @param _height
		 * @param animate
		 */
		public function resize(_width:int, _height:int, animate:Boolean = true):void
		{
			// check to see if window is open
			if (!thisWindow.closed)
			{
				if (animate)
				{
					
					var timer:Timer = new Timer(1000 / 60, 20);
					
					timer.addEventListener(TimerEvent.TIMER, timerResizeHandler);
					timer.start();
					tempWidth = _width;
					tempHeight = _height;
				}
				else
				{
					//super.width = _width;
					//super.height = _height;
					thisWindow.width = _width;
					thisWindow.height = _height;
					resizeAlign();
				}
			}
		} // end function resize
		
		
		
		// ************************************************* SET AND GET **************************************************
		
		
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
			
		}
		
		
		/**
		 * 
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
				
				if (_titleBarMode != "minimal")
				{
					
					closeButton.icon = xIcon;
					maximizeButton.icon = maximizeIcon;
					minimizeButton.icon = minimizeIcon;
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
					
				case "full":
					_titleBarHeight = 48;
					break;
					
				case "minimal":
					_titleBarHeight = 10;
					
					closeButton.icon = null;
					maximizeButton.icon = null;
					minimizeButton.icon = null;
					break;
					
				case "none":
					_titleBar.scaleY = 0; 		// scale is changed so the the height becomes 0 and makes the content position change when drawn
					_titleBar.visible = false;
					
					closeButton.visible = false;
					maximizeButton.visible = false;
					minimizeButton.visible = false;
					break;
					
			} // end switch
			
			
			closeButton.setSize(_titleBarHeight, _titleBarHeight);
			maximizeButton.setSize(_titleBarHeight, _titleBarHeight);
			minimizeButton.setSize(_titleBarHeight, _titleBarHeight);
			
			
			draw();
		} 
	
		
		/**
		 * 
		 */
		public function get bMenu():BNativeMenu
		{
			return _bMenu;
		}
		
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
				_drawElement.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			}
			else
			{
				if (_drawElement.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					_drawElement.removeEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
				}
			}
		}
		
		
		/**
		 * 
		 */
		public function get windowShape():String
		{
			return _windowShape
		}
		
		public function set windowShape(value:String):void
		{
			_windowShape = value;
			
			if (value == BNativeWindowShape.RECTANGULAR)
			{
				
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
			resizeAlign();
		}
		
		
		/**
		 * 
		 */
		public function get content():DisplayObjectContainer
		{
			return _content
		}
		
		
		
		/******************************* native windows overrides *************************************/
		
		
		override public function set menu(value:NativeMenu):void
		{
			trace("You may want to use the Borris.display.BNativeMenu class instead of the flash.display.NativeMenu class.");
			super.menu = value;
		}
	
		override public function set title(value:String):void
		{
			super.title = value;
			_titleBar.title = value;
			draw();
		}
		
		override public function get title():String
		{
			return _titleBar.title;
		}
		
		
		
		/**
		 * Gets or sets the style for this component.
		 */
		public function get style():BStyle
		{
			return _drawElement.style;
		}
		
		public function set style(value:BStyle):void
		{
			_drawElement.style = value;
			_drawElement.style.owner = container;
			_drawElement.style.values = value.values;
			//dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE, this));
		}
		
		
		
	}

}