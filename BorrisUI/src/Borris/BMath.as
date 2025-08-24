/* Author: Rohaan Allport
 * Date Created: 02/11/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 *
 *
 */


package Borris 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	
	public class BMath 
	{
		// constants
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		// 
		// 
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180/Math.PI;
		} // end 
		
		
		// 
		// 
		/*public static function radiansToGradians(radians:Number):Number
		{
			return 0;
		} // end 
		*/
		
		// 
		// 
		public static function degreesToRadians(degrees:Number):Number
		{
			return degrees * Math.PI/180;
		} // end 
		
		
		// 
		// 
		/*public static function degreesToGradians(degrees:Number):Number
		{
			return 0;
		} // end 
		
		
		// 
		// 
		public static function gradiansToRadians(gradians:Number):Number
		{
			return 0;
		} // end 
		
		
		// 
		// 
		public static function gradiansToDegrees(gradians:Number):Number
		{
			return 0;
		} // end 
		*/
		
		// 
		// 
		public static function factorial(x:Number):Number
		{
			var factorial:int = 1;
			for(var i:int = 1; i <= x; i++)
			{
				factorial *= i;
			}
			return factorial;
		} // end 
		
		
		// 
		// 
		public static function log(x:Number, base:Number = 10):Number
		{
			return Math.log(x)/Math.log(base)
		} // end 
		
		
		// 
		// 
		public static function ln(x:Number):Number
		{
			return Math.log(x);
		} // end 
		
		
		// 
		// 
		public static function nCr(a:uint, b:uint):Number
		{
			//a!/(b!*(a-b)!)
			return factorial(a)/(factorial(b) * factorial(a - b));
		} // end 
		
		
		// 
		// 
		public static function nPr(a:uint, b:uint):Number
		{
			return factorial(a)/factorial(a - b);
		} // end 
		
		
		// 
		// 
		public static function mean(value1:Number, value2:Number, ...rest):Number
		{
			var total:Number = value1 + value2;
			rest.forEach(function(value:Number, index:int, array:Array):void
			{
				total += value;
			}
			);
			return total/(rest.length + 2);
			//return 0;
		} // end 
		
		
		// 
		// 
		/*public static function median(value1:Number, value2:Number, value3:Number, ...rest):Number
		{
			var tempArray:Array = [];
			
			for (var i:int = 0; i < rest.length + 3; i++)
			{
				
			}
			
			return 0;
		} // end 
		
		
		// 
		// 
		public static function mode(value1:Number, value2:Number, value3:Number, ...rest):Number
		{
			return 0;
		} // end 
	
		*/
	}

}