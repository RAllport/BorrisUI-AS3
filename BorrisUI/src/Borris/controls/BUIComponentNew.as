/* Author: Rohaan Allport
 * Date Created: 08/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The base Borris user interface component.
 * 
 * Todos: The invalidate/onInvalidate function has an error where it makes a new instance. making multiplye of the object
	 * 
 * 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	//import flash.geom.Rectangle;
	//import flash.utils.*;
	import flash.filters.*;
	
	import Borris.managers.BStyleManager;
	
	
	[Event(name="resize", type="flash.events.Event")]
	//[Event(name="draw", type="flash.events.Event")]
	
	public class BUIComponentNew extends Sprite
	{
		protected var initialized:Boolean = false;
		
		protected var _enabled:Boolean = true;
		protected var _focusEnabled:Boolean = true;
		protected var isFocused:Boolean =  false;
		protected var uiFocusRect:DisplayObject;
		//private var _focusManager:Boolean;
		private var _mouseFocusEnabled:Boolean;
		
		// x, y, height, width, scaleX, scaleY, visible, 
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		
		public function BUIComponentNew(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0):void
		{
			super();
			initialize();

			// Register for focus and keyboard events.
			if(tabEnabled) 
			{
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			} // end if
			
			move(x, y);
			//draw();
			
			// event handling
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if(parent != null)
			{
				parent.addChild(this);
			}
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function onAddedToStage
		// 
		protected function onAddedToStage(event:Event):void
		{
			//trace("BUIComponent | onAddedToStage().");
			if (!initialized)
			{
				initialize();
			}
			
			draw();
			//invalidate();
			//addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//BStyleManager.registerBUIComponent(this);
		} // function onAddedToStage
		
		
		// function onRemovedToStage
		// 
		protected function onRemovedFromStage(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			BStyleManager.unRegisterBUIComponent(this);
		} // end function onRemovedToStage
		
		
		// function focusInHandler
		// 
		protected function focusInHandler(event:FocusEvent):void 
		{
			//drawFocus(true);
			isFocused = true;
		} // end function focusInHandler
		
		
		// function focusOutHandler
		// 
		protected function focusOutHandler(event:FocusEvent):void 
		{
			//drawFocus(false);
			isFocused = false;
		} // end function focusOutHandler
		
		
		// function keyDownHandler
		// 
		protected function keyDownHandler(event:KeyboardEvent):void 
		{
			// You must override this function if your component accepts focus
		} // end function keyDownHandler
		
		
		// function keyUpHandler
		// 
		protected function keyUpHandler(event:KeyboardEvent):void 
		{
			// You must override this function if your component accepts focus
		} // end function keyUpHandler
		
		
		// function onInvalidate
		// 
		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		} // end function onInvalidate
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		// function initialize
		//
		protected function initialize():void
		{
			//trace("BUIComponent | initialize().");
			initialized = true;
			
		} // end function initialize
		
		
		// function draw
		// 
		protected function draw():void
		{
			// classes that extend UIComponent should deal with each possible invalidated property
			// common values include all, size, enabled, styles, state
			// draw should call super or validate when finished updating
			/*if(isInvalid(InvalidationType.SIZE, InvalidationType.STYLES)) 
			{
				if(isFocused && focusManager.showFocusIndicator) 
				{ 
					drawFocus(true); 
				}
			}
			validate();*/
			
			//dispatchEvent(new Event(Component.DRAW));
			
		} // end function draw
		
		
		// function invalidate
		// 
		protected function invalidate():void
		{
			//draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		} // end function invalidate
		
		
		// function drawNow
		// Initiates an immediate draw operation, without invalidating everything as invalidateNow does.
		public function drawNow():void
		{
			draw();
		} // end function drawNow
		
		
		// function drawFocus
		// Shows or hides the focus indicator on this component.
		/*public function drawFocus(focused:Boolean):void
		{
			isFocused = focused; // We need to set isFocused here since there are drawFocus() calls from FM.

			//Remove uiFocusRect if focus is turned off
			if (uiFocusRect != null && contains(uiFocusRect)) 
			{
				removeChild(uiFocusRect);
				uiFocusRect = null;
			}
			//Add focusRect to stage, and resize.  If component is focused.
			if (focused) 
			{
				uiFocusRect = getDisplayObjectInstance(getStyleValue("focusRectSkin")) as Sprite;
				if (uiFocusRect == null) 
				{ 
					return; 
				}
				var focusPadding:Number = Number(getStyleValue("focusRectPadding"));

				uiFocusRect.x = -focusPadding;
				uiFocusRect.y = -focusPadding;
				uiFocusRect.width = width + (focusPadding*2);
				uiFocusRect.height = height + (focusPadding*2);

				addChildAt(uiFocusRect, 0);
			}
		} // end function drawFocus*/
		
		
		// function getFocus
		// Retrieves the object that currently has focus.
		public function getFocus():InteractiveObject
		{
			if(stage) 
			{
				return stage.focus;
			}
			return null;
		} // end function getFocus
		
		
		// function move
		// Moves the component to the specified position within its parent.
		public function move(x:int, y:int):void
		{
			this.x = Math.round(x);
			this.y = Math.round(y);
			//dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
			
		} // end function move
		
		
		// function setFocus
		// Sets the focus to this component.
		public function setFocus():void
		{
			if(stage) 
			{
				stage.focus = this;
			}
		} // end function setFocus
		
		
		// function setSize
		// Sets the component to the specified width and height.
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			//draw();
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
			
		} // end function setSize
		
		
		
		//*************************************** SET AND GET **************************************
		
		// enabled
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = value;
			tabEnabled = tabChildren = value;
			// perhaps do a redraw ?
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		
		// focusEnabled
		public function set focusEnabled(value:Boolean):void
		{
			_focusEnabled = value;
		}
		
		public function get focusEnabled():Boolean
		{
			return _focusEnabled;
		}
		
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		// width
		override public function set width(value:Number):void
		{
			_width = Math.ceil(value);
			//draw();
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		// height
		override public function set height(value:Number):void
		{
			_height = Math.ceil(value);
			//draw();
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		// x
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		// y
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		
	}
	
	
	
}