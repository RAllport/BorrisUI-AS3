/* Author: Rohaan Allport
 * Date Created: 08/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The base Borris user interface component.
 * 
 * Todos:
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
	import flash.geom.Matrix;
	
	import Borris.display.BElement;
	import Borris.display.BStyle;
	import Borris.events.BStyleEvent;
	
	
	
	[Event(name="resize", type="flash.events.Event")]
	//[Event(name="draw", type="flash.events.Event")]
	
	
	//--------------------------------------
    //  Class description
    //--------------------------------------	
    /**
     *  The BUIComponent class is the base class for all visual components.
     */
	public class BUIComponent extends Sprite
	{
		// assets
		protected var uiFocusRect:DisplayObject;
		
		
		// other
		protected var isFocused:Boolean =  false;
		protected var initialized:Boolean = false;					// used to check if a component has been initailized
		protected var focusPadding:int = 3;
		
		
		// set and get 
		protected var _enabled:Boolean = true;
		protected var _focusEnabled:Boolean = true;					// 
		//private var _focusManager:Boolean;
		private var _mouseFocusEnabled:Boolean;					// (Doesn't do anything. not here nor in fl.core.UIComponent)
		
		protected var _width:Number = 0;							// Used for overriding and drawing.
		protected var _height:Number = 0;							// Used for overriding and drawing.
		
		protected var _style:BStyle;								// Used for styling.
		
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BUIComponent component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BUIComponent(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0):void
		{
			super();

			// Register for focus and keyboard events.
			/*tabEnabled = true;
			if(tabEnabled)  
			{
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			} // end if*/
			
			// testing
			focusEnabled = _focusEnabled;	// seems to be working
			uiFocusRect = new BElement(); 	// seems to be working
			/*BElement(uiFocusRect).style.backgroundColor = 0x000000;
			BElement(uiFocusRect).style.backgroundOpacity = 0;
			BElement(uiFocusRect).style.borderColor = 0x0099CC;
			BElement(uiFocusRect).style.borderWidth = 2;
			BElement(uiFocusRect).style.borderOpacity = 1;
			BElement(uiFocusRect).style.borderRadius = 8;*/
			
			
			move(x, y);
			//draw();
			
			
			if(parent != null)
			{
				parent.addChild(this);
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			_style = new BStyle(this);
			
			
			//addEventListener(BStyleEvent.CHANGE, styleChangeHandler);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * Initailizes the component when it is added to a stage. 
		 * Draws the component, and removes the Event.ADDED_TO_STAGE listener
		 */ 
		protected function onAddedToStage(event:Event):void
		{
			//trace("BUIComponent | onAddedToStage().");
			if (!initialized)
			{
				initialize();
			}
			//move();
			draw();
			//this.visible = true;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		} // function onAddedToStage
		
		
		/**
		 * 
		 * 
		 */ 
		protected function focusInHandler(event:FocusEvent):void 
		{
			if (event.target as DisplayObject == this)
			{
				drawFocus(true);
				isFocused = true;
				if (this.parent)
				{
					this.parent.setChildIndex(this, this.parent.numChildren -1);
				}
			}
			
		} // end function focusInHandler
		
		
		/**
		 * 
		 * 
		 */ 
		protected function focusOutHandler(event:FocusEvent):void 
		{
			drawFocus(false);
			isFocused = false;
		} // end function focusOutHandler
		
		
		/**
		 * 
		 * 
		 */ 
		protected function keyDownHandler(event:KeyboardEvent):void 
		{
			// You must override this function if your component accepts focus
		} // end function keyDownHandler
		
		
		/**
		 * 
		 * 
		 */ 
		protected function keyUpHandler(event:KeyboardEvent):void 
		{
			// You must override this function if your component accepts focus
		} // end function keyUpHandler
		
		
		/**
		 * Draws the component after being flagged as invalid.
		 * 
		 */ 
		protected function onInvalidate(event:Event):void
		{
			draw();
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
		} // end function onInvalidate
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Sets <code>initialized</code> variable to true.
		 */ 
		protected function initialize():void
		{
			//trace("BUIComponent | initialize().");
			initialized = true;
			
		} // end function initialize
		
		
		/**
		 * Draws the component.
		 */ 
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
			
			// dirty was of redrawing the style
			_style.backgroundColor = _style.backgroundColor;
			
		} // end function draw
		
		
		/**
		 * 
		 * @param focused
		 */
		protected function drawFocus(focused:Boolean):void
		{
			if (focused)
			{
				if (!uiFocusRect)
					return;
				
				uiFocusRect.x = -focusPadding;
				uiFocusRect.y = -focusPadding;
				uiFocusRect.width = _width + (focusPadding * 2);
				uiFocusRect.height = height + (focusPadding * 2);
				
				// using the super.addChildAt() ensure code does not break when overriding addChildAt()
				super.addChildAt(uiFocusRect, 0);
			}
			else
			{
				if (uiFocusRect && contains(uiFocusRect))
				{
					// using the super.removeChildAt() ensure code does not break when overriding removeChild()
					super.removeChild(uiFocusRect);
				}
			}
			
		} // end function drawFocus
		
		
		/**
         * Marks a property as invalid and redraws the component on the
         * next frame unless otherwise specified.
         */
		protected function invalidate():void
		{
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		} // end function invalidate
		
		
		// Initiates an immediate draw operation, without invalidating everything as <code>invalidateNow</code> does.
		/**
		 * Initiates an immediate draw operation.
		 * 
		 */ 
		public function drawNow():void
		{
			draw();
		} // end function drawNow
		
		
		/**
		 * Retrieves the object that currently has focus.
		 * 
		 */ 
		public function getFocus():InteractiveObject
		{
			if(stage) 
			{
				return stage.focus;
			}
			return null;
		} // end function getFocus
		
		
		/**
		 * Sets the focus to this component.
		 * 
		 */ 
		public function setFocus():void
		{
			if(stage) 
			{
				stage.focus = this;
			}
		} // end function setFocus
		
		
		/**
		 * Moves the component to the specified position within its parent.
		 * This has the same effect as changing the component location by setting its x and y properties. 
		 * Calling this method triggers the ComponentEvent.MOVE event to be dispatched.
		 * 
		 * @param x The x coordinate value that specifies the position of the component within its parent, 
		 * in pixels. This value is calculated from the left.
		 * @param y The y coordinate value that specifies the position of the component within its parent, 
		 * in pixels. This value is calculated from the top.
		 */ 
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
			//dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
			
		} // end function move
		
		
		/**
		 * Sets the component to the specified width and height.
		 * 
		 * @param width The width of the component, in pixels.
		 * @param height The height of the component, in pixels.
		 */ 
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			draw();
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
			
		} // end function setSize
		
		
		
		//**************************************** SET AND GET ******************************************
		
		/**
         * Gets or sets a value that indicates whether the component can accept user interaction.
         * A value of <code>true</code> indicates that the component can accept user interaction; 
		 * a value of <code>false</code> indicates that it cannot. 
         *
         * <p>If you set the <code>enabled</code> property to <code>false</code>, the color of the 
         * container is dimmed and user input is blocked (with the exception of the Label and ProgressBar components).</p>
         */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = value;
			tabEnabled = tabChildren = value;
			//value ? alpha = 1 : alpha = 0.5;
			alpha = value ? 1 : 0.5;
			// perhaps do a redraw ?
		}
		
		
		/**
         * Gets or sets a Boolean value that indicates whether the component can receive focus. 
		 * A value of <code>true</code> indicates that it can 
         * receive focus; a value of <code>false</code> indicates that it cannot.
         *
         * <p>If this property is <code>false</code>, focus is transferred to the first
         * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
         */
		public function get focusEnabled():Boolean
		{
			return _focusEnabled;
		}
		public function set focusEnabled(value:Boolean):void
		{
			_focusEnabled = value;
			if (value)
			{
				tabEnabled = true;
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			else
			{
				tabEnabled = false;
				removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
		
		/**
         * Gets or sets a Boolean value that indicates whether the component can receive focus 
         * after the user clicks it. A value of <code>true</code> indicates that it can 
         * receive focus; a value of <code>false</code> indicates that it cannot.
         *
         * <p>If this property is <code>false</code>, focus is transferred to the first
         * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
         */
		public function get mouseFocusEnabled():Boolean
		{
			return _mouseFocusEnabled;
		}
		public function set mouseFocusEnabled(value:Boolean):void
		{
			_mouseFocusEnabled = value;
		}
		
		
		/**
		 * Gets or sets the style for this component.
		 */
		public function get style():BStyle
		{
			return _style;
		}
		
		public function set style(value:BStyle):void
		{
			_style = value;
			_style.owner = this;
			_style.values = value.values;
			//dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE, this));
		}
		
		
		/**
		 * Sets the parent of the component.
		 */
		public function set parent(value:DisplayObjectContainer):void
		{
			if (parent)
				parent.removeChild(this);
			
			value.addChild(this);
		}
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		/**
		 * Gets or sets the width of the component, in pixels.
		 * 
		 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
		 */
		override public function get width():Number
		{
			return _width * scaleX;
			//return Math.max(_width, getBounds(this).width);
		}
		override public function set width(value:Number):void
		{
			_width = Math.ceil(value);
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		/**
		 * Gets or sets the height of the component, in pixels.
		 * 
		 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
		 */
		override public function get height():Number
		{
			return _height * scaleY;
			//return Math.max(_height, getBounds(this).height);
		}
		override public function set height(value:Number):void
		{
			_height = Math.ceil(value);
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		/**
		 * Gets or sets the x coordinate that represents the position of the component along the x axis within its parent container. 
		 * This value is described in pixels and is calculated from the left.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		
		/**
		 * Gets or sets the y coordinate that represents the position of the component along the y axis within its parent container. 
		 * This value is described in pixels and is calculated from the top.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		
		
	}
	
	
	
}