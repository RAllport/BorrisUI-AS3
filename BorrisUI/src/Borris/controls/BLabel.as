/* Author: Rohaan Allport
 * Date Created: 19/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Label component displays one or more lines of plain or HTML-formatted text that can be formatted for alignment and size. Label components do not have borders and cannot receive focus.
 * 
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.*
	import flash.text.*;
	
	import Borris.assets.fonts.*;
	
	
	public class BLabel extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var skin:Sprite;
		
		
		// text stuff
		protected var _textField:TextField;
		protected var enabledTF:TextFormat;
		protected var disabledTF:TextFormat;
		protected var calibriRegular:CalibriRegular = new CalibriRegular();
		
		
		// other
		
		
		
		// set and get
		protected var _autoSize:String;
		protected var _selectable:Boolean = false;
		protected var _text:String = "";
		protected var _wordWrap:Boolean = false;
		
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BLabel component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
		 * @param text The text String to be displayed by the BLabel component.
         */
		public function BLabel(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, text:String = "") 
		{
			_autoSize = TextFieldAutoSize.NONE;
			_text = text;
			
			super(parent, x, y);
			initialize();
			setSize(100, 20);
			draw();
			
			this.text = text;
		}
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			mouseEnabled = false;
			mouseChildren = false;
			
			
			// initialize assets
			skin = new Sprite();
			
			
			// initialize the text feilds and formats
			enabledTF = new TextFormat("Calibri", 16, 0xFFFFFF, false);
			disabledTF = new TextFormat("Calibri", 16, 0xCCCCCC, false);
			
			
			// initialize the text field
			_textField = new TextField();
			_textField.text = _text;
			_textField.type = TextFieldType.DYNAMIC;
			_textField.selectable = false;
			_textField.x = 0;
			_textField.y = 0;
			_textField.width = _width;
			_textField.height = _height;
			_textField.setTextFormat(enabledTF);
			_textField.defaultTextFormat = enabledTF;
			_textField.mouseEnabled = false;
			//_textField.autoSize = TextFieldAutoSize.NONE;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			
			addChild(skin);
			addChild(_textField);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			/*skin.graphics.clear();
			skin.graphics.lineStyle(2, 0xCCCCCC, 1);
			skin.graphics.moveTo( -_textField.height, 0);
			skin.graphics.lineTo(0, _textField.height);
			skin.graphics.lineTo(_textField.width + _textField.height, _textField.height);
			
			skin.graphics.beginFill(0xCCCCCC, 1);
			skin.graphics.drawCircle(_textField.width + _textField.height, _textField.height, 8);
			skin.graphics.endFill();*/
			
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			_textField.width = width;
			_textField.height = height;
			draw();
		} // end function setSize
		
		
		//***************************************** SET AND GET *****************************************
		
		/**
         * Gets or sets a string that indicates how a label is sized and aligned to fit the value of its text property. 
		 * The following are valid values:
		 * <ul>
		 * <li>TextFieldAutoSize.NONE: The label is not resized or aligned to fit the text.</li>
		 * <li>TextFieldAutoSize.LEFT: The right and bottom sides of the label are resized to fit the text. The left and top sides are not resized.</li>
		 * <li>TextFieldAutoSize.CENTER: The left and right sides of the label resize to fit the text. 
		 * The horizontal center of the label stays anchored at its original horizontal center position.</li>
		 * <li>TextFieldAutoSize.RIGHT: The left and bottom sides of the label are resized to fit the text. The top and right sides are not resized.</li>
		 * </lu>
		 * 
		 * @default TextFieldAutoSize.NONE
         */
		public function get autoSize():String
		{
			return _textField.autoSize;
		}
		public function set autoSize(value:String):void
		{
			_textField.autoSize = value;
		}
		
		
		/**
         * Gets or sets a value that indicates whether the text can be selected. 
		 * A value of true indicates that it can be selected; 
		 * a value of false indicates that it cannot.
		 * 
		 * Text that can be selected can be copied from the Label component by the user.
		 * 
		 * @default false
         */
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}
		public function set selectable(value:Boolean):void
		{
			_textField.selectable = value;
			_textField.mouseEnabled = value;
			mouseEnabled = value;
			mouseChildren = value;
		}
		
		
		/**
         * Gets or sets the plain text to be displayed by the Label component.
		 * 
		 * <p>Note that characters that represent HTML markup have no special meaning in the string and will appear as they were entered.</p>
		 * 
		 * @default "Label"
         */
		public function get text():String
		{
			return _textField.text;
		}
		public function set text(value:String):void
		{
			_textField.text = value;
			this.width = _textField.width;
		}
		
		
		/**
         * A reference to the internal text field of the Label component.
         */
		public function get textField():TextField
		{
			return _textField;
		}
		
		
		/**
         * Gets or sets a value that indicates whether the text field supports word wrapping. 
		 * A value of true indicates that it does; 
		 * a value of false indicates that it does not.
		 * 
		 * @default false
         */
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
		}
		
		
		/**
         * @inheritDoc
         */
		override public function get width():Number
		{
			return _textField.width
		}
		override public function set width(value:Number):void
		{
			_width = value;
			_textField.width = value;
			draw();
		}
		
		
		/**
         * @inheritDoc
         */
		override public function get height():Number
		{
			return _textField.height;
		}
		override public function set height(value:Number):void
		{
			_width = value;
			_textField.height = value;
			draw();
		}
		
		
	}

}