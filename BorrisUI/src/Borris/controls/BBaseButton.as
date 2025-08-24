/* Author: Rohaan Allport
 * Date Created: 11/04/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.filters.DropShadowFilter;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.display.BElement;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------	
    /**
     * The BBaseButton class is the base class for all button components, defining properties and methods that are common to all buttons. 
	 * This class handles drawing states and the dispatching of button events.
     */
	public class BBaseButton extends BUIComponent
	{
		// assets
		protected var upSkin:Sprite;							// The up skin of this details Object.
		protected var overSkin:Sprite;							// The over skin of this details Object.
		protected var downSkin:Sprite;							// The down skin of this details Object.
		protected var disabledSkin:Sprite;						// The disabled skin of this details Object.
		
		protected var selectedUpSkin:Sprite;
		protected var selectedOverSkin:Sprite;
		protected var selectedDownSkin:Sprite;
		protected var selectedDisabledSkin:Sprite;
		
		
		// other
		protected var states:Array;
		protected var drawFlag:Boolean = true;
		protected var disabledAlpha:Number = 0.5;
		protected var currentState:DisplayObject;
		protected var stateTimer:Timer = new Timer(300);
		
		// set and get
		//protected var _autoRepaet:Boolean;		// 
		
		protected var _upColor:uint = 0x222222;	
		protected var _overColor:uint = 0x0099CC;	
		protected var _downColor:uint = 0x003366;	
		protected var _disabledColor:uint = 0x111111;	
		
		protected var _selectedUpColor:uint = 0x0099CC;
		protected var _selectedOverColor:uint = 0x00CCFF;
		protected var _selectedDownColor:uint = 0x003366;
		protected var _selectedDisabledColor:uint = 0x0099CC;
		
		protected var _upAlpha:Number = 1;
		protected var _overAlpha:Number = 1;
		protected var _downAlpha:Number = 1;
		protected var _disabledAlpha:Number = 1;
		
		protected var _selectedUpAlpha:Number = 1;
		protected var _selectedOverAlpha:Number = 1;
		protected var _selectedDownAlpha:Number = 1;
		protected var _selectedDisabledAlpha:Number = 1;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BBaseButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BBaseButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0):void
		{
			// constructor code
			super(parent, x, y);
			initialize();
			setSize(100, 24);
			//draw();
			
			changeState(upSkin);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * 
		 * @param event 
		 */ 
		protected function mouseHandler(event:MouseEvent):void
		{
			// if the button is not enabled set the disabeled skins and skip everything
			if (!enabled)
			{
				changeState(disabledSkin);
				
				return;
			} //  end if
			
			
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
				
			} // end switch
			
		} // end function mouseHandler
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize the skins
			upSkin = new BElement();
			overSkin = new BElement();
			downSkin = new BElement()
			disabledSkin = new BElement();
			
			selectedUpSkin = new BElement();
			selectedOverSkin = new BElement();
			selectedDownSkin = new BElement();
			selectedDisabledSkin = new BElement();
			
			
			addChild(upSkin);
			addChild(overSkin);
			addChild(downSkin);
			addChild(disabledSkin);
			
			addChild(selectedUpSkin);
			addChild(selectedOverSkin);
			addChild(selectedDownSkin);
			addChild(selectedDisabledSkin);
			
			
			// 
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			
			
			// add the state skins to the state array
			states = new Array(upSkin, overSkin, downSkin, disabledSkin, selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin);
			
			// event handling
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			if (!drawFlag)
			{
				//trace("not drawing");
				return;
			}
			
			super.draw();
			
			/*upSkin.graphics.clear();
			upSkin.graphics.beginFill(_upColor, _upAlpha);
			upSkin.graphics.drawRect(0, 0, _width, _height); 
			upSkin.graphics.endFill();
			
			overSkin.graphics.clear();
			overSkin.graphics.beginFill(_overColor, _overAlpha);
			overSkin.graphics.drawRect(0, 0, _width, _height);
			overSkin.graphics.endFill();
			
			downSkin.graphics.clear();
			downSkin.graphics.beginFill(_downColor, _downAlpha);
			downSkin.graphics.drawRect(0, 0, _width, _height); 
			downSkin.graphics.endFill();
			
			disabledSkin.graphics.clear();
			disabledSkin.graphics.beginFill(_disabledColor, _disabledAlpha);
			disabledSkin.graphics.drawRect(0, 0, _width, _height);
			disabledSkin.graphics.endFill();
			
			
			// selected skins
			selectedUpSkin.graphics.clear();
			selectedUpSkin.graphics.beginFill(_selectedUpColor, _selectedUpAlpha);
			selectedUpSkin.graphics.drawRect(0, 0, _width, _height);
			selectedUpSkin.graphics.endFill();
			
			selectedOverSkin.graphics.clear();
			selectedOverSkin.graphics.beginFill(_selectedOverColor, _selectedOverAlpha);
			selectedOverSkin.graphics.drawRect(0, 0, _width, _height);
			selectedOverSkin.graphics.endFill();
			
			selectedDownSkin.graphics.clear();
			selectedDownSkin.graphics.beginFill(_selectedDownColor, _selectedDownAlpha);
			selectedDownSkin.graphics.drawRect(0, 0, _width, _height); 
			selectedDownSkin.graphics.endFill();
			
			selectedDisabledSkin.graphics.clear();
			selectedDisabledSkin.graphics.beginFill(_selectedDisabledColor, _selectedDisabledAlpha);
			selectedDisabledSkin.graphics.drawRect(0, 0, _width, _height);
			selectedDisabledSkin.graphics.endFill();*/
			
			
			
			//Boomy
			// draw skins
			/*var roundNess:Number = 4;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_width - 2, _height - 2, Math.PI / 2, 0, 0);
			var buttonWidth:int = _width;
			var buttonHeight:int = _height;
			
			// with shine
			upSkin.graphics.clear();
			upSkin.graphics.beginFill(0x0099FF, 1); // border
			upSkin.graphics.drawRoundRect(0, 0, _width, _height, roundNess, roundNess);
			upSkin.graphics.drawRoundRect(1, 1, _width - 2, _height - 2, roundNess - 1, roundNess - 1);
			upSkin.graphics.beginGradientFill("linear", [0x7FC4FF, 0x0099FF, 0x0099FF, 0x7FC4FF], [0.6, 0.55, 0.45, 0.4], [0, 64, 192, 255], matrix); // main colour
			upSkin.graphics.drawRoundRect(1, 1, _width - 2, _height - 2, roundNess - 1, roundNess - 1);
			upSkin.graphics.beginFill(0xFFFFFF, 0.7); // shine
			upSkin.graphics.drawRoundRect(1, 1, _width - 2, _height * 0.4, roundNess - 1, roundNess - 1);
			upSkin.graphics.endFill();
			
			// without shine
			upSkin.graphics.clear();
			upSkin.graphics.beginFill(0x222222, 1);
			upSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			upSkin.graphics.beginGradientFill("linear", [0x666666, 0x333333], [1, 1], [0, 128], matrix);
			upSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 1, roundNess - 1);
			upSkin.graphics.endFill();
			
			overSkin.graphics.clear();
			overSkin.graphics.beginFill(0x222222, 1);
			overSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			overSkin.graphics.beginGradientFill("linear", [0x777777, 0x444444], [1, 1], [0, 128], matrix);
			overSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 1, roundNess - 1);
			overSkin.graphics.beginGradientFill("linear", [0x006699, 0x006699], [1, 0], [0, 250], matrix);
			overSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 2, roundNess - 2);
			overSkin.graphics.drawRect(3, 3, buttonWidth - 6, buttonHeight - 6);
			overSkin.graphics.endFill();
			
			downSkin.graphics.clear();
			downSkin.graphics.beginFill(0x000000, 1);	// shadow
			downSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			downSkin.graphics.beginFill(0x151515, 1);	// shadow
			downSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 1, roundNess - 1);
			downSkin.graphics.beginGradientFill("linear", [0x555555, 0x222222], [1, 1], [0, 128], matrix);
			downSkin.graphics.drawRoundRect(2, 2, buttonWidth - 4, buttonHeight - 4, roundNess - 2, roundNess - 2);
			downSkin.graphics.endFill();
			
			
			/*upSkin.graphics.clear();
			upSkin.graphics.beginFill(0x454545, 0);
			upSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			upSkin.graphics.endFill();
			
			overSkin.graphics.clear();
			overSkin.graphics.beginFill(0x222222, 1);
			overSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			overSkin.graphics.beginGradientFill("linear", [0x999999, 0x333333], [1, 1], [0, 255], matrix);
			overSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 1, roundNess - 1);
			overSkin.graphics.beginGradientFill("linear", [0x666666, 0x333333], [1, 1], [0, 255], matrix);
			overSkin.graphics.drawRoundRect(2, 2, buttonWidth - 4, buttonHeight - 4, roundNess - 2, roundNess - 2);
			overSkin.graphics.endFill();
			
			downSkin.graphics.clear();
			downSkin.graphics.beginFill(0x000000, 1);	// shadow
			downSkin.graphics.drawRoundRect(0, 0, buttonWidth, buttonHeight, roundNess, roundNess);
			downSkin.graphics.beginFill(0x151515, 1);	// shadow
			downSkin.graphics.drawRoundRect(1, 1, buttonWidth - 2, buttonHeight - 2, roundNess - 1, roundNess - 1);
			downSkin.graphics.beginFill(0x303030, 1);	// main colour
			downSkin.graphics.drawRoundRect(2, 2, buttonWidth - 4, buttonHeight - 4, roundNess - 2, roundNess - 2);
			downSkin.graphics.endFill();*/
			
			
			// testing
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
			
			BElement(overSkin).style.backgroundColor = _overColor;
			BElement(overSkin).style.backgroundOpacity = _overAlpha;
			
			BElement(downSkin).style.backgroundColor = _downColor;
			BElement(downSkin).style.backgroundOpacity = _downAlpha;
			
			BElement(disabledSkin).style.backgroundColor = _disabledColor;
			BElement(disabledSkin).style.backgroundOpacity = _disabledAlpha;
			
			BElement(selectedUpSkin).style.backgroundColor = _selectedUpColor;
			BElement(selectedUpSkin).style.backgroundOpacity = _selectedUpAlpha;
			
			BElement(selectedOverSkin).style.backgroundColor = _selectedOverColor;
			BElement(selectedOverSkin).style.backgroundOpacity = _selectedOverAlpha;
			
			BElement(selectedDownSkin).style.backgroundColor = _selectedDownColor;
			BElement(selectedDownSkin).style.backgroundOpacity = _selectedDownAlpha;
			
			BElement(selectedDisabledSkin).style.backgroundColor = _selectedDisabledColor;
			BElement(selectedDisabledSkin).style.backgroundOpacity = _selectedDisabledAlpha;
			
		} // end function draw
		
		
		/**
		 * Changes the state of the component.
		 * 
		 * @param state
		 */ 
		protected function changeState(state:DisplayObject):void
		{
			var newTween:Tween;
			
			for(var i:int = 0; i < states.length; i++)
			{
				var tempState:DisplayObject = states[i]; 
				
				if(state == tempState)
				{
					newTween = new Tween(state, "alpha", Regular.easeOut, 0, 1, 0.3, true);
					currentState = state;
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
			
			/*for(var i:int = 0; i < states.length; i++)
			{
				var tempState:DisplayObject = states[i]; 
				tempState.visible = false;
				
				if(state == tempState)
				{
					tempState.visible = true;
				}
				else 
					tempState.visible = false;
			} // end for*/
			
		} // end function changeState
		
		
		/**
		 * Set the color of the desired state of the component (up, over, down, disabled, selected up, selected over, seleced down, and selected disabled)
		 * Passing in a value that is negative will keep the color the same.
		 * This will allow you to skip over states and only change the colors of the states you want.
		 */ 
		public function setStateColors(upColor:int, overColor:int = -1, downColor:int = -1, disabeledColor:int = -1, selectedUpColor:int = -1, selectedOverColor:int = -1, selectedDownColor:int = -1, selectedDisabledColor:int = -1):void
		{
			// create temporary colors to hold the previous color
			var tempUpColor:uint = _upColor;
			var tempOverColor:uint = _overColor;
			var tempDownColor:uint = _downColor;
			var tempDisabledColor:uint = _disabledColor;
			var tempSelectedUpColor:uint = _selectedUpColor;
			var tempSelectedOverColor:uint = _selectedOverColor;
			var tempSelectedDownColor:uint = _selectedDownColor;
			var tempSelectedDisabledColor:uint = _selectedDisabledColor;
			
			// check to see if the values passed are 0 or greater (greater than -1).
			// if yes then set the new color.
			// else set the old color
			_upColor = upColor > -1 ? upColor : tempUpColor;
			_overColor = overColor > -1 ? overColor : tempOverColor;
			_downColor = downColor > -1 ? downColor : tempDownColor;	
			_disabledColor = disabeledColor > -1 ? disabeledColor : tempDisabledColor;	
			
			_selectedUpColor = selectedUpColor > -1 ? selectedUpColor : tempSelectedUpColor;
			_selectedOverColor = selectedOverColor > -1 ? selectedOverColor : tempSelectedOverColor;
			_selectedDownColor = selectedDownColor > -1 ? selectedDownColor : tempSelectedDownColor;
			_selectedDisabledColor = selectedDisabledColor > -1 ? selectedDisabledColor : tempSelectedDisabledColor;
			
			// redraw the button to apply the changes
			draw();
			//invalidate();
		} // end function setStateAlphas
		
		
		/**
		 * Set the color of the desired state of the component.
		 * 
		 */ 
		public function setStateAlphas(upAlpha:Number, overAlpha:Number, downAlpha:Number, disabeledAlpha:Number, selectedUpAlpha:Number, selectedOverAlpha:Number, selectedDownAlpha:Number, selectedDisabledAlpha:Number):void
		{
			upSkin.alpha = _upAlpha = upAlpha;
			overSkin.alpha = _overAlpha = overAlpha;
			downSkin.alpha = _downAlpha = downAlpha;	
			disabledSkin.alpha = _disabledAlpha = disabeledAlpha;	
			
			selectedUpSkin.alpha = _selectedUpAlpha = selectedUpAlpha;
			selectedOverSkin.alpha = _selectedOverAlpha = selectedOverAlpha;
			selectedDownSkin.alpha = _selectedDownAlpha = selectedDownAlpha;
			selectedDisabledSkin.alpha = _selectedDisabledAlpha = selectedDisabledAlpha;
			
			//invalidate();
			draw();
		} // end function function setStateAlphas
		
		
		/**
		 * Set the skin of the desired state of the component.
		 * 
		 */ 
		public function setSkins(upSkin:DisplayObject, overSkin:DisplayObject = null, downSkin:DisplayObject = null, disabledSkin:DisplayObject = null, 
		selectedUpSkin:DisplayObject = null, selectedOverSkin:DisplayObject = null, selectedDownSkin:DisplayObject = null, selectedDisabledSkin:DisplayObject = null):void
		{
			// if upSkin is null, set the draw flag to true
			if (upSkin == null)
			{
				drawFlag = true;
				//draw();
				invalidate();
				return;
			} // 
			
			
			// clear the state styles
			BElement(this.upSkin).style.clear();
			BElement(this.overSkin).style.clear();
			BElement(this.downSkin).style.clear();
			BElement(this.disabledSkin).style.clear();
			BElement(this.selectedUpSkin).style.clear();
			BElement(this.selectedOverSkin).style.clear();
			BElement(this.selectedDownSkin).style.clear();
			BElement(this.selectedDisabledSkin).style.clear();
			
			
			// set drawFlag to false so that the button no longer draws
			drawFlag = false;
			
			
			// remove all skins
			this.upSkin.parent.removeChild(this.upSkin);
			this.overSkin.parent.removeChild(this.overSkin);
			this.downSkin.parent.removeChild(this.downSkin);
			this.disabledSkin.parent.removeChild(this.disabledSkin);
			this.selectedUpSkin.parent.removeChild(this.selectedUpSkin);
			this.selectedOverSkin.parent.removeChild(this.selectedOverSkin);
			this.selectedDownSkin.parent.removeChild(this.selectedDownSkin);
			this.selectedDisabledSkin.parent.removeChild(this.selectedDisabledSkin);
			
			
			//set skins
			this.upSkin = upSkin as Sprite;
			this.overSkin = overSkin ? overSkin as Sprite : upSkin as Sprite;
			this.downSkin = downSkin ? downSkin as Sprite : upSkin as Sprite;
			this.disabledSkin = disabledSkin ? disabledSkin as Sprite : upSkin as Sprite;
			this.selectedUpSkin = selectedUpSkin ? selectedUpSkin as Sprite : upSkin as Sprite;
			this.selectedOverSkin = selectedOverSkin ? selectedOverSkin as Sprite : upSkin as Sprite;
			this.selectedDownSkin = selectedDownSkin ? selectedDownSkin as Sprite : upSkin as Sprite;
			this.selectedDisabledSkin = selectedDisabledSkin ? selectedDisabledSkin as Sprite : upSkin as Sprite;
			
			
			// add the skins
			addChild(this.upSkin);
			addChild(this.overSkin);
			addChild(this.downSkin);
			addChild(this.disabledSkin);
			addChild(this.selectedUpSkin);
			addChild(this.selectedOverSkin);
			addChild(this.selectedDownSkin);
			addChild(this.selectedDisabledSkin);
			
			
			// recreate/fill the states array
			states = new Array(this.upSkin, this.overSkin, this.downSkin, this.disabledSkin, this.selectedUpSkin, this.selectedOverSkin, this.selectedDownSkin, this.selectedDisabledSkin);
			//changeState(upSkin);
			
		} // end function setSkins
		
		
		/**
		 * Gets the skin of the secified state of the component.
		 * (up, over, down, disabled, selected up, selected over, seleced down, and selected disabled)
		 */ 
		public function getSkin(skin:String):DisplayObject
		{
			switch(skin)
			{
				case "upSkin":
					return upSkin;
					break;
				
				case "overSkin":
					return overSkin;
					break;
				
				case "downSkin":
					return downSkin;
					break;
				
				case "disabledSkin":
					return disabledSkin;
					break;
				
				case "selectedUpSkin":
					return selectedUpSkin;
					break;
					
				case "selectedOverSkin":
					return selectedOverSkin;
					break;
					
				case "selectedDownSkin":
					return selectedDownSkin;
					break;
					
				case "selectedDisabledSkin":
					return selectedDisabledSkin;
					break;
			} // end switch  
			
			return upSkin;
			
		} // end function getSkin
		
		
		//**************************************** SET AND GET ******************************************
		
		// autoRepeat
		/*public function set autoRepeat(value:Boolean):void
		{
			_autoRepeat = value;
		}
		
		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}*/
		
		
		/**
		 * Gets or sets a value that indicates whether the component can accept user input. 
		 * A value of <code>true</code> indicates that the component can accept user input; 
		 * a value of <code>false</code> indicates that it cannot.
		 * 
		 * <p>When this property is set to false, the button is disabled. 
		 * This means that although it is visible, it cannot be clicked. 
		 * This property is useful for disabling a specific part of the user interface.</p>
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			value ? alpha = 1 : alpha = disabledAlpha;
			value ? changeState(upSkin) : changeState(disabledSkin);
		}
		
	}

}