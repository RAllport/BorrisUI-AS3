/* Author: Rohaan Allport
 * Date Created: 08/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	
	public class BButton extends BLabelButton
	{
		//assets 
		
		
		// set and get
		
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BButton component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
		 * @param label The text label for the component.
         */
		public function BButton(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = ""):void 
		{
			// constructor code
			super(parent, x, y, label);
			//initialize();		// causes duble drawing for some reason	
			//setSize(100, 24);
			//draw();
			
		}

	}
	
}
