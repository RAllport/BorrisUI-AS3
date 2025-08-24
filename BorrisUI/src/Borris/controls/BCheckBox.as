/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BCheckBox displays a small box that can contain a check mark. 
 * 			A BCheckBox can also display an optional text label that is positioned to the left, right, top, or bottom of the BCheckBox.
 * 
 * 			A BCheckBox changes its state in response to a mouse click, from selected to cleared, or from cleared to selected. 
 * 			BCheckBox components include a set of true or false values that are not mutually exclusive.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.events.*
	import flash.geom.ColorTransform;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.assets.icons.TickIconFlat256_256;
	import Borris.display.BElement;
	
	
	public class BCheckBox extends BLabelButton
	{
		// constants
		
		
		// assets
		
		
		// other
		
		
		// set and get
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BCheckBox component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
		 * @param label The text label for the component.
         */
		public function BCheckBox(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = ""):void
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
			labelText.x = 30;
			labelText.y = 0;
			
			// set state colors
			setStateColors(0xCCCCCC, 0xFFFFFF, 0x999999, 0x666666, 0xCCCCCC, 0xFFFFFF, 0x999999, 0x666666);
			setStateAlphas(1, 1, 1, 0.8, 1, 1, 1, 0.8);
			
			setIcon(null, null, null, null, null, new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256(), new TickIconFlat256_256());
			setIconBounds(2, 2, 16, 16);
			
			// 
			selectedUpIcon.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 0x00, 0x99, 0xCC, 0);
			selectedOverIcon.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 0x00, 0xCC, 0xFF, 0);
			selectedDownIcon.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 0x00, 0x66, 0x99, 0);
			selectedDisabledIcon.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 0x00, 0x33, 0x66, 0);
			
			
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
			selectedDisabledSkin.width = buttonHeight;
			
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
			BElement(upSkin).style.borderWidth = strokeThickness;
			
			BElement(overSkin).style.backgroundColor = backColor;
			BElement(overSkin).style.backgroundOpacity = _overAlpha;
			BElement(overSkin).style.borderColor = _overColor;
			BElement(overSkin).style.borderOpacity = _overAlpha;
			BElement(overSkin).style.borderWidth = strokeThickness;
			
			BElement(downSkin).style.backgroundColor = backColor;
			BElement(downSkin).style.backgroundOpacity = _downAlpha;
			BElement(downSkin).style.borderColor = _downColor;
			BElement(downSkin).style.borderOpacity = _downAlpha;
			BElement(downSkin).style.borderWidth = strokeThickness;
			
			BElement(disabledSkin).style.backgroundColor = backColor;
			BElement(disabledSkin).style.backgroundOpacity = _disabledAlpha;
			BElement(disabledSkin).style.borderColor = _downColor;
			BElement(disabledSkin).style.borderOpacity = _disabledAlpha;
			BElement(disabledSkin).style.borderWidth = strokeThickness;
			
			// 
			BElement(selectedUpSkin).style.backgroundColor = backColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderColor = _selectedUpColor;
			BElement(selectedUpSkin).style.borderOpacity = _selectedUpAlpha;
			BElement(selectedUpSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedOverSkin).style.backgroundColor = backColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderColor = _selectedOverColor;
			BElement(selectedOverSkin).style.borderOpacity = _selectedOverAlpha;
			BElement(selectedOverSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedDownSkin).style.backgroundColor = backColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderColor = _selectedDownColor;
			BElement(selectedDownSkin).style.borderOpacity = _selectedDownAlpha;
			BElement(selectedDownSkin).style.borderWidth = strokeThickness;
			
			BElement(selectedDisabledSkin).style.backgroundColor = backColor;
			BElement(selectedDisabledSkin).style.backgroundOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.borderOpacity = _selectedDisabledAlpha;
			BElement(selectedDisabledSkin).style.borderWidth = strokeThickness;
			
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
			
			
			/*var newTween:Tween;
			
			if (state == selectedUpSkin)
			{
				newTween = new Tween(selectedOverIcon, "width", Regular.easeOut, 0, 16, 0.3, true);
				newTween = new Tween(selectedOverIcon, "height", Regular.easeOut, 0, 16, 0.3, true);
			}
			else if (state == overSkin)
			{
				selectedOverIcon.visible = true;
				newTween = new Tween(selectedOverIcon, "width", Regular.easeOut, 16, 0, 0.3, true);
				newTween = new Tween(selectedOverIcon, "height", Regular.easeOut, 16, 0, 0.3, true);
				
				if (prevState == upSkin)
				{
					trace("up skin");
					//selectedOverIcon.visible = true;
					//newTween = new Tween(selectedOverIcon, "width", Regular.easeOut, 16, 0, 0.3, true);
					//newTween = new Tween(selectedOverIcon, "height", Regular.easeOut, 16, 0, 0.3, true);
				}
			}*/
			
		} // function changeState
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
         * A checkbox toggles by definition, so the <code>toggle</code> property is set to 
         * <code>true</code> in the constructor and cannot be changed.
		 */
		override public function set toggle(value:Boolean):void
		{
			return;
		}
		
		
		/**
		 * The checkbox icon is a tick mark. It it set in the constructor and cannot be changed.
		 */
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