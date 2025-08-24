/* Author: Rohaan Allport
 * Date Created: 09/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BComboBox component contains a drop-down list from which the user can select one value. 
 * 				Its functionality is similar to that of the SELECT form element in HTML. 
 * 				The BComboBox component can be editable, in which case the user can type entries that 
 * 				are not in the list into the TextInput portion of the BComboBox component.
 * 
 * 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.display.BElement;;
	import Borris.controls.listClasses.*;
	import Borris.assets.icons.*;
	
	
	public class BComboBox extends BUIComponent
	{
		// assets
		protected var button:BLabelButton;
		protected var inputText:BTextInput;
		protected var arrowIcon:Shape;
		
		
		// style
		
		
		
		// other
		protected var listMask:Shape;
		protected var showList:Boolean;											// A flag boolean for toggling the dropdown.
		
		
		
		// set and get
		protected var _dropdown:BList;											// [read-only] Gets a reference to the List component that the ComboBox component contains.
		protected var _editable:Boolean = false;								// 
		protected var _listPosition:String = BComboBoxDropdownPosition.CENTER;	// 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BComboBox component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BComboBox(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) 
		{
			// constructor code
			super(parent, x, y);
			initialize();
			setSize(200, 30);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (event.currentTarget == button)
			{
				toggleDropdown(showList);
			}
			else if (event.currentTarget == stage)
			{
				if (!hitTestPoint(event.stageX, event.stageY, true))
				{
					hideDropdown();
				}
			}
			
		} // end function mouseDownHandler
		
		
		/**
		 * 
		 * @param event
		 */
		protected function dropdownChangeHander(event:Event):void
		{
			event.stopImmediatePropagation();
			
			button.label = _dropdown.selectedItem.label;
			inputText.text = _dropdown.selectedItem.label;
			hideDropdown();
			
			dispatchEvent(event);
		} // end function dropdownChangeHander
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize the button;
			button = new BLabelButton(this, 0, 0, "Label");
			button.autoSize = false;
			//button.setSkins(button.getSkin("upSkin"), button.getSkin("overSkin"), button.getSkin("downSkin"), button.getSkin("disabledSkin"));
			
			// initialize the text input
			inputText = new BTextInput(this, 0, 0, "text");
			
			// icons
			arrowIcon = new Shape();
			arrowIcon.graphics.lineStyle(1, 0xCCCCCC, 1, false, "normal", "none");
			arrowIcon.graphics.moveTo(-2.5, -5);
			arrowIcon.graphics.lineTo(2.5, 0);
			arrowIcon.graphics.lineTo(-2.5, 5);
			
			button.icon = arrowIcon;
			button.setIconBounds(_width - _height/2, _height/2);
			
			// initialize the dropdown (the BList)
			_dropdown = new BList(this, _width, button.height);
			showList = true;
			dropdown.visible = false;
			
			
			// initialize listMask
			listMask = new Shape();
			listMask.graphics.beginFill(0xFF00FF, 1);
			listMask.graphics.drawRect(0, 0, 100, 100);
			listMask.graphics.endFill();
			listMask.x = 0;
			listMask.y = 0;
			_dropdown.mask = listMask;
			
			
			// add assets
			addChild(listMask);
			
			
			// draw the combo box
			draw();
			
			// event handling
			button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			inputText.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_dropdown.addEventListener(Event.CHANGE, dropdownChangeHander);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			var strokeThickness:int = 2;
			
			// 
			button.width = _width;
			button.height = _height;
			
			// 
			inputText.width = _width;
			inputText.height = _height;
			
			// 
			button.visible = !_editable;
			inputText.visible = _editable;
			
			// 
			arrowIcon.x = _width - _height/2;
			arrowIcon.y = _height / 2;
			//button.setIconBounds(_width - _height/2, _height/2);
			
			// 
			_dropdown.width = _width;
			
			// 
			//listMask.x = 0;
			//listMask.y = _height;
			listMask.width = _width;
			listMask.height = _dropdown.height;
			
			
			// draw button skins
			BElement(button.getSkin("upSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("upSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderColor = 0x666666;
			BElement(button.getSkin("upSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderWidth = 2;
			
			BElement(button.getSkin("overSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("overSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderColor = 0x999999;
			BElement(button.getSkin("overSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderWidth = 2;
			
			BElement(button.getSkin("downSkin")).style.backgroundColor = 0x333333;
			BElement(button.getSkin("downSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderColor = 0x666666;
			BElement(button.getSkin("downSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderWidth = 2;
			
			/*BElement(button.getSkin("disabledSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("disabledSkin")).style.backgroundOpacity = 1;
			
			BElement(button.getSkin("selectedUpSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("selectedUpSkin")).style.backgroundOpacity = 1;
			
			BElement(button.getSkin("selectedOverSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("selectedOverSkin")).style.backgroundOpacity = 1;
			
			BElement(button.getSkin("selectedDownSkin")).style.backgroundColor = 0x333333;
			BElement(button.getSkin("selectedDownSkin")).style.backgroundOpacity = 1;
			
			BElement(button.getSkin("selectedDisabledSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("selectedDisabledSkin")).style.backgroundOpacity = 1;*/
			
		} // end function draw
		
		
		/**
		 * 
		 * @param showList
		 */
		protected function toggleDropdown(showList:Boolean = true):void
		{
			var tweenMove:Tween;
			var tweenFade:Tween;
			var tweenArrow:Tween;
			
			/*if (_dropdown.y < _height)
			{
				showDropdown();
			}
			else
			{
				hideDropdown();
			}*/
			
			if (showList)
			{
				showDropdown();
			}
			else {
				hideDropdown();
			}
			
		} // end function showDropdown
		
		
		/**
		 * Displays the list
		 */
		protected function showDropdown():void
		{
			// (easy fix) fixes bug where dropdown is not the width of the combobox, due to not drawing
			// another fix is calling the draw function in the BUIComponent.setSize() function
			//_dropdown.width = _width;
			
			var tweenMove:Tween;
			var tweenFade:Tween;
			var tweenArrow:Tween;
			
			//tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, _height - _dropdown.height, _height, 0.3, true);
			tweenFade = new Tween(_dropdown, "alpha", Regular.easeInOut, 0, 1, 0.3, true);
			//tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 90, 0.3, true);
			
			switch(_listPosition)
			{
				/* 
				 * It is important that we set the position of the mask and dropdown for each (most) case(s)
				 */
				
				case BComboBoxDropdownPosition.CENTER:
					// in center mode, we tween the mask instead
					_dropdown.x = 0;
					_dropdown.y = -_dropdown.height / 2 + _height / 2;
					tweenMove = new Tween(listMask, "y", Regular.easeInOut, _height/2, -_dropdown.height / 2 + _height / 2, 0.3, true);
					tweenFade = new Tween(listMask, "height", Regular.easeInOut, 0, _dropdown.height, 0.3, true);
					setChildIndex(_dropdown, numChildren - 1);
					arrowIcon.visible = false;
					arrowIcon.rotation = -90;
					break;
					
				case BComboBoxDropdownPosition.TOP:
					listMask.x = 0;
					listMask.y = -_dropdown.height;
					_dropdown.x = 0;
					tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, 0, -_dropdown.height, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, -90, 0.3, true);
					break;
					
				case BComboBoxDropdownPosition.BOTTOM:
					listMask.x = 0;
					listMask.y = _height;
					_dropdown.x = 0;
					tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, _height - _dropdown.height, _height, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 90, 0.3, true);
					break;
					
				case BComboBoxDropdownPosition.LEFT:
					listMask.x = -_dropdown.width;
					listMask.y = 0;
					_dropdown.y = 0;
					tweenMove = new Tween(_dropdown, "x", Regular.easeInOut, _dropdown.x, -_dropdown.width, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 180, 0.3, true);
					break;
				
				case BComboBoxDropdownPosition.RIGHT:
					listMask.x = _dropdown.width;
					listMask.y = 0;
					_dropdown.y = 0;
					tweenMove = new Tween(_dropdown, "x", Regular.easeInOut, _dropdown.x, _dropdown.width, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 0, 0.3, true);
					break;
				
			}
			
			_dropdown.visible = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			showList = false;
			
		} // end function showDropdown
		
		
		/**
		 * Hides the list
		 */
		protected function hideDropdown():void
		{
			var tweenMove:Tween;
			var tweenFade:Tween;
			var tweenArrow:Tween;
			
			//tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, _dropdown.y, _height - _dropdown.height, 0.3, true);
			tweenFade = new Tween(_dropdown, "alpha", Regular.easeInOut, _dropdown.alpha, 0, 0.3, true);
			//tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 0, 0.3, true);
			
			switch(_listPosition)
			{
				case BComboBoxDropdownPosition.CENTER:
					tweenMove = new Tween(listMask, "y", Regular.easeInOut, listMask.y, _height/2, 0.3, true);
					setChildIndex(_dropdown, 0);
					arrowIcon.visible = true;
					break;
					
				case BComboBoxDropdownPosition.TOP:
					tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, _dropdown.y, 0, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 90, 0.3, true);
					break;
					
				case BComboBoxDropdownPosition.BOTTOM:
					tweenMove = new Tween(_dropdown, "y", Regular.easeInOut, _dropdown.y, _height - _dropdown.height, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, -90, 0.3, true);
					break;
					
				case BComboBoxDropdownPosition.LEFT:
					tweenMove = new Tween(_dropdown, "x", Regular.easeInOut, _dropdown.x, 0, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 0, 0.3, true);
					break;
				
				case BComboBoxDropdownPosition.RIGHT:
					tweenMove = new Tween(_dropdown, "x", Regular.easeInOut, _dropdown.x, 0, 0.3, true);
					tweenArrow = new Tween(arrowIcon, "rotation", Regular.easeOut, arrowIcon.rotation, 180, 0.3, true);
					break;
				
			}
			
			// create a timer and event listener to set the visibility of the list to false after a giving time
			var visibilityTimer:Timer = new Timer(300, 1);
			visibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, 
			function(event:TimerEvent):void
			{
				_dropdown.visible = false;
			}
			);
			visibilityTimer.start();
			
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			showList = true;
			
		} // end function hideDropdown
		
		
		//*************************************** SET AND GET **************************************
		
		/**
		 * Gets a reference to the BList component that the BComboBox component contains. 
		 */
		public function get dropdown():BList
		{
			return _dropdown;
		}
		
		
		/**
		 * Gets a reference to the BTextInput component that the BComboBox component contains. 
		 */
		public function get textField():BTextInput
		{
			return inputText;
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the BComboBox component is editable or read-only. 
		 * A value of <code>true</code> indicates that the BComboBox component is editable; 
		 * a value of <code>false</code> indicates that it is not.
		 * 
		 * <p>In an editable ComboBox component, a user can enter values into the text box that do not appear in the drop-down list. The text box displays the text of the item in the list. If a ComboBox component is not editable, text cannot be entered into the text box.</p>
		 * 
		 * @default false;
		 */
		public function get editable():Boolean
		{
			return _editable;
		}
		public function set editable(value:Boolean):void 
		{
			_editable = value;
			draw();
		}
		
		
		// dropdownWidth
		
		
		/**
		 * Gets the number of items in the list. This property belongs to the BList component but can be accessed from a BComboBox instance.
		 */
		public function get length():int
		{
			return _dropdown.length;
		}
		
		
		/**
		 * Gets or sets the characters that a user can enter in the text field. 
		 * If the value of the restrict property is a string of characters, 
		 * you can enter only characters in the string into the text field. 
		 * The string is read from left to right. If the value of the restrict property is null, you can enter any character. 
		 * If the value of the restrict property is an empty string (""), you cannot enter any character. 
		 * You can specify a range by using the hyphen (-) character. 
		 * This restricts only user interaction; a script can put any character into the text field.
		 * 
		 * @default null
		 */
		public function get restrict():String
		{
			return inputText.restrict;
		}
		public function set restrict(value:String):void
		{
			inputText.restrict = value;
		}
		
		
		/**
		 * Gets or sets the maximum number of rows that can appear in a drop-down list that does not have a scroll bar. 
		 * If the number of items in the drop-down list exceeds this value, the list is resized and a scroll bar is displayed, 
		 * if necessary. If the number of items in the drop-down list is less than this value, the drop-down list is resized 
		 * to accommodate the number of items that it contains.
		 * 
		 * <p>This behavior differs from that of the List component, which always shows the number of rows specified 
		 * by its rowCount property, even if this includes empty space.</p>
		 * 
		 * @default 0
		 */
		public function get rowCount():uint
		{
			return _dropdown.rowCount;
		}
		/*public function set rowCount(value:uint):void
		{
			_dropdown.rowCount = value;
		}*/
		
		
		/**
		 * Gets or sets the index of the item that is selected in a single-selection list. A single-selection list is a list in which only one item can be selected at a time.
		 * 
		 * <p>A value of -1 indicates that no item is selected; if multiple selections are made, 
		 * this value is equal to the index of the item that was selected last in the group of selected items.</p>
		 * 
		 * <p>When ActionScript is used to set this property, the item at the specified index replaces the current selection. 
		 * When the selection is changed programmatically, a change event object is not dispatched.</p>
		 */
		public function get selectedIndex():int
		{
			return _dropdown.selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			_dropdown.selectedIndex = value;
			button.label = _dropdown.getItemAt(value).label;
			//_dropdown.selectedItem = _dropdown.getItemAt(value);
		}
		
		
		/**
		 * Gets or sets the value of the item that is selected in the drop-down list. 
		 * If the user enters text into the text box of an editable ComboBox component, the selectedItem property is undefined. 
		 * This property has a value only if the user selects an item or if ActionScript is used to select an item from the drop-down list. 
		 * If the ComboBox component is not editable, the value of the selectedItem property is always valid. 
		 * If there are no items in the drop-down list of an editable ComboBox component, the value of this property is null.
		 * 
		 * @default null
		 */
		public function get selectedItem():Object
		{
			return _dropdown.selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			_dropdown.selectedItem = value;
			button.label = value.label;
			inputText.text = value.label;
		}
		
		
		/**
		 * Gets the string that is displayed in the TextInput portion of the ComboBox component. 
		 * This value is calculated from the data by using the labelField or labelFunction property.
		 */
		public function get selectedLabel():String
		{
			return dropdown.selectedItem.label;
		}
		
		
		/**
		 * Gets or sets the text that the text box contains in an editable ComboBox component. 
		 * For ComboBox components that are not editable, this value is read-only.
		 * 
		 * @default ""
		 */
		public function get text():String
		{
			return inputText.text;
		}
		public function set text(value:String):void
		{
			inputText.text = value;
		}
		
		
		// value
		/*public function get value():String
		{
			
		}*/
		
		
		/**
		 * Gets or sets the position of the list.
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BComboBoxDropdownPosition.LEFT</li>
		 * 	<li>BComboBoxDropdownPosition.RIGHT</li>
		 * 	<li>BComboBoxDropdownPosition.TOP</li>
		 * 	<li>BComboBoxDropdownPosition.BOTTOM</li>
		 * 	<li>BComboBoxDropdownPosition.CENTER</li>
		 * </ul>
		 * 
		 * @default BComboBoxDropdownPosition.CENTER
		 */
		public function get listPosition():String
		{
			return _listPosition;
		}
		public function set listPosition(value:String):void
		{
			switch(value)
			{
				case BComboBoxDropdownPosition.CENTER:
					_dropdown.x = 0;
					_dropdown.y = -_dropdown.height / 2 + _height / 2;
					arrowIcon.rotation = -90;
					break;
					
				case BComboBoxDropdownPosition.TOP:
					listMask.x = 0;
					listMask.y = -_dropdown.height;
					_dropdown.x = 0;
					arrowIcon.rotation = -90;
					break;
					
				case BComboBoxDropdownPosition.BOTTOM:
					listMask.x = 0;
					listMask.y = _height;
					_dropdown.x = 0;
					arrowIcon.rotation = -90;
					break;
					
				case BComboBoxDropdownPosition.LEFT:
					listMask.x = -_dropdown.width;
					listMask.y = 0;
					_dropdown.y = 0;
					arrowIcon.rotation = -90;
					break;
				
				case BComboBoxDropdownPosition.RIGHT:
					listMask.x = _dropdown.width;
					listMask.y = 0;
					_dropdown.y = 0;
					arrowIcon.rotation = -90;
					break;
				
				/*case BComboBoxDropdownPosition.AUTO:
					listMask.x = 0;
					listMask.y = 0;
					_dropdown.x = 0;
					_dropdown.y = 0;
					arrowIcon.rotation = -90;
					break;*/
				
			}
			
			_listPosition = value;
		}
		
		
	}
	
}
