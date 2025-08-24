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
	public class BColorChooserAdvanced_old extends BColorChooser
	{
		// constants
		
		
		// assets
		protected var tabContainer:BPanel;
		protected var gimpTab:BTab = new BTab("Gimp");
		protected var barsTab:BTab = new BTab("Bars");
		protected var hueTab:BTab = new BTab("Hue");
		protected var swatchedTab:BTab = new BTab("Swatches");
		
		
		// style
		
		
		// other
		
		
		// set and get
		protected var _changeImmediately:Boolean = true;
		protected var _alphaEnabled:Boolean = false;
		protected var _alpha:Number = 1;
		protected var _alphaBar:VColorBar;
		protected var _alphaMap:BitmapData;
		//protected var _alphaTile:AlphaTile;
		//protected var _alphaValue:InputText;
		
		
		public function BColorChooserAdvanced_old(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, value:uint = 0xFF0000) 
		{
			// constructor
			super(parent, x, y, value);
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
			tabContainer.resize(360, 260, false);
			this.parent.addChild(tabContainer);
			
			
			var tabGroup:BTabGroup = new BTabGroup("adv color chooser tabs");
			tabGroup.addTab(gimpTab);
			tabGroup.addTab(barsTab);
			tabGroup.addTab(hueTab);
			tabGroup.addTab(swatchedTab);
			tabGroup.parent = tabContainer.content;
			
			var hueRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 10, "H:", true);
			var saturationRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 40, "S:");
			var brightnessRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 70, "B:");
			var redRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 110, "R:");
			var greenRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 140, "G:");
			var blueRb:BRadioButton = new BRadioButton(gimpTab.content, 120, 170, "B:");
			
			// make a radio button group
			var gimpRbGroup:BRadioButtonGroup = new BRadioButtonGroup("gimp rb group");
			gimpRbGroup.addRadioButton(hueRb);
			gimpRbGroup.addRadioButton(saturationRb);
			gimpRbGroup.addRadioButton(brightnessRb);
			gimpRbGroup.addRadioButton(redRb);
			gimpRbGroup.addRadioButton(greenRb);
			gimpRbGroup.addRadioButton(blueRb);
			
			var hueInputText:BTextInput = new BTextInput(gimpTab.content, 180, 10, "100");
			hueInputText.width = 50;
			hueInputText.height = 24;
			hueInputText.restrict = "0-9";
			hueInputText.maxChars = 3;
			
			var satInputText:BTextInput = new BTextInput(gimpTab.content, 180, 40, "100");
			satInputText.width = 50;
			satInputText.height = 24;
			satInputText.restrict = "0-9";
			satInputText.maxChars = 3;
			
			var brightnessInputText:BTextInput = new BTextInput(gimpTab.content, 180, 70, "100");
			brightnessInputText.width = 50;
			brightnessInputText.height = 24;
			brightnessInputText.restrict = "0-9";
			brightnessInputText.maxChars = 3;
			
			var redInputText:BTextInput = new BTextInput(gimpTab.content, 180, 110, "255");
			redInputText.width = 50;
			redInputText.height = 24;
			redInputText.restrict = "0-9";
			redInputText.maxChars = 3;
			
			var greenInputText:BTextInput = new BTextInput(gimpTab.content, 180, 140, "255");
			greenInputText.width = 50;
			greenInputText.height = 24;
			greenInputText.restrict = "0-9";
			greenInputText.maxChars = 3;
			
			var blueInputText:BTextInput = new BTextInput(gimpTab.content, 180, 170, "255");
			blueInputText.width = 50;
			blueInputText.height = 24;
			blueInputText.restrict = "0-9";
			blueInputText.maxChars = 3;
			
			var alphaSlider:BSlider = new BSlider(BSliderOrientation.VERTICAL, tabContainer.content, 280, 40);
			alphaSlider.height = 180;
			alphaSlider.snapInterval = 1;
			
			// add assets to respective containers
			
			
			
			// event handling
			swatch.addEventListener(MouseEvent.MOUSE_DOWN, showWindow);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
		} // emd function draw
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
	}
	
	
}


/*
function hsvTorgb(h:Number, s:Number, v:Number):uint 
{
	var ht:Number = (h - int(h) + int(h < 0)) * 6, hi:int = int(ht), vt:Number = v * 255;
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

function rgbTohsv(r:int, g:int, b:int):uint 
{ 
	// h:12bit,s:10bit,v:8bit
	var max:int, min:int, sv:int;
	
	if (r > g) 
	{ 
		if (g>b) {min=b;max=r;} else {min=g;max=(r>b)?r:b;} 
	} 
	else
	{ 
		if (g<b) {max=b;min=r;} else {max=g;min=(r<b)?r:b;} 
	}
	
	if (max == min) 
		return max;
	
	sv = (int((max - min) * 1023 / max) << 8) | max;
	
	if (b == max) 
		return (int((r-g)*682.6666666666666/(max-min)+2730.6666666666665)<<18)|sv;
	
	if (g == max) 
		return (int((b-r)*682.6666666666666/(max-min)+1365.3333333333332)<<18)|sv;
	
	if (g >= b) 
		return (int((g-b)*682.6666666666666/(max-min))<<18)|sv;
	
	return (int(4096+(g-b)*682.6666666666666/(max-min))<<18)|sv;
}


*/

import flash.display.*;
import flash.events.*;
import flash.geom.*;

import Borris.controls.*;
import Borris.controls.ColorChooserClasses.BColorController;


class VColorBar extends BColorController
{
	function VColorBar(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, defaultHandler:Function = null)
	{
		super(parent, x, y, width, height, defaultHandler);
		
		_pointerRange = new Rectangle(width * 0.5, 0, 0, height);
		_pointer.x = _pointerRange.x;
	}
}





class ColorChooserExModel extends Sprite 
{
    protected static const $$:Number = 0.00392156862745098;
	
    protected var _h:Number; 
	protected var _s:Number; 
	protected var _v:Number; 
	protected var _r:uint; 
	protected var _g:uint; 
	protected var _b:uint; 
	protected var _a:uint;
	
    //protected var _chooser:ColorChooserEx;
	
   
    //function ColorChooserExModel(parent:DisplayObjectContainer, chooser:ColorChooserEx) 
    function ColorChooserExModel(parent:DisplayObjectContainer) 
	{
        super();
        parent.addChild(this);
        visible = false;
       // _chooser = chooser;
    }
    
    protected function _setup():void 
	{
		
	}
    
    protected function _HSVupdated():void 
	{
        var v:uint = hsvTorgb(_h, _s, _v);
        _r = (v >> 16) & 0xff;
        _g = (v >> 8) & 0xff;
        _b = v & 0xff;
    }
    
    protected function _RGBupdated():void 
	{
        var hsv:uint = rgb2hsv(_r, _g, _b);
        _h = (hsv >> 18) * 0.000244140625;
        _s = ((hsv >> 8) & 0x3ff) * 0.0009775171065493646;
        _v = (hsv & 0xff) * 0.00392156862745098;
    }

    public function get value():uint 
	{ 
		return (_a << 24) | (_r << 16) | (_g << 8) | _b; 
		
	}
	
    public function set value(v:uint):void 
	{
        _a = (v >> 24) & 0xff;
        _r = (v >> 16) & 0xff;
        _g = (v >> 8) & 0xff;
        _b = v & 0xff;
        _RGBupdated();
        _setup();
    }
    
}


class GimpModel extends ColorChooserExModel 
{
    private var ctrl:ControlPad; 
	private var bar:VColorBar; 
	private var tabs:Array; 
	private var cursor:Shape; 
	private var _selectedTab:int;
    
    public function get selectedTab():int 
	{ 
		return 
		_selectedTab; 
	}
	
	
    public function set selectedTab(idx:int):void 
	{
        _selectedTab = idx;
        cursor.y = _selectedTab * 18 + 4;
        _setup();
    }
    
    //function GimpModel(parent:DisplayObjectContainer, chooser:ColorChooserEx) 
    function GimpModel(parent:DisplayObjectContainer) 
	{
        var y_:Number = 4; 
		var me:Sprite = this;
        
		//super(parent, chooser);
		super(parent, chooser);
        
		ctrl = new ControlPad(me, 8, 8, 100, 100, _onCtrlChange);
        bar = new VColorBar(me, 112, 8, 12, 100, _onBarChange);
        tabs = [newTab("H"), newTab("S"), newTab("V"), newTab("R"), newTab("G"), newTab("B")];
        addChild(cursor = new Shape());
        cursor.graphics.beginFill(0x8080ff, 0.25);
        cursor.graphics.drawRect(0,0,26,18);
        cursor.graphics.endFill();
        cursor.x = 130;
        selectedTab = 0;
		
        function newTab(label:String):BLabelButton
		{
            var newButton:BLabelButton = new BLabelButton(me, 130, y_, label, _onTabClick);
            newButton.setSize(26, 18);
            y_ += 18;
            return newButton;
        }
    }

    override protected function _setup():void 
	{
        _updateColors();
        _updatePointer();
    }
    
    protected function _onTabClick(e:Event):void 
	{
        selectedTab = int((e.target.y + 10) / 20);
    }
    
    protected function _onCtrlChange(e:Event):void 
	{
        switch (_selectedTab) 
		{
			case 0:  _s=ctrl.valueX; _v=ctrl.valueY; _HSVupdated(); break;
			case 1:  _v=ctrl.valueX; _h=ctrl.valueY; _HSVupdated(); break;
			case 2:  _h=ctrl.valueX; _s=ctrl.valueY; _HSVupdated(); break;
			case 3:  _b=ctrl.valueX*255; _g=ctrl.valueY*255; _RGBupdated(); break;
			case 4:  _r=ctrl.valueX*255; _b=ctrl.valueY*255; _RGBupdated(); break;
			default: _g=ctrl.valueX*255; _r=ctrl.valueY*255; _RGBupdated(); break;
        }
        _updateColors(true, false);
        //_chooser.browseColorChoiceEx(value);
    }
    
    protected function _onBarChange(e:Event):void 
	{
        switch (_selectedTab) 
		{
			case 0:  _h = bar.valueY; _HSVupdated(); break;
			case 1:  _s = bar.valueY; _HSVupdated(); break;
			case 2:  _v = bar.valueY; _HSVupdated(); break;
			case 3:  _r = bar.valueY * 255; _RGBupdated(); break;
			case 4:  _g = bar.valueY * 255; _RGBupdated(); break;
			default: _b = bar.valueY * 255; _RGBupdated(); break;
			
        }
        _updateColors(false, true);
        //_chooser.browseColorChoiceEx(value);
    }
    
    protected function _updateColors(b:Boolean = true, c:Boolean = true):void 
	{
        var rc:Rectangle = new Rectangle(0,0,12,1), i:int;
        if (_selectedTab < 3) 
		{
            switch (_selectedTab) 
			{
				case 0: _drawHSV(b, c); break;
				case 1: _drawSVH(b, c); break;
				case 2: _drawVHS(b, c); break;
            }
        } 
		else 
		_drawRGB(5-_selectedTab,b,c);
        
		for (rc.y=99, i=0; i<100; rc.y--, i++) bar.pixels.fillRect(rc, _bar[i]);
        ctrl.pixels.fillRect(ctrl.pixels.rect, 0);
        ctrl.pixels.setVector(ctrl.pixels.rect, _mtx);
    }
    
    protected function _updatePointer():void 
	{
        switch (_selectedTab) 
		{
			case 0:  bar.valueY=_h; ctrl.valueX=_s; ctrl.valueY=_v; break;
			case 1:  bar.valueY=_s; ctrl.valueX=_v; ctrl.valueY=_h; break;
			case 2:  bar.valueY=_v; ctrl.valueX=_h; ctrl.valueY=_s; break;
			case 3:  bar.valueY=_r*$$; ctrl.valueX=_b*$$; ctrl.valueY=_g*$$; break;
			case 4:  bar.valueY=_g*$$; ctrl.valueX=_r*$$; ctrl.valueY=_b*$$; break;
			default: bar.valueY=_b*$$; ctrl.valueX=_g*$$; ctrl.valueY=_r*$$; break;
        }
    }
    
    private var _bar:Vector.<uint> = new Vector.<uint>(100);
    
	private var _mtx:Vector.<uint> = new Vector.<uint>(10000);
    
	private function _drawHSV(b:Boolean, c:Boolean):void 
	{
        var h:Number = _h, s:Number = _s, v:Number = _v, i:int;
		
        if (b) 
			for (i = 0; i < 100; i++) 
				_bar[i] = hsv2rgb(i*0.01, 1, 1);
        
		if (c) 
			for (i = 0, v = 99; v >= 0; v--) 
				for (s = 0; s < 100; s++, i++) 
					_mtx[i] = hsv2rgb(h, s*0.01, v*0.01);
    }
    
	private function _drawSVH(b:Boolean, c:Boolean):void 
	{
        var h:Number=_h, s:Number=_s, v:Number=_v, i:int;
        if (b) for (i=0; i<100; i++) _bar[i] = hsv2rgb(h, i*0.01, i*0.005+0.5);
        if (c) for (i=0, h=99; h>=0; h--) for (v=0; v<100; v++, i++) _mtx[i] = hsv2rgb(h*0.01, s, v*0.01);
    }
    
	private function _drawVHS(b:Boolean, c:Boolean):void 
	{
        var h:Number=_h, s:Number=_s, v:Number=_v, i:int;
        if (b) for (i=0; i<100; i++) _bar[i] = hsv2rgb(h, 1, i*0.01);
        if (c) for (i=0, s=99; s>=0; s--) for (h=0; h<100; h++, i++) _mtx[i] = hsv2rgb(h*0.01, s*0.01, v);
    }
    
	private function _drawRGB(rgbIndex:int, b:Boolean, c:Boolean):void 
	{
        var shift:int = rgbIndex*8, shiftx:int = [8,16,0][rgbIndex], shifty:int = [16,0,8][rgbIndex],
            rgb:uint = value, col:int = 0xff000000|rgb&~(0xff<<shift), i:int, x:int, y:int;
        if (b) for (i=0; i<100; i++) _bar[i] = 0xff000000 | (int(i*2.55)<<shift);
        if (c) {
            col = 0xff000000|rgb&~((0xff<<shiftx)|(0xff<<shifty));
            for (i=0, y=99; y>=0; y--) for (x=0; x<100; x++, i++) _mtx[i] = col | (int(x*2.55)<<shiftx)|(int(y*2.55)<<shifty);
        }
    }
}
	