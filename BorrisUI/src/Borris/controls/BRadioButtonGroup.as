/* Author: Rohaan Allport
 * Date Created: 20/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BRadioButton component lets you force a user to make a single selection from a set of choices. 
 * 			This component must be used in a group of at least two BRadioButton instances. 
 * 			Only one member of the group can be selected at any given time. 
 * 			Selecting one radio button in a group deselects the currently selected radio button in the group. 
 * 			You set the groupName parameter to indicate which group a radio button belongs to. 
 * 			When the user clicks or tabs into a BRadioButton component group, only the selected radio button receives focus.
 * 
 * 			A radio button can be enabled or disabled. A disabled radio button does not receive mouse or keyboard input.
 * 
 *	todo/imporovemtns: 
*/


package Borris.controls 
{
	import flash.events.*;
	
	
	public class BRadioButtonGroup extends EventDispatcher
	{
		
		protected var _name:String;
		internal var radioButtons:Array;
		protected var _selection:BRadioButton;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BRadioButtonGroup component instance.
         *
         * @param name The name of the BRadioButtonGroup
         */
		public function BRadioButtonGroup(name:String) 
		{
			_name = name;
			radioButtons = [];
		}
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 * @param radioButton
		 */
		internal function clear(radioButton:BRadioButton):void
		{
			for (var i:int = 0; i < numRadioButtons; i++ )
			{
				if (radioButtons[i] != radioButton)
				{
					radioButtons[i].selected = false;
				}
				//radioButtons[i].selected = false;
			}
		} // end function clear
		
		
		
		/**
		 * Adds a radio button to the internal radio button array for use with 
		 * radio button group indexing, which allows for the selection of a single radio button
		 * in a group of radio buttons.  This method is used automatically by radio buttons, 
		 * but can also be manually used to explicitly add a radio button to a group.
		 * 
		 * @param radioButton The BRadioButton instance to be added to the current radio button group.
		 */
		public function addRadioButton(radioButton:BRadioButton):void 
		{
			// if the group name of the button is not the name of this array, then change its group name
			if (radioButton.group != this) 
			{
				
				if (radioButton.group)
				{
					radioButton.group.removeRadioButton(radioButton);
				}
				radioButton.group = this;
				radioButtons.push(radioButton);
			}
			
			if (radioButton.selected) 
			{ 
				selection = radioButton; 
			}
			
		} // function addRadioButton
		
		
		/** 
		 * Clears the RadioButton instance from the internal list of radio buttons.
		 * 
		 * @param radioButton The BRadioButton instance to remove.
		 */
		public function removeRadioButton(radioButton:BRadioButton):void 
		{
			var i:int = getRadioButtonIndex(radioButton);
			if (i != -1) 
			{
				radioButtons.splice(i, 1);
			}
			if (_selection == radioButton) 
			{ 
				_selection = null; 
			}
		} // end 
		
		
		/**
		 * Retrieves the BRadioButton component at the specified index location.
		 * 
		 * @param index The index of the BRadioButton component in the BRadioButtonGroup component, where the index of the first component is 0.
		 * 
		 * @return The specified BRadioButton component.
		 */
		public function getRadioButtonAt(index:int):BRadioButton 
		{
			return BRadioButton(radioButtons[index]);
		} // end 
		
		
		/**
		 * Returns the index of the specified BRadioButton instance.
		 * 
		 * @param radioButton The BRadioButton instance to locate in the current BRadioButtonGroup.
		 * 
		 * @return The index of the specified BRadioButton component, or -1 if the specified BRadioButton was not found.
		 */
		public function getRadioButtonIndex(radioButton:BRadioButton):int 
		{
			return radioButtons.indexOf(radioButton);
		} // end 

		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets the instance name of the radio button.
		 */
		public function get name():String 
		{
			return _name;
		}

		
		/**
		 * Gets the number of radio buttons in this radio button group.
		 */
		public function get numRadioButtons():int 
		{
			return radioButtons.length;
		}
		
		
		/**
		 * Gets or sets a reference to the radio button that is currently selected from the radio button group.
		 */
		public function get selection():BRadioButton 
		{
			return _selection;
		}
		
		public function set selection(value:BRadioButton):void 
		{
			
			_selection = value;
			if (value.selected)
			{
				clear(value);
			}
			value.selected = true;
		}
		
		
		
	}

}