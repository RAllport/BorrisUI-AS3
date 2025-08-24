/* Author: Rohaan Allport
 * Date Created: 27/01/2016 (dd/mm/yyyy)
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
	import flash.geom.Rectangle;;
	
	import Borris.controls.BColorBarOrientation;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BColorBar extends BColorController 
	{
		
		// set and get
		protected var _orientation:String;
		
		
		public function BColorBar(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, defaultHandler:Function = null) 
		{
			//_orientation = orientation;
			_orientation = BColorBarOrientation.VERTICAL;
			
			super(parent, x, y, width, height + 1, defaultHandler);
			
			pointerRange = new Rectangle(width / 2, 0, 0, height);
			thumb.x = pointerRange.x;
		}
		
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 * @return
		 */
		override protected function drawThumb():void
		{
			super.drawThumb();
			
			thumb.graphics.clear();
			thumb.graphics.beginFill(0x999999, 1);
			
			if(_orientation == BColorBarOrientation.HORIZONTAL)
			{
				thumb.graphics.moveTo(0, -_height/2);
				thumb.graphics.lineTo(-5, -_height/2 - 5);
				thumb.graphics.lineTo(-5, -_height/2 - 15);
				thumb.graphics.lineTo(5, -_height/2 - 15);
				thumb.graphics.lineTo(5, -_height/2 - 5);
				thumb.graphics.lineTo(0, -_height/2);
				
				thumb.graphics.moveTo(0, _height/2);
				thumb.graphics.lineTo(-5, _height/2 + 5);
				thumb.graphics.lineTo(-5, _height/2 + 15);
				thumb.graphics.lineTo(5, _height/2 + 15);
				thumb.graphics.lineTo(5, _height/2 + 5);
				thumb.graphics.lineTo(0, _height / 2);
				
				thumb.y = _height/2;
			}
			else if(BColorBarOrientation.VERTICAL)
			{
				thumb.graphics.moveTo(- _width/2, 0);
				thumb.graphics.lineTo(- _width/2 - 5, 5);
				thumb.graphics.lineTo(- _width/2 - 15, 5);
				thumb.graphics.lineTo(- _width/2 - 15, -5);
				thumb.graphics.lineTo(- _width/2 - 5, -5);
				thumb.graphics.lineTo(- _width/2, 0);
				
				thumb.graphics.moveTo(_width/2, 0);
				thumb.graphics.lineTo(_width/2 + 5, 5);
				thumb.graphics.lineTo(_width/2 + 15, 5);
				thumb.graphics.lineTo(_width/2 + 15, -5);
				thumb.graphics.lineTo(_width/2 + 5, -5);
				thumb.graphics.lineTo(_width / 2, 0);
				
				thumb.x = _width/2;
			}
			
			thumb.graphics.endFill();
			
		} // end function createPointer
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets or sets the orientaion of the color bar.
		 * This property changes the thumb rotation and the thumb range. 
		 * The width, and height is not affected by this property.
		 * Acceptable values are BColorBarOrientation.HORIZONTAL and BColorBarOrientation.VERTICAL.
		 */
		public function get orientation():String
		{
			return _orientation;
		}
		public function set orientation(value:String):void
		{
			_orientation = value;
			
			if(_orientation == BColorBarOrientation.HORIZONTAL)
			{
				pointerRange = new Rectangle(0, _height/2, _width, 0);
			}
			else if(BColorBarOrientation.VERTICAL)
			{
				pointerRange = new Rectangle(_width/2, 0, 0, _height);
			}
			else
			{
				throw new Error("The BColorBar.orientation property can only me 'horizontal' or 'vertical'. Use the BColorBarOrientation class to set this property.");
			}
			
			draw();
		}
		
		
		
	}

}