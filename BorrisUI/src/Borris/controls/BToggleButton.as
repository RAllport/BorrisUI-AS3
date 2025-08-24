/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BToggleButton displays an oval/elipse like shape contains a circular icon. 
 * 			A BToggleButton can also display an optional text label that is positioned to the left, right, top, or bottom of the BToggleButton.
 * 
 * 			A BToggleButton changes its state in response to a mouse click or swipe, from on to off, or from off to on. 
 * 			BToggleButton components include a set of true or false values that are not mutually exclusive.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls
{
	import Borris.assets.icons.TickIconFlat256_256;
	import flash.display.*;
	import flash.events.*
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.display.BElement;
	
	
	public class BToggleButton extends BLabelButton
	{
		// constants
		
		
		// assets
		
		
		// other
		
		
		// set and get
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BToggleButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
		 * @param label The text label for the component.
         */
		public function BToggleButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = ""):void
		{
			_toggle = true;
			_autoSize = false;
			
			super(parent, x, y, label);
			//initialize();		// causes duble drawing for some reason	
			setSize(100, 20);
			//draw();
		}
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 * 
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// 
			labelText.x = 50;
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
			var buttonWidth:int = 40;
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
			BElement(selectedUpSkin).style.backgroundColor = _selectedUpColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderColor = _selectedUpColor;
			BElement(selectedUpSkin).style.borderOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderRadius = buttonHeight;
			BElement(selectedUpSkin).style.borderWidth = 0;
			
			BElement(selectedOverSkin).style.backgroundColor = _selectedOverColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderColor = _selectedOverColor;
			BElement(selectedOverSkin).style.borderOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderRadius = buttonHeight;
			BElement(selectedOverSkin).style.borderWidth = 0;
			
			BElement(selectedDownSkin).style.backgroundColor = _selectedDownColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderColor = _selectedDownColor;
			BElement(selectedDownSkin).style.borderOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderRadius = buttonHeight;
			BElement(selectedDownSkin).style.borderWidth = 0;
			
			BElement(selectedDisabledSkin).style.backgroundColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.backgroundOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.borderOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderRadius = buttonHeight;
			BElement(selectedDisabledSkin).style.borderWidth = 0;
			
			
			// icons
			Sprite(upIcon).graphics.clear();
			Sprite(upIcon).graphics.beginFill(_upColor, 1);
			Sprite(upIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(upIcon).graphics.endFill();
			
			Sprite(overIcon).graphics.clear();
			Sprite(overIcon).graphics.beginFill(_overColor, 1);
			Sprite(overIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(overIcon).graphics.endFill();
			
			Sprite(downIcon).graphics.clear();
			Sprite(downIcon).graphics.beginFill(_downColor, 1);
			Sprite(downIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(downIcon).graphics.endFill();
			
			Sprite(disabledIcon).graphics.clear();
			Sprite(disabledIcon).graphics.beginFill(_disabledColor, 1);
			Sprite(disabledIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(disabledIcon).graphics.endFill();
			
			// selected icons
			Sprite(selectedUpIcon).graphics.clear();
			Sprite(selectedUpIcon).graphics.beginFill(_upColor, 1);
			Sprite(selectedUpIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(selectedUpIcon).graphics.endFill();
			
			Sprite(selectedOverIcon).graphics.clear();
			Sprite(selectedOverIcon).graphics.beginFill(_overColor, 1);
			Sprite(selectedOverIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(selectedOverIcon).graphics.endFill();
			
			Sprite(selectedDownIcon).graphics.clear();
			Sprite(selectedDownIcon).graphics.beginFill(_downColor, 1);
			Sprite(selectedDownIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(selectedDownIcon).graphics.endFill();
			
			Sprite(selectedDisabledIcon).graphics.clear();
			Sprite(selectedDisabledIcon).graphics.beginFill(_disabledColor, 1);
			Sprite(selectedDisabledIcon).graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			Sprite(selectedDisabledIcon).graphics.endFill();
			
			
			// position icons
			upIcon.x = overIcon.x = downIcon.x = disabledIcon.x = (buttonHeight - (circleRadius * 2)) / 2;
			selectedUpIcon.x = selectedOverIcon.x = selectedDownIcon.x = selectedDisabledIcon.x = buttonWidth - 2 - 2 - 12;
			upIcon.y = overIcon.y = downIcon.y = disabledIcon.y = selectedUpIcon.y = selectedOverIcon.y = selectedDownIcon.y = selectedDisabledIcon.y = (buttonHeight - (circleRadius * 2)) / 2;
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function changeState(state:DisplayObject):void
		{
			for(var i:int = 0; i < states.length; i++)
			{ 
				var tempState:DisplayObject = states[i]; 
				var tempIcon:DisplayObject = icons[i];
				
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
			
			if (state == selectedOverSkin)
			{
				newTween = new Tween(upIcon, "x", Regular.easeOut, upIcon.x, 40 - 2 - 2 - 12, 0.3, true);
				newTween = new Tween(selectedUpIcon, "x", Regular.easeOut, upIcon.x, 40 - 2 - 2 - 12, 0.3, true);
				newTween = new Tween(overIcon, "x", Regular.easeOut, overIcon.x, 40 - 2 - 2 - 12, 0.3, true);
				newTween = new Tween(selectedOverIcon, "x", Regular.easeOut, overIcon.x, 40 - 2 - 2 - 12, 0.3, true);
			}
			else if (state == overSkin)
			{
				newTween = new Tween(upIcon, "x", Regular.easeOut, upIcon.x, 2 + 2, 0.3, true);
				newTween = new Tween(overIcon, "x", Regular.easeOut, overIcon.x, 2 + 2, 0.3, true);
			}
			
		} // function changeState
		
		
		//***************************************** SET AND GET *****************************************
		
		
		// toggle
		override public function set toggle(value:Boolean):void
		{
			return;
		}
		
		// icon
		override public function set icon(value:DisplayObject):void
		{
			return;
		}
		
		override public function get icon():DisplayObject
		{
			return null;
		}
		
		
	}

}