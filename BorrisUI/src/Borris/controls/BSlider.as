/* Author: Rohaan Allport
 * Date Created: 27/04/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The Slider component lets users select a value by moving a slider thumb between the end points of the slider track. The current value of the Slider component is determined by the relative location of the thumb between the end points of the slider, corresponding to the minimum and maximum values of the Slider component.
 * 
 *	todo/imporovemtns: 
	 * finish live dragging
	 * finish position thumbs
	 * add labels
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
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	 
	public class BSlider extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var thumb:BBaseButton;
		
		protected var sliderTrackSkin:Sprite;
		protected var sliderTrackDisabledSkin:Sprite;
		
		protected var tickSkin:Sprite;
		
		protected var label:BLabel;
		
		
		// other
		protected var disabledAlpha:Number = 0.5;
		
		protected var trackWidth:int;
		protected var trackHeight:int;
		
		
		// set and get
		protected var _liveDragging:Boolean = true;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _orientation:String;
		protected var _snapInterval:Number = 0;
		protected var _tickInterval:Number = 0;
		protected var _value:Number = 0;
		protected var _labelMode:String = BSliderLabelMode.ALWAYS;
		protected var _labelPrecision:int = 0;
		protected var _labelPosition:String = BSliderLabelPosition.TOP;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BSlider component instance.
		 * 
         * @param orientation The orientation of the slider. Either horizontal or vertial 
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BSlider(orientation:String = BSliderOrientation.HORIZONTAL, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0)
		{
			_orientation = orientation;
			
			super(parent, x, y);
			initialize();
			//setSize(100, 12);
			draw();
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseHandler(event:MouseEvent):void
		{
			// for when the user clicks the track
			// bring the thumb to the position clicked
			if (event.currentTarget == sliderTrackSkin)
			{
				var tween:Tween
				
				if(_orientation == BSliderOrientation.HORIZONTAL)
				{
					tween = new Tween(thumb, "x", Regular.easeOut, thumb.x, mouseX, 0.2, true);
					thumb.x = mouseX;
					thumb.x = Math.max(thumb.x, 0);
					thumb.x = Math.min(thumb.x, _width);
					_value = thumb.x / width * (_maximum - _minimum) + _minimum;
				}
				else if(_orientation == BSliderOrientation.VERTICAL)
				{
					tween = new Tween(thumb, "y", Regular.easeOut, thumb.y, mouseY, 0.2, true);
					thumb.y = mouseY;
					thumb.y = Math.max(thumb.y, 0);
					thumb.y = Math.min(thumb.y, _height);
					_value = (_height - thumb.y)/height * (_maximum - _minimum) + _minimum;
				}
				snap();
				//trace("Value: " + _value);
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			
			// for snapping the thumb 
			if (_snapInterval != 0)
			{
				if (_orientation == BSliderOrientation.HORIZONTAL)
				{
					thumb.x = Math.round(_width / (_maximum - _minimum)) * _value;
				}
				else if (_orientation == BSliderOrientation.VERTICAL)
				{
					thumb.y = -Math.round(_height / (_maximum - _minimum)) * _value + _height;
				}
			}
			
			updateLabel();
			
			//trace("Value: " + _value);
		} // end function mouseHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragThumb(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideThumb);
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				thumb.startDrag(false, new Rectangle(0, 10, _width, 0));
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				thumb.startDrag(false, new Rectangle(-10, 0, 0, _height));
			}
			
			// show the label if label mode is move
			if(_labelMode == BSliderLabelMode.MOVE)
			{
				label.visible = true;
			}
			//trace("Value: " + _value);
		} // end function onDragThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDropThumb(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropThumb);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideThumb);
			stopDrag();
			
			// hide the label if label mode is move
			if(_labelMode == BSliderLabelMode.MOVE)
			{
				label.visible = false;
			}
		} // end function onSlideThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onSlideThumb(event:MouseEvent):void
		{
			var prevValue:Number = _value;
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				_value = thumb.x/width * (_maximum - _minimum) + _minimum;
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				_value = (_height - thumb.y)/height * (_maximum - _minimum) + _minimum;
			}
			
			if(_value != prevValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			updateLabel();
			snap();
			
			//trace("Value: " + _value);
		} // end function onSlideThumb
		
		
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			
			// initialize the assets
			thumb = new BBaseButton(this);
			thumb.setSkins(thumb.getSkin("upSkin"), thumb.getSkin("overSkin"), thumb.getSkin("downSkin"), thumb.getSkin("disabledSkin"));
			
			sliderTrackSkin = new Sprite();
			sliderTrackDisabledSkin = new Sprite();
			
			tickSkin = new Sprite();
			
			label = new BLabel(this, 0, 0, _value.toString());
			label.autoSize = TextFieldAutoSize.LEFT;
			
			// add assets to respective containers
			addChild(sliderTrackSkin);
			addChild(sliderTrackDisabledSkin);
			addChild(tickSkin);
			addChild(thumb);
			
			
			// 
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = true;
			
			
			// checking to see if the orientation property is set to horizontal or vertical, or neither
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				setSize(200, 20);
				trackWidth = _width;
				trackHeight = 2;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				setSize(20, 200);
				trackWidth = 2;
				trackHeight = _height;
			}
			else
			{
				setSize(200, 20);
				_orientation = BSliderOrientation.HORIZONTAL;
				trackWidth = _width;
				trackHeight = 2;
				throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
			}
			
			
			// event handling
			sliderTrackSkin.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			thumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			thumb.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			thumb.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragThumb);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			
			// checking to see if the orientation property is set to horizontal or vertical, or neither
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				thumb.rotation = 0;
				thumb.x = Math.round(_width / (_maximum - _minimum)) * _value;
				thumb.y = 10;
				
				trackWidth = _width;
				trackHeight = 2;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				thumb.rotation = 90;
				thumb.x = -10;
				thumb.y = -Math.round(_height / (_maximum - _minimum)) * _value + _height;
				
				trackWidth = 2;
				trackHeight = _height;
			}
			
			// redraws the tick marks
			tickInterval = _tickInterval;
			
			var thumbWidth:int = 10;
			var thumbHeight:int = 12;
			
			sliderTrackSkin.graphics.clear();
			sliderTrackSkin.graphics.beginFill(0x999999, 1);
			sliderTrackSkin.graphics.drawRect(0, 0, trackWidth, trackHeight);
			sliderTrackSkin.graphics.beginFill(0x000000, 0);
			sliderTrackSkin.graphics.drawRect(-_width + trackWidth, 0, _width, _height);
			sliderTrackSkin.graphics.endFill();
			
			sliderTrackDisabledSkin.graphics.clear();
			sliderTrackDisabledSkin.graphics.beginFill(0x666666, 1);
			sliderTrackDisabledSkin.graphics.drawRect(0, 0, trackWidth, trackHeight);
			sliderTrackDisabledSkin.graphics.endFill();
			sliderTrackDisabledSkin.visible = false;
			
			Sprite(thumb.getSkin("upSkin")).graphics.clear();
			Sprite(thumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1);
			Sprite(thumb.getSkin("upSkin")).graphics.drawCircle(0, 0, 10);
			Sprite(thumb.getSkin("upSkin")).graphics.endFill();
			Sprite(thumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1); // make a pointy arrow
			Sprite(thumb.getSkin("upSkin")).graphics.moveTo( -10, 0);
			Sprite(thumb.getSkin("upSkin")).graphics.lineTo(0, -15);
			Sprite(thumb.getSkin("upSkin")).graphics.lineTo(10, 0);
			//Sprite(thumb.getSkin("upSkin")).graphics.drawRoundRect( -4, -13, 8, 26, 8, 8);
			Sprite(thumb.getSkin("upSkin")).graphics.endFill();
			
			Sprite(thumb.getSkin("overSkin")).graphics.clear();
			Sprite(thumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1);
			Sprite(thumb.getSkin("overSkin")).graphics.drawCircle(0, 0, 10);
			Sprite(thumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1); // make a pointy arrow
			Sprite(thumb.getSkin("overSkin")).graphics.moveTo( -10, 0);
			Sprite(thumb.getSkin("overSkin")).graphics.lineTo(0, -15);
			Sprite(thumb.getSkin("overSkin")).graphics.lineTo(10, 0);
			Sprite(thumb.getSkin("overSkin")).graphics.endFill();
			
			Sprite(thumb.getSkin("downSkin")).graphics.clear();
			Sprite(thumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1);
			Sprite(thumb.getSkin("downSkin")).graphics.drawCircle(0, 0, 10);
			Sprite(thumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1); // make a pointy arrow
			Sprite(thumb.getSkin("downSkin")).graphics.moveTo( -10, 0);
			Sprite(thumb.getSkin("downSkin")).graphics.lineTo(0, -15);
			Sprite(thumb.getSkin("downSkin")).graphics.lineTo(10, 0);
			Sprite(thumb.getSkin("downSkin")).graphics.endFill();
			Sprite(thumb.getSkin("downSkin")).scaleX = Sprite(thumb.getSkin("downSkin")).scaleY = 1.5;
			
			Sprite(thumb.getSkin("disabledSkin")).graphics.clear();
			Sprite(thumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1);
			Sprite(thumb.getSkin("disabledSkin")).graphics.drawCircle(0, 0, 10);
			Sprite(thumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1); // make a pointy arrow
			Sprite(thumb.getSkin("disabledSkin")).graphics.moveTo( -10, 0);
			Sprite(thumb.getSkin("disabledSkin")).graphics.lineTo(0, -15);
			Sprite(thumb.getSkin("disabledSkin")).graphics.lineTo(10, 0);
			Sprite(thumb.getSkin("disabledSkin")).graphics.endFill();
			
			// update the label
			updateLabel();
			
		} // end function draw
		
		
		/**
		 * 
		 */
		protected function snap():void
		{
			if (_snapInterval <= 0)
			{
				return;
			}
			else
			{
				var pow:Number = Math.pow(10, 6);
				var snap:Number = _snapInterval * pow;
				var rounded:Number = Math.round(_value * pow);
				var snapped:Number = Math.round(rounded / snap) * snap;
				var val:Number = snapped / pow;
				_value = Math.max(minimum, Math.min(maximum, val));
				
			}
			
		} // end function snap
		
		
		/**
		 * 
		 */
		protected function updateLabel():void
		{
			label.text = _value.toPrecision(3);//getLabelForValue(lowValue);

			if(_orientation == BSliderOrientation.VERTICAL)
			{
				label.y = thumb.y - label.height / 2;
				
				if(_labelPosition == BSliderLabelPosition.LEFT)
				{
					label.x = -label.width - 5;
				}
				else
				{
					label.x = _width - 5;
				}
			}
			else if(BSliderOrientation.HORIZONTAL)
			{
				label.x = thumb.x - label.width/2;
				
				if(_labelPosition == BSliderLabelPosition.BOTTOM)
				{
					label.y = _height + 2;
				}
				else
				{
					label.y = -label.height - 10;
				}
				
			}
		} // end function updateLabels
		
		
		/**
		 * 
		 */
		protected function positionThumb():void
		{
			
		} // end function positionThumb
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the value is changed
		 * continuously as the user moves the slider thumb. 
		 */
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}
		
		
		/**
		 * The maximum allowed value on the BSlider component instance.
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
		}
		
		
		/**
		 * The minimum value allowed on the BSlider component instance.
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
		}
		
		
		/**
		 * Sets the orientaion of the slider. 
		 * Acceptable values are BSliderOrientation.HORIZONTAL and BSliderOrientation.VERTICAL.
		 */
		public function get orientation():String
		{
			return _orientation;
		}
		public function set orientation(value:String):void
		{
			var prevOrientation:String = _orientation;
			var prevWidth:Number = _width;
			var prevHeight:Number = _height;
			
			_orientation = value;
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				//setSize(_width, _height);
				prevOrientation == BSliderOrientation.HORIZONTAL ? setSize(_width, _height) : setSize(_height, _width);
				trackWidth = _width;
				trackHeight = 5;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				//setSize(_height, _width);
				prevOrientation == BSliderOrientation.VERTICAL ? setSize(_width, _height) : setSize(_height, _width);
				trackWidth = 5;
				trackHeight = _height;
			}
			else
			{
				setSize(_width, _height);
				_orientation = BSliderOrientation.HORIZONTAL;
				trackWidth = _width;
				trackHeight = 5;
				throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class to set this property.");
			}
			
			invalidate();
		}
		
		
		/**
		 * Gets or sets the increment by which the value is increased or decreased as the user moves the slider thumb.
		 * 
		 * <p>For example, this property is set to 2, the minimum value is 0, and the maximum value is 10, 
		 * the position of the thumb will always be at 0, 2, 4, 6, 8, or 10. If this property is set to 0, 
		 * the slider moves continuously between the minimum and maximum values.</p>
		 * 
		 * @default 0
		 */
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		public function set snapInterval(value:Number):void
		{
			_snapInterval = value;
		}
		
		
		/**
		 * The spacing of the tick marks relative to the maximum value of the component. 
		 * The BSlider component displays tick marks whenever you set the tickInterval property to a nonzero value.
		 * 
		 * @default 0
		 */
		public function get tickInterval():Number
		{
			return _tickInterval;
		}
		public function set tickInterval(value:Number):void
		{
			_tickInterval = value;
			
			tickSkin.graphics.clear();
			
			if(value != 0)
			{
				var ticks:int = Math.floor((_maximum - _minimum) / value)
				
				for (var i:int = 0; i < ticks + 1; i++ )
				{
					tickSkin.graphics.beginFill(0xFFFFFF, 1);
					
					if (_orientation == BSliderOrientation.HORIZONTAL)
					{
						tickSkin.graphics.drawRect((_width / (_maximum - _minimum) * _tickInterval * i) - 0.5, -4, 1, 3);
					}
					else if (_orientation == BSliderOrientation.VERTICAL)
					{
						tickSkin.graphics.drawRect(3, (_height / (_maximum - _minimum) * _tickInterval * i) - 0.5, 3, 1);
					}
					tickSkin.graphics.endFill();
				} // end for
				
			}
			
		}
		
		
		/**
		 * Gets or sets the current value of the BSlider component. 
		 * This value is determined by the position of the slider thumb between the minimum and maximum values.
		 */
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			_value = value;
		}
		
		
		/**
		 * 
		 */
		public function set labelMode(value:String):void
		{
			_labelMode = value;
			
			if (value == BSliderLabelMode.ALWAYS)
			{
				label.visible = true;
			}
			else if (value == BSliderLabelMode.NEVER || value ==  BSliderLabelMode.MOVE)
			{
				label.visible = false;
			}
			
		}
		
		
		/**
		 * 
		 */
		public function get labelPrecision():int
		{
			return _labelPrecision;
		}
		public function set labelPrecision(value:int):void
		{
			_labelPrecision = value;
		}
		
		
		/**
		 * 
		 */
		public function get labelPosition():String
		{
			return _labelPosition;
		}
		public function set labelPosition(value:String):void
		{
			_labelPosition = value;
		}
		
		
	}

}