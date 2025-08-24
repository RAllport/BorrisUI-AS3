/* Author: Rohaan Allport
 * Date Created: 06/09/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 Decription: A Custom Sprite that has functions to help with common appliction UI and makes it act like an application window.
 * 				It can be dragged, closed, resized.
 * 				It can support Tabs, switch tabs, and change the position of tabs (done though the BTabManager Object)
 * 
 * 
*/


package Borris.panels
{
	import flash.display.*;
	import flash.desktop.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	
	import Borris.controls.*;
	import Borris.ui.BMouseCursor;
	import Borris.assets.icons.*;
	
	
	public class BPanelAttached extends BBasePanelAttached
	{
		// constants
		internal static const SIZE_OFFSET:uint = 0;				// Used for offsetting the assets in window mode (when it is a NativeWindow)
		internal static const TOP_BORDER_HEIGHT:uint = 18;		// The height of the top border. (sometimes it might be different than the other borders.)
		internal static const BORDER_WIDTH:uint = 4;			// the width of the borders. recommended use for the mask, soo that content doesn't show over the borders.
																// and in the tab manager to position the tabs.
		
		internal static const TAB_AREA_TOP_MARGIN:uint = 18;		// the margin from the top of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_BOTTOM_MARGIN:uint = 3;	// the margin from the bottom of the panel, to where the tabs should be placed
		internal static const TAB_AREA_LEFT_MARGIN:uint = 5;		// the margin from the left of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_RIGHT_MARGIN:uint = 3;		// the margin from the right of the panel, to where the tabs should be placed
		internal static const TAB_AREA_HEIGHT:uint = 25;			// The height of the place where the tabs are.
		
		internal static const CONTENT_MARGIN:uint = 1; 				// The margin of the content within the borders
		
		internal static const TOP_BORDER_MARGIN:uint = 0;			// The margin of the top border fromt the top of the panel
		internal static const BOTTOM_BORDER_MARGIN:uint = 0;		// 
		internal static const LEFT_BORDER_MARGIN:uint = 0;			// 
		internal static const RIGHT_BORDER_MARGIN:uint = 0;			// 
		
		
		// asset variables
		
		// resize grabbers
		
		
		// tab variables
		protected var _tabManager:BATabManager; 				// [read-only] reference to this panel's tab manager
		
		// display variables?
		
		// resizing and mouse variables
		
		// set and get protected variables
		
		
		public function BPanelAttached() 
		{
			// constructor code
			
			// asset variables
			background = new Sprite();
			border = new Sprite();
			dragger = new Sprite();
			closeBtn = new BButton();
			windowBtn = new BButton();
			
			
			
			// initialize window buttons
			
			closeBtn.setStateColors(0x00000000, 0xcc0000, 0xFF6666, 0x000000, 0x0099cc, 0x00ccff, 0x006699, 0x0099cc); 
			windowBtn.setStateColors(0x000000, 0x999999, 0x666666, 0x000000, 0x0099cc, 0x00ccff, 0x006699, 0x0099cc);
			
			closeBtn.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			windowBtn.setStateAlphas(1, 1, 1, 1, 1, 1, 1, 1);
			
			closeBtn.setSize(14, 14);
			windowBtn.setSize(14, 14);
			
			closeBtn.icon = new XIcon10x10();
			windowBtn.icon =  new WindowIcon10x10();
			
			/*
			 * The gray boomy theme
			closeBtn.setSkins(closeBtn.getSkin("upSkin"), closeBtn.getSkin("overSkin"), closeBtn.getSkin("downSkin"));
			windowBtn.setSkins(windowBtn.getSkin("upSkin"), windowBtn.getSkin("overSkin"), windowBtn.getSkin("downSkin"));
			
			var xIcon:Sprite = new Sprite();
			xIcon.graphics.clear();
			xIcon.graphics.lineStyle(1, 0x000000, 1, false, "normal", "square", "bevel"); 
			xIcon.graphics.moveTo(0, 0);
			xIcon.graphics.lineTo(8, 8);
			xIcon.graphics.moveTo(8, 0);
			xIcon.graphics.lineTo(0, 8);
			
			var windowIcon:Sprite = new Sprite();
			windowIcon.graphics.clear();
			windowIcon.graphics.lineStyle(1, 0x000000, 1, false, "normal", "square", "bevel"); 
			windowIcon.graphics.drawRect(0, 2, 5, 5);
			windowIcon.graphics.drawRect(2, 0, 5, 5);
			
			closeBtn.icon = xIcon;
			windowBtn.icon = windowIcon;
			*/
			
			// mask
			mk = new Shape();
			mk.graphics.beginFill(0xff0055, 0.2);
			mk.graphics.drawRect(0, 0, 50, 50);
			mk.graphics.endFill();
			mk.width = this.panelWidth - (BORDER_WIDTH * 2 + 2);
			mk.height = this.panelHeight - (TOP_BORDER_HEIGHT + BORDER_WIDTH);
			
			
			this.addChild(background);
			this.addChild(dragger);
			this.addChild(border);
			this.addChild(closeBtn);
			this.addChild(windowBtn);
			this.addChild(mk);
			
			// tabs and tab manager
			_tabManager = new BATabManager(this);
			_tabManager.mask = mk;
			
			// initialize resize grabbers
			initializeResizeGrabbers();
			
			initializeCursorEvent();
			initializeEventHandlers();
			
			
			// draw the panel
			_borderColor = 0x222222;// 0x333333;
			_borderTransparency = 1;
			_borderThickness = 3;
			
			_backgroundColor = 0x000000;// 0x454545;
			_backgroundTransparency = 1;
			
			_draggerColor = 0x000000;// 0x292929;
			_draggertransparency = 1;
			
			_gradientColor = 0xCCCCCC;// 0x000000;
			_gradientOuterTransparency = 0.6;
			_gradientInnerTransparency = 0//0.4;
			
			_shineColor = 0xFFFFFF;
			_shineTransparency = 0;//0.4;
			
			draw();
			
		}
		
		
		// function initializeResizeGrabbers
		// Initialize some invisble object to act as resize grabbers. Unlike an actual Window, the method used for 
		// resizing requires that the edges and the grabbers be sepparate.
		override protected function initializeResizeGrabbers():void
		{
			super.initializeResizeGrabbers();
			
		} // end function initializeResizeGrabbers
		
		
		// function initializeEventHandlers
		// 
		override protected function initializeEventHandlers():void
		{
			super.initializeEventHandlers();
			
			border.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
			border.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			
		} // end function initializeEventHandlers
		
		
		// function draw
		// In progress
		override protected function draw():void
		{
			registrationPoint.x = 0;
			registrationPoint.y = 0;
			
			// resize grabbers
			resizeGrabberTL.x = 0;
			resizeGrabberTL.y = 0;
			resizeGrabberTR.x = _panelWidth - RESIZE_GRABBER_THICKNESS;
			resizeGrabberTR.y = 0;
			resizeGrabberBL.x = 0;
			resizeGrabberBL.y = _panelHeight - RESIZE_GRABBER_THICKNESS;
			resizeGrabberBR.x = _panelWidth - RESIZE_GRABBER_THICKNESS;
			resizeGrabberBR.y = _panelHeight - RESIZE_GRABBER_THICKNESS;
			
			resizeGrabberTE.x = resizeGrabberTL.x + resizeGrabberTL.width;
			resizeGrabberTE.y = 0;
			resizeGrabberBE.x = resizeGrabberBL.x + resizeGrabberBL.width;
			resizeGrabberBE.y = _panelHeight - RESIZE_GRABBER_THICKNESS;
			resizeGrabberLE.x = 0;
			resizeGrabberLE.y = resizeGrabberTL.y + resizeGrabberTL.height;
			resizeGrabberRE.x = _panelWidth - RESIZE_GRABBER_THICKNESS;
			resizeGrabberRE.y = resizeGrabberTR.y + resizeGrabberTR.height;
			
			resizeGrabberTE.width = _panelWidth - (RESIZE_GRABBER_THICKNESS * 2);
			resizeGrabberBE.width = _panelWidth - (RESIZE_GRABBER_THICKNESS * 2);
			resizeGrabberLE.height = _panelHeight - (RESIZE_GRABBER_THICKNESS * 2);
			resizeGrabberRE.height = _panelHeight - (RESIZE_GRABBER_THICKNESS * 2);
			
			
			// dragger
			dragger.graphics.clear();
			// grey boomy theme
			dragger.graphics.beginFill(_draggerColor, _draggertransparency);
			/*dragger.graphics.drawRect(0, 0, 100, 24);
			dragger.graphics.beginFill(0xFFFFFF, 0.4);
			dragger.graphics.drawRect(0, 24, 100, 1);
			dragger.graphics.endFill();*/
			dragger.graphics.drawRect(0, 0, 100, 24);
			dragger.graphics.beginFill(0x999999, 1);
			dragger.graphics.drawRect(0, 24, 100, 1);
			dragger.graphics.endFill();
			
			dragger.width = _panelWidth - (BORDER_WIDTH * 2);
			dragger.x = registrationPoint.x + BORDER_WIDTH;
			dragger.y = registrationPoint.y + TOP_BORDER_HEIGHT;
			
			
			// background
			background.graphics.clear();
			background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
			background.graphics.drawRect(0, 0, 100, 100);
			background.graphics.endFill();
			
			background.x = registrationPoint.x;
			background.y = registrationPoint.y + TOP_BORDER_HEIGHT;
			background.width = _panelWidth;
			background.height = _panelHeight - TOP_BORDER_HEIGHT - BORDER_WIDTH - TOP_BORDER_MARGIN;
			
			
			// border
			border.x = registrationPoint.x;
			border.y = registrationPoint.y;
			
			border.graphics.clear();
			
			border.graphics.beginFill(_borderColor, _borderTransparency);
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			
			border.graphics.beginFill(_gradientColor, _gradientOuterTransparency); // outer grad
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - 2);
			
			border.graphics.beginFill(_gradientColor, _gradientInnerTransparency);
			border.graphics.drawRect(2, 2, _panelWidth - 4, _panelHeight - 4);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			
			border.graphics.beginFill(_gradientColor, _gradientInnerTransparency);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			border.graphics.drawRect(4, 4, _panelWidth - 8, _panelHeight - 8);
			
			// top border
			border.graphics.beginFill(_borderColor, _borderTransparency);
			border.graphics.drawRect(1, 1, _panelWidth - 2, TOP_BORDER_HEIGHT - 1);
			
			border.graphics.beginFill(_gradientColor, _gradientOuterTransparency); // outer grad
			border.graphics.drawRect(2, TOP_BORDER_HEIGHT - 1, _panelWidth - 4, 1);
			
			border.graphics.beginFill(_shineColor, _shineTransparency); // shine
			border.graphics.drawRect(2, 1, _panelWidth - 4, 1);
			
			border.graphics.endFill();
			
			
			// close and window button
			closeBtn.x = registrationPoint.x + _panelWidth - closeBtn.width - BORDER_WIDTH;
			closeBtn.y = 2;
			
			// draw close button
			/*Sprite(closeBtn.getSkin("upSkin")).graphics.clear();
			Sprite(closeBtn.getSkin("upSkin")).graphics.beginFill(0x222222, 1);
			Sprite(closeBtn.getSkin("upSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(closeBtn.getSkin("upSkin")).graphics.beginFill(0x666666, 1);
			Sprite(closeBtn.getSkin("upSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(closeBtn.getSkin("upSkin")).graphics.beginFill(0x444444, 1);
			Sprite(closeBtn.getSkin("upSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(closeBtn.getSkin("upSkin")).graphics.endFill();
			
			Sprite(closeBtn.getSkin("overSkin")).graphics.clear();
			Sprite(closeBtn.getSkin("overSkin")).graphics.beginFill(0x222222, 1);
			Sprite(closeBtn.getSkin("overSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(closeBtn.getSkin("overSkin")).graphics.beginFill(0x777777, 1);
			Sprite(closeBtn.getSkin("overSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(closeBtn.getSkin("overSkin")).graphics.beginFill(0x555555, 1);
			Sprite(closeBtn.getSkin("overSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(closeBtn.getSkin("overSkin")).graphics.endFill();
			
			Sprite(closeBtn.getSkin("downSkin")).graphics.clear();
			Sprite(closeBtn.getSkin("downSkin")).graphics.beginFill(0x222222, 1);
			Sprite(closeBtn.getSkin("downSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(closeBtn.getSkin("downSkin")).graphics.beginFill(0x333333, 1);
			Sprite(closeBtn.getSkin("downSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(closeBtn.getSkin("downSkin")).graphics.beginFill(0x444444, 1);
			Sprite(closeBtn.getSkin("downSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(closeBtn.getSkin("downSkin")).graphics.endFill();
			
			
			// draw window button
			Sprite(windowBtn.getSkin("upSkin")).graphics.clear();
			Sprite(windowBtn.getSkin("upSkin")).graphics.beginFill(0x222222, 1);
			Sprite(windowBtn.getSkin("upSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(windowBtn.getSkin("upSkin")).graphics.beginFill(0x666666, 1);
			Sprite(windowBtn.getSkin("upSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(windowBtn.getSkin("upSkin")).graphics.beginFill(0x444444, 1);
			Sprite(windowBtn.getSkin("upSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(windowBtn.getSkin("upSkin")).graphics.endFill();
			
			Sprite(windowBtn.getSkin("overSkin")).graphics.clear();
			Sprite(windowBtn.getSkin("overSkin")).graphics.beginFill(0x222222, 1);
			Sprite(windowBtn.getSkin("overSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(windowBtn.getSkin("overSkin")).graphics.beginFill(0x777777, 1);
			Sprite(windowBtn.getSkin("overSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(windowBtn.getSkin("overSkin")).graphics.beginFill(0x555555, 1);
			Sprite(windowBtn.getSkin("overSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(windowBtn.getSkin("overSkin")).graphics.endFill();
			
			Sprite(windowBtn.getSkin("downSkin")).graphics.clear();
			Sprite(windowBtn.getSkin("downSkin")).graphics.beginFill(0x222222, 1);
			Sprite(windowBtn.getSkin("downSkin")).graphics.drawRoundRect(0, 0, 14, 14, 4);
			Sprite(windowBtn.getSkin("downSkin")).graphics.beginFill(0x333333, 1);
			Sprite(windowBtn.getSkin("downSkin")).graphics.drawRoundRect(1, 1, 12, 12, 3);
			Sprite(windowBtn.getSkin("downSkin")).graphics.beginFill(0x444444, 1);
			Sprite(windowBtn.getSkin("downSkin")).graphics.drawRect(2, 2, 10, 10);
			Sprite(windowBtn.getSkin("downSkin")).graphics.endFill();*/
			
			windowBtn.x = closeBtn.x - windowBtn.width //- 1;
			windowBtn.y = 2;
			
			// mask
			mk.x = TAB_AREA_LEFT_MARGIN;
			mk.y = TAB_AREA_TOP_MARGIN;
			mk.width = _panelWidth - (BORDER_WIDTH * 2);
			mk.height = _panelHeight - (BORDER_WIDTH * 2) + (BORDER_WIDTH - TAB_AREA_TOP_MARGIN);
			
			tabManager.container.x = 0;
			tabManager.container.y = 0;
			tabManager.update();
			
		} // end function draw
		
		
		// function enterFrameHandler
		// 
		override protected function enterFrameHandler(event:Event):void
		{
			_panelWidth = resizeGrabberRE.x - resizeGrabberLE.x;	 // the width of the panel
			_panelHeight = resizeGrabberBE.y - resizeGrabberTE.y;	 // the height of the panel
			
			registrationPoint.x = 0;
			registrationPoint.y = 0;
			
			// Set the panelWidth and panelHeight properties
			// 4 conditions needed to accomodate for all 4 edges of the panel
			if(mouseEventTarget == resizeGrabberTR || mouseEventTarget == resizeGrabberTL)
			{
				_panelWidth = resizeGrabberTR.x - resizeGrabberTL.x;
				_panelHeight = resizeGrabberBE.y - mouseEventTarget.y;
			}
			else if(mouseEventTarget == resizeGrabberLE || mouseEventTarget == resizeGrabberRE)
			{
				_panelWidth = resizeGrabberRE.x - resizeGrabberLE.x;
				_panelHeight = resizeGrabberBE.y - resizeGrabberTE.y;
			}
			else if(mouseEventTarget == resizeGrabberTE || mouseEventTarget == resizeGrabberBE)
			{
				_panelWidth = resizeGrabberTR.x - resizeGrabberTL.x;
				_panelHeight = resizeGrabberBE.y - resizeGrabberTE.y;
			}
			else if(mouseEventTarget == resizeGrabberBL || mouseEventTarget == resizeGrabberBR)
			{
				_panelWidth = resizeGrabberBR.x - resizeGrabberBL.x;
				_panelHeight = mouseEventTarget.y - resizeGrabberTE.y;
			}
			
			// make sure _panelWidth and _panelHeight are not greater the or less then the max width/min width and max height/min height
			_panelWidth = _panelWidth > _maxWidth ? _maxWidth : _panelWidth;
			_panelWidth = _panelWidth < _minWidth ? _minWidth : _panelWidth;
			
			_panelHeight = _panelHeight > _maxHeight ? _maxHeight : _panelHeight;
			_panelHeight = _panelHeight < _minHeight ? _minHeight : _panelHeight;
			
			// set the mouseEventTarget to the mouse position
			mouseEventTarget.x = mouseX;
			mouseEventTarget.y = mouseY;
			
			
			// align the assets
			
			// top resizers
			if(mouseEventTarget == resizeGrabberTL || mouseEventTarget == resizeGrabberTR || mouseEventTarget == resizeGrabberTE)
			{
				registrationPoint.y = mouseEventTarget.y;
			} 
			// left resizers
			if(mouseEventTarget == resizeGrabberTL || mouseEventTarget == resizeGrabberLE || mouseEventTarget == resizeGrabberBL)
			{
				registrationPoint.x = mouseEventTarget.x;
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
			
			
			// dragger
			dragger.width = _panelWidth - (BORDER_WIDTH * 2);
			dragger.x = registrationPoint.x + BORDER_WIDTH;
			dragger.y = registrationPoint.y + TOP_BORDER_HEIGHT;
			
			// background
			background.x = registrationPoint.x;
			background.y = registrationPoint.y + TOP_BORDER_HEIGHT;
			background.width = _panelWidth;
			background.height = _panelHeight - TOP_BORDER_HEIGHT - BORDER_WIDTH - TOP_BORDER_MARGIN;
			
			// close and window buttons
			closeBtn.x = registrationPoint.x + _panelWidth - closeBtn.width - BORDER_WIDTH;
			closeBtn.y = registrationPoint.y + 2;
			windowBtn.x = closeBtn.x - windowBtn.width - 1;
			windowBtn.y = registrationPoint.y + 2;
			
			// border
			border.x = registrationPoint.x;
			border.y = registrationPoint.y;
			
			border.graphics.clear();
			
			border.graphics.beginFill(_borderColor, 1);
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			
			border.graphics.beginFill(0x000000, 0.6); // outer grad
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - 2);
			
			border.graphics.beginFill(0x000000, 0.4);
			border.graphics.drawRect(2, 2, _panelWidth - 4, _panelHeight - 4);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			
			border.graphics.beginFill(0x000000, 0.4);
			border.graphics.drawRect(3, 3, _panelWidth - 6, _panelHeight - 6);
			border.graphics.drawRect(4, 4, _panelWidth - 8, _panelHeight - 8);
			
			// top border
			border.graphics.beginFill(_borderColor, 1);
			border.graphics.drawRect(1, 1, _panelWidth - 2, TOP_BORDER_HEIGHT - 1);
			
			border.graphics.beginFill(0x000000, 0.8); // outer grad
			border.graphics.drawRect(2, TOP_BORDER_HEIGHT - 1, _panelWidth - 4, 1);
			
			border.graphics.beginFill(0xFFFFFF, 0.4); // shine
			border.graphics.drawRect(2, 1, _panelWidth - 4, 1);
			
			border.graphics.endFill();
			
			
			// mask
			mk.x = registrationPoint.x + TAB_AREA_LEFT_MARGIN;
			mk.y = registrationPoint.y + TAB_AREA_TOP_MARGIN;
			mk.width = _panelWidth - (BORDER_WIDTH * 2);
			mk.height = _panelHeight - (BORDER_WIDTH * 2) + (BORDER_WIDTH - TAB_AREA_TOP_MARGIN);
			
			
			// update the tabManager
			tabManager.container.x = registrationPoint.x;
			tabManager.container.y = registrationPoint.y;
			tabManager.update();
			
		} // end function enterFrameHandler
		
		
		// function initializeCursorEvent
		// Set mouse event to change the cursor style based on the action that is being performed
		override protected function initializeCursorEvent():void
		{
			border.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			border.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			super.initializeCursorEvent();
			
		} // end function initializeCursorEvent
		
		
		// function changeCursor
		// Change the cursor based on the event type, and event target
		override protected function changeCursor(event:MouseEvent):void
		{
			
			if(event.type == MouseEvent.ROLL_OVER)
			{
				switch(event.currentTarget)
				{
					case border:
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
					
				} // end switch 
			}
			else if(event.type == MouseEvent.ROLL_OUT)
				Mouse.cursor = MouseCursor.AUTO;
			
			
		} // end function changeCursor
		
		
		
		
		// *************************************************** SET AND GET **********************************************
		
		// tabManager
		public function get tabManager():BATabManager
		{
			return _tabManager;
		}
		
		
		// closable
		override public function set closable(value:Boolean):void
		{
			_closable = value;
			
			if(value)
			{
				closeBtn.visible = true;
			}
			else
			{
				closeBtn.visible = false;
			}
		}
		
		override public function get closable():Boolean
		{
			return _closable;
		}
		
		// draggable
		override public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if(value)
			{
				border.mouseEnabled = true;
			}
			else
			{
				border.mouseEnabled = false;
			}
		}
		
		
		
		// *************************************************** SET AND GET OVERRIDES **********************************************
		
		// addChild
		
		
	}
	
}
