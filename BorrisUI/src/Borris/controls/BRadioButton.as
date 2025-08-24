/* Author: Rohaan Allport
 * Date Created: 20/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The RadioButton component lets you force a user to make a single selection from a set of choices. 
 * 			This component must be used in a group of at least two RadioButton instances. 
 * 			Only one member of the group can be selected at any given time. 
 * 			Selecting one radio button in a group deselects the currently selected radio button in the group. 
 * 			You set the groupName parameter to indicate which group a radio button belongs to. 
 * 			When the user clicks or tabs into a RadioButton component group, only the selected radio button receives focus.
 * 
 * 			A radio button can be enabled or disabled. A disabled radio button does not receive mouse or keyboard input.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.events.*
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	
	//import fl.transitions.*;
	//import fl.transitions.easing.*;
	
	import mx.effects.*;
	import mx.effects.easing.*;
	
	import Borris.display.BElement;
	import Borris.transitions.*;
	
	
	public class BRadioButton extends BLabelButton
	{
		// constants
		
		
		// assets
		
		
		// other
		protected var defaultGroupName:String = "BRadioButtonGroup";
		
		
		// set and get
		protected var _group:BRadioButtonGroup;		// The BRadioButtonGroup object to which this RadioButton belongs.
		protected var _groupName:String;			// The group name for a radio button instance or group.
		protected var _value:Object;				// A user-defined value that is associated with a radio button.
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BRadioButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
		 * @param label The text label for the component.
		 * @param checked Specify whether the BradioButton should be selected or not.
         */
		public function BRadioButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = "", checked:Boolean = false)
		{
			_toggle = true;
			_autoSize = false;
			_groupName = defaultGroupName;
			_value = null;
			
			super(parent, x, y, label);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override protected function mouseHandler(event:MouseEvent):void
		{
			// the super.mouseHandler() could be called here, but it wouldn't make much sense due to the nature and order of how to change the states.
			
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
			
			
			// if this item was clicked on, and it does NOT have a a submenu.
			// The CLICK listener is added and removed in the "set enabled" function
			if(event.type == MouseEvent.CLICK)
			{
				// if this button was clicked on set selected
				// selected can only be set if the the toggle property is true
				// if a radio buton is click when it is slected, it remains selected.
				// a radio button cannot become unselected by clicking it, only via another radio button from the same group being clicked
				if (selected)
				{
					//selected = true;
					return;
				}
				else 
				{
					selected = !selected;
				}
				
				// only if selected is true, dispatch a new select event
				if (selected)
				{
					// dispatch a new selecte event
					this.dispatchEvent(new Event(Event.SELECT, false, false));
				}
			} // end if
			
			
			if (_selected)
			//if (_toggle && _selected)
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
							changeState(selectedUpSkin);
							break;
						
						case MouseEvent.CLICK:
							changeState(selectedUpSkin);
							break;
					} // end switch
			}
			else
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
						changeState(upSkin);
						break;
					
					case MouseEvent.CLICK:
						changeState(upSkin);
						break;
				} // end switch
			}
			
		} // end function mouseHandler
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// 
			labelText.x = 30;
			labelText.y = 0;
			
			// set state colors
			setStateColors(0xCCCCCC, 0xFFFFFF, 0x999999, 0x666666, 0x0099CC, 0x00CCFF, 0x006699, 0x003366);
			setStateAlphas(1, 1, 1, 0.8, 1, 1, 1, 0.8);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			var buttonWidth:int = 20;
			var buttonHeight:int = 20;
			var strokeThickness:int = 2;
			var circleRadius:int = 6;
			var backColor:uint = 0x000000;
			
			
			//
			upSkin.width = 
			overSkin.width = 
			downSkin.width = 
			disabledSkin.width = 
			selectedUpSkin.width = 
			selectedOverSkin.width = 
			selectedDownSkin.width = 
			selectedDisabledSkin.width = buttonWidth;
			
			upSkin.height = 
			overSkin.height = 
			downSkin.height = 
			disabledSkin.height = 
			selectedUpSkin.height = 
			selectedOverSkin.height = 
			selectedDownSkin.height = 
			selectedDisabledSkin.height = buttonHeight;
			
			BElement(upSkin).style.backgroundColor = backColor;
			BElement(upSkin).style.backgroundOpacity = _upAlpha;
			BElement(upSkin).style.borderColor = _upColor;
			BElement(upSkin).style.borderOpacity = _upAlpha;
			BElement(upSkin).style.borderRadius = buttonHeight;
			BElement(upSkin).style.borderWidth = strokeThickness;
			
			BElement(overSkin).style.backgroundColor = backColor;
			BElement(overSkin).style.backgroundOpacity = _overAlpha;
			BElement(overSkin).style.borderColor = _overColor;
			BElement(overSkin).style.borderOpacity = _overAlpha;
			BElement(overSkin).style.borderRadius = buttonHeight;
			BElement(overSkin).style.borderWidth = strokeThickness;
			
			BElement(downSkin).style.backgroundColor = backColor;
			BElement(downSkin).style.backgroundOpacity = _downAlpha;
			BElement(downSkin).style.borderColor = _downColor;
			BElement(downSkin).style.borderOpacity = _downAlpha;
			BElement(downSkin).style.borderRadius = buttonHeight;
			BElement(downSkin).style.borderWidth = strokeThickness;
			
			BElement(disabledSkin).style.backgroundColor = backColor;
			BElement(disabledSkin).style.backgroundOpacity = _disabledAlpha;
			BElement(disabledSkin).style.borderColor = _downColor;
			BElement(disabledSkin).style.borderOpacity = _disabledAlpha;
			BElement(disabledSkin).style.borderRadius = buttonHeight;
			BElement(disabledSkin).style.borderWidth = strokeThickness;
			
			// 
			BElement(selectedUpSkin).style.backgroundColor = backColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderColor = _selectedUpColor;
			BElement(selectedUpSkin).style.borderOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderRadius = buttonHeight;
			BElement(selectedUpSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedOverSkin).style.backgroundColor = backColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderColor = _selectedOverColor;
			BElement(selectedOverSkin).style.borderOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderRadius = buttonHeight;
			BElement(selectedOverSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedDownSkin).style.backgroundColor = backColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderColor = _selectedDownColor;
			BElement(selectedDownSkin).style.borderOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderRadius = buttonHeight;
			BElement(selectedDownSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedDisabledSkin).style.backgroundColor = backColor;
			BElement(selectedDisabledSkin).style.backgroundOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.borderOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderRadius = buttonHeight;
			BElement(selectedDisabledSkin).style.borderWidth = strokeThickness;
			
			
			
			// icons
			/*upIcon.graphics.clear();
			upIcon.graphics.beginFill(_upColor, 1);
			upIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			upIcon.graphics.endFill();
			
			overIcon.graphics.clear();
			overIcon.graphics.beginFill(_overColor, 1);
			overIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			overIcon.graphics.endFill();
			
			downIcon.graphics.clear();
			downIcon.graphics.beginFill(_downColor, 1);
			downIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			downIcon.graphics.endFill();
			
			disabledIcon.graphics.clear();
			disabledIcon.graphics.beginFill(_disabledColor, 1);
			disabledIcon.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			disabledIcon.graphics.endFill();*/
			
			
			// selected icons
			Sprite(selectedUpIcon).graphics.clear();
			Sprite(selectedUpIcon).graphics.beginFill(_upColor, 1);
			Sprite(selectedUpIcon).graphics.drawCircle(0, 0, circleRadius);
			Sprite(selectedUpIcon).graphics.endFill();
			
			Sprite(selectedOverIcon).graphics.clear();
			Sprite(selectedOverIcon).graphics.beginFill(_overColor, 1);
			Sprite(selectedOverIcon).graphics.drawCircle(0, 0, circleRadius);
			Sprite(selectedOverIcon).graphics.endFill();
			
			Sprite(selectedDownIcon).graphics.clear();
			Sprite(selectedDownIcon).graphics.beginFill(_downColor, 1);
			Sprite(selectedDownIcon).graphics.drawCircle(0, 0, circleRadius);
			Sprite(selectedDownIcon).graphics.endFill();
			
			Sprite(selectedDisabledIcon).graphics.clear();
			Sprite(selectedDisabledIcon).graphics.beginFill(_disabledColor, 1);
			Sprite(selectedDisabledIcon).graphics.drawCircle(0, 0, circleRadius);
			Sprite(selectedDisabledIcon).graphics.endFill();
			
			
			// position icons
			upIcon.x = overIcon.x = downIcon.x = disabledIcon.x = buttonHeight / 2;
			selectedUpIcon.x = selectedOverIcon.x = selectedDownIcon.x = selectedDisabledIcon.x = buttonHeight / 2;
			upIcon.y = overIcon.y = downIcon.y = disabledIcon.y = selectedUpIcon.y = selectedOverIcon.y = selectedDownIcon.y = selectedDisabledIcon.y = buttonHeight / 2;
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override protected function changeState(state:DisplayObject):void
		{
			var prevState:DisplayObject;
			
			for(var i:int = 0; i < states.length; i++)
			{ 
				var tempState:DisplayObject = states[i]; 
				var tempIcon:DisplayObject = icons[i];
				
				if (tempState.visible)
				{
					prevState = tempState;
				}
				
				if(state == tempState)
				{
					tempState.visible = true;
					tempIcon.visible = true;
				}
				else 
				{
					tempState.visible = false;
					tempIcon.visible = false;
				}
				
			} // end for
			
			var newTween:Tween;
			
			if (state == selectedUpSkin)
			{
				if (prevState == upSkin)
				{
					//newTween = new Tween(selectedUpIcon, "scaleX", Regular.easeOut, 0, 1, 0.3, true);
					//newTween = new Tween(selectedUpIcon, "scaleY", Regular.easeOut, 0, 1, 0.3, true);
					
					var timer:Timer = new Timer(300, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void
					{
						selectedUpIcon.visible = true;
						selectedUpIcon.scaleX = selectedUpIcon.scaleY = 1;
					} // end anomymous function
					); // end timer.addEventListener()
					
					timer.start();
					
					newTween = new Tween(this, 0, 1, 300, -1, onShowIconUpdate, onShowIconEnd);
					
					function onShowIconUpdate(value:Object):void
					{
						selectedUpIcon.scaleX = value as Number;
						selectedUpIcon.scaleY = value as Number;
					}
					
					function onShowIconEnd(value:Object):void
					{
						selectedUpIcon.scaleX = value as Number;
						selectedUpIcon.scaleY = value as Number;
					}
					
					var newBTween:BTween = new BTween(selectedUpIcon, 0.3, null, { scaleX: 1, scaleY: 1 }, null);
					
				} // end if
			}
			else if (state == upSkin)
			{
				if (prevState == selectedUpSkin)
				{
					selectedUpIcon.visible = true;
					//newTween = new Tween(selectedUpIcon, "scaleX", Regular.easeOut, 1, 0, 0.3, true);
					//newTween = new Tween(selectedUpIcon, "scaleY", Regular.easeOut, 1, 0, 0.3, true);
					newTween = new Tween(this, 1, 0, 300, -1, onHideIconUpdate, onHideIconEnd);
					
					function onHideIconUpdate(value:Object):void
					{
						selectedUpIcon.scaleX = value as Number;
						selectedUpIcon.scaleY = value as Number;
					}
					
					function onHideIconEnd(value:Object):void
					{
						selectedUpIcon.scaleX = value as Number;
						selectedUpIcon.scaleY = value as Number;
					}
					
				} // end if
				
			} // end else if
			
		} // end function changeState
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * The BRadioButtonGroup object to which this RadioButton belongs.
		 */
		public function get group():BRadioButtonGroup
		{
			return _group;
		}
		public function set group(value:BRadioButtonGroup):void
		{
			_group = value;
			value.addRadioButton(this) 
		}
		
		
		/**
		 * The group name for a radio button instance or group. 
		 * You can use this property to get or set a group name for a radio button instance or for a radio button group
		 * 
		 * @default "RadioButtonGroup"
		 */
		public function get groupName():String
		{
			return _groupName;
		}
		public function set groupName(value:String):void
		{
			_groupName = value;
		}
		
		
		/**
		 * Indicates whether a radio button is currently selected (true) or deselected (false). 
		 * You can only set this value to true; setting it to false has no effect. 
		 * To achieve the desired effect, select a different radio button in the same radio button group.
		 * 
		 * @default false
		 */
		override public function set selected(value:Boolean):void
		{
			if(value && _enabled)
			{
				changeState(selectedUpSkin);
			}
			else
			{
				changeState(upSkin);
			}
			
			_selected = value;
			
			
			if (_group)
			{
				if(_selected)
				{
					_group.clear(this);
				}
			}
			
			
		}
		
		
		/**
		 * A radio button is a toggle button; its toggle property is set to true in the constructor and cannot be changed.
		 * 
		 * @default true
		 */
		override public function set toggle(value:Boolean):void
		{
			return;
		}
		
		
		/**
		 * A user-defined value that is associated with a radio button.
		 * 
		 * @default null
		 */
		public function get value():Object
		{
			return _value;
		}
		public function set value(value:Object):void
		{
			_value = value;
		}
		
	}

}