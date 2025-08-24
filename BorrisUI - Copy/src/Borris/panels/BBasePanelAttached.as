/* Author: Rohaan Allport
 * Date Created: 23/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Custom Sprite that has functions to help with common appliction UI and makes it act like an application window.
 * 				It can be dragged, closed, resized.
 * 				It can support Tabs, switch tabs, and change the position of tabs (done though the BATabManager Object)
 * 
 *	todo/imporovemtns: 
 * 					- add calculation for margins and borders. (currently only top margin calculation is there, cuz laziness)
 * 					- override the addChild() method so that children cannot be added directly to the panel.
 * 						- make a new tab, (call it "Tab" + tabManager.numTabs + 1?), add the tab using the tabManager, and set the tab.content as the child. (im a boss!)
 * 
 * Note: Override neccesarry function.
 * 					- Overriding the initializeEventHandlers(), draw(), enterFrameHandler(), and sometime the initializeCursorEvent(), changeCursor() functions are a MUST.
 * 					- Also, add get tabManager() function to subclasses
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
	
	
	public class BBasePanelAttached extends Sprite
	{
		// constants
		//internal static const SIZE_OFFSET:uint = 0;				// Used for offsetting the assets in window mode (when it is a NativeWindow)
		internal static const TOP_BORDER_HEIGHT:uint = 18;			// The height of the top border. (sometimes it might be different than the other borders.)
		internal static const BORDER_WIDTH:uint = 4;				// the width of the borders. recommended use for the mask, soo that content doesn't show over the borders.
																	// and in the tab manager to position the tabs.
		
		internal static const TAB_AREA_TOP_MARGIN:uint = 18;		// the margin from the top of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_BOTTOM_MARGIN:uint = 3;	// the margin from the bottom of the panel, to where the tabs should be placed
		internal static const TAB_AREA_LEFT_MARGIN:uint = 5;		// the margin from the left of the panel, to where the tabs should be placed
		//internal static const TAB_AREA_RIGHT_MARGIN:uint = 3;		// the margin from the right of the panel, to where the tabs should be placed
		internal static const TAB_AREA_HEIGHT:uint = 25;			// The height of the place where the tabs are.
		
		internal static const CONTENT_MARGIN:uint = 1; 				// The margin of the content within the borders
		
		internal static const TOP_BORDER_MARGIN:uint = 25;			// The margin of the top border fromt the top of the panel
		internal static const BOTTOM_BORDER_MARGIN:uint = 0;		// 
		internal static const LEFT_BORDER_MARGIN:uint = 0;			// 
		internal static const RIGHT_BORDER_MARGIN:uint = 0;			// 
		
		internal static const RESIZE_GRABBER_THICKNESS:uint = 4;	// 
		
		
		// asset variables
		protected var background:Sprite;
		protected var dragger:Sprite;
		protected var closeBtn:BButton;
		protected var windowBtn:BButton;
		
		protected var border:Sprite;
		
		
		// resize grabbers
		protected var resizeGrabberTL:Sprite;
		protected var resizeGrabberTR:Sprite;
		protected var resizeGrabberBL:Sprite;
		protected var resizeGrabberBR:Sprite;
		protected var resizeGrabberTE:Sprite;
		protected var resizeGrabberBE:Sprite;
		protected var resizeGrabberLE:Sprite;
		protected var resizeGrabberRE:Sprite;
		
		// tab variables
		//private var _tabManager:BBaseTabManager; 				// [read-only] reference to this panel's tab manager
		
		// display variables?
		protected var mk:Shape; 								// A shape to mask content and tabs
		
		// resizing and mouse variables
		protected var beginMouseX:int;							// Not actually used for anything.
		protected var beginMouseY:int;							// Not actually used for anything.
		protected var endMouseX:int;							// Not actually used for anything.
		protected var endMouseY:int;							// Not actually used for anything.
		protected var beginMousePoint:Point;					// Not actually used for anything.
		protected var endMousePoint:Point;						// Not actually used for anything.
		
		protected var mouseIsDown:Boolean;						// Not actually used for anything.
		protected var mouseEventTarget:Sprite;					// 
		
		protected var registrationPoint:Point = new Point(0, 0);
		
		
		// set and get private variables
		//protected var _position:String; 			// [read-only].
		protected var _panelWidth:int = 500;		// 
		protected var _panelHeight:int = 500;		// 
		protected var _maxWidth:Number = 2048;		// 
		protected var _maxHeight:Number = 2048;		//
		protected var _minWidth:Number = 50;		// 
		protected var _minHeight:Number= 50;		//
		
		protected var _resizable:Boolean = true;		// Set or get whether this Panel is resizable.
		protected var _closable:Boolean = true;			// Set or get whether this Panel is closable.
		protected var _draggable:Boolean = true;		// Set or get whether this Panel is draggable.
		protected var _detachable:Boolean = true;		// Set or get whether this Panel is detachable.
		protected var _attached:Boolean = true;			// [read-only] Whether or not this panel is attached to the main window.
		protected var _freeMove:Boolean = true;			// Set or get whether this Panel can me freely dragged around.
		
		// customizablity
		protected var _borderColor:uint = 0x333333;
		protected var _borderTransparency:Number = 1;
		protected var _borderThickness:Number = 3;
		protected var _backgroundColor:uint = 0x454545;
		protected var _backgroundTransparency:Number = 1;
		
		protected var _draggerColor:uint = 0x292929;
		protected var _draggertransparency:Number = 1;
		
		protected var _gradientColor:uint = 0x000000;
		protected var _gradientOuterTransparency:Number = 0.6;
		protected var _gradientInnerTransparency:Number = 0.4;
		
		protected var _shineColor:uint = 0xFFFFFF;
		protected var _shineTransparency:Number = 0.4;
		
		
		public function BBasePanelAttached() 
		{
			// constructor code
			
			/*mk = new Shape();
			mk.graphics.beginFill(0xff0055, 0.2);
			mk.graphics.drawRect(0, 0, 50, 50);
			mk.graphics.endFill();
			mk.width = this.panelWidth - (panelLeftEdge.width + panelRightEdge.width + 2);
			mk.height = this.panelHeight - (panelTopEdge.height + panelBottomEdge.height);
			
			//positionAlign(_position);
			
			
			this.addChild(background);
			this.addChild(dragger);
			
			this.addChild(panelTopEdge);
			this.addChild(panelBottomEdge);
			this.addChild(panelLeftEdge);
			this.addChild(panelRightEdge);
			this.addChild(panelTLCorner);
			this.addChild(panelTRCorner);
			this.addChild(panelBLCorner);
			this.addChild(panelBRCorner);
			this.addChild(closeBtn);
			this.addChild(windowBtn);
			this.addChild(mk);
			
			
			// tabs and tab manager
			//_tabManager = new BFileTabManager(this)
			//_tabManager.mask = mk;
			
			// initialize resize grabbers
			initializeResizeGrabbers();
			
			initializeCursorEvent();
			initializeEventHandlers();
			
			draw();*/
		}
		
		
		// function initializeResizeGrabbers
		// Initialize some invisble object to act as resize grabbers. Unlike an actual Window, the method used for 
		// resizing requires that the edges and the grabbers be sepparate.
		protected function initializeResizeGrabbers():void
		{
			var thickness:int = 5;
			var color:uint = 0x00FF00;
			var alpha:Number = 1;
			
			resizeGrabberTL = new Sprite();
			resizeGrabberTR = new Sprite();
			resizeGrabberBL = new Sprite();
			resizeGrabberBR = new Sprite();
			resizeGrabberTE = new Sprite();
			resizeGrabberBE = new Sprite();
			resizeGrabberLE = new Sprite();
			resizeGrabberRE = new Sprite();
			
			
			resizeGrabberTL.graphics.beginFill(color, 1);
			resizeGrabberTL.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberTL.graphics.endFill();
			
			resizeGrabberTR.graphics.beginFill(color, 1);
			resizeGrabberTR.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberTR.graphics.endFill();
			
			resizeGrabberBL.graphics.beginFill(color, 1);
			resizeGrabberBL.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberBL.graphics.endFill();
			
			resizeGrabberBR.graphics.beginFill(color, 1);
			resizeGrabberBR.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberBR.graphics.endFill();
			
			resizeGrabberTE.graphics.beginFill(color, 1);
			resizeGrabberTE.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberTE.graphics.endFill();
			
			resizeGrabberBE.graphics.beginFill(color, 1);
			resizeGrabberBE.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberBE.graphics.endFill();
			
			resizeGrabberLE.graphics.beginFill(color, 1);
			resizeGrabberLE.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberLE.graphics.endFill();
			
			resizeGrabberRE.graphics.beginFill(color, 1);
			resizeGrabberRE.graphics.drawRect(0, 0, RESIZE_GRABBER_THICKNESS, RESIZE_GRABBER_THICKNESS);
			resizeGrabberRE.graphics.endFill();
			
			
			
			resizeGrabberTL.alpha = 
			resizeGrabberTR.alpha = 
			resizeGrabberBL.alpha = 
			resizeGrabberBR.alpha = 
			resizeGrabberTE.alpha = 
			resizeGrabberBE.alpha = 
			resizeGrabberLE.alpha = 
			resizeGrabberRE.alpha = 0;
			
			this.addChild(resizeGrabberTL);
			this.addChild(resizeGrabberTR);
			this.addChild(resizeGrabberBL);
			this.addChild(resizeGrabberBR);
			this.addChild(resizeGrabberTE);
			this.addChild(resizeGrabberBE);
			this.addChild(resizeGrabberLE);
			this.addChild(resizeGrabberRE);
			
		} // end function initializeResizeGrabbers
		
		
		// function initializeEventHandlers
		// 
		protected function initializeEventHandlers():void
		{
			
			resizeGrabberTL.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberTR.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberBL.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberBR.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberTE.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberBE.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberLE.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			resizeGrabberRE.addEventListener(MouseEvent.MOUSE_DOWN, resizePanel);
			
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
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, bringToFront);
			closeBtn.addEventListener(MouseEvent.CLICK, closePanel);
			//windowBtn.addEventListener(MouseEvent.CLICK, windowPanel);
			
			
			// 
			
		} // end function initializeEventHandlers
		
		
		// function draw
		// In progress
		protected function draw():void
		{
			// override this function
			
		} // end function draw
		
		
		// function openPanel
		// 
		public function openPanel():void
		{
			this.visible = true;
			this.dispatchEvent(new Event(Event.OPEN, false, false));
		} // end function openPanel
		
		
		// function closePanel
		// clsoe the panel. Doesn't actually close. Its visiblity is set to false
		protected function closePanel(event:MouseEvent):void
		{
			this.visible = false;
			this.dispatchEvent(new Event(Event.CLOSE, false, false));
		} // end function closePanel
		
		
		// function bringToFront
		// Bring this Panel infront of all other children of the parent DisplayObjectContainer
		protected function bringToFront(event:MouseEvent):void
		{
			parent.setChildIndex(this, (parent.numChildren - 1));
			//dispatchEvent(new PanelFocusEvent(BPanelFocusEvent.FOCUS_IN, false, false);
		} // end function bringToFront
		
		
		// function startDragPanel
		// Drag the by holding the mouse down on the appropriate asset.
		protected function startDragPanel(event:MouseEvent):void
		{
			this.startDrag();
			//dispatchEvent(new FocusEvent(BPanelEvent.MOVING, false, false);
		} // end function startDragPanel
		
		
		// function stopDragPanel
		// Stop dragging the panel by releasing the mouse from the asset
		protected function stopDragPanel(event:MouseEvent):void
		{
			this.stopDrag();
			//dispatchEvent(new FocusEvent(BPanelEvent.MOVING, false, false);
		} // end function stopDragPanel
		
		
		// function resizePanel
		// 
		protected function resizePanel(event:MouseEvent):void
		{
			
			var resizeGrabber:Sprite = event.currentTarget as Sprite;
			
			mouseIsDown = true;
			
			beginMouseX = resizeGrabber.x;
			beginMouseY = resizeGrabber.y;
			mouseEventTarget = resizeGrabber;
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
			
		} // end function resizePanel
		
		
		// function stopResizePanel
		// 
		protected function stopResizePanel(event:MouseEvent = null):void
		{
			mouseIsDown = false;
			
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			this.x = this.x + resizeGrabberTL.x;
			this.y = this.y + resizeGrabberTL.y;
			
			if(event.target == resizeGrabberTE)
			{
				this.x = this.x + resizeGrabberTL.x;
				this.y = this.y + resizeGrabberTE.y;
			}
			else if(event.target == resizeGrabberLE)
			{
				this.x = this.x + resizeGrabberLE.x;
				this.y = this.y + resizeGrabberTL.y;
			}
			else if(event.target == resizeGrabberBL)
			{
				this.x = this.x + resizeGrabberBL.x;
				this.y = this.y + resizeGrabberTL.y;
			}
			else if(event.target == resizeGrabberTR)
			{
				this.x = this.x + resizeGrabberTL.x;
				this.y = this.y + resizeGrabberTR.y;
			}
			
			// draw the panel
			draw();
			
		} // end function stopResizePanel
		
		
		// function enterFrameHandler
		// 
		protected function enterFrameHandler(event:Event):void
		{
			// Best to just override this function. Very complex.
			// Some things to do in the subclass overrides are listed below
			
			
			// update the tabManager
			// tabManager.update();
			
			// dispatch a panel resiizing event here
			//this.dispatchEvent(new Event(Event.RESIZE, false, false);
			
		} // end function enterFrameHandler
		
		
		// function initializeCursorEvent
		// Set mouse event to change the cursor style based on the action that is being performed
		protected function initializeCursorEvent():void
		{
			//dragger.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			//dragger.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			//panelTopEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			//panelTopEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
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
			
		} // end function initializeCursorEvent
		
		
		// function changeCursor
		// Change the cursor based on the event type, and event target
		protected function changeCursor(event:MouseEvent):void
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
		
		// position
		/*public function get position():String
		{
			return _position;
		}*/
		
		// panelWidth
		public function set panelWidth(value:int):void
		{
			value = value > _maxWidth ? _maxWidth : value;
			value = value < _minWidth ? _minWidth : value;
			_panelWidth = value;
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
			draw();
		}
		
		public function get panelWidth():int
		{
			return _panelWidth;
		}
		
		// panelHeight
		public function set panelHeight(value:int):void
		{
			value = value > _maxHeight ? _maxHeight : value;
			value = value < _minHeight ? _minHeight : value;
			_panelHeight = value;
			this.dispatchEvent(new Event(Event.RESIZE, false, false));
			draw();
		}
		
		public function get panelHeight():int
		{
			return _panelHeight;
		}
		
		// maxWidth
		public function set maxWidth(value:int):void
		{
			_maxWidth = value;
			_panelWidth = _panelWidth > _maxWidth ? _maxWidth : _panelWidth;
			draw();
		}
		
		public function get maxWidth():int
		{
			return _maxWidth;
		}
		
		// maxHeight
		public function set maxHeight(value:int):void
		{
			_maxHeight = value;
			_panelHeight = _panelHeight > _maxHeight ? _maxHeight : _panelHeight;
			draw();
		}
		
		public function get maxHeight():int
		{
			return _maxHeight;
		}
		
		// minWidth
		public function set minWidth(value:int):void
		{
			_minWidth = value;
			_panelWidth = _panelWidth < _minWidth ? _minWidth : _panelWidth;
			draw();
		}
		
		public function get minWidth():int
		{
			return _minWidth;
		}
		
		// minHeight
		public function set minHeight(value:int):void
		{
			_minHeight = value;
			_panelHeight = _panelHeight < _minHeight ? _minHeight : _panelHeight;
			draw();
		}
		
		public function get minHeight():int
		{
			return _minHeight;
		}
		
		// tabManager
		/*public function get tabManager():BFileTabManager
		{
			return _tabManager;
		}*/
		
		// resizable
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
		
		public function get resizable():Boolean
		{
			return _resizable;
		}
		
		// closable
		public function set closable(value:Boolean):void
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
		
		public function get closable():Boolean
		{
			return _closable;
		}
		
		// draggable
		public function set draggable(value:Boolean):void
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
		
		public function get draggable():Boolean
		{
			return _draggable
		}
		
		// detachable
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
		
		
		// *************************************************** SET AND GET OVERRIDES **********************************************
		
		// width 
		override public function set width(value:Number):void
		{
			panelWidth = value;
		}
		
		override public function get width():Number
		{
			return _panelWidth;
		}
		
		
		// height
		override public function set height(value:Number):void
		{
			panelHeight = value;
		}
		
		override public function get height():Number
		{
			return _panelHeight;
		}
		
	}

}