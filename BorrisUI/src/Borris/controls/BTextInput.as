/* Author: Rohaan Allport
 * Date Created: 13/05/2015 (dd/mm/yyyy)
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
	import flash.ui.Keyboard;
	import flash.filters.DropShadowFilter;
	
	import Borris.display.BElement;;
	
	
	public class BTextInput extends BUIComponent
	{
		// assets
		protected var upSkin:Sprite;							// The up skin of this details Object.
		protected var overSkin:Sprite;							// The over skin of this details Object.
		protected var downSkin:Sprite;							// The down skin of this details Object.
		protected var disabledSkin:Sprite;						// The disabled skin of this details Object.
		protected var focusSkin:Sprite;
		
		// text stuff
		protected var focusInTF:TextFormat;
		protected var focusOutTF:TextFormat;
		
		
		// other
		protected var states:Array;
		protected var disabledAlpha:Number = 0.5;
		
		// set and get
		protected var _editable:Boolean = true;							// 
		//protected var _imeMode:String;
		protected var _textField:TextField;
		protected var _textPadding:Number = 0;						// 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BRangeSlider component instance.
		 * 
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
		 * @param text The text to be shown by the BTextInput component.
         */
		public function BTextInput(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, text:String = "") 
		{
			// constructor code
			super(parent, x, y);
			initialize();
			setSize(100, 30);
			draw();
			
			_textField.text = text;
		}
		
		//************************************* EVENT HANDLERS ******************************************
		
		/**
		 * 
		 * @param event
		 */
		protected function onChange(event:Event):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(event);
		} // end function onChange
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onEnter(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				dispatchEvent(event);
			}
		} // end function onEnter
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onTextInput(event:TextEvent):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(event);
		} // end function onInputText
		
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseHandler(event:MouseEvent):void
		{	
			
			
		} // end function mouseHandler
		
		
		/**
		 * 
		 * @param event
		 */
		private function focusHandler(event:FocusEvent):void
		{
			switch(event.type)
			{
				case FocusEvent.FOCUS_IN:
					if (_editable)
					{
						changeState(focusSkin);
						_textField.setTextFormat(focusInTF);
						_textField.defaultTextFormat = focusInTF;
					}
					break;
					
				case FocusEvent.FOCUS_OUT:
					changeState(upSkin);
					_textField.setTextFormat(focusOutTF);
					_textField.defaultTextFormat = focusOutTF;
					break;
			}
		} // end function focusHandler
		
		
		
		//************************************* FUNCTIONS ******************************************
		
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
			focusSkin = new BElement();
			
			// initialize text formats
			focusInTF = new TextFormat("Calibri", 16, 0x000000, false);
			focusOutTF = new TextFormat("Calibri", 16, 0xCCCCCC, false);
			
			// initialize the text field
			_textField = new TextField();
			//_textField.setTextFormat(focusOutTF);
			//_textField.defaultTextFormat = focusOutTF;
			_textField.text = "hehehe";
			_textField.selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.x = 0;
			_textField.y = 0;
			_textField.width = _width;
			_textField.height = _height;
			_textField.setTextFormat(focusOutTF);
			_textField.defaultTextFormat = focusOutTF;
			_textField.mouseEnabled = true;
			_textField.autoSize = TextFieldAutoSize.NONE;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			//_textField.background = true;
			//_textField.backgroundColor = 0x0000ff;
			
			addChild(upSkin);
			addChild(overSkin);
			addChild(downSkin);
			//addChild(disabledSkin);
			addChild(focusSkin);
			addChild(_textField);
			
			// add the state skins to the state array
			states = new Array(upSkin, overSkin, downSkin, disabledSkin, focusSkin);
			changeState(upSkin);
			
			// event handling
			_textField.addEventListener(Event.CHANGE, onChange);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			//
			upSkin.width = 
			overSkin.width = 
			downSkin.width = 
			disabledSkin.width = 
			focusSkin.width = _width;
			
			upSkin.height = 
			overSkin.height = 
			downSkin.height = 
			disabledSkin.height = 
			focusSkin.height = _height;
			
			BElement(upSkin).style.backgroundColor = 0x333333;
			BElement(upSkin).style.backgroundOpacity = 0.9;
			BElement(upSkin).style.borderColor = 0xCCCCCC;
			BElement(upSkin).style.borderOpacity = 0.9;
			BElement(upSkin).style.borderWidth = 2;
			
			BElement(overSkin).style.backgroundColor = 0x666666;
			BElement(overSkin).style.backgroundOpacity = 0.9;
			BElement(overSkin).style.borderColor = 0xFFFFFF;
			BElement(overSkin).style.borderOpacity = 0.9;
			BElement(overSkin).style.borderWidth = 2;
			
			/*BElement(downSkin).style.backgroundColor = 0x666666;
			BElement(downSkin).style.backgroundOpacity = 1;
			BElement(downSkin).style.borderColor = 0x666666;
			BElement(downSkin).style.borderOpacity = 1;
			BElement(downSkin).style.borderWidth = 2;
			
			BElement(disabledSkin).style.backgroundColor = 0x666666;
			BElement(disabledSkin).style.backgroundOpacity = 1;
			BElement(disabledSkin).style.borderColor = 0x666666;
			BElement(disabledSkin).style.borderOpacity = 1;
			BElement(disabledSkin).style.borderWidth = 2;*/
			
			BElement(focusSkin).style.backgroundColor = 0xFFFFFF;
			BElement(focusSkin).style.backgroundOpacity = 1;
			BElement(focusSkin).style.borderColor = 0x999999;
			BElement(focusSkin).style.borderOpacity = 1;
			BElement(focusSkin).style.borderWidth = 2;
			
			// draw text field
			//_textField.displayAsPassword = _displayAsPassword;
			_textField.height = _height - 4;
			_textField.width = _width - 4;
			focusInTF.size = Math.floor(_height * 0.6);
			focusOutTF.size = Math.floor(_height * 0.6);
			_textField.x = 2;
			_textField.y = _height / 2 - _textField.height / 2;
			//trace("BTextInput.draw() | text field height: " + _textField.height);
			
		} // end function draw
		
		
		/**
		 * Changes the state of the component.
		 * 
		 * @param state
		 */
		protected function changeState(state:DisplayObject):void
		{
			for(var i:int = 0; i < states.length; i++)
			{
				var tempState:DisplayObject = states[i]; 
				tempState.visible = false;
				
				if(state == tempState)
				{
					tempState.visible = true;
				}
				else 
					tempState.visible = false;
			} // end for
			
		} // end function changeState
		
		
		/**
		 * Appends the specified string after the last character that the TextArea contains. 
		 * This method is more efficient than concatenating two strings by using an addition assignment on a text property; 
		 * for example, myTextArea.text += moreText. 
		 * This method is particularly useful when the TextArea component contains a significant amount of content.
		 * 
		 * @param text The string to be appended to the existing text.
		 */
		public function appendText(text:String):void
		{
			_textField.appendText(text);
		} // end function appendText
		
		
		/**
		 * Sets the range of a selection made in a text area that has focus. 
		 * The selection range begins at the index that is specified by the start parameter, 
		 * and ends at the index that is specified by the end parameter. 
		 * If the parameter values that specify the selection range are the same, 
		 * this method sets the text insertion point in the same way that the caretIndex property does.
		 * 
		 * <p>The selected text is treated as a zero-based string of characters in which the first selected 
		 * character is located at index 0, the second character at index 1, and so on.</p>
		 * 
		 * <p>This method has no effect if the text field does not have focus.</p>
		 * 
		 * @param beginIndex The index location of the first character in the selection.
		 * @param endIndex The index location of the last character in the selection.
		 */
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			_textField.setSelection(beginIndex, endIndex);
		} // end function setSelection
		
		
		
		//***************************************** SET AND GET *****************************************
		
		/**
		 * Gets or sets a Boolean value that indicates how a selection is displayed when the text field does not have focus.
		 * 
		 * <p>When this value is set to true and the text field does not have focus, 
		 * Flash Player highlights the selection in the text field in gray. 
		 * When this value is set to false and the text field does not have focus, 
		 * Flash Player does not highlight the selection in the text field.</p>
		 * 
		 * @default false
		 */
		public function get alwaysShowSelection():Boolean
		{
			return _textField.alwaysShowSelection;
		}
		public function set alwaysShowSelection(value:Boolean):void
		{
			_textField.alwaysShowSelection = value;
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether extra white space is removed from a TextInput component that contains HTML text. 
		 * Examples of extra white space in the component include spaces and line breaks. 
		 * A value of true indicates that extra white space is removed; a value of false indicates that extra white space is not removed.
		 * 
		 * <p>This property affects only text that is set by using the htmlText property; 
		 * it does not affect text that is set by using the text property. 
		 * If you use the text property to set text, the condenseWhite property is ignored.</p>
		 * 
		 * <p>If the condenseWhite property is set to true, you must use standard HTML commands, 
		 * such as <br> and <p>, to place line breaks in the text field.</p>
		 * 
		 * @default false
		 */
		public function get condenseWhite():Boolean
		{
			return _textField.condenseWhite;
		}
		public function set condenseWhite(value:Boolean):void
		{
			_textField.condenseWhite = value;
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the current TextInput component 
		 * instance was created to contain a password or to contain text. 
		 * A value of true indicates that the component instance is a password text field; 
		 * a value of false indicates that the component instance is a normal text field.
		 * 
		 * <p>When this property is set to true, for each character that the user enters into the text field, 
		 * the TextInput component instance displays an asterisk. 
		 * Additionally, the Cut and Copy commands and their keyboard shortcuts are disabled. 
		 * These measures prevent the recovery of a password from an unattended computer.</p>
		 * 
		 * @default false
		 */
		public function get displayAsPassword():Boolean
		{
			return _textField.displayAsPassword;
		}
		public function set displayAsPassword(value:Boolean):void
		{
			_textField.displayAsPassword = value;
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the text field can be edited by the user. 
		 * A value of true indicates that the user can edit the text field; 
		 * a value of false indicates that the user cannot edit the text field.
		 * 
		 * @default true;
		 */
		public function get editable():Boolean
		{
			return _editable;
		}
		public function set editable(value:Boolean):void
		{
			_editable = value;
			//_textField.selectable = value;
			
			if (value)
			{
				_textField.type = TextFieldType.INPUT;
			}
			else
			{
				_textField.type = TextFieldType.DYNAMIC;
			}
		}
		
		
		/**
		 * Gets or sets the position of the thumb of the horizontal scroll bar.
		 * 
		 * @default 0
		 */
		public function get horizontalScrollPosition():int
		{
			return _textField.scrollH;
		}
		public function set horizontalScrollPosition(value:int):void
		{
			_textField.scrollH = value;
		}
		
		
		/**
		 * Gets or sets the position of the thumb of the vertical scroll bar.
		 */
		public function get verticalScrollPosition():int
		{
			return _textField.scrollV;
		}
		public function set verticalScrollPosition(value:int):void
		{
			_textField.scrollV = value;
		}
		
		
		/**
		 * Contains the HTML representation of the string that the text field contains.
		 * 
		 * @default ""
		 */
		public function get htmlText():String
		{
			return _textField.htmlText;
		}
		public function set htmlText(value:String):void
		{
			_textField.htmlText = value;
		}
		
		
		// imeMode
		/*public function set imeMode(value:String):void
		{
			_imeMode = value;
		}
		
		public function get imeMode():String
		{
			return _imeMode;
		}*/
		
		
		/**
		 * Gets the number of characters in a TextInput component.
		 * 
		 * @default 0
		 */
		public function get length():int
		{
			return _textField.length;
		}
		
		
		/**
		 * Gets or sets the maximum number of characters that a user can enter in the text field.
		 * 
		 * @default 0
		 */
		public function get maxChars():int
		{
			return _textField.maxChars;
		}
		public function set maxChars(value:int):void
		{
			_textField.maxChars = value;
		}
		
		
		/**
		 * Gets a value that describes the furthest position to which the text field can be scrolled to the right.
		 * 
		 * @default 0
		 */
		public function get maxHorizontalScrollPosition():int
		{
			return _textField.maxScrollH;
		}
		
		
		/**
		 * Gets a value that describes the furthest position to which the text field can be scrolled to the bottom.
		 * 
		 * @default 0
		 */
		public function get maxVerticalScrollPosition():int
		{
			return _textField.maxScrollV;
		}
	
		
		/**
		 * Gets or sets the string of characters that the text field accepts from a user. 
		 * Note that characters that are not included in this string are accepted in the text field if they are entered programmatically.
		 * 
		 * <p>The characters in the string are read from left to right. 
		 * You can specify a character range by using the hyphen (-) character.</p>
		 * 
		 * <p>If the value of this property is null, the text field accepts all characters. 
		 * If this property is set to an empty string (""), the text field accepts no characters.</p>
		 * 
		 * <p>If the string begins with a caret (^) character, 
		 * all characters are initially accepted and succeeding characters in the string are excluded from the set of accepted characters. 
		 * If the string does not begin with a caret (^) character, 
		 * no characters are initially accepted and succeeding characters in the string are included in the set of accepted characters.</p>
		 * 
		 * @default null
		 */
		public function get restrict():String
		{
			return _textField.restrict;
		}
		public function set restrict(value:String):void
		{
			_textField.restrict = value;
		}
		
		
		/**
		 * Gets the index value of the first selected character in a selection of one or more characters.
		 * 
		 * <p>The index position of a selected character is zero-based and calculated from the first character that appears in the text area. 
		 * If there is no selection, this value is set to the position of the caret.</p>
		 * 
		 * @default 0
		 */
		public function get selectionBeginIndex():int
		{
			return _textField.selectionBeginIndex;
		}
		
		
		/**
		 * Gets the index position of the last selected character in a selection of one or more characters.
		 * 
		 * <p>The index position of a selected character is zero-based and calculated from the first character 
		 * that appears in the text area. If there is no selection, this value is set to the position of the caret.</p>
		 * 
		 * @default 0
		 */
		public function get selectionEndIndex():int
		{
			return _textField.selectionEndIndex;
		}
		
		
		/**
		 * Gets or sets a string which contains the text that is currently in the TextInput component. 
		 * This property contains text that is unformatted and does not have HTML tags. 
		 * To retrieve this text formatted as HTML, use the htmlText property.
		 * 
		 * @default ""
		 */
		public function get text():String
		{
			return _textField.text;
		}
		public function set text(value:String):void
		{
			_textField.text = value;
		}
		
		
		/**
		 * A reference to the internal text field of the TextInput component.
		 */
		public function get textField():TextField
		{
			return _textField
		}
		
		
		/**
		 * The height of the text, in pixels.
		 * 
		 * @default 0
		 */
		public function get textHeight():Number
		{
			return _textField.textHeight;
		}
		
		
		/**
		 * The width of the text, in pixels.
		 * 
		 * @default 0
		 */
		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
		
		
	}

}