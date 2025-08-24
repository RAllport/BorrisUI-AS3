package Borris.transitions.easing
{

	/**
	 * The Linear class defines easing functions.
	 */  
	public class Linear
	{

		/**
		 * The <code>easeNone()</code> method defines a constant motion 
		 * with no acceleration. 
		 *
		 * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 *
		 * @return The value of the interpolated property at the specified time.
		 */  
		public static function easeNone(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		
		/**
		 * The <code>easeIn()</code> method defines a constant motion 
		 * with no acceleration. 
		 *
		 * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 *
		 * @return The value of the interpolated property at the specified time.
		 */  
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		
		/**
		 * The <code>easeOut()</code> method defines a constant motion 
		 * with no acceleration. 
		 *
		 * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @return The value of the interpolated property at the specified time.
		 */  
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
		
		/**
		 * The <code>easeInOut()</code> method defines a constant motion 
		 * with no acceleration. 
		 *
		 * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 *
		 * @return The value of the interpolated property at the specified time.
		 */  
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
		
	}

}
