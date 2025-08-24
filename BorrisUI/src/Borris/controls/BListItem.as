package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BListItem extends BLabelButton 
	{
		// set and get 
		protected var _data:Object;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BList component instance.
         *
         * @param label The text label for the component.
		 * @param data that is associated with the component.
         */
		public function BListItem(label:String="", data:Object = null) 
		{
			_data = data;
			super(null, 0, 0, label);
			
		}
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			_autoSize = false;
			toggle = true;
		} // end function initialize
		
		
		//***************************************** SET AND GET *****************************************
		
		/**
		 * Gets or sets an Object that represents the data that is associated with a component.
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
	}
		

}