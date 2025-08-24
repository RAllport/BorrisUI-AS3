/* Author: Rohaan Allport
 * Date Created: 22/01/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls 
{
	import Borris.controls.ColorChooserClasses.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	//import flash.geom.Matrix;
	//import flash.geom.Point;
	//import flash.geom.ColorTransform;
	import flash.filters.DropShadowFilter;
	
	import Borris.containers.BPanel;
	import Borris.display.*;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BColorChooserAdvanced extends BColorChooser
	{
		// constants
		
		
		// assets
		//tabs
		protected var tabContainer:BPanel;
		protected var gimpTab:BTab = new BTab("Gimp");
		protected var barsTab:BTab = new BTab("Bars");
		protected var hueTab:BTab = new BTab("Hue");
		protected var swatchedTab:BTab = new BTab("Swatches");
		
		// radio buttons
		protected var hueRb:BRadioButton;
		protected var saturationRb:BRadioButton;
		protected var brightnessRb:BRadioButton;
		protected var redRb:BRadioButton;
		protected var greenRb:BRadioButton;
		protected var blueRb:BRadioButton;
		
		// text inputs
		protected var hueInputText:BTextInput;
		protected var satInputText:BTextInput;
		protected var brightnessInputText:BTextInput;
		protected var redInputText:BTextInput;
		protected var greenInputText:BTextInput;
		protected var blueInputText:BTextInput;
		
		
		
		// style
		protected var controlWidth:int = 180;
		protected var barWidth:int = 10;
		
		
		// other
		protected var canvas:Shape = new Shape();
		
		
		// gimp
		protected var gimpBar:BColorBar;
		protected var ctrl:BColorController;
		protected var hue:uint = 0;
		protected var saturation:uint = 0;
		protected var brightness:uint = 0;
		protected var red:uint = 0;
		protected var green:uint = 0;
		protected var blue:uint = 0;
		protected var selectedRBIndex:int = 0;
		
		
		
		// set and get
		//protected var _changeImmediately:Boolean = true;
		//protected var _alphaEnabled:Boolean = false;
		//protected var _alpha:Number = 1;
		//protected var _alphaBar:BColorBar;
		//protected var _alphaMap:BitmapData;
		//protected var _alphaTile:AlphaTile;
		//protected var _alphaValue:InputText;
		
		
		public function BColorChooserAdvanced(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, value:uint = 0xFF0000) 
		{
			// constructor
			super(parent, x, y, value);
			
			trace("RGB to HSB: " + rgbTohsb(255, 200, 100).toString(16));
			//trace("HSB to RGB: " + hsbTorgb(0xffffff, 0x00ee00, 0x000033).toString());
			//rgbTohsb(10, 200, 105);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * Shows the color spectrum.
		 * Called when the user clicks the swatch.
		 */ 
		override protected function showSpectrum(event:MouseEvent):void
		{
			
		} // end function showSpectrum
		
		
		/**
		 * Hides the color specturm.
		 * Called when the user clicks anywhere on stage
		 */ 
		override protected function hideSpectrum(event:MouseEvent):void
		{
			
		} // end function hideSpectrum
		
		
		/**
		 * 
		 */ 
		protected function showWindow(event:MouseEvent):void
		{
			trace();
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, hideWindow);
			//event.stopImmediatePropagation();
			//tabContainer.activate();
			tabContainer.x = this.x;
			tabContainer.y = this.y + 30;
			if (tabContainer.active)
			{
				tabContainer.close();
			}
			else
			{
				tabContainer.activate();
			}
		} // end function showSpectrum
		
		
		/**
		 * 
		 */ 
		protected function hideWindow(event:MouseEvent):void
		{
			swatch.removeEventListener(MouseEvent.MOUSE_DOWN, hideWindow);
			tabContainer.close();
		} // end function hideSpectrum
		
		
		/**
		 * 
		 */
		protected function onRadioButtonClick(event:MouseEvent):void
		{
			//trace(BRadioButton(event.target).group.getRadioButtonIndex(event.target as BRadioButton));
			selectedRBIndex = BRadioButton(event.target).group.getRadioButtonIndex(event.target as BRadioButton);
			
			
			
			// set m, ratios and alphas
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(barWidth, controlWidth, Math.PI/2, 0, 0);
			
			var colors:Array = [];
			var ratios:Array = [0, 255];
			var alphas:Array = [1, 1];
			
			
			switch(selectedRBIndex)
			{
				case 0:
					matrix.createGradientBox(barWidth, controlWidth, -Math.PI/2, 0, 0);
					colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
					ratios = [];
					alphas = [];
					var part:Number = 0xFF / (colors.length - 1);
					
					for (var i:int = 0; i < colors.length; i++) 
					{
						ratios.push(part * i);
						alphas.push(1);
					}
					break;
				
				case 1:  
					colors = [0x000000, 0x000000];
					updateSaturation();
					break;
				
				case 2:  
					colors = [0xFFFFFF, 0x000000];
					break;
				
				case 3:  
					colors = [0xFF0000, 0x000000];
					break;
				
				case 4:  
					colors = [0x00FF00, 0x000000];
					break;
				
				case 5: 
					colors = [0x0000FF, 0x000000];
					break;
					
			} // end switch 
			
			
			// init gimp bar
			canvas.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix); 
			canvas.graphics.drawRect(0, 0, barWidth, controlWidth + 1);
			
			// draw the to gimpBar
			gimpBar.bitmapData.draw(canvas);
			
		} // end function onRadioButtonClick
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onHueChange(event:Event):void
		{
			update();
		} // end 
		
		
		/**
		 * 
		 */
		protected function onCtrlChange(event:Event):void
		{
			/*switch (selectedRBIndex) 
			{
				case 0:  
					saturation = ctrl.valueX; 
					brightness = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 1:  
					brightness = ctrl.valueX; 
					hue = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 2:  
					hue = ctrl.valueX; 
					saturation = ctrl.valueY; 
					//_HSVupdated(); 
					break;
				
				case 3:  
					blue = ctrl.valueX * 255; 
					green = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
				
				case 4:  
					red = ctrl.valueX * 255; 
					blue = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
				
				default: 
					green = ctrl.valueX * 255; 
					red = ctrl.valueY * 255; 
					//_RGBupdated(); 
					break;
			} // end switch 
			//_updateColors(true, false);
			//_chooser.browseColorChoiceEx(value);*/
			
			
			update();
			
		} // function onCtrlChange
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * @inheritDoc
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			swatch.removeEventListener(MouseEvent.MOUSE_DOWN, showSpectrum);
			
			// initialize assets
			tabContainer = new BPanel();
			tabContainer.titleBarMode = BTitleBarMode.NONE;
			tabContainer.minimizable = false;
			tabContainer.maximizable = false;
			tabContainer.draggable = false;
			tabContainer.resizable = false;
			tabContainer.minSize = new Point(240, 220);
			tabContainer.x = this.x;
			tabContainer.y = this.y + 30;
			tabContainer.resize(480, 300, false);
			this.parent.addChild(tabContainer);
			//trace("tab container stage width: " + tabContainer.stage.stageWidth);
			
			var tabGroup:BTabGroup = new BTabGroup("adv color chooser tabs");
			tabGroup.addTab(gimpTab);
			tabGroup.addTab(barsTab);
			tabGroup.addTab(hueTab);
			tabGroup.addTab(swatchedTab);
			tabGroup.parent = tabContainer.content;
			tabGroup.setContentSize(420, 220);
			
			hueRb = new BRadioButton(gimpTab.content, 130, 10, "H:", true);
			saturationRb = new BRadioButton(gimpTab.content, 130, 40, "S:");
			brightnessRb = new BRadioButton(gimpTab.content, 130, 70, "B:");
			redRb = new BRadioButton(gimpTab.content, 130, 110, "R:");
			greenRb = new BRadioButton(gimpTab.content, 130, 140, "G:");
			blueRb = new BRadioButton(gimpTab.content, 130, 170, "B:");
			
			// make a radio button group
			var gimpRbGroup:BRadioButtonGroup = new BRadioButtonGroup("gimp rb group");
			gimpRbGroup.addRadioButton(hueRb);
			gimpRbGroup.addRadioButton(saturationRb);
			gimpRbGroup.addRadioButton(brightnessRb);
			gimpRbGroup.addRadioButton(redRb);
			gimpRbGroup.addRadioButton(greenRb);
			gimpRbGroup.addRadioButton(blueRb);
			//gimpRbGroup.selection = hueRb;
			hueRb.selected = true;
			
			hueInputText = new BTextInput(gimpTab.content, 190, 10, "100");
			hueInputText.width = 50;
			hueInputText.height = 24;
			hueInputText.restrict = "0-9";
			hueInputText.maxChars = 3;
			
			satInputText = new BTextInput(gimpTab.content, 190, 40, "100");
			satInputText.width = 50;
			satInputText.height = 24;
			satInputText.restrict = "0-9";
			satInputText.maxChars = 3;
			
			brightnessInputText = new BTextInput(gimpTab.content, 190, 70, "100");
			brightnessInputText.width = 50;
			brightnessInputText.height = 24;
			brightnessInputText.restrict = "0-9";
			brightnessInputText.maxChars = 3;
			
			redInputText = new BTextInput(gimpTab.content, 190, 110, "255");
			redInputText.width = 50;
			redInputText.height = 24;
			redInputText.restrict = "0-9";
			redInputText.maxChars = 3;
			
			greenInputText = new BTextInput(gimpTab.content, 190, 140, "255");
			greenInputText.width = 50;
			greenInputText.height = 24;
			greenInputText.restrict = "0-9";
			greenInputText.maxChars = 3;
			
			blueInputText = new BTextInput(gimpTab.content, 190, 170, "255");
			blueInputText.width = 50;
			blueInputText.height = 24;
			blueInputText.restrict = "0-9";
			blueInputText.maxChars = 3;
			
			var alphaSlider:BSlider = new BSlider(BSliderOrientation.VERTICAL, tabContainer.content, 390, 40);
			alphaSlider.height = controlWidth;
			alphaSlider.snapInterval = 1;
			
			var alphaNs:BNumericStepper = new BNumericStepper(tabContainer.content, 350, 240);
			alphaNs.editable = true;
			alphaNs.minimum = 0;
			alphaNs.maximum = 100;
			//alphaNs.setSize(60, 24);
			alphaNs.buttonPlacement = BNumericStepperButtonPlacement.HORIZONTAL;
			
			
			
			
			// set m, ratios and alphas
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(barWidth, controlWidth, -Math.PI/2, 0, 0);
			
			var colors:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
			var part:Number = 0xFF / (colors.length - 1);
			var ratios:Array = [];
			var alphas:Array = [];
			
            for (var i:int = 0; i < colors.length; i++) 
			{
                ratios.push(part * i);
                alphas.push(1);
            }
			
			// init gimp bar
			canvas.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix); 
			canvas.graphics.drawRect(0, 0, barWidth, controlWidth + 1);
			
			gimpBar = new BColorBar(gimpTab.content, 100, 10, barWidth, controlWidth);
			gimpBar.bitmapData.draw(canvas);
			gimpBar.valueXY(0.5, 1);
			
			ctrl = new BColorController(gimpTab.content, -100, 10, controlWidth, controlWidth);
			//ctrl.bitmapData.fillRect(ctrl.bitmapData.rect, 0xff0000ff);
			
			
			update();
			
			//ctrl.addEventListener(Event.CHANGE, function(event:Event):void
			/*gimpBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				//trace(ctrl.bitmapData.getPixel(BColorController(event.currentTarget).valueX * (controlWidth - 1), BColorController(event.currentTarget).valueY * -controlWidth + controlWidth).toString(16));
				//trace(gimpBar.bitmapData.getPixel(BColorController(event.currentTarget).valueX * barWidth, BColorController(event.currentTarget).valueY * -controlWidth + controlWidth).toString(16));
				trace(gimpBar.hexValue);
			});*/
			
			
			// add assets to respective containers
			
			
			
			// event handling
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, showWindow);
			hueRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			saturationRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			brightnessRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			redRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			greenRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			blueRb.addEventListener(MouseEvent.CLICK, onRadioButtonClick);
			gimpBar.addEventListener(Event.CHANGE, onHueChange);
			ctrl.addEventListener(Event.CHANGE, onCtrlChange);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
		} // emd function draw
		
		
		/**
		 * Updates the hue, saturation, brightness, red ccolor channel, green color channel, blue color channel, 
		 * alpha channel, and full ARGB color value.
		 */
		protected function update():void
		{
			// draw the ctrl BColorController
			var colorGrad:Shape = new Shape();
			var lightGrad:Shape = new Shape();
			var lightMatrix:Matrix = new Matrix();
			
			colorGrad.graphics.beginFill(gimpBar.value, 1);
            colorGrad.graphics.drawRect(0, 0, 200, 200);
			lightMatrix.createGradientBox(controlWidth, controlWidth, Math.PI / 2, 0, 0);
			
			var m2:Matrix = new Matrix();
			m2.createGradientBox((controlWidth - 1), controlWidth);
			lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 255], m2);
            lightGrad.graphics.drawRect(0, 0, controlWidth, controlWidth);
			
			lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 1], [0, 255], lightMatrix);
            lightGrad.graphics.drawRect(0, 0, controlWidth, controlWidth);
			
			//ctrl.bitmapData.fillRect(ctrl.bitmapData.rect, gimpBar.value);
			ctrl.bitmapData.draw(colorGrad);
			ctrl.bitmapData.draw(lightGrad);
			
			
			
			
			// calculate the hue (0-360), saturation (0-100) and brightness (0-100)
			hue = gimpBar.valueY * 360;
			saturation = ctrl.valueX * 100;
			brightness = ctrl.valueY * 100;
			
			// separate the color channels
			//var alpha:uint = (colorValue >> 24) & 0xFF;  	// Isolate the Alpha channel 
			red   = (ctrl.value >> 16) & 0xFF;  			// Isolate the Red channel 
			green = (ctrl.value >> 8) & 0xFF;			// Isolate the Green channel 
			blue  = ctrl.value & 0xFF;					// Isolate the Blue channel

			// update the text inputs
			hueInputText.text = hue.toString();
			satInputText.text = saturation.toString();
			brightnessInputText.text = brightness.toString();
			redInputText.text = red.toString();
			greenInputText.text = green.toString();
			blueInputText.text = blue.toString();
			
			inputText.text = ctrl.value.toString(16);
			
			// draw the swatch
			swatch.graphics.clear();
			swatch.graphics.beginFill(0xFFFFFF);
			swatch.graphics.drawRect(0, 0, 20, 20);
			swatch.graphics.beginFill(ctrl.value);
			swatch.graphics.drawRect(1, 1, 18, 18);
			swatch.graphics.endFill();
			
		} // end function update
		
		
		/**
		 * 
		 */
		protected function updateHue():void
		{
			
		} // end 
		
		
		/**
		 * 
		 */
		protected function updateSaturation():void
		{
			// set m, ratios and alphas
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(controlWidth, controlWidth, 0, 0, 0);
			
			var colors:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
			var part:Number = 0xFF / (colors.length - 1);
			var ratios:Array = [];
			var alphas:Array = [];
			
            for (var i:int = 0; i < colors.length; i++) 
			{
                ratios.push(part * i);
                alphas.push(1);
            }
			
			
			
			// draw the ctrl BColorController
			var colorGrad:Shape = new Shape();
			var lightGrad:Shape = new Shape();
			var lightMatrix:Matrix = new Matrix();
			
			colorGrad.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix); 
            colorGrad.graphics.drawRect(0, 0, controlWidth, controlWidth);
			lightMatrix.createGradientBox(controlWidth, controlWidth, Math.PI / 2, 0, 0);
			
			var m2:Matrix = new Matrix();
			m2.createGradientBox((controlWidth - 1), controlWidth);
			lightGrad.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [-gimpBar.valueY + 1, 1], [0, 255], lightMatrix);
            lightGrad.graphics.drawRect(0, 0, controlWidth, controlWidth);
			
			ctrl.bitmapData.draw(colorGrad);
			ctrl.bitmapData.draw(lightGrad);
			//ctrl.bitmapData.draw(lightGrad, null, null, BlendMode.MULTIPLY);
			
		} // end function 
		
		
		/**
		 * 
		 */
		protected function updateBrightness():void
		{
			
		} // end function 
		
		
		/**
		 * 
		 */
		protected function updateRed():void
		{
			
		} // end function 
		
		
		/**
		 * 
		 */
		protected function updateGreen():void
		{
			
		} // end function 
		
		
		/**
		 * 
		 */
		protected function updateBlue():void
		{
			
		} // end function 
		
		
		//**************************************** SET AND GET ******************************************
		
		
	}
	
	
}


import flash.display.*;
import flash.events.*;
import flash.geom.*;

import Borris.controls.*;
import Borris.controls.ColorChooserClasses.BColorController;


/**
 * Convert HSV (hue, saturation, brightness) to RGB (red, green, blue)
 * 
 * @param h
 * @param s
 * @param b
 * @return
 */
function hsbTorgb(h:Number, s:Number, b:Number):uint 
{
	var ht:Number = (h - int(h) + int(h < 0)) * 6;
	var hi:int = int(ht), vt:Number = b * 255;
	
	switch(hi) 
	{
		case 0: return 0xff000000 | (vt << 16) | (int(vt * (1 - (1 - ht + hi) * s)) << 8) | int(vt * (1 - s));
		case 1: return 0xff000000 | (vt << 8) | (int(vt * (1 - (ht - hi) * s)) << 16) | int(vt * (1 - s));
		case 2: return 0xff000000 | (vt << 8) | int(vt * (1 - (1 - ht + hi) * s)) | (int(vt * (1 - s)) << 16);
		case 3: return 0xff000000 | vt | (int(vt * (1 - (ht - hi) * s)) << 8) | (int(vt * (1 - s)) << 16);
		case 4: return 0xff000000 | vt | (int(vt * (1 - (1 - ht + hi) * s)) << 16) | (int(vt * (1 - s)) << 8);
		case 5: return 0xff000000 | (vt << 16) | int(vt * (1 - (ht - hi) * s)) | (int(vt * (1 - s)) << 8);
		
	}
	
	return 0;
}


/**
 * Convert RGB (red, green, blue) values to HSV (hue, saturation, brightness)
 * 
 * @param r
 * @param g
 * @param b
 * @return
 */
function rgbTohsb(r:int, g:int, b:int):uint 
{ 
	// h:12bit,s:10bit,v:8bit
	var max:int = Math.max(r, g, b); 
	var min:int = Math.min(r, g, b); 
	var sv:int;
	
	
	
	if (max == min) 
		return max;
	
	sv = (int((max - min) * 1023 / max) << 8) | max;
	
	if (b == max) 
		return (int((r - g) * 682.6666666666666 / (max - min) + 2730.6666666666665) << 18) | sv;
	
	if (g == max) 
		return (int((b - r) * 682.6666666666666 / (max - min) + 1365.3333333333332) << 18) | sv;
	
	if (g >= b) 
		return (int((g - b) * 682.6666666666666 / (max - min)) << 18) | sv;
	
	return (int(4096 + (g - b) * 682.6666666666666 / (max - min)) << 18) | sv;
	
} //end function rgbTohsv



