/* Author: Rohaan Allport
 * Date Created: 08/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.transitions 
{
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	
	import Borris.transitions.easing.Quadratic;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BTween extends EventDispatcher
	{
		// constants
		
		
		
		// static 
		public var defaultDispatchEvents:Boolean = false;
		public var defaultEase:Function = function():void;
		private var _stopAll:Boolean = false;
		public var _timeScaleAll:Number = 1;
		
		
		// other
		protected var _shape:Shape = new Shape();
		protected var _timer:Timer = new Timer(300);
		
		protected var _beginValues:Object;
		protected var _endValues:Object;
		protected var _originalBeginValues:Object;
		protected var _originalEndValues:Object;
		
		private var _delta:Number = NaN;
		
		
		// set and get
		protected var _autoPlay:Boolean = true;
		protected var _data:Object;
		protected var _delay:Number = 0;
		//protected var _dispatchEvent:Boolean = true;
		protected var _duration:Number = 0;
		protected var _transitionFunction:Function = function (t:Number, b:Number, c:Number, d:Number):Number { return c*t/d + b; }
		protected var _nextTween:BTween;
		protected var _prevTween:BTween;					// [read-only]
		//protected var _onChange:Function;
		//protected var _onComplete:Function;
		//protected var _onInitialize:Function;
		protected var _paused:Boolean;						// [read-only]
		//protected var _pluginData:Object;
		protected var _position:Number;
		//protected var _nextPosition:Number;					// [read-only]
		//protected var _prevPosition:Number;					// [read-only]
		//protected var _ratio:Number;
		//protected var _nextRatio:Number;					// [read-only]
		//protected var _prevRatio:Number;					// [read-only]
		protected var _repeat:Boolean = false;
		protected var _repeatCount:int = 1;
		protected var _stopped:Boolean;						// [read-only]
		protected var _target:Object;
		protected var _timeScale:Number = 1;
		protected var _useFrames:Boolean = false;
		
		protected var _FPS:Number;
		protected var _isPlaying:Boolean;
		protected var _loop:Boolean;
		protected var _startTime:Number;
		protected var _endTime:Number;
		protected var _currentTime:Number;
		
		protected var _tweenProperties:Object;					// [read-only]
		
		
		/**
		 * Creates a new instance of the BTween class.
		 * 
		 * @param target The target object (or array of objects) whose properties will be tweened. 
		 * @param duration Length of time of the transition. (calculated in seconds if <code>useFrames</code> = false or calculated in frames if <code>useFrames</code> = true.)
		 * @param beginValues An object defining the begin value for each property that should be tweened. For example, to tween from x=100, y=100, you could pass {x:100, y:100} as the beginValues object. If set to null, the begin values will be the values that the target If an end value for the property is not set, there will be no effect on that property.
		 * @param endValues An object defining the end value for each property that should be tweened. For example, to tween to x=100, y=100, you could pass {x:100, y:100} as the endValues object.
		 * @param tweenProperties An object containing special properties to set on this tween. For example, you could pass {transitionFunction:Regular.easeInOut} to set the transitionFunction property of the new instance.
		 * 
		 * @see Borris.transitions.easing
		 */
		public function BTween(target:Object = null, duration:Number = 1, beginValues:Object = null, endValues:Object = null, tweenProperties:Object = null) 
		{
			_target = target
			//this.target = target;
			_duration = duration;
			//this.duration = duration;
			
			setBeginValues(beginValues);
			setEndValues(endValues);
			
			_tweenProperties = tweenProperties;
			_transitionFunction = Quadratic.easeIn;
			
			//if (this.duration == 0 && delay == 0 && autoPlay)
			if (_duration == 0 && _delay == 0 && _autoPlay)
			{
				_position = 0;
				//position = 0;
			} // end if
			
			this._timer = new Timer(100);
			this.start();
			
			this.start();
			//this.play();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		//=================================
		// Play head function
		//=================================
		
		
		/**
		 * Begins playing forward of a tweened animation that has been paused or stopped. This method will change the direction of the tween if it is in reverse.
		 */
		public function play():void
		{
			if (_paused)
			{
				
			
			_paused = false;
			
			// GTween.paused
			/*if (isNaN(_position) || (repeatCount != 0 && _position >= repeatCount*duration)) {
				// reached the end, reset.
				_inited = false;
				calculatedPosition = calculatedPositionOld = ratio = ratioOld = positionOld = 0;
				_position = -delay;
			}
			tickList[this] = true;
			// prevent garbage collection:
			if (target is IEventDispatcher) { target.addEventListener("_", invalidate); }
			else { gcLockList[this] = true; }
			
			
			// fl Tween.start()
			this.rewind();
			this.startEnterFrame();
			this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_START, this._time, this._position));
			
			// fl Tween.resume()
			this.fixTime();
			this.startEnterFrame();
			this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_RESUME, this._time, this._position));
			*/
			
			} // end if
		} // end function 
		
		
		/**
		 * Starts the play of a tweened animation from the beginning. This method is used for 
		 * restarting a Tween from the beginning of its animation after it stops or has completed 
		 * its animation.
		 */   
		public function start():void
		{
			// fl Tween.start()
			this.rewind();
			this.startEnterFrame();
			//this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_START, this._time, this._position));
		} // end function 
		
		
		/**
		 * Stops the play of a tweened animation and brings it to the beginning.
		 */
		public function stop():void
		{
			
		} // end function 
		
		
		/**
		 * Pauses the play of a tweened animation at its current value.
		 */
		public function pause():void
		{
			
		} // end function pause
		
		
		/**
		 * Resumes the play of a tweened animation that has been puased without changing the direction the tween is playing. Use this method to continue
		 * a tweened animation after you have paused it by using the <code>Tween.pause()</code> method.
		 */
		public function resume():void
		{
			// fl Tween.resume()
			this.fixTime();
			this.startEnterFrame();
			//this.dispatchEvent(new TweenEvent(TweenEvent.MOTION_RESUME, this._time, this._position));
		} // end function 
		
		
		/**
		 * Restarts the play of a tweened animation and begins playing forward from the beginning.
		 */
		public function restart():void
		{
			// fl Tween.rewind()
			//this._time = t;
			this.fixTime();
			this.update(); 
			
		} // end function 
		
		/**
		 * Reverses the play of a tweened animation at its current position.
		 */
		public function reverse():void
		{
			
		} // end function 
		
		
		/**
		 * Rewinds the play of a tweened animation at its current position. A time scale can be set to change the speed at which the tween should rewind. For example, setting a time scale of 2 will rewind the tween twice as fast, and setting a time scale of 0.5 will rewind the tween half as fast.
		 * 
		 * @param timeScale The rate at which the tweened animation should be played.
		 * 
		 * @see #reverse()
		 * @see #fastForward()
		 * @see #timeScale
		 */
		public function rewind(timeScale:Number = 1):void
		{
			
		} // end function 
		
		
		/**
		 * Fast forwards the play of a tweened animation at its current position. A time scale can be set to change the speed at which the tween should fast forward. For example, setting a time scale of 2 will fast forward the tween twice as fast, and setting a time scale of 0.5 will fast forward the tween half as fast.
		 * 
		 * @param timeScale The rate at which the tweened animation should be played.
		 * 
		 * @see #reverse()
		 * @see #rewind()
		 * @see #timeScale
		 */
		public function fastForward(timeScale:Number = 1):void
		{
			
		} // end function 
		
		
		/**
		 * 
		 * @param position
		 */
		public function gotoAndPlay(position:Number):void
		{
			
		} // end function gotoAndPlay
		
		
		/**
		 * 
		 * @param position
		 */
		public function gotoAndStop(position:Number):void
		{
			
		} // end function gotoAndStop
		
		
		/**
		 * 
		 */
		public function gotoBeginning():void
		{
			
		} // end function 
		
		
		/**
		 * 
		 */
		public function gotoEnd():void
		{
			
		} // end function 
		
		
		
		//=================================
		// getter and setter function
		//=================================
		
		/**
		 * Returns the begin value for the specified property if one exists.
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @return Returns the begin value for the specified property if one exists.
		 */
		public function getBeginValue(poperty:String):Number
		{
			return 0;
		} // end function getBeginValue
		
		
		/**
		 * Returns the end value for the specified property if one exists.
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @return Returns the end value for the specified property if one exists.
		 */
		public function getEndValue(poperty:String):Number
		{
			return 0;
		} // end function getEndValue
		
		
		/**
		 * Returns an object containing the begin and end values for the specified property if one exists.
		 * To get the value of each property, use the begin and end properties of the object.
		 * For example, object.begin and object.end.
		 * This is a shorthand function to <code>getBeginValue(poperty:String)</code> and <code>getEndValue(poperty:String)</code>;
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @return Returns an object containing the begin and end values for the specified property if one exists.
		 */
		public function getValue(poperty:String):Object
		{
			return {begin: 0, end: 0};
		} // end function getValue
		
		
		/**
		 * Sets the numeric begin value for a property on the target object that is to be tweened.
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @param value The begin value of the property before the tween starts.
		 */
		public function setBeginValue(poperty:String, value:Number):void
		{
			
		} // end function setBeginValue
		
		
		/**
		 * Sets the numeric end value for a property on the target object that is to be tweened.
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @param value The end value of the property when the tween finishes.
		 */
		public function setEndValue(poperty:String, value:Number):void
		{
			
		} // end function setEndValue
		
		
		/**
		 * Sets the numeric begin and end value for a property on the target object that is to be tweened.
		 * This is a shorthand function to <code>setBeginValue(poperty:String, value:Number)</code> and <code>setEndValue(poperty:String, value:Number)</code>.
		 * 
		 * @param poperty The name of the property affected by the tween of the target object.
		 * @param beginValue The begin value of the property before the tween starts.
		 * @param endValue The end value of the property when the tween finishes.
		 */
		public function setValue(poperty:String, beginValue:Number, endValue:Number):void
		{
			
		} // end function setValues
		
		
		/**
		 * Returns an object containing the numeric begin value of the tweened properties on the target object.
		 * This is a shorthand function to <code>getBeginValue(poperty:String)</code>.
		 */
		public function getBeginValues():Object
		{
			return _beginValues;
		} // end function getBeginValues
		
		
		/**
		 * 
		 * This is a shorthand function to <code>getEndValue(poperty:String)</code>.
		 */
		public function getEndValues():Object
		{
			return _endValues;
		} // end function getEndValues
		
		
		/**
		 * 
		 * This is a shorthand function to <code>getBeginValues()</code> and <code>getEndValues()</code>.
		 * 
		 * @return
		 */
		public function getValues():Object
		{
			return {beginValues: _beginValues, endValues: _endValues}
		} // end function getValues
		
		
		/**
		 * 
		 * This is a shorthand function to <code>setBeginValue(poperty:String, value:Number)</code>.
		 * 
		 * @param values
		 */
		public function setBeginValues(values:Object):void
		{
			
		} // end function setBeginValues
		
		
		/**
		 * 
		 * This is a shorthand function to <code>setEndValue(poperty:String, value:Number)</code>.
		 * 
		 * @param values
		 */
		public function setEndValues(values:Object):void
		{
			
		} // end function setEndValues
		
		
		/**
		 * 
		 * This is a shorthand function to <code>setBeginValues(values:Object)</code> and <code>setEndValues(values:Object)</code>.
		 * 
		 * @param beginValues
		 * @param endValues
		 */
		public function setValues(beginValues:Object = null, endValues:Object = null):void
		{
			
		} // end function setValues
		
		
		/**
		 * Resets the tween to its original begin values.
		 */
		public function resetBeginValues():void
		{
			
		} // end function resetBeginValues
		
		
		/**
		 * Resets the tween to its original end values.
		 */
		public function resetEndValues():void
		{
			
		} // end function resetEndValues
		
		
		/**
		 * Resets the tween to its original begin and end values.
		 * This is a shorthand function to <code>resetBeginValues()</code> and <code>resetEndValues()</code>.
		 */
		public function resetValues():void
		{
			
		} // end function resetEndValues
		
		
		/**
		 * Swaps the begin and end values of the tween.
		 */
		public function swapValues():void
		{
			
		} // end function swapValues
		
		
		
		
		/**
		 * @private
		 */
		protected function startEnterFrame():void 
		{
			/*if (isNaN(this._fps)) 
			{
				// original frame rate dependent way
				_mc.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
			} 
			else 
			{
				// custom frame rate
				var milliseconds:Number = 1000 / this._fps;
				this._timer.delay = milliseconds;
				this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler, false, 0, true);
				this._timer.start();
			}
			//this.isPlaying = true;
			
			_paused = false;*/
			
		} // end function startEnterFrame
		
		
		//=================================
		// private function
		//=================================
		
		/**
		 * Forwards the tweened animation to the next frame of an animation that was stopped. Use this
		 * method to forward a frame at a time of a tweened animation after you use the 
		 * <code>Tween.stop()</code> method to stop it.
		 *
		 * <p><strong>Note:</strong> Use this method on frame-based tweens only. A tween is
		 * set to frame based at its creation by setting the <code>useSeconds</code> parameter to 
		 * <code>false</code>.</p>
		 */     
		public function nextFrame():void 
		{
			/*if (this.useSeconds) 
				this.time = (getTimer() - this._startTime) / 1000;
			else 
				this.time = this._time + 1;*/
		}

		/**
		 * @private
		 */
		protected function onEnterFrame(event:Event):void 
		{
			this.nextFrame();
		}

		/**
		 * @private
		 */
		protected function timerHandler(timerEvent:TimerEvent):void 
		{
			this.nextFrame();
			timerEvent.updateAfterEvent();
		}

		/**
		 * Plays the previous frame of the tweened animation from the current stopping point of an 
		 * animation that was stopped. Use this method to play a tweened animation backwards one frame 
		 * at a time after you use the <code>Tween.stop()</code> method to stop it.
		 *
		 * <p><strong>Note:</strong> Use this method on frame-based tweens only. A tween is set
		 * to frame based at its creation by setting the <code>Tween.start()</code> 
		 * <code>useSeconds</code> parameter to <code>false</code>.</p>
		 *
		 * @keyword Tween
		 *
		 * @see #start()
		 *
		 * @playerversion Flash 9
		 * @playerversion AIR 1.0
		 * @productversion Flash CS3
		 * @langversion 3.0
		 */ 
		public function prevFrame():void 
		{
			//if (!this.useSeconds) this.time = this._time - 1;
		}
		
		
		
		/**
		 * @private
		 */
		private function fixTime():void 
		{
			/*if (this.useSeconds) 
				this._startTime = getTimer() - this._time * 1000;*/
			
			/*if (!_useFrames) 
				this._startTime = getTimer() - this._time * 1000;*/
		}

		/**
		 * @private
		 */ 
		private function update():void 
		{
			//this.setPosition(this.getPosition(this._time));
		}
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * The duration of the tweened animation in frames or seconds. This property is set as
		 * a parameter when creating a new Tween instance or when calling the 
		 * <code>Tween.yoyo()</code> method.
		 */
		public function get duration():Number 
		{
			return this._duration;
		}
		
		public function set duration(value:Number):void 
		{
			_duration = (value <= 0) ? Infinity : value;
		}
		
		
	}

}