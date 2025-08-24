package Borris.controls.datePickerClasses 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.*;
	import Borris.display.BElement;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BDateCell extends BLabelButton 
	{
		// assets
		protected var currentUpSkin:Sprite;
		protected var currentOverSkin:Sprite;
		protected var currentDownSkin:Sprite;
		
		protected var currentSelectedUpSkin:Sprite;
		protected var currentSelectedOverSkin:Sprite;
		protected var currentSelectedDownSkin:Sprite;
		
		
		// style
		protected var currentMonthTF:TextFormat = new TextFormat("Calibri", 22, 0xFFFFFF, false);
		
		
		// other
		private var currentDay:Boolean = false;
		private var currentMonth:Boolean = false;
		
		
		// set and get
		protected var _state:String = "normal"; 				// up, over, down, selectedUp, selectedOver, selectedDown, current, notMonth 
		
		
		public function BDateCell(parent:DisplayObjectContainer=null, x:Number = 0, y:Number = 0) 
		{
			super(parent, x, y);
			setSize(40, 40);
			
			autoSize = false;
			labelPlacement = BButtonLabelPlacement.CENTER;
			toggle = true;
			setStateColors(0x000000, 0xCCCCCC, 0x666666, 0x000000, 0x00CCFF, 0x0099CC, 0x000000, 0x000000);
			setStateAlphas(0, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2, 0.1);
		}
		
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * @inheritDoc 
		 * 
		 * @param event
		 */
		override protected function mouseHandler(event:MouseEvent):void
		{
			
			//trace("mouse event recieved!: " + event.type);
			// if the button is not enabled set the disabeled skins and skip everything
			if (!enabled)
			{
				if (selected)
				{
					changeState(selectedDisabledSkin);
				}
				else
				{
					changeState(disabledSkin);
				}
				
				return;
			} //  end if
			
			
			// if this button was clicked on set selected
			// selected can only be set if the the toggle property is true
			if(event.type == MouseEvent.CLICK)
			{
				// set selected to not selected 
				selected = !selected;
				
				// only if selected is true, dispatch a new select event
				if (selected)
				{
					// dispatch a new selecte event
					this.dispatchEvent(new Event(Event.SELECT, false, false));
				}
			} // end if
			
			
			// this is a toggle button and it is selected, use the selecetd states
			// a button cant be selected unless is it a toggle button, so having the _toogle condition is unneccessary.
			// see BLableButton.selected
			if (_toggle && _selected)
			{
				switch(event.type)
				{
					case MouseEvent.ROLL_OVER:
						changeState(selectedOverSkin);
						break;
						
					case MouseEvent.ROLL_OUT:
						changeState(selectedUpSkin);
						break;
						
					case MouseEvent.MOUSE_DOWN:
						changeState(selectedDownSkin);
						break;
						
					case MouseEvent.MOUSE_UP:
						changeState(selectedOverSkin);
						break;
						
					case MouseEvent.CLICK:
						changeState(selectedOverSkin);
						break;
					
				} // end switch
				
				if (currentDay)
				switch(event.type)
				{
					case MouseEvent.ROLL_OVER:
						changeState(currentSelectedOverSkin);
						break;
						
					case MouseEvent.ROLL_OUT:
						changeState(currentSelectedUpSkin);
						break;
						
					case MouseEvent.MOUSE_DOWN:
						changeState(currentSelectedDownSkin);
						break;
						
					case MouseEvent.MOUSE_UP:
						changeState(currentSelectedOverSkin);
						break;
						
					case MouseEvent.CLICK:
						changeState(currentSelectedOverSkin);
						break;
					
				} // end switch
			}
			else // else if it is not a toggle button and not selected, use the normal skins
			{
				switch(event.type)
				{
					case MouseEvent.ROLL_OVER:
						changeState(overSkin);
						break;
						
					case MouseEvent.ROLL_OUT:
						changeState(upSkin);
						break;
						
					case MouseEvent.MOUSE_DOWN:
						changeState(downSkin);
						break;
						
					case MouseEvent.MOUSE_UP:
						changeState(overSkin);
						break;
						
					case MouseEvent.CLICK:
						changeState(overSkin);
						break;
					
				} // end switch
				
				if (currentDay)
				switch(event.type)
				{
					case MouseEvent.ROLL_OVER:
						changeState(currentOverSkin);
						break;
						
					case MouseEvent.ROLL_OUT:
						changeState(currentUpSkin);
						break;
						
					case MouseEvent.MOUSE_DOWN:
						changeState(currentDownSkin);
						break;
						
					case MouseEvent.MOUSE_UP:
						changeState(currentOverSkin);
						break;
						
					case MouseEvent.CLICK:
						changeState(currentOverSkin);
						break;
					
				} // end switch
			}
			
			//trace("Selected: " + selected);
			
		} // end function mouseHandler
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function initialize():void
		{
			// initialize the skins
			currentUpSkin = new BElement();
			currentOverSkin = new BElement();
			currentDownSkin = new BElement();
			currentSelectedUpSkin = new BElement();
			currentSelectedOverSkin = new BElement();
			currentSelectedDownSkin = new BElement();
			
			// call super initialize
			super.initialize();
			
			
			// add assets to respective containers
			addChild(currentUpSkin);
			addChild(currentOverSkin);
			addChild(currentDownSkin);
			addChild(currentSelectedUpSkin);
			addChild(currentSelectedOverSkin);
			addChild(currentSelectedDownSkin);
			
			removeChild(disabledSkin);
			removeChild(selectedDisabledSkin);
			
			
			// add the state skins to the state array
			states = new Array(upSkin, overSkin, downSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, currentUpSkin, 
			currentOverSkin, currentDownSkin, currentSelectedUpSkin, currentSelectedOverSkin, currentSelectedDownSkin);
			//changeState(upSkin);
			
			// 
			textField.setTextFormat(currentMonthTF);
			textField.defaultTextFormat = currentMonthTF;
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			var borderWidth:int = 2;
			var borderOpacity:Number = 0.8;
			
			//var upBorderColor:uint = 0x000000;
			var overBorderColor:uint = 0xCCCCCC;
			var downBorderColor:uint = 0xFFFFFF;
			var selectedUpBorderColor:uint = 0x0099CC;
			var selectedOverBorderColor:uint = 0x00CCFF;
			var selectedDownBorderColor:uint = 0x006699;
			var currentUpBorderColor:uint = 0x0099CC;
			var currentOverBorderColor:uint = 0x00CCFF;
			var currentDownBorderColor:uint = 0x006699;
			
			
			BElement(upSkin).style.backgroundColor = _upColor;
			BElement(upSkin).style.backgroundOpacity = _upAlpha;
			
			BElement(overSkin).style.backgroundColor = _overColor;
			BElement(overSkin).style.backgroundOpacity = _overAlpha;
			BElement(overSkin).style.borderWidth = borderWidth;
			BElement(overSkin).style.borderColor = overBorderColor;
			BElement(overSkin).style.borderOpacity = borderOpacity;
			
			BElement(downSkin).style.backgroundColor = _downColor;
			BElement(downSkin).style.backgroundOpacity = _downAlpha;
			BElement(downSkin).style.borderWidth = borderWidth;
			BElement(downSkin).style.borderColor = downBorderColor;
			BElement(downSkin).style.borderOpacity = borderOpacity;
			
			// selected skins
			BElement(selectedUpSkin).style.backgroundColor = _selectedUpColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderWidth = borderWidth;
			BElement(selectedUpSkin).style.borderColor = selectedUpBorderColor;
			BElement(selectedUpSkin).style.borderOpacity = borderOpacity;
			
			BElement(selectedOverSkin).style.backgroundColor = _selectedOverColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderWidth = borderWidth;
			BElement(selectedOverSkin).style.borderColor = selectedOverBorderColor;
			BElement(selectedOverSkin).style.borderOpacity = borderOpacity;
			
			BElement(selectedDownSkin).style.backgroundColor = _selectedDownColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderWidth = borderWidth;
			BElement(selectedDownSkin).style.borderColor = selectedDownBorderColor;
			BElement(selectedDownSkin).style.borderOpacity = borderOpacity;
			
			
			// current skins
			
			currentUpSkin.width = 
			currentOverSkin.width = 
			currentDownSkin.width = 
			currentSelectedUpSkin.width = 
			currentSelectedOverSkin.width = 
			currentSelectedDownSkin.width = _width;
			
			currentUpSkin.height = 
			currentOverSkin.height = 
			currentDownSkin.height = 
			currentSelectedUpSkin.height = 
			currentSelectedOverSkin.height = 
			currentSelectedDownSkin.height = _height;
			
			BElement(currentUpSkin).style.backgroundColor = 0x0099CC;
			BElement(currentUpSkin).style.backgroundOpacity = 1;
			
			BElement(currentOverSkin).style.backgroundColor = 0x0099CC;
			BElement(currentOverSkin).style.backgroundOpacity = 1;
			BElement(currentOverSkin).style.borderWidth = borderWidth;
			BElement(currentOverSkin).style.borderColor = 0x66CCFF;
			BElement(currentOverSkin).style.borderOpacity = 1;
			
			BElement(currentDownSkin).style.backgroundColor = 0x0099CC;
			BElement(currentDownSkin).style.backgroundOpacity = 1;
			BElement(currentDownSkin).style.borderWidth = borderWidth;
			BElement(currentDownSkin).style.borderColor = 0x006699;
			BElement(currentDownSkin).style.borderOpacity = 1;
			
			// selected 
			BElement(currentSelectedUpSkin).style.backgroundColor = 0x0099CC;
			BElement(currentSelectedUpSkin).style.backgroundOpacity = 1;
			BElement(currentSelectedUpSkin).style.borderWidth = borderWidth;
			//BElement(currentSelectedUpSkin).style.borderColor = 0x0099CC;
			BElement(currentSelectedUpSkin).style.borderColor = 0x66CCFF;
			BElement(currentSelectedUpSkin).style.borderOpacity = 1;
			
			BElement(currentSelectedOverSkin).style.backgroundColor = 0x0099CC;
			BElement(currentSelectedOverSkin).style.backgroundOpacity = 1;
			BElement(currentSelectedOverSkin).style.borderWidth = borderWidth;
			//BElement(currentSelectedOverSkin).style.borderColor = 0x66CCFF;
			BElement(currentSelectedOverSkin).style.borderColor = 0x99CCFF;
			BElement(currentSelectedOverSkin).style.borderOpacity = 1;
			
			BElement(currentSelectedDownSkin).style.backgroundColor = 0x0099CC;
			BElement(currentSelectedDownSkin).style.backgroundOpacity = 1;
			BElement(currentSelectedDownSkin).style.borderWidth = borderWidth;
			BElement(currentSelectedDownSkin).style.borderColor = 0x006699;
			BElement(currentSelectedDownSkin).style.borderOpacity = 1;
			
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override protected function changeState(state:DisplayObject):void
		{
			
			// replication of BBaseButton.changeState()
			var newTween:Tween;
			
			for(var i:int = 0; i < states.length; i++)
			{
				var tempState:DisplayObject = states[i]; 
				
				if(state == tempState)
				{
					newTween = new Tween(state, "alpha", Regular.easeOut, 0, 1, 0.3, true);
				}
				else
				{
					newTween = new Tween(tempState, "alpha", Regular.easeOut, tempState.alpha, 0, 0.3, true);
				}
				
			} // end for
			
			
			// 
			stateTimer.addEventListener(TimerEvent.TIMER, 
			function(event:TimerEvent):void
			{
				for(var i:int = 0; i < states.length; i++)
				{
					var tempState:DisplayObject = states[i]; 
					tempState.alpha = 0;
					
					if(state == tempState)
					{
						tempState.alpha = 1;
					}
				} // end for
				
				stateTimer.reset();
			}
			);
			stateTimer.start();
			
			
			// 
			if (currentMonth)
			{
				textField.alpha = 1;
			}
			else
			{
				textField.alpha = 0.5;
			}
			
		} // function changeState
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets for sets the sate of the cell.
		 */
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			
			
			currentDay = false;
			currentMonth = false;
			
			switch(_state)
			{
				/*case "up":
					changeState(upSkin);
					break;
				
				case "over":
					changeState(overSkin);
					break;
				
				case "down":
					changeState(downSkin);
					break;
				
				case "selectedUp":
					changeState(selectedUpSkin);
					break;
				
				case "selectedOver":
					changeState(selectedOverSkin);
					break;
				
				case "selectedDown":
					changeState(selectedDownSkin);
					break;
				
				case "currentUp":
					changeState(currentUpSkin);
					currentDay = true;
					break;
					
				case "currentOver":
					changeState(currentOverSkin);
					currentDay = true;
					break;
					
				case "currentDown":
					changeState(currentDownSkin);
					currentDay = true;
					break;
				
				//case "notMonth":
					//changeState(notMonthSkin);
					//break;*/
				
				case "normal":
					changeState(upSkin);
					break;
				
				case "currentMonth":
					currentMonth = true;
					changeState(upSkin);
					break;	
					
				case "currentDay":
					currentMonth = true;
					currentDay = true;
					changeState(currentUpSkin);
					break;
				
				default:
					changeState(upSkin);
				
			} // end switch case
			
		}
		
	}

}