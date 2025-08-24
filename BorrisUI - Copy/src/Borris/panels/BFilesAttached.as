/* Author: Rohaan Allport
 * Date Created: 30/09/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Custom Sprite that has functions to help with common appliction UI and makes it act like an application window.
 * 				It can be dragged, closed, resized.
 * 				It can support File Tabs, switch tabs, and change the position of tabs (done though the BFileTabManager Object)
*/


package Borris.panels
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.filters.*;
	
	import Borris.controls.*;
	import Borris.ui.BMouseCursor;
	
	
	public class BFilesAttached extends BBasePanelAttached
	{
		// constants
		internal static const SIZE_OFFSET:uint = 0;				// Used for offsetting the assets in window mode (when it is a NativeWindow)
		internal static const TOP_BORDER_HEIGHT:uint = 8;		// The height of the top border. (sometimes it might be different than the other borders.)
		internal static const BORDER_WIDTH:uint = 8;			// the width of the borders. recommended use for the mask, soo that content doesn't show over the borders.
																// and in the tab manager to position the tabs.
		
		internal static const TAB_AREA_TOP_MARGIN:uint = 3;			// the margin from the top of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_BOTTOM_MARGIN:uint = 3;	// the margin from the bottom of the panel, to where the tabs should be placed
		internal static const TAB_AREA_LEFT_MARGIN:uint = 8;		// the margin from the left of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_RIGHT_MARGIN:uint = 3;		// the margin from the right of the panel, to where the tabs should be placed
		internal static const TAB_AREA_HEIGHT:uint = 22;			// The height of the place where the tabs are.
		
		internal static const CONTENT_MARGIN:uint = 0; 				// The margin of the content within the borders
		
		internal static const TOP_BORDER_MARGIN:uint = 25;			// The margin of the top border from the top of the panel
		internal static const BOTTOM_BORDER_MARGIN:uint = 0;		// 
		internal static const LEFT_BORDER_MARGIN:uint = 0;			// 
		internal static const RIGHT_BORDER_MARGIN:uint = 0;			// 
		
		
		// asset variables
		protected var canvas:Sprite;
		protected var moreFilesDragger:Sprite;
		
		
		// resize grabbers
		
		
		// tab variables
		protected var _tabManager:BFileTabManager; 				// [read-only] reference to this panel's tab manager
		
		// display variables?
		
		// resizing and mouse variables
		
		// set and get protected variables
		

		public function BFilesAttached() 
		{
			// constructor code
			
			// asset variables
			background = new Sprite();
			border = new Sprite();
			dragger = new Sprite();
			closeBtn = new BButton();
			windowBtn = new BButton();
			
			
			// mask
			mk = new Shape();
			mk.graphics.beginFill(0xff0055, 0.2);
			mk.graphics.drawRect(0, 0, 50, 50);
			mk.graphics.endFill();
			mk.width = _panelWidth - (BORDER_WIDTH * 2);
			mk.height = this.panelHeight - (BORDER_WIDTH * 2) + (BORDER_WIDTH - TAB_AREA_TOP_MARGIN);
			
			canvas = new Sprite();
			canvas.graphics.beginFill(0xffffff, 1);
			canvas.graphics.drawRect(0, 0, 50, 50);
			canvas.graphics.endFill();
			canvas.width = _panelWidth - (BORDER_WIDTH * 2);
			canvas.height = this.panelHeight - (BORDER_WIDTH * 2) - TOP_BORDER_MARGIN;
			canvas.mouseEnabled = false;
			
			//moreFilesDragger = new MoreFilesDragger();
			
			
			this.addChild(background);
			this.addChild(dragger);
			this.addChild(border);
			this.addChild(closeBtn);
			this.addChild(windowBtn);
			this.addChild(mk);
			this.addChild(canvas);
			//this.addChild(moreFilesDragger);
			this.setChildIndex(canvas, this.numChildren - 1);
			
			// tabs and tab manager
			_tabManager = new BFileTabManager(this);
			_tabManager.mask = mk;
			
			// initialize resize grabbers
			initializeResizeGrabbers();
			
			initializeCursorEvent();
			initializeEventHandlers();
			
			
			// draw the panel
			_borderColor = 0x000000;// 0x333333;
			_borderTransparency = 1;
			_borderThickness = 8;// 4;
			
			_backgroundColor = 0x222222;// 0x454545;
			_backgroundTransparency = 1;
			
			_draggerColor = 0x000000;// 0x292929;
			_draggertransparency = 0.5;// 1;
			
			_gradientColor = 0xCCCCCC;// 0x000000;
			_gradientOuterTransparency = 1;//0.5;
			_gradientInnerTransparency = 0.4;//0.3;
			
			_shineColor = 0xFFFFFF;
			_shineTransparency = 0.4;
			
			draw();
			
			canvas.filters = new Array(new GlowFilter(_gradientColor, 1, 6, 6, 2, 1, true, true));
		}
		
		
		// function initializeResizeGrabbers
		// Initialize some invisble object to act as resize grabbers. Unlike an actual Window, the method used for 
		// resizing requires that the edges and the grabbers be sepparate.
		override protected function initializeResizeGrabbers():void
		{
			super.initializeResizeGrabbers();
		} // end function initializeResizeGrabbers
		
		
		// function onAddedToStage
		// 
		override protected function initializeEventHandlers():void
		{
			super.initializeEventHandlers();
			
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDragPanel);
			dragger.addEventListener(MouseEvent.MOUSE_UP, stopDragPanel);
			
		} // end function initializeEventHandlers
		
		
		// function draw
		// In progress
		override protected function draw():void
		{
			registrationPoint.x = 0;
			registrationPoint.y = TOP_BORDER_MARGIN;
			
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
			dragger.graphics.beginFill(_draggerColor, _draggertransparency);
			dragger.graphics.drawRect(0, 0, 100, 32);
			dragger.graphics.endFill();
			
			dragger.width = _panelWidth;
			dragger.x = registrationPoint.x;
			dragger.y = registrationPoint.y - TOP_BORDER_MARGIN;
			
			
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
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight - TOP_BORDER_MARGIN);
			border.graphics.drawRect(_borderThickness, _borderThickness, _panelWidth - (_borderThickness * 2), _panelHeight - TOP_BORDER_MARGIN - (_borderThickness * 2));
			
			border.graphics.beginFill(_gradientColor, _gradientOuterTransparency); // outer grad
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight - TOP_BORDER_MARGIN);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - TOP_BORDER_MARGIN - 2);
			
			border.graphics.beginFill(_gradientColor, _gradientInnerTransparency);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - TOP_BORDER_MARGIN - 2);
			border.graphics.drawRect(2, 2, _panelWidth - 4, _panelHeight - TOP_BORDER_MARGIN - 4);
			
			border.graphics.beginFill(_shineColor, _shineTransparency);	// shine
			border.graphics.drawRect(1, 1, _panelWidth - 2, 1);
			//border.alpha = 0.5;
			
			// close and window button
			closeBtn.x = registrationPoint.x + _panelWidth - closeBtn.width - BORDER_WIDTH;
			closeBtn.y = 2;
			windowBtn.x = closeBtn.x - windowBtn.width - 1;
			windowBtn.y = 2;
			
			
			// mask
			mk.x = TAB_AREA_LEFT_MARGIN;
			mk.y = TAB_AREA_TOP_MARGIN;
			mk.width = _panelWidth - (BORDER_WIDTH * 2);
			mk.height = _panelHeight - (BORDER_WIDTH * 2) + (BORDER_WIDTH - TAB_AREA_TOP_MARGIN);
			
			
			// canvas
			canvas.x = BORDER_WIDTH;
			canvas.y = TOP_BORDER_MARGIN + TOP_BORDER_HEIGHT;
			canvas.width = _panelWidth - (BORDER_WIDTH * 2);
			canvas.height = _panelHeight - (BORDER_WIDTH * 2) - TOP_BORDER_MARGIN;
			
			//moreFilesDragger.x = panelWidth - moreFilesDragger.width;
			//moreFilesDragger.y = 0;
			
			tabManager.container.x = 0;
			tabManager.container.y = 0;
			tabManager.update();
			
		} // end function draw
		
		
		// function bringToFront
		// Bring this Panel infront of all other children of the parent DisplayObjectContainer
		override protected function bringToFront(event:MouseEvent):void
		{
			super.bringToFront(event);
			this.setChildIndex(canvas, this.numChildren - 1);
		} // end function bringToFront
		
		// function enterFrameHandler
		// 
		override protected function enterFrameHandler(event:Event):void
		{
			_panelWidth = resizeGrabberRE.x - resizeGrabberLE.x; // the width of the panel
			_panelHeight = resizeGrabberBE.y - resizeGrabberTE.y; // the height of the panel
			
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
			dragger.x = registrationPoint.x;
			dragger.y = registrationPoint.y;
			dragger.width = _panelWidth;
			
			
			// background
			background.x = registrationPoint.x + BORDER_WIDTH;
			background.y = registrationPoint.y + TOP_BORDER_MARGIN + TOP_BORDER_HEIGHT;
			background.width = _panelWidth - (BORDER_WIDTH * 2);
			background.height = _panelHeight - TOP_BORDER_HEIGHT - BORDER_WIDTH - TOP_BORDER_MARGIN;
			
			
			// border
			border.x = registrationPoint.x;
			border.y = registrationPoint.y + TOP_BORDER_MARGIN;
			
			border.graphics.clear();
			
			border.graphics.beginFill(_borderColor, _borderTransparency);
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight - TOP_BORDER_MARGIN);
			border.graphics.drawRect(_borderThickness, _borderThickness, _panelWidth - (_borderThickness * 2), _panelHeight - TOP_BORDER_MARGIN - (_borderThickness * 2));
			
			border.graphics.beginFill(_gradientColor, _gradientOuterTransparency); // outer grad
			border.graphics.drawRect(0, 0, _panelWidth, _panelHeight - TOP_BORDER_MARGIN);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - TOP_BORDER_MARGIN - 2);
			
			border.graphics.beginFill(_gradientColor, _gradientInnerTransparency);
			border.graphics.drawRect(1, 1, _panelWidth - 2, _panelHeight - TOP_BORDER_MARGIN - 2);
			border.graphics.drawRect(2, 2, _panelWidth - 4, _panelHeight - TOP_BORDER_MARGIN - 4);
			
			border.graphics.beginFill(_shineColor, _shineTransparency);	// shine
			border.graphics.drawRect(1, 1, _panelWidth - 2, 1);
			
			border.graphics.endFill();
			
			
			// close and window buttons
			closeBtn.x = registrationPoint.x + _panelWidth - closeBtn.width - BORDER_WIDTH;
			closeBtn.y = registrationPoint.y + 2;
			windowBtn.x = closeBtn.x - windowBtn.width - 1;
			windowBtn.y = registrationPoint.y + 2;
			
			
			// mask
			mk.x = registrationPoint.x + TAB_AREA_LEFT_MARGIN;
			mk.y = registrationPoint.y + TAB_AREA_TOP_MARGIN;
			mk.width = _panelWidth - (BORDER_WIDTH * 2);
			mk.height = _panelHeight - (BORDER_WIDTH * 2) + (BORDER_WIDTH - TAB_AREA_TOP_MARGIN);
			
			
			// cancas
			canvas.x = registrationPoint.x + BORDER_WIDTH;
			canvas.y = registrationPoint.y + TOP_BORDER_MARGIN + TOP_BORDER_HEIGHT;
			canvas.width = _panelWidth - (BORDER_WIDTH * 2);
			canvas.height = _panelHeight - TOP_BORDER_HEIGHT - BORDER_WIDTH - TOP_BORDER_MARGIN;
			
			
			// update the tabManager
			tabManager.container.x = registrationPoint.x;
			tabManager.container.y = registrationPoint.y;
			tabManager.update();
			
		} // end function enterFrameHandler
		
		
		// function initializeCursorEvent
		// Set mouse event to change the cursor style based on the action that is being performed
		override protected function initializeCursorEvent():void
		{
			dragger.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			dragger.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
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
					case dragger:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
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
		public function get tabManager():BFileTabManager
		{
			return _tabManager;
		}
		
		
		// draggable
		override public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if(value)
			{
				dragger.mouseEnabled = true;
			}
			else
			{
				dragger.mouseEnabled = false;
			}
		}
		
		
		
		// *************************************************** SET AND GET OVERRIDES **********************************************
		
		

	}
	
}
