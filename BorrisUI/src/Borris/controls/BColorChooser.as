/* Author: Rohaan Allport
 * Date Created: 14/05/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.* ;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.filters.DropShadowFilter;
	
	
	/**
	 * The BColorChooser component displays a text input and switch button from which the user can select a color.
	 * 
	 * <p>By default, the component displays a single swatch of color on a square button. When the user clicks this button, a panel opens to display a rectangular color spectrum.</p>
	 * 
	 * @author Rohaan Allport
	 */
	public class BColorChooser extends BUIComponent
	{
		// constants
		
		// assets
		protected var colorsContainer:Sprite;																	// The sprite for drawing the color sppectrum into.
		protected var inputText:BTextInput;																		// The input text located right next to the swatch for manually typin gin a color
		protected var swatch:Sprite;																			// The main swatch of the color chooser
		
		// other
		protected var colors:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];	// 
		protected var part:Number = 0xFF / (colors.length-1);													// 
        protected var ratios:Array = [];																		// 
		protected var alphas:Array = [];																		// 
        protected var m:Matrix = new Matrix();																	// 
		protected var bitmapData:BitmapData;																	// 
		
		protected var oldColor:uint;																			// 
		protected var tempColor:uint;																			// 
		
		
		// set and get
		protected var _value:uint = 0xff0000;																	// 
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BColorChooser component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
		 * @param value The color value of the color chooser in hexadecimal.
         */
		public function BColorChooser(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, value:uint = 0xFF0000) 
		{
			// constructor code
			_value = value;
			
			super(parent, x, y);
			initialize();
			setSize(100, 20);
			draw();
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * Change the swatch color and value when the user changes the text in the input text.
		 */ 
		protected function onInputChange(event:Event):void
		{
			// prevent processing of event listeners in the current node and event flow
			event.stopImmediatePropagation();
			
			// set old color to value
			oldColor = _value;
			
			// convert text to a number in base 16
			_value = parseInt("0x" + inputText.text, 16);
			
			// set input text to uppercase
			inputText.text = inputText.text.toUpperCase();
			
			// redraw the color chooser (although only the swatch needs to redraw)
			draw();
			
			// dispatch a new change event
			dispatchEvent(new Event(Event.CHANGE));
			
		} // end onInputChange
		
		
		/**
		 * Shows the color spectrum.
		 * Called when the user clicks the swatch.
		 */ 
		protected function showSpectrum(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, hideSpectrum);
			event.stopImmediatePropagation();
			colorsContainer.visible = !colorsContainer.visible;
		} // end function showSpectrum
		
		
		/**
		 * Hides the color specturm.
		 * Called when the user clicks anywhere on stage
		 */ 
		protected function hideSpectrum(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, hideSpectrum);
			colorsContainer.visible = false;
		} // end function hideSpectrum
		
		
		/**
		 * Change the visibility for the colors container
		 */
		protected function displaySpectrum():void
		{
			colorsContainer.visible = !colorsContainer.visible;
		} // end function displaySpectrum
		
		
		/**
		 * Update the swatch color as the mouse moves over the color spectrum.
		 */ 
		protected function updateSwatch(event:MouseEvent):void
		{
			value = bitmapData.getPixel(colorsContainer.mouseX, colorsContainer.mouseY);
			dispatchEvent(new Event(Event.CHANGE));
		} // end function updateSwatch
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize text input
			inputText = new BTextInput(this, 0, 0, "");
			inputText.width = 50;
			inputText.height = 20;
			inputText.restrict = "0123456789ABCDEFabcdef";
			inputText.maxChars = 6;
			
			// initialize swatch
			swatch = new Sprite();
			swatch.x = 60;
			//swatch.filters = [new DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 1, 1, true)];
			swatch.tabEnabled = true;
			
			colorsContainer = new Sprite();
			colorsContainer.x = 60;
			colorsContainer.y = 30;
			
			// 
			value = _value;
			
			
			// set m, ratios and alphas
			m.createGradientBox(250, 180);
            for (var i:int = 0; i < colors.length; i++) 
			{
                ratios.push(part * i);
                alphas.push(1);
            }
			
			var colorGrad:Shape = new Shape();
			var lightGrad:Shape = new Shape();
			var lightMatrix:Matrix = new Matrix();
			lightMatrix.createGradientBox(250, 180, Math.PI / 2, 0, 0);
			colorGrad.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, m);
            colorGrad.graphics.drawRect(0, 0, 250, 180);
			lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000], [1, 0, 0, 1], [0, 127, 128, 255], lightMatrix);
            lightGrad.graphics.drawRect(0, 0, 250, 180);
			
			
			// add assets and containers the stage
			colorsContainer.addChild(colorGrad);
			colorsContainer.addChild(lightGrad);
			colorsContainer.visible = false;
			
			// 
			addChild(inputText);
			addChild(swatch);
			addChild(colorsContainer);
			
			
			// 
            bitmapData = new BitmapData(250, 180);
            bitmapData.draw(colorsContainer);
			
			// event handling
			inputText.addEventListener(Event.CHANGE, onInputChange);
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, showSpectrum);
			colorsContainer.addEventListener(MouseEvent.MOUSE_MOVE, updateSwatch);
			//colorsContainer.addEventListener(MouseEvent.CLICK, updateSwatch);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			swatch.graphics.clear();
			swatch.graphics.beginFill(0xFFFFFF);
			swatch.graphics.drawRect(0, 0, 20, 20);
			swatch.graphics.beginFill(_value);
			swatch.graphics.drawRect(1, 1, 18, 18);
			swatch.graphics.endFill();
			
		} // end function draw
		
		
		/**
		 * Shows the color palette.
		 */ 
		public function openPalette():void
		{
			colorsContainer.visible = true;
			dispatchEvent(new Event(Event.OPEN));
		} // end function openPalette
		
		
		/**
		 * Hides the color palette. 
		 */ 
		public function closePalette():void
		{
			colorsContainer.visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		} // end function closePalette
		
		
		//***************************************** SET AND GET *****************************************
		
		/**
		 * Gets or sets a Boolean value that indicates whether the internal text field of the ColorPicker component is editable. 
		 * A value of <code>true</code> indicates that the internal text field is editable; 
		 * a value of <code>false</code> indicates that it is not.
		 * 
		 * @default true
		 */
		public function get editable():Boolean
		{
			return inputText.editable;
		}
		public function set editable(value:Boolean):void
		{
			inputText.editable = value;
		}
		
		
		/**
		 * gets or sets whether the internal input text should be displayed.
		 */
		public function get showTextField():Boolean
		{
			return inputText.visible;
		}
		public function set showTextField(value:Boolean):void
		{
			inputText.visible = value;
			swatch.x = value ? 60 : 10;
		}
		
		
		/**
		 * Gets the string value of the current color selection.
		 */
		public function get hexValue():String
		{
			return _value.toString(16);
		}
		
		
		/**
		 * Gets or sets value of the swatch color.
		 */
		public function get value():uint
		{
			return _value;
		}
		public function set value(val:uint):void
		{
			// set string to the string value of val in base 16
			var colorString:String = val.toString(16).toUpperCase();
			
			// while the the string is less than 6 characters, add zeros (0) infront of it.
			while(colorString.length < 6)
			{
				colorString = "0" + colorString;
			}
			
			// set text of the input text to the color string
			inputText.text = colorString;
			
			// convert string to a number in base 16
			_value = parseInt("0x" + inputText.text, 16);
			
			// redraw the color chooser (although only the swatch needs to redraw)
			draw();
		}
		
		
	}

}