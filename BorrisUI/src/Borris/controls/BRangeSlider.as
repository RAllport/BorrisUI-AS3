/* Author: Rohaan Allport
 * Date Created: 01/05/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The Slider component lets users select a value by moving a slider thumb between the end points of the slider track. The current value of the Slider component is determined by the relative location of the thumb between the end points of the slider, corresponding to the minimum and maximum values of the Slider component.
 * 
 *	todo/imporovemtns: 
	 * finish live dragging
	 * finish position thumbs
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
	
	
	public class BRangeSlider extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var highThumb:BBaseButton;
		protected var lowThumb:BBaseButton;
		
		protected var sliderTrackSkin:Sprite;
		protected var sliderTrackDisabledSkin:Sprite;
		
		protected var tickSkin:Sprite;
		
		protected var highLabel:BLabel;
		protected var lowLabel:BLabel;
		
		
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
		protected var _highValue:Number = 100;
		protected var _lowValue:Number = 0;
		protected var _labelMode:String = BSliderLabelMode.ALWAYS;
		protected var _labelPrecision:int = 0;
		protected var _labelPosition:String = BSliderLabelPosition.TOP;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BRangeSlider component instance.
		 * 
         * @param orientation The orientation of the slider. Either horizontal or vertial 
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BRangeSlider(orientation:String = BSliderOrientation.HORIZONTAL, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) 
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
			
			
		} // end function mouseHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragHighThumb(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideHighThumb);
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				highThumb.startDrag(false, new Rectangle(lowThumb.x, 10, _width - lowThumb.x, 0));
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				highThumb.startDrag(false, new Rectangle(-10, 0, 0, lowThumb.y));
			}
			
			// show the labels if label mode is move
			if(_labelMode == BSliderLabelMode.MOVE)
			{
				lowLabel.visible = true;
				highLabel.visible = true;
			}
		} // end function onDragHighThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragLowThumb(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropThumb);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlideLowThumb);
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				lowThumb.startDrag(false, new Rectangle(0, 10, highThumb.x, 0));
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				lowThumb.startDrag(false, new Rectangle(-10, highThumb.y, 0, _height - highThumb.y));
			}
			
			// show the labels if label mode is move
			if(_labelMode == BSliderLabelMode.MOVE)
			{
				lowLabel.visible = true;
				highLabel.visible = true;
			}
		} // end function onDragThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDropThumb(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropThumb);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideHighThumb);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlideLowThumb);
			stopDrag();
			
			// hide the labels if label mode is move
			if(_labelMode == BSliderLabelMode.MOVE)
			{
				lowLabel.visible = false;
				highLabel.visible = false;
			}
		} // end function onSlideThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onSlideHighThumb(event:MouseEvent):void
		{
			var prevValue:Number = _highValue;
			
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				_highValue = highThumb.x/width * (_maximum - _minimum) + _minimum;
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				_highValue = (_height - highThumb.y)/height * (_maximum - _minimum) + _minimum;
			}
			
			if(_highValue != prevValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			updateLabels();
			snap();
			
			//trace("Value: " + _highValue);
		} // end function onSlideHighThumb
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onSlideLowThumb(event:MouseEvent):void
		{
			var prevValue:Number = _lowValue;
			
			// 
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				_lowValue = lowThumb.x/width * (_maximum - _minimum) + _minimum;
			}
			else if(_orientation == BSliderOrientation.VERTICAL)
			{
				_lowValue = (_height - lowThumb.y)/height * (_maximum - _minimum) + _minimum;
			}
			
			if(_lowValue != prevValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			updateLabels();
			snap();
			
			//trace("Value: " + _value);
		} // end function onSlideLowThumb
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			
			// initialize the assets 
			highThumb = new BBaseButton(this);
			lowThumb = new BBaseButton(this);
			highThumb.setSkins(highThumb.getSkin("upSkin"), highThumb.getSkin("overSkin"), highThumb.getSkin("downSkin"), highThumb.getSkin("disabledSkin"));
			lowThumb.setSkins(lowThumb.getSkin("upSkin"), lowThumb.getSkin("overSkin"), lowThumb.getSkin("downSkin"), lowThumb.getSkin("disabledSkin"));
			
			sliderTrackSkin = new Sprite();
			sliderTrackDisabledSkin = new Sprite();
			
			tickSkin = new Sprite();
			
			highLabel = new BLabel(this, 0, 0, _highValue.toString());
			lowLabel = new BLabel(this, 0, 0, _lowValue.toString());
			highLabel.autoSize = TextFieldAutoSize.LEFT;
			lowLabel.autoSize = TextFieldAutoSize.LEFT;
			
			// add assets to respective containers
			addChild(sliderTrackSkin);
			addChild(sliderTrackDisabledSkin);
			addChild(tickSkin);
			
			
			// 
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = true;
			
			
			// checking to see if the orientation property is set to horizontal or vertical, or neither
			if(_orientation == BSliderOrientation.HORIZONTAL)
			{
				setSize(200, 20);
				trackWidth = _width;
				trackHeight = 5;
				_labelPosition = BSliderLabelPosition.TOP;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				setSize(20, 200);
				trackWidth = 5;
				trackHeight = _height;
				_labelPosition = BSliderLabelPosition.RIGHT;
			}
			else
			{
				setSize(200, 20);
				_orientation = BSliderOrientation.HORIZONTAL;
				trackWidth = _width;
				trackHeight = 20
				_labelPosition = BSliderLabelPosition.TOP;
				throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
			}
			
			
			// event handling
			//sliderTrackSkin.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			highThumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			highThumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			highThumb.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			highThumb.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
			highThumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragHighThumb);
			
			lowThumb.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			lowThumb.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			lowThumb.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			lowThumb.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
			lowThumb.addEventListener(MouseEvent.MOUSE_DOWN, onDragLowThumb);
			
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
				addChild(highThumb);
				highThumb.scaleX = 1;
				highThumb.rotation = 0;
				//highThumb.x = _width;
				highThumb.x = Math.round(_width / (_maximum - _minimum)) * _highValue;
				highThumb.y = 10;
				
				lowThumb.scaleX = 1;
				lowThumb.rotation = 0;
				//lowThumb.x = 0;
				lowThumb.x = Math.round(_width / (_maximum - _minimum)) * _lowValue;
				lowThumb.y = 10;
				
				trackWidth = _width;
				trackHeight = 2;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				addChild(lowThumb);
				highThumb.scaleX = -1;
				highThumb.rotation = 90;
				highThumb.x = -10;
				highThumb.y = 0;
				highThumb.y = -Math.round(_height / (_maximum - _minimum)) * _highValue + _height;
				
				lowThumb.scaleX = -1;
				lowThumb.rotation = 90;
				lowThumb.x = -10;
				lowThumb.y = _height;
				lowThumb.y = -Math.round(_height / (_maximum - _minimum)) * _lowValue + _height;
				
				trackWidth = 2;
				trackHeight = _height;
			}
			
			// redraws the tick marks
			//tickInterval = _tickInterval;
			
			var thumbWidth:int = 10;
			var thumbHeight:int = 16;
			
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
			
			
			// draw high thumb
			Sprite(highThumb.getSkin("upSkin")).graphics.clear();
			Sprite(highThumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1);
			Sprite(highThumb.getSkin("upSkin")).graphics.drawCircle(10, 0, 10);
			Sprite(highThumb.getSkin("upSkin")).graphics.endFill();
			Sprite(highThumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1); // make a pointy arrow
			Sprite(highThumb.getSkin("upSkin")).graphics.moveTo(0, 0);
			Sprite(highThumb.getSkin("upSkin")).graphics.lineTo(0, -15);
			Sprite(highThumb.getSkin("upSkin")).graphics.lineTo(20, 0);
			Sprite(highThumb.getSkin("upSkin")).graphics.endFill();
			
			Sprite(highThumb.getSkin("overSkin")).graphics.clear();
			Sprite(highThumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1);
			Sprite(highThumb.getSkin("overSkin")).graphics.drawCircle(10, 0, 10);
			Sprite(highThumb.getSkin("overSkin")).graphics.endFill();
			Sprite(highThumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1); // make a pointy arrow
			Sprite(highThumb.getSkin("overSkin")).graphics.moveTo(0, 0);
			Sprite(highThumb.getSkin("overSkin")).graphics.lineTo(0, -15);
			Sprite(highThumb.getSkin("overSkin")).graphics.lineTo(20, 0);
			Sprite(highThumb.getSkin("overSkin")).graphics.endFill();
			
			Sprite(highThumb.getSkin("downSkin")).graphics.clear();
			Sprite(highThumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1);
			Sprite(highThumb.getSkin("downSkin")).graphics.drawCircle(10, 0, 10);
			Sprite(highThumb.getSkin("downSkin")).graphics.endFill();
			Sprite(highThumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1); // make a pointy arrow
			Sprite(highThumb.getSkin("downSkin")).graphics.moveTo(0, 0);
			Sprite(highThumb.getSkin("downSkin")).graphics.lineTo(0, -15);
			Sprite(highThumb.getSkin("downSkin")).graphics.lineTo(20, 0);
			Sprite(highThumb.getSkin("downSkin")).graphics.endFill();
			Sprite(highThumb.getSkin("downSkin")).scaleX = Sprite(highThumb.getSkin("downSkin")).scaleY = 1.5;
			
			Sprite(highThumb.getSkin("disabledSkin")).graphics.clear();
			Sprite(highThumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1);
			Sprite(highThumb.getSkin("disabledSkin")).graphics.drawCircle(10, 0, 10);
			Sprite(highThumb.getSkin("disabledSkin")).graphics.endFill();
			Sprite(highThumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1); // make a pointy arrow
			Sprite(highThumb.getSkin("disabledSkin")).graphics.moveTo(0, 0);
			Sprite(highThumb.getSkin("disabledSkin")).graphics.lineTo(0, -15);
			Sprite(highThumb.getSkin("disabledSkin")).graphics.lineTo(20, 0);
			Sprite(highThumb.getSkin("disabledSkin")).graphics.endFill();
			
			
			// draw low thumb
			Sprite(lowThumb.getSkin("upSkin")).graphics.clear();
			Sprite(lowThumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1);
			Sprite(lowThumb.getSkin("upSkin")).graphics.drawCircle( -10, 0, 10);
			Sprite(lowThumb.getSkin("upSkin")).graphics.endFill();
			Sprite(lowThumb.getSkin("upSkin")).graphics.beginFill(0x999999, 1);
			Sprite(lowThumb.getSkin("upSkin")).graphics.moveTo(0, 0);
			Sprite(lowThumb.getSkin("upSkin")).graphics.lineTo(0, -15);
			Sprite(lowThumb.getSkin("upSkin")).graphics.lineTo(-20, 0);
			Sprite(lowThumb.getSkin("upSkin")).graphics.endFill();
			
			Sprite(lowThumb.getSkin("overSkin")).graphics.clear();
			Sprite(lowThumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1);
			Sprite(lowThumb.getSkin("overSkin")).graphics.drawCircle( -10, 0, 10);
			Sprite(lowThumb.getSkin("overSkin")).graphics.endFill();
			Sprite(lowThumb.getSkin("overSkin")).graphics.beginFill(0xFFFFFF, 1);
			Sprite(lowThumb.getSkin("overSkin")).graphics.moveTo(0, 0);
			Sprite(lowThumb.getSkin("overSkin")).graphics.lineTo(0, -15);
			Sprite(lowThumb.getSkin("overSkin")).graphics.lineTo(-20, 0);
			Sprite(lowThumb.getSkin("overSkin")).graphics.endFill();
			
			Sprite(lowThumb.getSkin("downSkin")).graphics.clear();
			Sprite(lowThumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1);
			Sprite(lowThumb.getSkin("downSkin")).graphics.drawCircle( -10, 0, 10);
			Sprite(lowThumb.getSkin("downSkin")).graphics.endFill();
			Sprite(lowThumb.getSkin("downSkin")).graphics.beginFill(0x0099CC, 1);
			Sprite(lowThumb.getSkin("downSkin")).graphics.moveTo(0, 0);
			Sprite(lowThumb.getSkin("downSkin")).graphics.lineTo(0, -15);
			Sprite(lowThumb.getSkin("downSkin")).graphics.lineTo(-20, 0);
			Sprite(lowThumb.getSkin("downSkin")).graphics.endFill();
			Sprite(lowThumb.getSkin("downSkin")).scaleX = Sprite(lowThumb.getSkin("downSkin")).scaleY = 1.5;
			
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.clear();
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.drawCircle( -10, 0, 10);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.endFill();
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.beginFill(0x333333, 1);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.moveTo(0, 0);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.lineTo(0, -15);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.lineTo(-20, 0);
			Sprite(lowThumb.getSkin("disabledSkin")).graphics.endFill();
			
			// update the labels
			updateLabels();
			
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
				
				var rounded:Number = Math.round(_highValue * pow);
				var snapped:Number = Math.round(rounded / snap) * snap;
				var val:Number = snapped / pow;
				_highValue = Math.max(minimum, Math.min(maximum, val));
				
				
				rounded = Math.round(_lowValue * pow);
				snapped = Math.round(rounded / snap) * snap;
				val = snapped / pow;
				_lowValue = Math.max(minimum, Math.min(maximum, val));
			}
			
		} // end function snap
		
		
		/**
		 * 
		 */
		protected function updateLabels():void
		{
			lowLabel.text = _lowValue.toPrecision(3);//getLabelForValue(lowValue);
			highLabel.text = _highValue.toPrecision(3);//getLabelForValue(highValue);

			if(_orientation == BSliderOrientation.VERTICAL)
			{
				lowLabel.y = lowThumb.y - lowLabel.height / 2;
				highLabel.y = highThumb.y - highLabel.height / 2;
				
				if(_labelPosition == BSliderLabelPosition.LEFT)
				{
					lowLabel.x = -lowLabel.width - 5;
					highLabel.x = -highLabel.width - 5;
				}
				else
				{
					lowLabel.x = _width - 5;
					highLabel.x = _width - 5;
				}
			}
			else if(BSliderOrientation.HORIZONTAL)
			{
				lowLabel.x = lowThumb.x - lowLabel.width/2;
				highLabel.x = highThumb.x - highLabel.width / 2;
				
				if(_labelPosition == BSliderLabelPosition.BOTTOM)
				{
					lowLabel.y = _height + 2;
					highLabel.y = _height + 2;
				}
				else
				{
					lowLabel.y = -lowLabel.height - 10;
					highLabel.y = -highLabel.height - 10;
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
				trackHeight = 2;
			}
			else if(BSliderOrientation.VERTICAL)
			{
				//setSize(_height, _width);
				prevOrientation == BSliderOrientation.VERTICAL ? setSize(_width, _height) : setSize(_height, _width);
				trackWidth = 2;
				trackHeight = _height;
			}
			else
			{
				setSize(_width, _height);
				_orientation = BSliderOrientation.HORIZONTAL;
				trackWidth = _width;
				trackHeight = 2;
				throw new Error("The BSlider.orientation property can only me 'horizontal' or 'vertical'. Use the BSliderOrientation class for set this property.");
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
					tickSkin.graphics.beginFill(0x999999, 1);
					
					if (_orientation == BSliderOrientation.HORIZONTAL)
					{
						tickSkin.graphics.drawRect((_width / (_maximum - _minimum) * _tickInterval * i) - 0.5, -4, 1, 3);
					}
					else if (_orientation == BSliderOrientation.VERTICAL)
					{
						tickSkin.graphics.drawRect(6, (_height / (_maximum - _minimum) * _tickInterval * i) - 0.5, 3, 1);
					}
					tickSkin.graphics.endFill();
				} // end for
				
			}
			
		}
		
		
		/**
		 * Gets or sets the current high value of the BSlider component. 
		 * This value is determined by the position of the slider thumb between the minimum and maximum values.
		 */
		public function get highValue():Number
		{
			return _highValue;
		}
		public function set highValue(value:Number):void
		{
			_highValue = value;
		}
		
		
		/**
		 * Gets or sets the current low value of the BSlider component. 
		 * This value is determined by the position of the slider thumb between the minimum and maximum values.
		 */
		public function get lowValue():Number
		{
			return _lowValue;
		}
		public function set lowValue(value:Number):void
		{
			_lowValue = value;
		}
		
		
		/**
		 * 
		 */
		public function get labelMode():String
		{
			return _labelMode;
		}
		public function set labelMode(value:String):void
		{
			_labelMode = value;
			
			if (value == BSliderLabelMode.ALWAYS)
			{
				lowLabel.visible = true;
				highLabel.visible = true;
			}
			else if (value == BSliderLabelMode.NEVER || value ==  BSliderLabelMode.MOVE)
			{
				lowLabel.visible = false;
				highLabel.visible = false;
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