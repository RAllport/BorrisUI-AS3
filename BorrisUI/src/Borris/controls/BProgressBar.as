/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BProgressBar component displays the progress of content that is being loaded. 
 * 			The ProgressBar is typically used to display the status of images, as well as portions of applications, while they are loading. 
 * 			The loading process can be determinate or indeterminate. 
 * 			A determinate progress bar is a linear representation of the progress of a task over time and is used when the amount of content to load is known. 
 * 			An indeterminate progress bar has a striped fill and a loading source of unknown size.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getTimer;
	
	import Borris.display.BProgressBarDirection;
	import Borris.display.BProgressBarMode;
	
	
	
	// Events
	[Event("complete", type="flash.events.Event")]
	[Event("progress", type="flash.events.ProgressEvent")]
	
	public class BProgressBar extends BUIComponent
	{
		// contants
		
		
		// assets
		// text assest
		protected var enabledTF:TextFormat;
		protected var disabledTF:TextFormat;
		protected var progressLabelText:TextField;
		//protected var estimatedTimeLabelText:TextField;
		//protected var  transferRateLabelText:TextField;
		
		// skin assets
		protected var enabledSkin:Sprite;			// 
		//protected var disabledSkin:Sprite;			// 
		
		protected var enabledLeftSkin:Sprite;		// 
		protected var enabledCenterSkin:Sprite;		// 
		protected var enabledRightSkin:Sprite;		// 
		
		//protected var disabledLeftSkin:Sprite;		// 
		//protected var disabledCenterSkin:Sprite;	// 
		//protected var disabledRightSkin:Sprite;		// 
		
		protected var bar:Shape;					// 
		//protected var mk:Shape;						// 
		
		
		// other
		
		
		// set and get
		protected var _color:uint = 0x0066FF;
		protected var _direction:String = "right";		// Indicates the fill direction for the progress bar.	//BProgressBarDirection.RIGHT
		protected var _maximum:Number;					// Gets or sets the maximum value for the progress bar when the ProgressBar.mode property is set to BBProgressBarMode.MANUAL.
		protected var _minimum:Number;					// Gets or sets the minimum value for the progress bar when the ProgressBar.mode property is set to BBProgressBarMode.MANUAL.
		protected var _mode:String;						// Gets or sets the method to be used to update the progress bar.
		protected var _percentComplete:Number;			// [read-only] Gets a number between 0 and 100 that indicates the percentage of the content has already loaded.
		protected var _source:Object;					// Gets or sets a reference to the content that is being loaded and for which the ProgressBar is measuring the progress of the load operation.
		protected var _value:Number;					// Gets or sets a value that indicates the amount of progress that has been made in the load operation.
		// overrides: width, height, sxaleX, scaleY
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BProgressBar component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
         */
		public function BProgressBar(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) 
		{
			super(parent, x, y);
			_mode = BProgressBarMode.EVENT;
			_maximum = 0;
			_minimum = 0;
			_percentComplete = 0;
			_value = 0;
			
			// initialize asset variables
			enabledTF = new TextFormat("Calibri", 14, 0xCCCCCC, false);
			disabledTF = new TextFormat("Calibri", 14, 0x000000, false);
			
			progressLabelText = new TextField();
			//progressLabelText.text = "Progress Label";
			progressLabelText.type = TextFieldType.DYNAMIC;
			progressLabelText.selectable = false;
			progressLabelText.width = 100;
			progressLabelText.height = 20;
			progressLabelText.setTextFormat(enabledTF);
			progressLabelText.defaultTextFormat = enabledTF;
			progressLabelText.mouseEnabled = false;
			//progressLabelText.autoSize = TextFieldAutoSize.LEFT;
			progressLabelText.antiAliasType = AntiAliasType.ADVANCED;
			
			
			enabledSkin = new Sprite();
			enabledSkin.mouseEnabled = false;
			
			enabledLeftSkin = left_mc;
			enabledCenterSkin = center_mc;
			enabledRightSkin = right_mc;
			
			bar = new Shape();
			bar.alpha = 1;
			//bar.graphics.beginFill(_color, 1);
			bar.graphics.drawRoundRect(0, 0, 100, 22, 22, 22);
			bar.graphics.endFill();
			bar.x = 0;
			bar.y = 20;
			
			
			// add assets to stage
			addChild(bar);
			addChild(progressLabelText);
			addChild(enabledSkin);
			
			enabledSkin.addChild(enabledLeftSkin);
			enabledSkin.addChild(enabledCenterSkin);
			enabledSkin.addChild(enabledRightSkin);
			
			
			//
			this.width = 300;
			this.color = 0x0066ff;
			//this.update();
			draw();
			
			
			// event handling
			
			
		}
		
		
		// function enterFrameHandler
		// 
		protected function enterFrameHandler(event:Event):void 
		{
			if (_source == null) 
				return;
				
			setProgress(_source.bytesLoaded, _source.bytesTotal, true);
			
			if (_value == _maximum && _maximum > 0 )
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		} // end function enterFrameHandler
		
		
		// function progressHandler
		// 
		protected function progressHandler(event:ProgressEvent):void 
		{
			var _percentComplete:Number = Math.round(event.bytesLoaded / event.bytesTotal) * 100;
			setProgress(event.bytesLoaded, event.bytesTotal, true);
			trace("BProgressBar | " + _percentComplete);
		} // end function progressHandler
		
		
		// function onCompleteHandle
		// 
		protected function onCompleteHandler(event:Event):void 
		{
			setProgress(_maximum, _maximum, true);
			dispatchEvent(event);
		} // end function onCompleteHandle
		
		
		/**
		 * @inheritDoc
		 * 
		 */ 
		override protected function draw():void
		{
			progressLabelText.x = 0;
			progressLabelText.y = 22;
			//progressLabelText.text = "Progress Label";
			
			enabledLeftSkin.x = 0;
			enabledLeftSkin.y = 0;
			
			enabledCenterSkin.x = enabledLeftSkin.x + enabledLeftSkin.width;
			enabledCenterSkin.y = 0;
			enabledCenterSkin.width = _width - enabledLeftSkin.width - enabledRightSkin.width;
			
			enabledRightSkin.x = enabledCenterSkin.x + enabledCenterSkin.width;
			enabledRightSkin.y = 0;
			
			bar.x = 0;
			bar.y = 0;
			
			update();
			
		} // end function draw
		
		
		// function reset
		// Resets the progress bar for a new load operation.
		public function reset():void
		{
			setProgress(0, 0);
			var tempScource:Object = _source;
			_source = null;
			source = tempScource;
			
		} // end function reset
		
		
		// function setProgress
		// Sets the state of the bar to reflect the amount of progress made when using manual mode.
		private function setProgress(value:Number, maximum:Number, dispatchEvent:Boolean = false):void
		{
			if (value == _value && maximum == _maximum) 
			{ 
				return; 
			}
			
			_value = value;
			_maximum = maximum;
			
			if (_value != _percentComplete && dispatchEvent) 
			{
				this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _value, _maximum));
				_percentComplete = _value;
			}
			
			update();
			//updateBar();
			//draw();
		} // end function setProgress
		
		
		// function update
		// update the bar, and text, and animations of any.
		private function update():void
		{
			progressLabelText.text = this.percentComplete + "%";
			updateBar();
			
		} // end function update
		
		
		// function update
		// update the bar only
		private function updateBar():void
		{
			//var barWidth:Number = _value / _maximum;
			var barWidth:Number = (_width / 100) * percentComplete;
			
			bar.graphics.clear();
			bar.graphics.beginFill(_color, 1);
			bar.graphics.drawRoundRect(0, 0, barWidth, 22, 22, 22);
			bar.graphics.endFill();
			
		} // end function update
		
		
		//***************************************** SET AND GET *****************************************
		
		// color
		public function get color():uint
		{
			return _color;
		}
		public function set color(value:uint):void
		{
			_color = value;
			update();
		}
		
		
		// direction
		public function get derection():String
		{
			return _direction;
		}
		public function set direction(value:String):void
		{
			
		}
		
		
		// maximum
		public function get maximum():Number
		{
			return _maximum;
		}
		public function set maximum(value:Number):void
		{
			if (_mode != BProgressBarMode.MANUAL)
				return;
			//_maximum = Math.max(value, 0);
			_maximum = value;
			_value = Math.min(_value, _maximum);
			updateBar();
		}
		
		
		// minimum
		public function get minimum():Number
		{
			return _minimum;
		}
		public function set minimum(value:Number):void
		{
			if (_mode != BProgressBarMode.MANUAL)
				return;
			//_minimum = Math.max(value, 0);
			_minimum = value;
			_value = Math.max(_value, _minimum);
			updateBar();
		}
		
		
		// mode
		public function get mode():String
		{
			return _mode;
		}
		public function set mode(value:String):void
		{
			if(_mode == value) 
				return;
				
			//resetProgress();
			
			_mode = value;
			
			if (value == BProgressBarMode.EVENT && _source != null) 
			{
				_source.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				_source.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			} 
			else if (value == BProgressBarMode.POLLED) 
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0 , true);
			}
			
		}
		
		
		// percentComplete
		public function get percentComplete():Number
		{
			//_percentComplete = (_maximum <= _minimum || _value <= _minimum) ?  0 : Math.max(0, Math.min(100, (_value-_minimum) / (_maximum - _minimum) * 100));
			return _percentComplete;
		}
		
		
		// source
		public function get source():Object
		{
			return _source;
		}
		public function set source(value:Object):void
		{
			if (_source == value)
				return;
				
			/*if (_mode != BProgressBarMode.MANUAL) 
			{ 
				//resetProgress(); 
			}*/
			
			_source = value;
			
			if (_source == null) 
				return; // Can not poll or add listeners to a null source!
			
			if (_mode == BProgressBarMode.EVENT) 
			{
				_source.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
				_source.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
				
			} 
			else if (_mode == BProgressBarMode.POLLED) 
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			}
			
		}
		
		
		// value
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			value = value > _maximum ? _maximum : value;
			value = value < _minimum ? _minimum : value;
			_value = value;
			update();
		}
		
		
		//***************************************** SET AND GET OVERRIDES *****************************************
		
		// width
		/*override public function set width():Number
		{
			
		}
		
		override public get width():Number
		{
			
		}*/
		
	}

}