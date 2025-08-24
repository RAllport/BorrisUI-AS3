/* Author: Rohaan Allport
 * Date Created: 26/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
*/


package Borris.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.geom.Point;
	
	
	public class BInput 
	{
		// constants
		public static const KEY_DOWN:String = "keyDown";
		public static const KEY_UP:String = "keyUp";
		public static const KEY_PRESSED:String = "keyPressed";
		public static const KEY_RELEASED:String = "keyReleased";
		
		public static const MOUSE_DOWN:String = "";
		public static const MOUSE_UP:String = "";
		public static const MOUSE_PRESSED:String = "";
		public static const MPUSE_RELEASED:String = "";
		public static const MOUSE_MOVING:String = "";
		
		
		// key variables
		private static var keysDown:Array;
		private static var keyState:Array;
		private static var _lastKey:int;						// [read only]
		private static var _framesSinceLastKey:int; 			// [read only]
		private static var _lastKeyFrameDifference:int;			// [read only]
		//public static var timeSinceLastKey:int;
		private static var keyBuffer:Array;
		private static var bufferSize:int;
		
		
		// mouse variables
		public static var mouseIsDown:Boolean = false;
		public static var mouseReleased:Boolean = false;
		public static var mousePressed:Boolean = false;
		//public static var mouseOver:Boolean = false;
		public static var mouseX:Number = 0;
		public static var mouseY:Number = 0;
		public static var prevMouseX:Number = 0;
		public static var prevMouseY:Number = 0;
		private static var mousePos:Point = new Point();
		public static var mouseOffsetX:Number = 0;
		public static var mouseOffsetY:Number = 0;
		public static var mouseDragX:Number = 0;
		public static var mouseDragY:Number = 0;
		public static var mouseDetectable:Boolean = false; /// True if flash knows what the mouse is doing.
		
		
		// touch variables
		//public static var touch:Touch;
		public static var touchX:Number = 0;
		public static var touchY:Number = 0;
		public static var prevTouchX:Number = 0;
		public static var prevTouchY:Number = 0;
		private static var touchPos:Point = new Point();
		public static var touchOffsetX:Number = 0;
		public static var touchOffsetY:Number = 0;
		public static var touchDragX:Number = 0;
		public static var touchDragY:Number = 0;
		
		public static var touchPressure:Number = 0;
		public static var touchWidth:Number = 0;
		public static var touchHeight:Number = 0;
		
		public static var fingerIsDown:Boolean = false;
		public static var fingerReleased:Boolean = false;
		public static var fingerTap:Boolean = false;
		
		
		// gesture variables
		
		
		// stage
		private static var stage:DisplayObjectContainer;
		
		
		// other
		private static var initialized:Boolean = false;
		
		
		/*public function BInput() 
		{
			
		}*/
		
		
		// function initialize
		// initialize the BInput
		public static function initialize(mainStage:DisplayObjectContainer, handleOwnUpdate:Boolean = false):void
		{
			if(initialized)
			{
				return;
			}
			initialized = true;

			stage = mainStage;
			BInput.handleOwnUpdate = handleOwnUpdate;
			keysDown = new Array();
			
			
			// make keyStages a new array with 222 items
			keyState = new Array(222);
			for(var i:int = 0; i < keyState.length; i++)
			{
				keyState[i] = KEY_UP;
			}
			
			
			// event handling
			
			// keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
			
			// mouse
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			/*stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_CLICK, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseClickHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseClickHandler, false, 0, true);*/
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			
			// touch
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			//stage.addEventListener(TouchEvent.TOUCH_OUT, touchOutHandler);
			//stage.addEventListener(TouchEvent.TOUCH_OVER, touchOverHandler);
			//stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, touchRollOutHandler);
			//stage.addEventListener(TouchEvent.TOUCH_ROLL_OVER, touchRollOverHandler);
			//stage.addEventListener(TouchEvent.TOUCH_TAP, touchTapHandler);
			//stage.addEventListener(TouchEvent.PROXIMITY_BEGIN, proximityBeginHandler);
			
			// gestures
			/*stage.addEventListener(TransformGestureEvent.GESTURE_PAN, gesturePanHandler);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, gestureSwipeHandler);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, gestureZoomHandler);
			
			stage.addEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, gestureTwoFingerTabHandler);
			stage.addEventListener(PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP, gesturePressAndTapHandler);*/
			
		} // end function initialize
		
		
		
		
		//****************************************** MOUSE INPUT FUNCTIONS ***************************************************
		
		// function pressAKey
		// fills an array with any keys that are currently held down
		private static function keyDown(event:KeyboardEvent):void
		{
			for(var i:int = 0; i < keysDown.length; i++)
			{
				if(keysDown[i] == event.keyCode)
				{
					return;
				}
			} // end for
			
			keysDown.push(event.keyCode);
			
			
			// 
			keyState[event.keyCode] = KEY_PRESSED;
			_lastKey = event.keyCode;
			_lastKeyFrameDifference = _framesSinceLastKey;
			_framesSinceLastKey = 0;
		} // end function pressAKey
		
		
		// function releaseAKey
		// removes keys from an array of they were released
		private static function keyUp(event:KeyboardEvent):void
		{
			var keyPos:int;
			for(var i:int = 0; i < keysDown.length; i++)
			{
				if(keysDown[i] == event.keyCode)
				{
					keyPos = i;
					break;
				} 
			}
			
			//trace("key up: " + event.keyCode);
			keysDown.splice(keyPos, 1);
			
			
			// 
			//keyState[keyCode] = KEY_UP;
			keyState[event.keyCode] = KEY_RELEASED;
		} // end function releaseAKey
		
		
		// function enterFrameHandler
		// runs when "handleOwnUpdate" is true
		private static function enterFrameHandler(event:Event):void
		{
			//trace("BInput | W: "  + keyState[Keyboard.W]);
			update();
		} // end function enterFrameHandler
		
		
		// function keyIsDown
		// 
		public static function keyIsDown(keyCode:int):Boolean
		{
			// 
			if(keyState[keyCode] == KEY_DOWN || keyState[keyCode] == KEY_PRESSED)
			{
				return true;
			}
			return false;
			
			// or
			//return (keyState[keyCode] == KEY_DOWN || keyState[keyCode] == KEY_PRESSED);
			
		} // end function keyIsDown
		
		
		// function keyPressed
		// check to see if the key was pressed on the current frame
		public static function keyPressed(keyCode:int):Boolean
		{
			// 
			if(keyState[keyCode] == KEY_PRESSED)
			{
				return true;
			}
			return false;
			
			// or
			//return (keyState[keyCode] == KEY_PRESSED);
			
		} // function keyPressed
		
		
		// function keyReleased
		// check to see if a key has been released on that frame
		public static function keyReleased(keyCode:int):Boolean
		{
			if(keyState[keyCode] == KEY_RELEASED)
			{
				return true;
			}
			return false;
			
		} // end function keyReleased 
		
		
		// function update
		// Run this function in the main loop
		public static function update():void
		{	
			//trace(framesSinceLastKey);
			_framesSinceLastKey++;
			
			// update key states
			for(var i:int = 0; i < keyState.length; i++)
			{
				
				if(keyState[i] != KEY_UP)
				{
					// set key state to UP if the key state is currently "RELEASED"
					if(keyState[i] == KEY_RELEASED)
					{
						keyState[i] = KEY_UP;
					}
					
					// set key state to DOWN if the key state is currently "PRESSED"
					if(keyState[i] == KEY_PRESSED)
					{
						keyState[i] = KEY_DOWN;
					} // end if
				} // end if
			} // end for
			
			
			// update mouse states
			//mouseIsDown = false;
			mousePressed = false;
			mouseReleased = false;
			//mouseOver = false;
			
			//fingerIdDown = false;
			fingerTap = false;
			fingerReleased = false;
			
		} // end function update
		
		
		//****************************************** MOUSE INPUT FUNCTIONS ***************************************************
		
		
		// function mouseDownHandler
		// 
		private static function mouseDownHandler(event:MouseEvent):void
		{
			mouseIsDown = true;
			mouseReleased = false
			mousePressed = true;
			mouseDragX = 0;
			mouseDragY = 0;
		} // end function mouseDownHandler
		
		
		// function mouseUpHandler
		// 
		private static function mouseUpHandler(event:MouseEvent):void
		{
			mouseIsDown = false;
			mouseReleased = true;
			mousePressed = false;
		} // end function mouseUpHandler
		
		
		// function mouseMoveHandler
		// 
		private static function mouseMoveHandler(event:MouseEvent):void
		{
			// Fix mouse release not being registered from mouse going off stage
			if (mouseIsDown != event.buttonDown)
			{
				mouseIsDown = event.buttonDown;
				mouseReleased = !event.buttonDown;
				mousePressed = event.buttonDown;
				mouseDragX = 0;
				mouseDragY = 0;
			}
			
			// Set mouseX, mouseY and mousePos
			mouseX = mousePos.x = event.stageX - stage.x;
			mouseY = mousePos.y = event.stageY - stage.y;
			
			// Store offset
			mouseOffsetX = mouseX - prevMouseX;
			mouseOffsetY = mouseY - prevMouseY;
			
			// Update drag
			if (mouseIsDown)
			{
				mouseDragX += mouseOffsetX;
				mouseDragY += mouseOffsetY;
			}
			
			prevMouseX = mouseX;
			prevMouseY = mouseY;
		} // end function mouseMoveHandler
		
		
		// function mouseLeavHandler
		// 
		private static function mouseLeaveHandler(event:Event):void
		{
			mouseReleased = mouseIsDown;
			mouseIsDown = false;
			mousePressed = false;
			
			mouseDetectable = false;
			//stage.dispatchEvent(new Event(MOUSE_UP_OR_LOST));
		} // end function mouseLeavHandler
		
		
		// function mousePositionIn
		//
		public static function mousePositionIn(displayObject:DisplayObject):Point
		{
			return displayObject.globalToLocal(mousePos);
		} // function mousePositionIn
		
		
		
		//****************************************** TOUCH INPUT FUNCTIONS ***************************************************
		
		
		// function touchBeginHandler
		// 
		public static function touchBeginHandler(event:TouchEvent):void
		{
			fingerIsDown = true;
			fingerReleased = false
			fingerTap = true;
			touchDragX = 0;
			touchDragY = 0;
			
			touchPressure = event.pressure;
		} // end function touchBeginHandler
		
		
		// function touchEndHandler
		// 
		public static function touchEndHandler(event:TouchEvent):void
		{
			fingerIsDown = false;
			fingerReleased = true;
			fingerTap = false;
			
			touchPressure = 0;
		} // end function touchEndHandler
		
		
		// function touchMoveHandler
		// 
		public static function touchMoveHandler(event:TouchEvent):void
		{
			// Set touchX, touchY and touchPos
			touchX = touchPos.x = event.stageX - stage.x;
			touchY = touchPos.y = event.stageY - stage.y;
			
			// Store offset
			touchOffsetX = touchX - prevTouchX;
			touchOffsetY = touchY - prevTouchY;
			
			// Update drag
			if (fingerIsDown)
			{
				touchDragX += touchOffsetX;
				touchDragY += touchOffsetY;
			}
			
			prevTouchX = touchX;
			prevTouchY = touchY;
			
			// Set touchPressure
			touchPressure = event.pressure;
		} // end function touchMoveHandler
		
		
		// function touchPositionIn
		// 
		public static function touchPositionIn(displayObject:DisplayObject):Point
		{
			return displayObject.globalToLocal(touchPos);
		} // end function touchPositionIn
		
		
		
		// **************************************  ********************************************
		
		// 
		// 
		/*public static function penStartHandler(event:AccelerometerEvent):void
		{
			AccelerometerEvent;
			GeolocationEvent;
			LocationChangeEvent
			PressAndTapGestureEvent
			StageOrientationEvent
		} // */
		
		
		// ************************************** SET AND GET ********************************************
		
		// lastKey
		public static function get lastKey():int
		{
			return _lastKey;
		}
		
		
		// framesSinceLastKey
		public static function get framesSinceLastKey():int
		{
			return _framesSinceLastKey;
		}
		
		
		// lastKeyFrameDifference
		public static function get lastKeyFrameDifference():int
		{
			return _lastKeyFrameDifference;
		}
		
		
		// handleOwnUpdate
		public static function set handleOwnUpdate(value:Boolean):void
		{
			// if value is true, add an enter frame listener to run the update function
			if (value)
			{
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			} //  end if
			else
			{
				if (stage.hasEventListener(Event.ENTER_FRAME))
				{
					stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
			}
		}
		
		public static function get handOwnUpdate():Boolean
		{
			return stage.hasEventListener(Event.ENTER_FRAME);
		}
		
		 
	}

}