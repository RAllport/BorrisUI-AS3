/* Author: Rohaan Allport
 * Date Created: 01/10/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: basically an HTML element
 * 
 * Todos:
	 * 
 * 
*/


package Borris.display 
{
	import flash.display.*;
	import flash.events.*;
	import Borris.events.BStyleEvent;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BElement extends Sprite
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _style:BStyle;
		
		
		public function BElement() 
		{
			//
			_style = new BStyle(this);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 */
		protected function draw():void
		{
			_style.backgroundColor = _style.backgroundColor;
		} // end function draw
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets or sets the style for this component.
		 */
		public function get style():BStyle
		{
			return _style;
		}
		
		public function set style(value:BStyle):void
		{
			_style = value;
			_style.owner = this;
			_style.values = value.values;
			//dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE, this));
		}
		
		
		/**
		 * Gets or sets the width of the component, in pixels.
		 * 
		 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
		 */
		override public function get width():Number
		{
			return _width * scaleX;
			//return Math.max(_width, getBounds(this).width);
		}
		override public function set width(value:Number):void
		{
			_width = Math.ceil(value);
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		/**
		 * Gets or sets the height of the component, in pixels.
		 * 
		 * <p>Setting this property causes a resize event to be dispatched. See the resize event for detailed information about when it is dispatched.</p>
		 */
		override public function get height():Number
		{
			return _height * scaleY;
			//return Math.max(_height, getBounds(this).height);
		}
		override public function set height(value:Number):void
		{
			_height = Math.ceil(value);
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		
	}

}