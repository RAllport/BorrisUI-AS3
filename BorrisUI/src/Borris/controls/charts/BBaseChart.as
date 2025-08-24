/* Author: Rohaan Allport
 * Date Created: 24/09/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls.charts 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	import Borris.controls.*;
	import Borris.containers.*;
	
	
	public class BBaseChart extends BCanvas
	{
		// assets
		protected var container:Sprite;
		protected var background:Shape;
		protected var canvas:Shape;
		protected var xLabelContainer:Sprite;
		protected var yLabelContainer:Sprite;
		protected var xLabel:BLabel;
		protected var yLabel:BLabel;
		
		
		// style
		protected var backgroundColor:uint = 0x000000;
		protected var chartBackgroundColor:uint = 0x333333;
		protected var chartBorderColor:uint = 0xCCCCCC;
		protected var labelColor:uint = 0xFFFFFF;
		
		
		// other
		
		
		
		// set and get
		protected var _data:Vector.<Number>;
		protected var _maximum:Number = 100;
		protected var _minimum:Number = 0;
		protected var _autoSize:Boolean = true;
		protected var _showLabels:Boolean = true;
		protected var _labelPrecision:int = 0;
		
		
		
		public function BBaseChart(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, data:Vector.<Number> = null ) 
		{
			_data = data;
			super(parent, x, y);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		
		
		//**************************************** SET AND GET ******************************************
		
		/**
		 * 
		 */
		public function set labelColor(value:uint):void
		{
			_labelColor = value;
			drawLabels();
		}
		
		public function get labelColor():uint
		{
			return _labelColor;
		}
		
		
		/**
		 * 
		 */
		public function set labelTransparency(value:Number):void
		{
			_labelTransparency = value;
			drawLabels();
		}
		
		public function get labelTransparency():Number
		{
			return _labelTransparency;
		}
		
		
		/**
		 * 
		 */
		public function set numberLabelsPosition(value:String):void
		{
			_numberLabelsPosition = value;
			
			pan(_panX, _panY);
			
			//drawLabels();
		}
		
		public function get numberLabelsPosition():String
		{
			return _numberLabelsPosition;
		}
		
		
		
		
	}

}