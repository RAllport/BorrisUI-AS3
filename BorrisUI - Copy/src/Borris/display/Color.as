/* Author: Rohaan Allport
 * Date Created: 05/01/2015 (dd/mm/yyyy)
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
	public class Color
	{
		
		/**
		 * 
		 */
		public static function RGBA(red:uint, green:uint, blue:uint, alpha:Number):void
		{
			red = red > 255 ? 255 : red;
			green = green > 255 ? 255 : green;
			blue = blue > 255 ? 255 : blue;
			alpha = Math.max(0, alpha);
			alpha = Math.min(1, alpha);
			
		} // end 
		
		
		/**
		 * 
		 */
		public static function Gradient():Gradient
		{
			
		} // end 
		
	}

}