/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BLabelButton class is an abstract class that extends the BaseButton class by adding a label, an icon, and toggle functionality. The LabelButton class is subclassed by the BButton, BCheckBox, BRadioButton, and BCellRenderer classes.
 * 
 * 			The LabelButton component is used as a simple button class that can be combined with custom skin states that support ScrollBar buttons, NumericStepper buttons, ColorPicker swatches, and so on.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.events.*
	import flash.text.*;
	
	
	public class BLabelButton extends BBaseButton
	{
		// constants
		
		
		// assets
		protected var labelText:BLabel;
		
		protected var upIcon:DisplayObject;
		protected var overIcon:DisplayObject;
		protected var downIcon:DisplayObject;
		protected var disabledIcon:DisplayObject;
		
		protected var selectedUpIcon:DisplayObject;
		protected var selectedDownIcon:DisplayObject;
		protected var selectedOverIcon:DisplayObject;
		protected var selectedDisabledIcon:DisplayObject;
		
		
		// text stuff
		protected var enabledTF:TextFormat;
		protected var disabledTF:TextFormat;
		protected var disabledTextAlpha:Number = 0.5;
		
		
		// other
		protected var icons:Array;
		protected var allIconsSameFlag:Boolean = false;
		protected var iconBoundsFlag:Boolean = false;
		
		
		// set and get
		protected var _label:String;
		protected var _labelPlacement:String = "center";
		protected var _iconPlacement:String = "center";	// 
		//protected var _autoRepaet:Boolean;			// 
		protected var _selected:Boolean;
		protected var _toggle:Boolean = false;			// Gets or sets a Boolean value that indicates whether a button can be toggled.
		protected var _icon:DisplayObject;				// 
		protected var _autoSize:Boolean = true;			// Gets or sets whether the button should auto size in length with the label
		protected var _textPadding:Number = 5;			// The spacing between the text and the edges of the component, and the spacing between the text and the icon, in pixels. The default value is 5.
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BLabelButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
		 * @param label The text label for the component.
         */
		public function BLabelButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = "") 
		{
			_label = label;
			
			super(parent, x, y);
			//initialize();		// causes duble drawing for some reason	
			//setSize(100, 24);
			//draw();
			
		}
		
		
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
			}
			
			//trace("Selected: " + selected);
			
		} // end function mouseHandler
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize label
			labelText = new BLabel(this, _textPadding, 0, _label);
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelPlacement = BButtonLabelPlacement.LEFT;
			
			// icons
			upIcon = new Sprite();
			overIcon = new Sprite();
			downIcon = new Sprite()
			disabledIcon = new Sprite();
			
			selectedUpIcon = new Sprite();
			selectedOverIcon = new Sprite();
			selectedDownIcon = new Sprite();
			selectedDisabledIcon = new Sprite();
			
			
			// add assets to respective containers
			addChild(labelText);
			
			addChild(upIcon);
			addChild(overIcon);
			addChild(downIcon);
			addChild(disabledIcon);
			
			addChild(selectedUpIcon);
			addChild(selectedOverIcon);
			addChild(selectedDownIcon);
			addChild(selectedDisabledIcon);
			
			
			// add the icons to the icon array
			icons =  new Array(upIcon, overIcon, downIcon, disabledIcon, selectedUpIcon, selectedOverIcon, selectedDownIcon, selectedDisabledIcon);
			changeState(upSkin);
			
			// event handling
			addEventListener(MouseEvent.CLICK, mouseHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			// if label is blank, remove it 
			if (labelText.text == "")
			{
				if (labelText.parent)
				{
					removeChild(labelText);
				}
			}
			else
			{
				addChild(labelText);
			}
			
			// if autoSize then adjust the width of the button automatically
			if (_autoSize)
			{
				if (labelText.text != "")
				{
					_width = labelText.width + _textPadding * 2;
				}
			}
			
			// reposition the label
			positionLabel(_labelPlacement);
			
			// reposition the icons
			if (!iconBoundsFlag) 
				positionIcons();
			
			super.draw();
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override protected function changeState(state:DisplayObject):void
		{
			super.changeState(state);
			
			if (allIconsSameFlag)
			{	
				upIcon.visible = allIconsSameFlag;
				return;
			}
			
			for(var i:int = 0; i < states.length; i++)
			{ 
				var tempState:DisplayObject = states[i]; 
				var tempIcon:DisplayObject = icons[i];
				
				if(state == tempState)
				{
					//tempState.visible = true;
					tempIcon.visible = true;
				}
				else 
				{
					//tempState.visible = false;
					tempIcon.visible = false;
				}
				
			} // end for
			
		} // function changeState
		
		
		/**
		 * 
		 * 
		 * @param all
		 * @param upIcon
		 * @param overIcon
		 * @param downIcon
		 * @param disabledIcon
		 * @param selectedUpIcon
		 * @param selectedOverIcon
		 * @param selectedDownIcon
		 * @param selectedDisabledIcon
		 */
		public function setIcon(all:DisplayObject = null, upIcon:DisplayObject = null, overIcon:DisplayObject = null, downIcon:DisplayObject = null, disabledIcon:DisplayObject = null, selectedUpIcon:DisplayObject = null, selectedOverIcon:DisplayObject = null, selectedDownIcon:DisplayObject = null, selectedDisabledIcon:DisplayObject = null):void
		{
			allIconsSameFlag = false; // flag to false arbitrarily
			
			// create temporary icons to hold the previous icons
			var tempUpIcon:DisplayObject = this.upIcon;
			var tempOverIcon:DisplayObject = this.overIcon;
			var tempDownIcon:DisplayObject = this.downIcon;
			var tempDisabledIcon:DisplayObject = this.disabledIcon;
			var tempSelectedUpIcon:DisplayObject = this.selectedUpIcon;
			var tempSelectedOverIcon:DisplayObject = this.selectedOverIcon;
			var tempSelectedDownIcon:DisplayObject = this.selectedDownIcon;
			var tempSelectedDisabledIcon:DisplayObject = this.selectedDisabledIcon;
			
			
			// remove all Icons
			if(this.upIcon.parent)					this.upIcon.parent.removeChild(this.upIcon);
			if(this.overIcon.parent)				this.overIcon.parent.removeChild(this.overIcon);
			if(this.downIcon.parent)				this.downIcon.parent.removeChild(this.downIcon);
			if(this.disabledIcon.parent)			this.disabledIcon.parent.removeChild(this.disabledIcon);
			if(this.selectedUpIcon.parent)			this.selectedUpIcon.parent.removeChild(this.selectedUpIcon);
			if(this.selectedOverIcon.parent)		this.selectedOverIcon.parent.removeChild(this.selectedOverIcon);
			if(this.selectedDownIcon.parent)		this.selectedDownIcon.parent.removeChild(this.selectedDownIcon);
			if(this.selectedDisabledIcon.parent)	this.selectedDisabledIcon.parent.removeChild(this.selectedDisabledIcon);
			
			
			// if all is set, then make all the icons for each state the same
			if (all)
			{
				//set Icons
				this.upIcon = all;
				this.overIcon = all;
				this.downIcon = all;
				this.disabledIcon = all;
				this.selectedUpIcon = all;
				this.selectedOverIcon = all;
				this.selectedDownIcon = all;
				this.selectedDisabledIcon = all;
				
				allIconsSameFlag = true;
				//trace("Setting all icons the same");
			}
			else if (!upIcon &&
			!overIcon &&
			!downIcon &&
			!disabledIcon &&
			!selectedUpIcon &&
			!selectedOverIcon &&
			!selectedDownIcon &&
			!selectedDisabledIcon) // if all are null, then return. No icons should be set
			{
				//trace("clear icons!");
				return;
			}
			else // 
			{
				this.upIcon = upIcon ? upIcon : tempUpIcon;
				this.overIcon = overIcon ? overIcon : tempOverIcon;
				this.downIcon = downIcon ? downIcon : tempDownIcon;
				this.disabledIcon = disabledIcon ? disabledIcon : tempDisabledIcon;
				this.selectedUpIcon = selectedUpIcon ? selectedUpIcon : tempSelectedUpIcon;
				this.selectedOverIcon = selectedOverIcon ? selectedOverIcon : tempSelectedOverIcon;
				this.selectedDownIcon = selectedDownIcon ? selectedDownIcon : tempSelectedDownIcon;
				this.selectedDisabledIcon = selectedDisabledIcon ? selectedDisabledIcon : tempSelectedDisabledIcon;
			}
			
			// add the Icons
			addChild(this.upIcon);
			addChild(this.overIcon);
			addChild(this.downIcon);
			addChild(this.disabledIcon);
			addChild(this.selectedUpIcon);
			addChild(this.selectedOverIcon);
			addChild(this.selectedDownIcon);
			addChild(this.selectedDisabledIcon);
			
			
			// recreate/fill the states array
			icons = new Array(this.upIcon, this.overIcon, this.downIcon, this.disabledIcon, this.selectedUpIcon, this.selectedOverIcon, this.selectedDownIcon, this.selectedDisabledIcon);
			changeState(currentState);
			
			// set the position of the new icons
			positionIcons();
			
		} // end function setIcons
		
		
		/**
		 * 
		 * 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param rotation
		 */
		public function setIconBounds(x:Number, y:Number, width:Number = NaN, height:Number = NaN, rotation:Number = 0):void
		{
			var icon:DisplayObject;
			iconBoundsFlag = true;
			
			for (var i:int = 0; i < icons.length; i++)
			{
				icon = icons[i];
				//icon.rotation = rotation;
				
				icon.x = x;
				icon.y = y;
				if (!isNaN(width))
				{
					icon.width = width;
				}
				if (!isNaN(height))
				{
					icon.height = height;
				}
				
				//icon.rotation = 60;
				
			}
			
			// 
			//positionIcons();
			
			// rotate the icons after they have been positioned (because the position icons function uses the bounds of the icon to calculate)
			// however, changing the rotation will (usually lol) change the bounds of the a displayObject
			for (i = 0; i < icons.length; i++)
			{
				icon = icons[i];
				icon.rotation = rotation;
			}
			
		} // end function setIconPosition
		
		
		/**
		 * 
		 * @param placement
		 */
		protected function positionLabel(placement:String):void
		{
			
			switch (placement)
			{
				case BButtonLabelPlacement.LEFT:
					labelText.x = _textPadding;
					labelText.y = _height/2 - labelText.height/2;
					break;
					
				case BButtonLabelPlacement.RIGHT:
					labelText.x = _width - labelText.width - _textPadding;
					labelText.y = _height/2 - labelText.height/2;
					break;
				
				case BButtonLabelPlacement.TOP:
					labelText.x = _width/2 - labelText.width/2;
					labelText.y = _textPadding;
					break;
					
				case BButtonLabelPlacement.BOTTOM:
					labelText.x = _width/2 - labelText.width/2;
					labelText.y = _height - labelText.height - _textPadding;
					break;
					
					
				case BButtonLabelPlacement.TOP_LEFT:
					labelText.x = _textPadding;
					labelText.y = _textPadding;
					break;
					
				case BButtonLabelPlacement.TOP_RIGHT:
					labelText.x = _width - labelText.width - _textPadding;
					labelText.y = _textPadding;
					break;
					
				case BButtonLabelPlacement.BOTTOM_LEFT:
					labelText.x = _textPadding;
					labelText.y = _height - labelText.height - _textPadding;
					break;
					
				case BButtonLabelPlacement.BOTTOM_RIGHT:
					labelText.x = _width - labelText.width - _textPadding;
					labelText.y = _height - labelText.height - _textPadding;
					break;
				
				case BButtonLabelPlacement.CENTER:
					labelText.x = _width/2 - labelText.width/2;
					labelText.y = _height/2 - labelText.height/2;
					break;
				
				
			} // end switch
			
			//trace("Label height: " + labelText.height);
			
		} // end function positionLabel
		
		
		/**
		 * 
		 */
		protected function positionIcons():void
		{
			// 
			var shorterSide:Number = Math.min(_width, _height);
			  
			var widthLonger:Boolean ;
			var heightLonger:Boolean;
			
			// loop through the icons array
			for (var i:int = 0; i < icons.length; i++)
			{
				var icon:DisplayObject = icons[i];
				
				// if the icon is larger than the button
				if ((icon.width > _width || icon.height > _height) && !iconBoundsFlag)
				{
					// scale each icon so that it is not larger than width or height of the button
					widthLonger = icon.width > icon.height ? true : false;
					heightLonger = icon.height > icon.width ? true : false;
					
					if (widthLonger)
					{
						icon.width = shorterSide;
						icon.scaleY = icon.scaleX;
					}
					else(heightLonger) // remove if part to make exact fit 
					{
						icon.height = shorterSide;
						icon.scaleX = icon.scaleY;
					}
				}
				
				
				// position the icons based on their bounds (because just using the x and y properties wouldn't work on all cases).
				
				// get the difference between the x position and the center of the bounds of the icon
				var xDifference:Number = (icon.getBounds(this).left + icon.getBounds(this).right) / 2 - icon.x;
				var yDifference:Number = (icon.getBounds(this).top + icon.getBounds(this).bottom) / 2 - icon.y;
				
				var centerX:Number = _width / 2 - xDifference;
				var centerY:Number = _height / 2 - yDifference;
				//var top:Number = centerY - icon.height/2 + _textPadding;
				//var bottom:Number = centerY + icon.height/2 - _textPadding;
				//var left:Number = centerX - icon.width/2 + _textPadding;
				//var right:Number = centerX + icon.width / 2 - _textPadding;
				
				var top:Number = centerY - _height/2 + icon.height / 2 + _textPadding;
				var bottom:Number = centerY + _height/2 - icon.height/2 - _textPadding;
				var left:Number = centerX - _width/2 + icon.width/2 + _textPadding;
				var right:Number = centerX + _width/2 - icon.width / 2 - _textPadding;
				
				// set the icons position
				switch(_iconPlacement)
				{
					case BButtonIconPlacement.LEFT:
						icon.x = left;
						icon.y = centerY;
						break;
						
					case BButtonIconPlacement.RIGHT:
						icon.x = right;
						icon.y = centerY;
						break;
					
					case BButtonIconPlacement.TOP:
						icon.x = centerX;
						icon.y = top;
						break;
						
					case BButtonIconPlacement.BOTTOM:
						icon.x = centerX;
						icon.y = bottom;
						break;
						
						
					case BButtonIconPlacement.TOP_LEFT:
						icon.x = left;
						icon.y = top;
						break;
						
					case BButtonIconPlacement.TOP_RIGHT:
						icon.x = right;
						icon.y = top;
						break;
						
					case BButtonIconPlacement.BOTTOM_LEFT:
						icon.x = left;
						icon.y = bottom;
						break;
						
					case BButtonIconPlacement.BOTTOM_RIGHT:
						icon.x = right;
						icon.y = bottom;
						break;
						
					case BButtonIconPlacement.CENTER:
						icon.x = centerX;
						icon.y = centerY;
						break;
					
				} // end switch
				
				
			} // end for 
			
		} // end function positionIcons
		
		
		//***************************************** SET AND GET *****************************************
		
		
		/**
		 * Position of the icon in relation to button in which it is contained.
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BButtonIconPlacement.LEFT</li>
		 * 	<li>BButtonIconPlacement.RIGHT</li>
		 * 	<li>BButtonIconPlacement.TOP</li>
		 * 	<li>BButtonIconPlacement.BOTTOM</li>
		 * 	<li>BButtonIconPlacement.CENTER</li>
		 * 	<li>BButtonIconPlacement.TOP_LEFT</li>
		 * 	<li>BButtonIconPlacement.BOTTOM_LEFT</li>
		 * 	<li>BButtonIconPlacement.TOP_RIGHT</li>
		 * 	<li>BButtonIconPlacement.BOTTOM_RIGHT</li>
		 * </ul>
		 * 
		 * @default BButtoniCONPlacement.CENTER
		 */
		public function get iconPlacement():String
		{
			return _iconPlacement;
		}
		public function set iconPlacement(value:String):void
		{
			_iconPlacement = value;
			positionIcons();
		}
		
		
		/**
		 * Gets or sets the text label for the component. By default, the label text appears centered on the button.
		 * 
		 * @default ""
		 */
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
			labelText.text = _label;
		}
		
		
		/**
		 * Position of the label in relation to button in which it is contained.
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BButtonLabelPlacement.LEFT</li>
		 * 	<li>BButtonLabelPlacement.RIGHT</li>
		 * 	<li>BButtonLabelPlacement.TOP</li>
		 * 	<li>BButtonLabelPlacement.BOTTOM</li>
		 * 	<li>BButtonLabelPlacement.CENTER</li>
		 * 	<li>BButtonLabelPlacement.TOP_LEFT</li>
		 * 	<li>BButtonLabelPlacement.BOTTOM_LEFT</li>
		 * 	<li>BButtonLabelPlacement.TOP_RIGHT</li>
		 * 	<li>BButtonLabelPlacement.BOTTOM_RIGHT</li>
		 * </ul>
		 * 
		 * @default BButtonLabelPlacement.CENTER
		 */
		public function get labelPlacement():String
		{
			return _labelPlacement;
		}
		public function set labelPlacement(value:String):void
		{
			_labelPlacement = value;
			positionLabel(value);
			//draw();
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether a toggle button is toggled in the on or off position. 
		 * A value of <code>true</code> indicates that it is toggled in the on position; 
		 * a value of <code>false</code> indicates that it is toggled in the off position. 
		 * This property can be set only if the toggle property is set to true.
		 * 
		 * <p>For a BCheckBox component, this value indicates whether the box displays a check mark. 
		 * For a BRadioButton component, this value indicates whether the component is selected.</p>
		 * 
		 * <p>The user can change this property by clicking the component, but you can also set this property programmatically.</p>
		 * 
		 * <p>If the toggle property is set to <code>true</code>, changing this property also dispatches a change event.</p>
		 * 
		 * @default false
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			// if this is not a toggle button, then it cannot be selected
			if(!_toggle)
			{
				_selected = false;
			}
			
			// change the state to ensure the correct state is active 
			// when the selected property via BLabel.selected = x, rather then a mouse event being dispatched.
			// (you are allowed to set the selected property even if the button is disabled)
			if (value)
			{
				if (_enabled)
				{
					changeState(selectedUpSkin);
				}
				else
				{
					changeState(selectedDisabledSkin);
				}
			}
			else
			{
				if (_enabled)
				{
					changeState(upSkin);
				}
				else
				{
					changeState(disabledSkin);
				}
			}
			
			_selected = value;
		}
		
		
		/**
		 * A reference to the component's internal text field.
		 */
		public function get textField():TextField
		{
			return labelText.textField;
		}
		
		
		/**
		 * Gets or sets a Number value for padding of the text and icon.
		 */
		public function get textPadding():Number
		{
			return _textPadding;
		}
		public function set textPadding(value:Number):void
		{
			_textPadding = value;
			positionLabel(_labelPlacement);
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether a button can be toggled. 
		 * A value of <code>true</code> indicates that it can; 
		 * a value of <code>false</code> indicates that it cannot.
		 * 
		 * <p>If this value is true, clicking the button toggles it between selected and unselected states. 
		 * You can get or set this state programmatically by using the selected property.</p>
		 * 
		 * <p>If this value is false, the button does not stay pressed after the user releases it. In this case, its selected property is always false.</p>
		 * 
		 * <p><strong>Note:</strong> When the toggle is set to false, selected is forced to false because only toggle buttons can be selected.</p>
		 * 
		 * @default false
		 */
		public function get toggle():Boolean
		{
			return _toggle;
		}
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
			
			if (!value)
			{
				selected = false;
			}
		}
		
		
		/**
		 * Gets or sets the icon for the component.
		 * 
		 * <p>This has the same effect as using the setIcon() function add passining a value to the all paramenter.</p>
		 * 
		 * <p>Setting a value of <code>null</code> will remove the current icon.</p>
		 * 
		 * @see #setIcon
		 */
		public function get icon():DisplayObject
		{
			return upIcon;
		}
		public function set icon(value:DisplayObject):void
		{
			if (value)
			{
				setIcon(value);
			}
			else
			{
				setIcon();
			}
		}
		
		
		/**
		 * Gets or sets whether the button should auto size in length with the label
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			draw();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			// change the state to ensure the correct state is active 
			// when the enabled property via BLabel.enabled = x.
			if (value)
			{
				if (_selected)
				{
					changeState(selectedUpSkin);
				}
				else
				{
					changeState(upSkin);
				}
			}
			else
			{
				if (_selected)
				{
					changeState(selectedDisabledSkin);
				}
				else
				{
					changeState(disabledSkin);
				}
			}
		}
		
	}

}