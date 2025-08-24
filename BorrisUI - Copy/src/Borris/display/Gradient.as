/* Author: Rohaan Allport
 * Date Created: 06/01/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.display 
{
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class Gradient 
	{
		protected var _type:String =  "linear";
		protected var _angle:Number = 0;
		protected var _colors:Array;
		protected var _alphas:Array;
		protected var _ratios:Array;
		
		
		public function Gradient(colors:Array, alphas:Array, ratios:Array = null, type:String = "linear", angle:Number = 0) 
		{
			_type = type;
			_angle = angle;
			_colors = colors;
			_alphas = alphas;
			//_ratios = ratios;
			_ratios = ratios ? ratios : [0, 255];
		}
		
		
		
		//**************************************** SET AND GET ******************************************
		
		/**
		 * 
		 */
		public function get type():String
		{
			return _type;
		}
		
		
		/**
		 * 
		 */
		public function get angle():Number
		{
			return _angle;
		}
		
		
		/**
		 * 
		 */
		public function get colors():Array
		{
			return _colors;
		}
		
		
		/**
		 * 
		 */
		public function get alphas():Array
		{
			return _alphas;
		}
		
		
		/**
		 * 
		 */
		public function get ratios():Array
		{
			return _ratios;
		}
		
	}

}