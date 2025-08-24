/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BScrollBar component provides the end user with a way to control the portion of data that is displayed when there is too much data to fit in the display area.
 * 	
 * The ScrollBar component provides the end user with a way to control the portion of data that is displayed when there is too much data to fit in the display area. 
 * The scroll bar consists of four parts: two arrow buttons, a track, and a thumb. The position of the thumb and display of the buttons depends on the current 
 * state of the scroll bar. The scroll bar uses four parameters to calculate its display state: a minimum range value; a maximum range value; a current position 
 * that must be within the range values; and a viewport size that must be equal to or less than the range and represents the number of items in the range that can 
 * be displayed at the same time.
 * 
 *	todo/imporovemtns: 
 * - 
 * - 
 * 
*/


package Borris.controls 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*
	import flash.text.*;
	import flash.geom.Rectangle;
	import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.assets.icons.*;
	
	public class BScrollBar extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var thumbIcon:Sprite;					// 
		protected var upArrow:BButton;					// 
		protected var downArrow:BButton;				// 
		protected var thumb:BBaseButton;				// The the draggable part of the scroll bar
		protected var track:BBaseButton;				// The back or the scroll bar. The area where the thumb can slide
		
		protected var upArrowIcon:Sprite;				
		protected var downArrowIcon:Sprite;				
		
		
		// other
		protected var trackWidth:int;
		protected var trackHeight:int;
		//protected var thumbWidth:int;
		//protected var thumbHeight:int;
		protected var thumbPercent:Number = 1;			// The size if the thumb in terms of percentage to the height/width
		protected var delayTimer:Timer;					// The Timer use to timer when the scroll bar is to hide.
		protected var thumbUpdateX:Number = 0;			// Required for tweening
		protected var thumbUpdateY:Number = 0;			// Required for tweening
		
		protected var repeatDelay:Timer;				// The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.
		protected var repeatInterval:Timer;				// The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay.
		protected var direction:String;
		
		// set and get
		protected var _lineScrollSize:Number = 0.2;		// Gets or sets a value that represents the increment by which to scroll the page when the scroll bar track is pressed.
		protected var _maxScrollPosition:Number;		// Gets or sets a number that represents the maximum scroll position.
		protected var _minScrollPosition:Number;		// Gets or sets a number that represents the minimum scroll position.
		protected var _orientation:String;				// Gets or sets a value that indicates whether the scroll bar scrolls horizontally or vertically.
		protected var _pageScrollSize:Number;			// Gets or sets a value that represents the increment by which the page is scrolled when the scroll bar track is pressed.
		protected var _pageSize:Number;					// Gets or sets the number of lines that a page contains.
		protected var _scrollPosition:Number = 0;		// Gets or sets the current scroll position and updates the position of the thumb.
		protected var _scrollTarget:TextField;			// Registers a TextField instance with the ScrollBar component instance.
		
		protected var _autoHide:Boolean = true;			// Get or set whether this scroll bar should auto hide after a giving time.
		protected var _hideDelay:int = 2000;			// Get or set the time it take for the scroll bar to hide.
		
		protected var _scrollBarMode:String = "all";	// Gets or sets the mode of the scroll bat. 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BSrollBar component instance.
		 * 
         * @param orientation The orientation of the slider. Either horizontal or vertial 
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BScrollBar(orientation:String = BScrollBarOrientation.VERTICAL, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) 
		{
			// constructor code
			_orientation = orientation;
			
			super(parent, x, y);
			initialize();
			//setSize(100, 20);
			draw();
			
		}
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * When the trace is clicked the thumb and scroll position changes.
		 * There should be a repeatTime and repeatDelay to adjust how fast it scrolls
		 * 
		 * @param event
		 */
		protected function onTrackMouseDown(event:MouseEvent):void
		{
			//trace("on track down");
			
			if (_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				if (this.mouseX < thumb.x + thumb.width/2)
				{
					direction = "up";
					doScroll(direction);
				}
				else if (this.mouseX > thumb.x + thumb.width/2)
				{
					direction = "down";
					doScroll(direction);
				}
			}
			else if (_orientation == BScrollBarOrientation.VERTICAL)
			{
				if (this.mouseY < thumb.y + thumb.height/2)
				{
					direction = "up";
					doScroll(direction);
				}
				else if (this.mouseY > thumb.y + thumb.height/2)
				{
					direction = "down";
					doScroll(direction);
				}
			}
			
			
			// start the repeate delay timer
			repeatDelay.start();
			
			// add an event listener to listen for when the mouse is up
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			
			// dispatch a new change event
			dispatchEvent(new Event(Event.CHANGE));
			
		} // end function onTrackMouseDown
		
		
		/**
		 * When the mounse is held down on the thumb, the user is able to drag it.
		 * in a range from the top for the track to the bottom of the track
		 * 
		 * @param	event
		 */
		protected function onThumbDown(event:MouseEvent):void
		{
			if (_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				thumb.startDrag(false, new Rectangle(_minScrollPosition, 0, _maxScrollPosition, 0)); 
			}
			else if (_orientation == BScrollBarOrientation.VERTICAL)
			{
				thumb.startDrag(false, new Rectangle(0, _minScrollPosition, 0, _maxScrollPosition)); 
			}
			
			// add an event listen
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateValue);
		} // end function onThumbDown
		
		
		/**
		 * Stops the thumb dragging
		 * called when the user releases the thumb (the stage actually)
		 * 
		 * @param	event
		 */
		protected function stopDragging(event:MouseEvent):void
		{
			thumb.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateValue);
		} // end function stopDragging
		
		
		/**
		 * Updates the value of the scrollPosition (for scroll panes) and the scroll target scroll (for text fields)
		 * called during onClickScrollButton() 
		 * 
		 * @param	event
		 */
		protected function updateValue(event:MouseEvent = null):void
		{
			if (event) // for tweening 
			{
				thumbUpdateX = thumb.x;
				thumbUpdateY = thumb.y;
			}
			
			if (_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				//_scrollPosition = (thumb.x - _minScrollPosition) / _maxScrollPosition;
				_scrollPosition = (thumbUpdateX - _minScrollPosition) / _maxScrollPosition;
				if (_scrollTarget && event) // for textFields
				{
					_scrollTarget.scrollH = Math.ceil(_scrollPosition * _scrollTarget.maxScrollH);
				}
			}
			else if (_orientation == BScrollBarOrientation.VERTICAL)
			{
				//_scrollPosition = (thumb.y - _minScrollPosition) / _maxScrollPosition;
				_scrollPosition = (thumbUpdateY - _minScrollPosition) / _maxScrollPosition;
				
				if (_scrollTarget && event) // for textFields
				{
					_scrollTarget.scrollV = Math.ceil(_scrollPosition * _scrollTarget.maxScrollV);
				}
			}
			
			// dispatch a new change event
			dispatchEvent(new Event(Event.CHANGE));
		} // end function updateValue
		
		
		/**
		 * Calls doScroll() and passes in "up" or "down" based on the button pressed.
		 * Called when a button is clicked (add functionality for holding down)
		 * 
		 * @param	event
		 */
		protected function onMouseDownScrollButton(event:MouseEvent):void
		{
			if (event.currentTarget == upArrow)
			{
				direction = "up";
			}
			else if (event.currentTarget == downArrow)
			{
				direction = "down";
			}
			
			doScroll(direction);
			
			// start the repeate delay timer
			repeatDelay.start();
			
			// add an event listener to listen for when the mouse is up
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			
		} // end function onMouseDownScrollButton
		
		
		/**
		 * Used for stopping continuous scrolling
		 * Called when the mouse is held up
		 * 
		 * @param	event
		 */
		protected function onReleaseMouse(event:MouseEvent):void
		{
			repeatDelay.stop();
			repeatDelay.reset();
			
			repeatInterval.stop();
			repeatInterval.reset();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			
		} // end function onReleaseButtonOrTrack
		
		
		/**
		 * Starts a timer to hide the scroll bar after a giving time
		 * Called when the mouse rolls off the scroll bar
		 * 
		 * @param	event
		 */
		protected function autoHideMouseHandler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, autoHideMouseRollOverHandler);
			
			if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				delayTimer.addEventListener(TimerEvent.TIMER, autoHideTimerHandler);
				delayTimer.reset();
				delayTimer.start();
			}
			
		} // end function autoHideMouseHandler
		
		
		/**
		 * Hides the scroll bar 
		 * Called after a giving time after the mouse rolled off the scroll bar
		 * 
		 * @param	event
		 */
		protected function autoHideTimerHandler(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER, autoHideTimerHandler);
			var tween:Tween = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.3, true);
		} // end function autoHideTimerHandler
		
		
		/**
		 * Shows the scroll bar
		 * Called when the mouse rolls of the scroll bar
		 * 
		 * @param event
		 */
		protected function autoHideMouseRollOverHandler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OVER, autoHideMouseRollOverHandler);
			delayTimer.removeEventListener(TimerEvent.TIMER, autoHideTimerHandler);
			
			var tween:Tween = new Tween(this, "alpha", Regular.easeOut, this.alpha, 1, 0.3, true);
		} // end function autoHideMouseRollOverHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function repeatDelayCompleteHandler(event:TimerEvent):void
		{
			repeatInterval.start();
		} // end function repeatDelayCompleteHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function repeatIntervalTimerHandler(event:TimerEvent):void
		{
			doScroll(direction);
		} // end function repeatIntervalTimerHandler
		
		
		//************************************* FUNCTIONS ******************************************
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			
			
			// initialize the assets
			//thumbIcon = new Sprite();
			track = new BBaseButton(this);
			upArrow = new BButton(this);
			downArrow = new BButton(this);
			thumb = new BBaseButton(this);
			
			
			
			// add assets to respective containers
			
			
			// initialize buttons
			thumb.setStateColors(0x999999, 0x999999, 0xCCCCCC, 0x111111);
			thumb.setStateAlphas(0.5, 1, 1, 1, 1, 1, 1, 1);
			
			track.setStateColors(0x666666, 0x666666, 0x666666, 0x666666);
			track.setStateAlphas(0.5, 1, 1, 1, 1, 1, 1, 1);
			
			upArrow.setSize(14, 14);
			downArrow.setSize(14, 14);
			upArrow.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
			downArrow.setStateColors(0x000000, 0x999999, 0xCCCCCC, 0x000000);
			upArrow.setStateAlphas(0, 1, 1, 1, 0, 1, 1, 1);
			downArrow.setStateAlphas(0, 1, 1, 1, 0, 1, 1, 1);
			
			
			// icons
			upArrowIcon = new ArrowIcon32x32();
			downArrowIcon = new ArrowIcon32x32();
			upArrowIcon.width = 10;
			upArrowIcon.height = 10;
			downArrowIcon.width = 10;
			downArrowIcon.height = 10;
			downArrowIcon.rotation = 180;
			
			upArrow.icon = upArrowIcon;
			downArrow.icon = downArrowIcon;
			
			
			// 
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = true;
			
			// prevent the track from coming infront the other assets
			track.tabEnabled = false;
			
			//
			autoHide = true;
			
			// timers
			delayTimer = new Timer(_hideDelay);
			repeatDelay = new Timer(500, 1);
			repeatInterval = new Timer(50);
			
			
			// checking to see if the orientation property is set to horizontal or vertical, or neither
			if(_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				setSize(200, 14);
				trackWidth = _width;
				trackHeight = 14;
				
			}
			else if(BScrollBarOrientation.VERTICAL)
			{
				setSize(14, 200);
				trackWidth = 14;
				trackHeight = _height;
				
			}
			else
			{
				setSize(200, 14);
				_orientation = BScrollBarOrientation.HORIZONTAL;
				trackWidth = _width;
				trackHeight = 14;
				throw new Error("The BScrollBarOrientation.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
			}
			
			
			// event handling
			track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			upArrow.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownScrollButton);
			downArrow.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownScrollButton);
			
			repeatDelay.addEventListener(TimerEvent.TIMER_COMPLETE, repeatDelayCompleteHandler);
			repeatInterval.addEventListener(TimerEvent.TIMER, repeatIntervalTimerHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			var thumbWidth:int = 14;
			var thumbHeight:int = 14;
			
			// checking to see if the orientation property is set to horizontal or vertical, or neither
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				thumb.x = 14;
				thumb.y = 0;
				
				trackWidth = _width;
				trackHeight = 14;
				
				// set the thumb with and height
				if (_scrollTarget)
				{
					thumbPercent = _scrollTarget.width / _scrollTarget.textWidth;
				}
				thumbWidth = Math.round((_width - 14 * 2) * thumbPercent);
				thumbWidth = Math.max(trackHeight, thumbWidth);
				thumbHeight = trackHeight;
				
				// 
				_minScrollPosition = 14;
				_maxScrollPosition = _width - thumbWidth - 14 * 2;
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				thumb.x = 0;
				thumb.y = 14;
				
				trackWidth = 14;
				trackHeight = _height;
				
				// set the thumb with and height
				thumbWidth = trackWidth;
				if (_scrollTarget)
				{
					thumbPercent = _scrollTarget.height / _scrollTarget.textHeight;
				}
				thumbHeight = Math.round((_height - 14 * 2) * thumbPercent);
				thumbHeight = Math.max(trackWidth, thumbHeight);
				
				// 
				_minScrollPosition = 14;
				_maxScrollPosition = _height - thumbHeight - 14 * 2;
			}
			
			// draw track
			
			
			// draw upArrow
			
			
			// draw downArrow
			
			
			upArrow.setSize(14, 14);
			downArrow.setSize(14, 14);
			thumb.setSize(thumbWidth, thumbHeight);
			track.setSize(trackWidth, trackHeight);
			
			
			if (_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				//upArrow.move(0, 0);
				//downArrow.move(_width - downArrow.width, 0);
				
				upArrow.move(0, upArrow.height);
				downArrow.move(_width - downArrow.width, downArrow.height);
				upArrow.rotation = -90;
				downArrow.rotation = -90;
			}
			else if (_orientation == BScrollBarOrientation.VERTICAL)
			{
				upArrow.move(0, 0);
				downArrow.move(0, _height - downArrow.height);
				upArrow.rotation = 0;
				downArrow.rotation = 0;
			}
			
			if (thumbPercent == 1)
			{
				visible = false;
			}
			else
			{
				visible = true;
			}
			
		} // end function draw
		
		
		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 */
		protected function positionThumb():void
		{
			/*
			if(_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				
			}
			else if(_orientation == BScrollBarOrientation.VERTICAL)
			{
				
			}*/
		} // end function positionThumb
		
		
		/**
		 * Used the adjusting the size fo the thumb in terms of a percentage
		 * Called in a displayObjectContainer such as a BscrollPane
		 * 
		 * @param value
		 */
		public function setThumbPercent(value:Number):void
		{
			thumbPercent = Math.min(value, 1.0);
			invalidate();
		} // end function setThumbPercent
		
		
		/**
		 * Changes the position of the thumb.
		 * changes the scroll target scroll (for textfields)
		 * calls updateValue()
		 * Called when the buttons are clicked, held down or the track is held down
		 * 
		 * @param direction
		 */
		public function doScroll(direction:String):void
		{
			// removed tweening because of scrolling when track is down.
			
			var percent:Number;				// used for positioning the thumb
			var tween:Tween;
			
			if (_orientation == BScrollBarOrientation.HORIZONTAL)
			{
				if (_scrollTarget) // for scrolling text fields
				{
					_scrollTarget.scrollH += (direction == "up") ? -10 : 10;
					percent = (_scrollTarget.scrollH - 1) / (_scrollTarget.maxScrollH - 1);
				}
				else if (_lineScrollSize) // for scrolling display objects
				{
					percent = (thumb.x - _minScrollPosition) / _maxScrollPosition;
					percent += (direction == "up") ? -_lineScrollSize : _lineScrollSize;
					if (percent < 0)
					{
						percent = 0;
					}
					else if (percent > 1)
					{
						percent = 1;
					}
				}
				
				thumb.x = percent * _maxScrollPosition + 14;
				thumbUpdateX = percent * _maxScrollPosition + 14;
				//tween = new Tween(thumb, "x", Regular.easeInOut, thumb.x, (percent * _maxScrollPosition + 14), 0.3, true);
			}
			else if (_orientation == BScrollBarOrientation.VERTICAL)
			{
				if (_scrollTarget) // for scrolling text fields
				{
					_scrollTarget.scrollV += (direction == "up") ? -1 : 1;
					percent = (_scrollTarget.scrollV - 1) / (_scrollTarget.maxScrollV - 1);
				}
				else if (_lineScrollSize) // for scrolling display objects
				{
					percent = (thumb.y - _minScrollPosition) / _maxScrollPosition;
					percent += (direction == "up") ? -_lineScrollSize : _lineScrollSize;
					if (percent < 0)
					{
						percent = 0;
					}
					else if (percent > 1)
					{
						percent = 1;
					}
				}
				
				thumb.y = percent * _maxScrollPosition + 14;
				thumbUpdateY = percent * _maxScrollPosition + 14;
				//tween = new Tween(thumb, "y", Regular.easeInOut, thumb.y, (percent * _maxScrollPosition + 14), 0.3, true); // 
			} // end if
			
			// 
			updateValue();
			
		} // end function doScroll
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * Gets or sets a value that represents the increment by which to scroll the page when the scroll bar track is pressed. 
		 * The pageScrollSize is measured in increments between the minScrollPosition and the maxScrollPosition values. 
		 * If this value is set to 0, the value of the pageSize property is used.
		 * 
		 * @default 0
		 */
		public function get lineScrollSize():Number
		{
			return _lineScrollSize;
		}
		public function set lineScrollSize(value:Number):void
		{
			_lineScrollSize = value;
		}
		
		
		/**
		 * Gets or sets a number that represents the maximum scroll position. 
		 * The scrollPosition value represents a relative position between the minScrollPosition and the maxScrollPosition values. 
		 * This property is set by the component that contains the scroll bar, and is the maximum value. 
		 * Usually this property describes the number of pixels between the bottom of the component and the bottom of the content, 
		 * but this property is often set to a different value to change the behavior of the scrolling. 
		 * For example, the TextArea component sets this property to the maxScrollH value of the text field, 
		 * so that the scroll bar scrolls appropriately by line of text.
		 * 
		 * @default 10
		 */
		public function get maxScrollPosition():Number
		{
			return _maxScrollPosition;
		}
		public function set maxScrollPosition(value:Number):void
		{
			_maxScrollPosition = value;
		}
		
		
		/**
		 * Gets or sets a number that represents the minimum scroll position. 
		 * The scrollPosition value represents a relative position between the minScrollPosition and the maxScrollPosition values. 
		 * This property is set by the component that contains the scroll bar, and is usually zero.
		 * 
		 * @default 0
		 */
		public function get minScrollPosition():Number
		{
			return _minScrollPosition;
		}
		public function set minScrollPosition(value:Number):void
		{
			_minScrollPosition = value;
		}
		
		
		/**
		 * Gets or sets a value that indicates whether the scroll bar scrolls horizontally or vertically. 
		 * Valid values are BScrollBarOrientation.HORIZONTAL and BScrollBarOrientation.VERTICAL.
		 */
		public function get orientation():String
		{
			return _orientation;
		}
		public function set orientation(value:String):void
		{
			var prevOrientation:String = _orientation; 	// a temporary variable to hold the previous orientation
			//var prevWidth:Number = _width;				// a temporary variable to hold the previous width
			//var prevHeight:Number = _height;			// a temporary variable to hold the previous height
			
			_orientation = value;
			
			// determine the new orrientation and swap the width and height
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				prevOrientation == BSliderOrientation.HORIZONTAL ? setSize(_width, _height) : setSize(_height, _width);
			}
			else if(BSliderOrientation.VERTICAL)
			{
				prevOrientation == BSliderOrientation.VERTICAL ? setSize(_width, _height) : setSize(_height, _width);
			}
			else
			{
				setSize(_width, _height);
				_orientation = BSliderOrientation.HORIZONTAL;
				throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
			}
			
			invalidate();
		}
		
		
		/**
		 * Gets or sets a value that represents the increment by which the page is scrolled when the scroll bar track is pressed. 
		 * The pageScrollSize value is measured in increments between the minScrollPosition and the maxScrollPosition values. 
		 * If this value is set to 0, the value of the pageSize property is used.
		 * 
		 * @default 0
		 */
		public function get pageScrollSize():Number
		{
			return _pageScrollSize;
		}
		public function set pageScrollSize(value:Number):void
		{
			_pageScrollSize = value;
		}
		
		
		/**
		 * Gets or sets the number of lines that a page contains. 
		 * The lineScrollSize is measured in increments between the minScrollPosition and the maxScrollPosition. 
		 * If this property is 0, the scroll bar will not scroll.
		 * 
		 * @default 10;
		 */
		public function get pageSize():Number
		{
			return _pageSize;
		}
		public function set pageSize(value:Number):void
		{
			_pageSize = value;
		}
		
		
		/**
		 * Gets or sets the current scroll position and updates the position of the thumb. 
		 * The scrollPosition value represents a relative position between the minScrollPosition and maxScrollPosition values.
		 * 
		 * @default 0
		 */
		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}
		public function set scrollPosition(value:Number):void
		{
			_scrollPosition = value;
			//invalidate();
		}
		
		
		/**
		 * Registers a TextField instance or a TLFTextField instance with the ScrollBar component instance.
		 */
		public function get scrollTarget():TextField
		{
			return _scrollTarget
		}
		public function set scrollTarget(value:TextField):void
		{
			_scrollTarget = value;
			invalidate();
		}
		
		
		/**
		 * 
		 */
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			
			if (value)
			{
				this.addEventListener(MouseEvent.ROLL_OUT, autoHideMouseHandler);
				this.addEventListener("releaseOutside", autoHideMouseHandler);
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OUT, autoHideMouseHandler);
				this.removeEventListener("releaseOutside", autoHideMouseHandler);
			}
			
		}
		
		
		/**
		 * 
		 */
		public function get hideDelay():int
		{
			return _hideDelay;
		}
		public function set hideDelay(value:int):void
		{
			_hideDelay = value;
			delayTimer.delay = _hideDelay;
		}
		
		
		/**
		 * 
		 */
		public function get scrollBarMode():String
		{
			return _scrollBarMode;
		}
		public function set scrollBarMode(value:String):void
		{
			switch(value)
			{
				case BScrollBarMode.ALL:
					track.visible = true;
					thumb.visible = true;
					upArrow.visible = true;
					downArrow.visible = true;
					break;
				
				case BScrollBarMode.BUTTONS_ONLY:
					track.visible = false;
					thumb.visible = false;
					upArrow.visible = true;
					downArrow.visible = true;
					break;
					
				case BScrollBarMode.SLIDER_ONLY:
					track.visible = true;
					thumb.visible = true;
					upArrow.visible = false;
					downArrow.visible = false;
					break;
				
				
				default:
					track.visible = true;
					thumb.visible = true;
					upArrow.visible = true;
					downArrow.visible = true;
				
			}
			
			_scrollBarMode = value;
			
		}
		
		
	}

}