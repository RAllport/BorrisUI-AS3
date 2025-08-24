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


package Borris.controls.ColorChooserClasses 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;;
	
	import Borris.controls.BUIComponent;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BColorController extends BUIComponent
	{
		// assets
		protected var background:Sprite = new Sprite();
		protected var thumb:Shape; 
		public var backBitmap:Bitmap;
		
		
		// other
		public var bitmapData:BitmapData;
		protected var pointerRange:Rectangle;
		
		
		public function BColorController(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, defaultHandler:Function = null) 
		{
			// contructor
			super(parent, x, y);
			//setSize(width, height);
			
			
			backBitmap = new Bitmap(bitmapData = new BitmapData(width, height, false, 0x808080));
			thumb = new Shape();
			
			pointerRange = bitmapData.rect;
			
			
			// add assets to respective containers
			addChild(background);
			addChild(thumb);
			background.addChild(backBitmap);
			
			buttonMode = true;
			
			//draw();
			setSize(width, height);
			
			
			// event handling
			addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
			
			if (defaultHandler != null) 
				addEventListener(Event.CHANGE, defaultHandler);
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragStart(event:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragEnd);
			onDragging(event);
		} // end function onDragStart
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragging(event:MouseEvent):void 
		{
			thumb.x = mouseX;
			thumb.y = mouseY;
			
			// make sure the thumb is within the thumb range bounds
			if (thumb.x < pointerRange.left)   
				thumb.x = pointerRange.left;
			else if (thumb.x > pointerRange.right)  
				thumb.x = pointerRange.right;
			
			if (thumb.y < pointerRange.top)
				thumb.y = pointerRange.top;
			else if (thumb.y > pointerRange.bottom) 
				thumb.y = pointerRange.bottom;
			
			// dispatch a new cgange event
			dispatchEvent(new Event(Event.CHANGE));
		} // end function onDragging
		
		
		/**
		 * 
		 * @param event
		 */
		protected function onDragEnd(event:MouseEvent):void 
		{
			onDragging(event);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragEnd);
		} // end function onDragEnd
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * @inheritDoc
		 */
		override protected function draw():void 
		{
			//pointerRange = bitmapData.rect;
			
			// draw a thin grey border
			background.graphics.clear();
			background.graphics.beginFill(0x666666, 1);
			background.graphics.drawRect( -2, -2, _width + 4, _height + 4);
			background.graphics.endFill();
			
			drawThumb();
		} // end function draw
		
		
		/**
		 * 
		 * @return
		 */
		protected function drawThumb():void
		{
			thumb.graphics.clear();
			thumb.graphics.beginFill(0xFFFFFF, 1);
			thumb.graphics.drawCircle(0, 0, 6);
			thumb.graphics.drawCircle(0, 0, 5);
			thumb.graphics.beginFill(0x000000, 1);
			thumb.graphics.drawCircle(0, 0, 5);
			thumb.graphics.drawCircle(0, 0, 4);
			thumb.graphics.endFill();
		} // end function createPointer
		
		
		/**
		 * Sets the value of the thumb in terms of percentage.
		 * percentX and percentY cannot be greater than 1 or less than 0.
		 * The values are automatically changed if a value greater than 1 or less than 0
		 * are passed. 
		 * 
		 * @param percentX
		 * @param percentY
		 */
		public function valueXY(percentX:Number, percentY:Number):void 
		{ 
			percentX = Math.min(percentX, 1);
			percentY = Math.min(percentY, 1);
			
			percentX = Math.max(percentX, 0);
			percentY = Math.max(percentY, 0);
			
			thumb.x = pointerRange.width * percentX;
			thumb.y = pointerRange.height * (1 - percentY);
		} // end function valueXY
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets the string value of the current color selection.
		 */
		public function get hexValue():String
		{
			return bitmapData.getPixel32(thumb.x, thumb.y).toString(16);
		}
		
		
		/**
		 * Gets or sets value of the swatch color.
		 */
		public function get value():uint
		{
			return bitmapData.getPixel(thumb.x, thumb.y);
		}
		public function set value(val:uint):void
		{
			// set string to the string value of val in base 16
			/*var colorString:String = val.toString(16).toUpperCase();
			
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
			draw();*/
		}
		
		
		
		/**
		 * 
		 */
		public function get valueX():Number 
		{ 
			return thumb.x / pointerRange.width; 
		}
		
		public function set valueX(value:Number):void 
		{ 
			value = Math.min(value, 1);
			value = Math.max(value, 0);
			thumb.x = pointerRange.width * value; 
		}
		
		
		/**
		 * 
		 */
		public function get valueY():Number 
		{ 
			return 1 - thumb.y / pointerRange.height; 
		}
		
		public function set valueY(value:Number):void 
		{ 
			value = Math.min(value, 1);
			value = Math.max(value, 0);
			thumb.y =  pointerRange.height * (1 - value); 
		}
		
		
	}
	
	
	

}