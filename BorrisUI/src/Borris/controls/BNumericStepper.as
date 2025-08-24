/* Author: Rohaan Allport
 * Date Created: 11/04/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls 
{
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	import Borris.assets.icons.*;
	
	
	
	public class BNumericStepper extends BUIComponent 
	{
		// assets
		protected var inputText:BTextInput;
		protected var upButton:BButton;
		protected var downButton:BButton;
		protected var percentageText:TextField;
		
		
		// style
		protected var color:uint;
		protected var textColor:uint;
		protected var borderThickness:int;
		protected var borderColor:uint;
		
		
		
		// other
		protected var repeatDelay:Timer;				// The number of milliseconds to wait after the buttonDown event is first dispatched before sending a second buttonDown event.
		protected var repeatInterval:Timer;				// The interval, in milliseconds, between buttonDown events that are dispatched after the delay that is specified by the repeatDelay.
		protected var direction:String;
		
		// set and get
		protected var _maxChars:int = 0;						// The maximum number of characters that can be entered in the field. A value of 0 means that any number of characters can be entered.
		protected var _maximum:Number = 10;						// Maximum value of the NumericStepper.
		protected var _minimum:Number = 0;						// Minimum value of the NumericStepper.
		protected var _nextValue:Number = 1;					// [read-only] The value that is one step larger than the current value property and not greater than the maximum property value.
		protected var _previousValue:Number = 0;				// [read-only] The value that is one step smaller than the current value property and not smaller than the maximum property value.
		protected var _stepSize:Number = 1;						// Non-zero unit of change between values.
		protected var _value:Number = 0;						// Current value displayed in the text area of the NumericStepper control.
		
		protected var _buttonPlacement:String = "left";			// 
		protected var _mode:String = "normal";					// 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BNumericStepper component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
         */
		public function BNumericStepper(parent:DisplayObjectContainer=null, x:Number=0, y:Number=0) 
		{
			super(parent, x, y);
			initialize();
			setSize(100, 30);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function mouseDownHandler
		// 
		protected function mouseDownHandler(event:MouseEvent = null):void 
		{
			if (event.currentTarget == upButton)
			{
				direction = "increment";
			}
			else if (event.currentTarget == downButton)
			{
				direction = "decrement";
			}
			
			incrementOrDecrement(direction);
			
			// start the repeate delay timer
			repeatDelay.start();
			
			// add an event listener to listen for when the mouse is up
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			
			dispatchEvent(new Event(Event.CHANGE, false, false));
		} // end function mouseDownHandler
		
		
		// function inputTextChangeHander
		// 
		protected function inputTextChangeHandler(event:Event):void
		{
			var tempValue:Number = Number(inputText.text);
			
			if (tempValue >= _minimum && tempValue <= _maximum)
			{
				_value = tempValue;
			}
			
			validateValues();
			trace("BNumericStepper | value: " + _value);
			trace("BNumericStepper | next value: " + _nextValue);
			trace("BNumericStepper | prev value: " + _previousValue);
			
			dispatchEvent(new Event(Event.CHANGE, false, false));
		} // end function inputTextChangeHander
		
		
		// function onReleaseButtonOrTrack
		// Used for stopping continuous scrolling
		// Called when the mouse is held up
		protected function onReleaseMouse(event:MouseEvent):void
		{
			repeatDelay.stop();
			repeatDelay.reset();
			
			repeatInterval.stop();
			repeatInterval.reset();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			
		} // end function onReleaseButtonOrTrack
		
		
		// function repeatDelayCompleteHandler
		// 
		protected function repeatDelayCompleteHandler(event:TimerEvent):void
		{
			repeatInterval.start();
		} // end function repeatDelayCompleteHandler
		
		
		// function repeatIntervalTimerHandler
		// 
		protected function repeatIntervalTimerHandler(event:TimerEvent):void
		{
			incrementOrDecrement(direction);
			
			dispatchEvent(new Event(Event.CHANGE, false, false));
		} // end function repeatIntervalTimerHandler
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize assets
			
			// 
			inputText = new BTextInput(this, 0, 0, _value.toString());
			inputText.restrict = "1234567890";
			
			// 
			upButton = new BButton(this, 0, 0);
			downButton = new BButton(this, 0, 0);
			
			// icons
			upButton.icon = new ArrowIcon10x5();
			downButton.icon = new ArrowIcon10x5();
			downButton.icon.rotation = 180;
			//upButton.icon = new AddIcon32x32();
			//downButton.icon = new MinusIcon32x32();
			
			// percentage text
			percentageText = new TextField();
			percentageText.text = "%";
			percentageText.autoSize = TextFieldAutoSize.RIGHT;
			percentageText.setTextFormat(inputText.textField.getTextFormat());
			percentageText.defaultTextFormat = inputText.textField.getTextFormat();
			percentageText.height = inputText.textField.height;
			percentageText.selectable = false;
			addChild(percentageText);
			percentageText.visible = (_mode == BNumericStepperMode.PERCENTAGE);
			
			
			// timers
			repeatDelay = new Timer(500, 1);
			repeatInterval = new Timer(50);
			
			
			// draw the Numeric stepper
			draw();
			
			
			// event handling
			upButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			downButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			inputText.addEventListener(Event.CHANGE, inputTextChangeHandler);
			
			repeatDelay.addEventListener(TimerEvent.TIMER_COMPLETE, repeatDelayCompleteHandler);
			repeatInterval.addEventListener(TimerEvent.TIMER, repeatIntervalTimerHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			var textHeight:int = 30;
			var buttonWidth:int = 30;
			
			// set the width and height of the text input
			inputText.width = _width - buttonWidth;
			inputText.height = _height;
			
			
			
			// set the width, height and positions of the buttons
			upButton.icon.rotation = 0;
			downButton.icon.rotation = 180;
				
			
			if (_buttonPlacement == BNumericStepperButtonPlacement.TOP)
			{
				_height = 60;
				
				inputText.x = 0;
				inputText.y = _height/2;
				inputText.width = _width;
				inputText.height = _height/2;
				
				upButton.width = _width;
				upButton.height = _height / 4;
				upButton.x = 0;
				upButton.y = 0;
				
				downButton.width = _width;
				downButton.height = _height / 4;
				downButton.x = 0;
				downButton.y = upButton.height;
				
			}
			else if (_buttonPlacement == BNumericStepperButtonPlacement.BOTTOM)
			{
				_height = 60;
				
				inputText.x = 0;
				inputText.y = 0;
				inputText.width = _width;
				inputText.height = _height/2;
				
				upButton.width = _width;
				upButton.height = _height / 4;
				upButton.x = 0;
				upButton.y = inputText.y + inputText.height;
				
				downButton.width = _width;
				downButton.height = _height / 4;
				downButton.x = 0;
				downButton.y = upButton.y + upButton.height;
				
			}
			else if (_buttonPlacement == BNumericStepperButtonPlacement.LEFT)
			{
				_height = 30;
				
				inputText.x = 0;
				inputText.y = 0;
				inputText.width = _width - buttonWidth;
				inputText.height = _height;
				
				upButton.width = buttonWidth;
				upButton.height = _height / 2;
				upButton.x = _width - upButton.width;
				upButton.y = 0;
				
				downButton.width = buttonWidth;
				downButton.height = _height/2;
				downButton.x = _width - downButton.width;
				downButton.y = _height / 2;
				
			}
			else if (_buttonPlacement == BNumericStepperButtonPlacement.RIGHT)
			{
				_height = 30;
				
				inputText.x = buttonWidth;
				inputText.y = 0;
				inputText.width = _width - buttonWidth;
				inputText.height = _height;
				
				upButton.width = buttonWidth;
				upButton.height = _height / 2;
				upButton.x = 0;
				upButton.y = 0;
				
				downButton.width = buttonWidth;
				downButton.height = _height/2;
				downButton.x = 0;
				downButton.y = _height / 2;
				
			}
			else if (_buttonPlacement == BNumericStepperButtonPlacement.VERTICAL)
			{
				_height = 60;
				
				inputText.x = 0;
				inputText.y = _height/4;
				inputText.width = _width;
				inputText.height = _height/2;
				
				upButton.width = _width;
				upButton.height = _height/4;
				upButton.x = 0;
				upButton.y = 0;
				
				downButton.width = _width;
				downButton.height = _height/4;
				downButton.x = 0;
				downButton.y = _height * 3/4;
				
			}
			else if (_buttonPlacement == BNumericStepperButtonPlacement.HORIZONTAL)
			{
				_height = 30;
				
				inputText.x = buttonWidth;
				inputText.y = 0;
				inputText.width = _width - buttonWidth * 2;
				inputText.height = _height;
				
				upButton.width = buttonWidth;
				upButton.height = _height;
				upButton.x = inputText.x + inputText.width;
				upButton.y = 0;
				
				downButton.width = buttonWidth;
				downButton.height = _height;
				downButton.x = 0;
				downButton.y = 0;
				
				upButton.icon.rotation = 90;
				downButton.icon.rotation = -90;
			}
			
			upButton.icon.x = upButton.width / 2;
			upButton.icon.y = upButton.height / 2;
			downButton.icon.x = downButton.width / 2;
			downButton.icon.y = downButton.height / 2;
			
			/*upButton.icon.width = upButton.icon.height = 16;
			downButton.icon.width = downButton.icon.height = 16;
			upButton.icon.x = upButton.width / 2 - upButton.icon.width/2;
			upButton.icon.y = upButton.height / 2 - upButton.icon.height/2;
			downButton.icon.x = downButton.width / 2 - downButton.icon.width/2;
			downButton.icon.y = downButton.height / 2 - downButton.icon.height/2;
			upButton.icon.rotation = 0;
			downButton.icon.rotation = 0;*/
			
			percentageText.setTextFormat(inputText.textField.getTextFormat());
			percentageText.defaultTextFormat = inputText.textField.getTextFormat();
			percentageText.height = inputText.textField.height;
			percentageText.x = inputText.x + inputText.width - percentageText.width;
			percentageText.y = inputText.y + inputText.textField.y;
			
			
			
			// 
			validateValues();
			
			// update the text of the TextInput
			updateTextInput();
			
		} // end function draw
		
		
		/**
		 * updates the text of the text input
		 */
		protected function updateTextInput():void
		{
			inputText.text = _value.toString();
		} // end function updateValue
		
		
		/**
		 * Makes sure that value, nextValue, previousValue is not geater than or less then maximum and minimum.
		 * Called during draw(), mouseClickHandler(), inputTextChangeHandler(), set value(), set maximum(), set minimum(), and set stepSize();
		 */
		 private function validateValues():void
		{
			// make sure value is not above maximum and not below minimum
			if (_value > _maximum) { _value = _maximum };
			if (_value < _minimum) { _value = _minimum };
			
			// set next value and previous value
			_nextValue = _value + _stepSize;
			_previousValue = value - _stepSize;
			
			// 
			if (_nextValue > _maximum) { _nextValue = _maximum };
			if (_previousValue < _minimum) { _previousValue = _minimum };
			
		} //  end function validateValues
		
		
		/**
		 * 
		 * @param direction
		 */
		private function incrementOrDecrement(direction:String):void
		{
			if (direction == "increment")
			{
				_value += _stepSize;
			}
			else if (direction == "decrement")
			{
				_value -= _stepSize;
			}
			
			validateValues();
			updateTextInput();
			
		} // end function incrementOrDecrement
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * Gets or sets the maximum number of characters that a user can enter in the text field.
		 */
		public function get maxChars():int
		{
			return _maxChars;
		}
		public function set maxChars(value:int):void
		{
			_maxChars = value;
			inputText.maxChars = value;
		}
		
		
		/**
		 * Gets or sets the maximum value in the sequence of numeric values.
		 * 
		 * @default 10
		 */
		public function get maximum():Number
		{
			return _maximum;
		}
		public function set maximum(value:Number):void
		{
			_maximum = value;
			validateValues();
		}
		
		
		/**
		 * Gets or sets the minimum number in the sequence of numeric values.
		 * 
		 * @default 0
		 */
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			_minimum = value;
			validateValues();
		}
		
		
		/**
		 * Gets the next value in the sequence of values.
		 */
		public function get nextValue():Number
		{
			return _nextValue;
		}
		
		
		/**
		 * Gets the previous value in the sequence of values.
		 */
		public function get previousValue():Number
		{
			return _previousValue;
		}
		
		
		// stepSize
		public function get stepSize():Number
		{
			return _stepSize;
		}
		public function set stepSize(value:Number):void
		{
			_stepSize = value;
			validateValues();
		}
		
		
		/**
		 * Gets or sets a nonzero number that describes the unit of change between values. 
		 * The value property is a multiple of this number less the minimum. 
		 * The NumericStepper component rounds the resulting value to the nearest step size.
		 * 
		 * @default 1
		 */
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			_value = value;
			validateValues();
		}
		
		
		/**
		 * 
		 */
		public function get buttonPlacement():String
		{
			return _buttonPlacement;
		}
		public function set buttonPlacement(value:String):void
		{
			_buttonPlacement = value;
			draw();
		}
		
		
		/**
		 * @copy Borris.controls.BTextInput#editable
		 */
		public function get editable():Boolean
		{
			return inputText.editable;
		}
		public function set editable(value:Boolean):void
		{
			inputText.editable = value;
			inputText.textField.selectable = value;
		}
		
		
		/**
		 * 
		 */
		public function get mode():String
		{
			return _mode;
		}
		public function set mode(value:String):void
		{
			_mode = value;
			percentageText.visible = (_mode == BNumericStepperMode.PERCENTAGE);
		}
		
		
	}

}