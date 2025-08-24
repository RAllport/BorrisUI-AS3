/* Author: Rohaan Allport
 * Date Created: 20/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BRadioButton component lets you force a user to make a single selection from a set of choices. 
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
	import flash.geom.Point;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.filters.*;
	
	import Borris.display.BElement;
	
	
	public class BIconRadioButton extends BRadioButton
	{
		// constants
		
		
		// assets
		
		
		// icons
		
		
		// text
		
		
		// other
		protected var tooltipTimer:Timer = new Timer(500, 0);
		
		
		// set and get
		protected var _tooltip:BTooltip;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BBIconRadioButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
		 * @param label The text label for the component.
		 * @param checked Specify whether the BradioButton should be selected or not.
         */
		public function BIconRadioButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = "", checked:Boolean = false) 
		{
			super(parent, x, y, label, checked);
			//initialize();		// causes duble drawing for some reason	
			setSize(30, 30);
			draw();
		}
		
		
		/**
		 * 
		 * @param event
		 */
		protected function tooltipTimerHandler(event:TimerEvent):void
		{
			_tooltip.display();
			tooltipTimer.reset();
			tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
		} // end function tooltipTimerHandler
		
		
		/**
		 * 
		 * @param event
		 */
		override protected function mouseHandler(event:MouseEvent):void
		{
			// if this item was clicked on, and it does NOT have a submenu.
			// The CLICK listener is added and removed in the "set enabled" function
			if(event.type == MouseEvent.CLICK)
			{
				// dispatch a new Event.SELECT object
				this.dispatchEvent(new Event(Event.SELECT, false, false));
				
				// set checked to not checked or Selected 
				//selected = !selected;
				if (selected)
				{
					selected = true;
				}
				else 
				{
					selected = !selected;
					if (selected)
					{
						//changeState(selectedOverSkin)
					}
				}
			} // end if
			
			
			parent.setChildIndex(this, parent.numChildren - 1);
			_tooltip.x = event.stageX;
			_tooltip.y = event.stageY + 22;
			
			
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
			
			
			if (enabled)
			{
				//trace("BIconRadioButton | Button enabled!");
				
				// if selected
				if(_selected)
				{
					//trace("BIconRadioButton | mouse event Button selected");
					switch(event.type)
					{
						case MouseEvent.ROLL_OVER:
							changeState(selectedOverSkin);
							tooltipTimer.start();
							tooltipTimer.addEventListener(TimerEvent.TIMER, tooltipTimerHandler);
							break;
							
						case MouseEvent.ROLL_OUT:
							changeState(selectedUpSkin);
							_tooltip.hide();
							if (tooltipTimer.hasEventListener(TimerEvent.TIMER))
							{
								tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
							}
							break;
							
						case MouseEvent.MOUSE_DOWN:
							changeState(selectedDownSkin);
							break;
							
						case MouseEvent.MOUSE_UP:
							changeState(selectedUpSkin);
							break;
					} //  end switch
				}
				else //  else (if not selected)
				{
					switch(event.type)
					{
						case MouseEvent.ROLL_OVER:
							changeState(overSkin);
							tooltipTimer.start();
							tooltipTimer.addEventListener(TimerEvent.TIMER, tooltipTimerHandler);
							break;
							
						case MouseEvent.ROLL_OUT:
							changeState(upSkin);
							_tooltip.hide();
							if (tooltipTimer.hasEventListener(TimerEvent.TIMER))
							{
								tooltipTimer.removeEventListener(TimerEvent.TIMER, tooltipTimerHandler);
							}
							break;
							
						case MouseEvent.MOUSE_DOWN:
							changeState(downSkin);
							break;
							
						case MouseEvent.MOUSE_UP:
							changeState(overSkin);
							break;
					} //  end switch
				}
				
				
			} // end if
			
			//trace(selectedUpSkin.visible);
			
		} // end function mouseHandler
		
		
		
		//***************************************** OVERRIDES *****************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// set state colors
			setStateColors(0x222222, 0x333333, 0x666666, 0x000000, 0x333333, 0x666666, 0x999999, 0x000000);
			setStateAlphas(0, 1, 1, 1, 1, 1, 1, 1);
			
			// text
			enabledTF = new TextFormat("Calibri", 14, 0x000000, false, false, false);
			
			// tooltip
			_tooltip = new BTooltip(DisplayObjectContainer(root), 0, 0, _label);
			_tooltip.displayPosition = "bottomRight";
			_tooltip.backgroundColor = 0x006699;
			
			removeChild(labelText);
			
			
			// event handling
			
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			//
			upSkin.width = 
			overSkin.width = 
			downSkin.width = 
			disabledSkin.width = 
			selectedUpSkin.width = 
			selectedOverSkin.width = 
			selectedDownSkin.width = 
			selectedDisabledSkin.width = _width;
			
			upSkin.height = 
			overSkin.height = 
			downSkin.height = 
			disabledSkin.height = 
			selectedUpSkin.height = 
			selectedOverSkin.height = 
			selectedDownSkin.height = 
			selectedDisabledSkin.height = _height;
			
			BElement(upSkin).style.backgroundColor = _upColor;
			BElement(upSkin).style.backgroundOpacity = _upAlpha;
			BElement(upSkin).style.borderColor = 0x333333;
			BElement(upSkin).style.borderOpacity = 1;
			BElement(upSkin).style.borderWidth = 0;
			
			BElement(overSkin).style.backgroundColor = _overColor;
			BElement(overSkin).style.backgroundOpacity = _overAlpha;
			BElement(overSkin).style.borderColor = 0x666666;
			BElement(overSkin).style.borderOpacity = 1;
			BElement(overSkin).style.borderWidth = 2;
			
			BElement(downSkin).style.backgroundColor = _downColor;
			BElement(downSkin).style.backgroundOpacity = _downAlpha;
			BElement(downSkin).style.borderColor = 0xCCCCCC;
			BElement(downSkin).style.borderOpacity = 0;
			BElement(downSkin).style.borderWidth = 2;
			
			BElement(disabledSkin).style.backgroundColor = _disabledColor;
			BElement(disabledSkin).style.backgroundOpacity = _disabledAlpha;
			BElement(disabledSkin).style.borderColor = 0xCCCCCC;
			BElement(disabledSkin).style.borderOpacity = 1;
			BElement(disabledSkin).style.borderWidth = 0;
			
			// 
			BElement(selectedUpSkin).style.backgroundColor = _selectedUpColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderColor = 0xCCCCCC;
			BElement(selectedUpSkin).style.borderOpacity = 1;
			BElement(selectedUpSkin).style.borderWidth = 0;
			BElement(selectedUpSkin).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];
			
			BElement(selectedOverSkin).style.backgroundColor = _selectedOverColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderColor = 0xCCCCCC;
			BElement(selectedOverSkin).style.borderOpacity = 1;
			BElement(selectedOverSkin).style.borderWidth = 0;
			BElement(selectedOverSkin).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];
			
			BElement(selectedDownSkin).style.backgroundColor = _selectedDownColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderColor = 0xCCCCCC;
			BElement(selectedDownSkin).style.borderOpacity = 1;
			BElement(selectedDownSkin).style.borderWidth = 0;
			BElement(selectedDownSkin).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];
			
			BElement(selectedDisabledSkin).style.backgroundColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.backgroundOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderColor = 0xCCCCCC;
			BElement(selectedDisabledSkin).style.borderOpacity = 1;
			BElement(selectedDisabledSkin).style.borderWidth = 0;
			BElement(selectedDisabledSkin).style.filters = [new DropShadowFilter(1, 90, 0x000000, 1, 4, 4, 1, 1, true)];
			
			
			
			// reposition the icons
			positionIcons();
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override protected function changeState(state:DisplayObject):void
		{
			
			if (allIconsSameFlag)
			{	
				upIcon.visible = allIconsSameFlag;
				return;
			}
			
			for(var i:int = 0; i < states.length; i++)
			{ 
				var tempState:DisplayObject = states[i];
				var tempIcon:DisplayObject = icons[i]
				
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
			
			
		} // function changeState
		
		
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * 
		 */
		public function get tooltip():BTooltip
		{
			return _tooltip
		}
				
		
		/**
		 * 
		 */
		public function get showTooltip():Boolean
		{
			return _tooltip.visible;
		}
		public function set showTooltip(value:Boolean):void
		{
			if (value)
			{
				_tooltip.visible = true;
				_tooltip.scaleX = _tooltip.scaleY = 1;
				_tooltip.alpha = 1;
			}
			else
			{
				_tooltip.visible = false;
				_tooltip.scaleX = _tooltip.scaleY = 0;
				_tooltip.alpha = 0;
			}
		}
		
		
		/**
		 * 
		 */
		public function get tooltipDelay():uint
		{
			return tooltipTimer.delay;
		}
		public function set tooltipDelay(value:uint):void
		{
			tooltipTimer.delay = value;
		}
		
		
		
	}

}