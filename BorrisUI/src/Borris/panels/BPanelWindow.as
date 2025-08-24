/* Author: Rohaan Allport
 * Date Created: 12/04/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Custom NativeWindows that has functions to help with common appliction UI.
 * 				It can be dragged, closed, resized.
 * 				It can support Tabs, switch tabs, and change the position of tabs (done though the BTabManager Object)
 * 
 * 
*/

package Borris.panels
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.desktop.*;
	import flash.geom.*;
	import flash.ui.*;
	
	import Borris.panels.*;
	import Borris.ui.BMouseCursor;
	
	
	public class BPanelWindow extends NativeWindow
	{
		internal static const SIZE_OFFSET:uint = 82; // 132 - 82 = 50
		internal static const TOP_BORDER_HEIGHT:uint = 18;		// The height of the top border. (sometimes it might be different than the other borders.)
		internal static const BORDER_WIDTH:uint = 4;			// the width of the borders. recommended use for the mask, soo that content doesn't show over the borders.
																// and in the tab manager to position the tabs.
																
		internal static const TAB_AREA_HEIGHT:uint = 25;
		internal static const CONTENT_MARGIN:uint = 1; 
		
		// asset variables
		private var background:Sprite;
		private var dragger:Sprite;
		private var closeBtn:SimpleButton;
		private var windowBtn:SimpleButton;
		
		private var panelTLCorner:Sprite;
		private var panelTRCorner:Sprite;
		private var panelBLCorner:Sprite;
		private var panelBRCorner:Sprite;
		private var panelTopEdge:Sprite;
		private var panelBottomEdge:Sprite;
		private var panelLeftEdge:Sprite;
		private var panelRightEdge:Sprite;
		
		// tab variables
		private var _tabManager:BTabManager; // read-only. reference to this panel's tab manager
		
		// window variables
		private var panelInitOptions:NativeWindowInitOptions;
		
		// position variables
		
		
		// display variables?
		private var mk:Shape; // a shape to mask content and tabs
		
		
		// set and get private variables
		protected var _width:Number; 				// [override] the width of this panel
		protected var _height:Number; 				// [override] the height of this panel
		protected var _maxWidth:Number;				// 
		protected var _maxHeight:Number;			//
		protected var _minWidth:Number;				// 
		protected var _minHeight:Number;			//
		
		protected var _resizable:Boolean;			// Set or get whether this Panel is resizable.
		protected var _closable:Boolean;			// Set or get whether this Panel is closable.
		protected var _draggable:Boolean;			// Set or get whether this Panel is draggable.
		protected var _detachable:Boolean;			// Set or get whether this Panel is detachable.
		protected var _attached:Boolean;			// [read-only] Whether or not this panel is attached to the main window.
		protected var _freeMove:Boolean;			// Set or get whether this Panel can me freely dragged around.
		
		
		public function BPanelWindow(owner:NativeWindow, initOptions:NativeWindowInitOptions = null, bounds:Rectangle = null) 
		{
			// constructor code
			
			// set windowInitOption
			if(initOptions != null)
				panelInitOptions = initOptions;
			else
			{
				panelInitOptions = new NativeWindowInitOptions();
				// set the NativeWindowInitOptions's properties
				panelInitOptions.maximizable = false;
				panelInitOptions.minimizable = false;
				panelInitOptions.owner = owner;
				panelInitOptions.renderMode = NativeWindowRenderMode.AUTO;
				panelInitOptions.resizable = true;
				panelInitOptions.systemChrome = NativeWindowSystemChrome.NONE;
				panelInitOptions.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
				panelInitOptions.type = NativeWindowType.LIGHTWEIGHT;
			}
			
			// call the super() (NativeWinodw) contructor
			super(panelInitOptions);
			
			// set the scale mode to 'no scale' so that the application does not change scale when resizing
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left
			stage.displayState = StageDisplayState.NORMAL;
			
			this.height = 200;
			
			// set some essentail NativeWindow properties
			this.alwaysInFront = false;
			bounds ? this.bounds = new Rectangle(bounds.x, bounds.y, bounds.width + BPanelWindow.SIZE_OFFSET, bounds.height) : this.bounds = new Rectangle(x, y, 100 + BPanelWindow.SIZE_OFFSET, this.height);
			this.maxSize = new Point(1920, 1080);
			this.minSize = new Point(50, 50); // a minimun size for the application window
			//this.menu = new NativeMenu();
			//this.title = "Window " + (NativeApplication.nativeApplication.openedWindows.indexOf(this));
			
			
			initializeAssets();
			initializeCursorEvent();
			
			// tabs and tab manager
			_tabManager = new BTabManager(this);
			//_tabManager = new BTabManager(this.stage); // this was trying a new method to make BTabManager usable in both BPanelWindow and BPanelAttached
			_tabManager.mask = mk;
		}
		
		
		// function initializeAssets
		// set the position and add all the assets to the stage. And add event listeners
		private function initializeAssets():void
		{
			// initialize window assets
			// set corners and edges first
			background = new PanelBackground();
			dragger = new PanelDragger();
			closeBtn = new BCloseButton();
			windowBtn = new BWindowButton();
			
			
			panelTLCorner = new PanelTLCorner2();
			panelTRCorner = new PanelTRCorner2();
			panelBLCorner = new PanelBLCorner();
			panelBRCorner = new PanelBRCorner();
			panelTopEdge = new PanelTopEdge2();
			panelBottomEdge = new PanelBottomEdge();
			panelLeftEdge = new PanelLeftEdge();
			panelRightEdge = new PanelRightEdge();
			
			panelTLCorner.x = 0;
			panelTLCorner.y = 0;
			panelTRCorner.x = this.width - BPanelWindow.SIZE_OFFSET;
			panelTRCorner.y = 0;
			panelBLCorner.x = 0;
			panelBLCorner.y = this.height;
			panelBRCorner.x = this.width - BPanelWindow.SIZE_OFFSET;
			panelBRCorner.y = this.height;
			
			panelTopEdge.x = panelTLCorner.width;
			panelTopEdge.y = 0;
			panelTopEdge.width = this.width - panelTLCorner.width - panelTRCorner.width - BPanelWindow.SIZE_OFFSET;
			panelBottomEdge.x = panelBLCorner.width;
			panelBottomEdge.y = this.height;
			panelBottomEdge.width = this.width - panelBLCorner.width - panelBRCorner.width - BPanelWindow.SIZE_OFFSET;
			panelLeftEdge.x = 0;
			panelLeftEdge.y = panelTLCorner.height;
			panelLeftEdge.height = this.height - panelTLCorner.height - panelBLCorner.height;
			panelRightEdge.x = this.width - BPanelWindow.SIZE_OFFSET;
			panelRightEdge.y = panelTRCorner.height;
			panelRightEdge.height = this.height - panelTRCorner.height - panelBRCorner.height;
			
			
			mk = new Shape();
			mk.x = panelLeftEdge.width + BPanelWindow.CONTENT_MARGIN;
			//mk.y = panelTopEdge.height + dragger.height + 2;
			mk.y = panelTopEdge.height;
			mk.graphics.beginFill(0xff0055, 0.2);
			mk.graphics.drawRect(0, 0, 50, 50);
			mk.graphics.endFill();
			mk.width = this.width - (panelLeftEdge.width + panelRightEdge.width + BPanelWindow.CONTENT_MARGIN*2) - BPanelWindow.SIZE_OFFSET;
			//mk.height = this.height - (panelTopEdge.height + panelBottomEdge.height + dragger.height + 4); // 
			mk.height = this.height - (panelTopEdge.height + panelBottomEdge.height);
			
			dragger.width = this.width - (panelLeftEdge.width + panelRightEdge.width) - BPanelWindow.SIZE_OFFSET;
			dragger.x = panelLeftEdge.width;
			dragger.y = panelTopEdge.height;
			
			background.x = 0;
			background.y = panelTopEdge.height;
			background.height = this.height;
			background.width = this.width - BPanelWindow.SIZE_OFFSET;
			
			closeBtn.x = this.width - closeBtn.width - panelRightEdge.width - BPanelWindow.SIZE_OFFSET;
			closeBtn.y = 2; //panelTopEdge.height;
			windowBtn.x = closeBtn.x - windowBtn.width - 1;
			windowBtn.y = 2;
			
			
			stage.addChild(background);
			stage.addChild(dragger);
			stage.addChild(panelTopEdge);
			stage.addChild(panelBottomEdge);
			stage.addChild(panelLeftEdge);
			stage.addChild(panelRightEdge);
			stage.addChild(panelTLCorner);
			stage.addChild(panelTRCorner);
			stage.addChild(panelBLCorner);
			stage.addChild(panelBRCorner);
			stage.addChild(closeBtn);
			stage.addChild(windowBtn);
			stage.addChild(mk);
			
			
			// event handling
			//dragger.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			panelTLCorner.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			panelTRCorner.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			panelTopEdge.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			
			closeBtn.addEventListener(MouseEvent.CLICK, closePanel);
			
			//panelTLCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			//panelTRCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			panelBLCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			panelBRCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			//panelTopEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			panelBottomEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			panelRightEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			panelLeftEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
			
			
			this.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
			this.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, resizeAlign);
			//this.owner.addEventListener(NativeWindowBoundsEvent.MOVING, onNativeWindowMoving);
		} // function initializeAssets

		
		// function closePanel
		// clsoe the panel. Doesn't actually close. Its visiblity is set to false
		private function closePanel(event:MouseEvent):void
		{
			this.visible = false;
		} // end function closePanel
		
		
		// function moveWindow
		// Drag the by holding the mouse down on the appropriate asset.
		private function moveWindow(event:MouseEvent):void
		{
			this.startMove();
		} // end function moveWindow
		
		
		// function resizeWindow
		// resize the window by holding the mouse down on the appropriate asset
		private function resizeWindow(event:MouseEvent):void
		{
			if(event.currentTarget == panelTLCorner)
			{
				this.startResize(NativeWindowResize.TOP_LEFT);
			}
			if(event.currentTarget == panelTRCorner)
			{
				this.startResize(NativeWindowResize.TOP_RIGHT);
			}
			if(event.currentTarget == panelBLCorner)
			{
				this.startResize(NativeWindowResize.BOTTOM_LEFT);
			}
			if(event.currentTarget == panelBRCorner)
			{
				this.startResize(NativeWindowResize.BOTTOM_RIGHT);
			}
			
			if(event.currentTarget == panelTopEdge)
			{
				this.startResize(NativeWindowResize.TOP);
			}
			if(event.target == panelBottomEdge)
			{
				this.startResize(NativeWindowResize.BOTTOM);
			}
			if(event.currentTarget == panelLeftEdge)
			{
				this.startResize(NativeWindowResize.LEFT);
			}
			if(event.currentTarget == panelRightEdge)
			{
				this.startResize(NativeWindowResize.RIGHT);
			}
			
		} // end function resizeWindow
		
		
		// function resizeAlign
		// aligns/readjust the assets of the panel during a resize or resizing event.
		// an offset is applied the the right, top, and bottom assets to make the window appear smaller than it 
		// actually is. This is because the minSize property for windows is (132, X)
		private function resizeAlign(event:Event = null):void
		{
			
			//panelTLCorner.x = 0;
			//panelTLCorner.y = 0;
			panelTRCorner.x = this.width - BPanelWindow.SIZE_OFFSET;
			//panelTRCorner.y = 0;
			//panelBLCorner.x = 0;
			panelBLCorner.y = this.height;
			panelBRCorner.x = this.width - BPanelWindow.SIZE_OFFSET;
			panelBRCorner.y = this.height;
			
			panelTopEdge.x = panelTLCorner.width;
			//panelTopEdge.y = 0;
			panelTopEdge.width = this.width - panelTLCorner.width - panelTRCorner.width - BPanelWindow.SIZE_OFFSET;
			panelBottomEdge.x = panelBLCorner.width;
			panelBottomEdge.y = this.height;
			panelBottomEdge.width = this.width - panelBLCorner.width - panelBRCorner.width - BPanelWindow.SIZE_OFFSET;
			//panelLeftEdge.x = 0;
			panelLeftEdge.y = panelTLCorner.height;
			panelLeftEdge.height = this.height - panelTLCorner.height - panelBLCorner.height;
			panelRightEdge.x = this.width - BPanelWindow.SIZE_OFFSET;
			panelRightEdge.y = panelTRCorner.height;
			panelRightEdge.height = this.height - panelTRCorner.height - panelBRCorner.height;
			
			dragger.width = this.width - (panelLeftEdge.width + panelRightEdge.width) - BPanelWindow.SIZE_OFFSET;
			
			background.height = this.height;
			background.width = this.width - BPanelWindow.SIZE_OFFSET;
			
			closeBtn.x = this.width - closeBtn.width - panelRightEdge.width - BPanelWindow.SIZE_OFFSET;
			//closeBtn.y = 2; //panelTopEdge.height;
			windowBtn.x = closeBtn.x - windowBtn.width - 1;
			//windowBtn.y = 2;
			
			mk.width = this.width - (panelLeftEdge.width + panelRightEdge.width + 2) - BPanelWindow.SIZE_OFFSET;
			//mk.height = this.height - (panelTopEdge.height + panelBottomEdge.height + dragger.height + 4); // 
			mk.height = this.height - (panelTopEdge.height + panelBottomEdge.height);
			
			//_tabManager.update(this.width - BPanelWindow.SIZE_OFFSET - 10, this.height - 43 - 4);
			_tabManager.update();
			//trace("panel width: " + this.width + " \t| panel hieght" + this.height);
			
		} // end function resizeAlign
		
		
		// function setMinSize
		// set the minimum size of the panel.
		// this function sets the NativeWindow.minSize property and added an offset value,
		// making the actual minSize property larger than the assigned width and/or height.
		// this is because the minimum window size for windows is (132, X)
		protected function setMinSize(width:Number, height:Number):void
		{
			this.minSize.x = width + BPanelWindow.SIZE_OFFSET;
			this.minSize.y = height;
		} // end function setMinSize
		
		
		// function initializeCursorEvent
		// Set mouse event to change the cursor style based on the action that is being performed
		private function initializeCursorEvent():void
		{
			//dragger.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			//dragger.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			
			
			panelTLCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelTRCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelBLCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelBRCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelTopEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelBottomEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelRightEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			panelLeftEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
			
			panelTLCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelTRCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelBLCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelBRCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelTopEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelBottomEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelRightEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			panelLeftEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
		} // end function initializeCursorEvent
		
		
		// function changeCursor
		// Change the cursor based on the event type, and event target
		private function changeCursor(event:MouseEvent):void
		{
			
			if(event.type == MouseEvent.ROLL_OVER)
			{
				switch(event.currentTarget)
				{
					case dragger:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
					case panelTLCorner:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
					case panelTRCorner:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
					case panelTopEdge:
						Mouse.cursor = BMouseCursor.MOVE;
						break;
					
					case panelBLCorner:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_LEFT;
						break;
					
					case panelBRCorner:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM_RIGHT;
						break;
					
					case panelBottomEdge:
						Mouse.cursor = BMouseCursor.RESIZE_BOTTOM;
						break;
					
					case panelLeftEdge:
						Mouse.cursor = BMouseCursor.RESIZE_LEFT;
						break;
					
					case panelRightEdge:
						Mouse.cursor = BMouseCursor.RESIZE_RIGHT;
						break;
					
				}
			}
			else if(event.type == MouseEvent.ROLL_OUT)
				Mouse.cursor = MouseCursor.AUTO;
			
			
		} // end function changeCursor
		
		
		//*************************************** SET AND GET *****************************************
		
		// width
		/*override public function set width(value:Number):void
		{
			_width = value;
			super.width = value + BPanelWindow.SIZE_OFFSET;
		}
		
		override public function get width():Number
		{
			//return super.width;
			return _width;
		}
		
		// height
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		override public function get height():Number
		{
			return super.height;
		}*/
		
		// tabManager
		public function get tabManager():BTabManager
		{
			return _tabManager;
		}
		
		// resizable
		public function set resizable(value:Boolean):void
		{
			_resizable = value;
			
			if(value)
			{
				//panelTLCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				//panelTRCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBLCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBRCorner.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				//panelTopEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBottomEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelRightEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelLeftEdge.addEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				
				
				this.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
				this.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, resizeAlign);
				
				
				//panelTLCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				//panelTRCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBLCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBRCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				//panelTopEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBottomEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelRightEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelLeftEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				
				//panelTLCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				//panelTRCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBLCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBRCorner.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				//panelTopEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBottomEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelRightEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelLeftEdge.addEventListener(MouseEvent.ROLL_OUT, changeCursor);
			}
			else
			{
				//panelTLCorner.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				//panelTRCorner.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBLCorner.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBRCorner.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				//panelTopEdge.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelBottomEdge.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelRightEdge.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				panelLeftEdge.removeEventListener(MouseEvent.MOUSE_DOWN, resizeWindow);
				
				
				this.removeEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
				this.removeEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, resizeAlign);
				
				
				//panelTLCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				//panelTRCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBLCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBRCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				//panelTopEdge.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelBottomEdge.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelRightEdge.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelLeftEdge.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				
				//panelTLCorner.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				//panelTRCorner.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBLCorner.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBRCorner.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				//panelTopEdge.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelBottomEdge.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelRightEdge.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
				panelLeftEdge.removeEventListener(MouseEvent.ROLL_OUT, changeCursor);
			}
			
		}
		
		override public function get resizable():Boolean
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
				panelTLCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelTRCorner.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelTopEdge.addEventListener(MouseEvent.ROLL_OVER, changeCursor);
				
				panelTLCorner.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
				panelTRCorner.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
				panelTopEdge.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			}
			else
			{
				panelTLCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelTRCorner.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				panelTopEdge.removeEventListener(MouseEvent.ROLL_OVER, changeCursor);
				
				panelTLCorner.removeEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
				panelTRCorner.removeEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
				panelTopEdge.removeEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
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
		
		
		// attached
		/*public function set attached(value:Boolean):void
		{
			_attached = value;
			
			if(!value)
			{
				this.detachable = false;
			}
		}*/
		
		public function get attached():Boolean
		{
			return _attached;
		}
		
	}
	
}
