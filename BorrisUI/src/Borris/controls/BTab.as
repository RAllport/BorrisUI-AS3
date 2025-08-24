/* Author: Rohaan Allport
 * Date Created: 18/01/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.display.BElement;;
	import Borris.containers.BScrollPane;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BTab extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var container:Sprite;							// A container to hold the items of the details Object
		protected var _button:BLabelButton;
		
		protected var mk:Shape;									// A make to mask out overflow of the container from the bottom and right.
		
		
		// style
		
		
		// other
		
		
		// set and get
		protected var _group:BTabGroup;							// The BTabGroup object to which this RadioButton belongs.
		protected var _label:String;							// 
		protected var _content:BScrollPane;						// [read-only] the content belonging to this tab
		
		
		/**
         * Creates a new BTab component instance.
         *
		 * @param label The text label for the component.
         */
		public function BTab(label:String = "Label") 
		{
			_label = label;
			super(null, 0, 0);
			initialize();
			setSize(100, 32);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * Positions and adds the content of this tab when the tab is added to stage.
		 * 
		 * @param event
		 */
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			// we should do a check here to see if the Tab was added to a BPanelWindow or BPannelAttached2
			
			// 
			_content.x = 0;
			_content.y = this.y + this.height;
			this.parent.addChild(_content);
			
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			draw();
		} // end function onAddedToStage
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize asset variables
			_content = new BScrollPane();
			_content.x = 0;
			_content.y = this.y + this.height;
			_content.contentPadding = 10;
			_content.style.backgroundColor = 0x006699;
			_content.style.backgroundOpacity = 0.5;
			
			// initialize the button;
			_button = new BLabelButton(this, 0, 0, _label);
			_button.autoSize = true;
			_button.toggle = true;
			
			
			// event handling
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			
			// if autoSize then adjust the width of the button automatically
			if (_button.autoSize)
			{
				if (!_button.textField.text =="")
				{
					_width = _button.textField.width + _button.textPadding * 2;
				}
			}
			
			_button.width = _width;
			_button.height = _height;
			
			//
			BElement(button.getSkin("upSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("upSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("upSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderWidth = 1;
			
			BElement(button.getSkin("overSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("overSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("overSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderWidth = 1;
			BElement(button.getSkin("overSkin")).style.highlightColor = 0x0099CC;
			BElement(button.getSkin("overSkin")).style.highlightHeight = 4;
			BElement(button.getSkin("overSkin")).style.highlightOpacity = 1; 
			
			BElement(button.getSkin("downSkin")).style.backgroundColor = 0x333333;
			BElement(button.getSkin("downSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("downSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderWidth = 1;
			BElement(button.getSkin("downSkin")).style.highlightColor = 0x0099CC;
			BElement(button.getSkin("downSkin")).style.highlightHeight = 4;
			BElement(button.getSkin("downSkin")).style.highlightOpacity = 1; 
			
			BElement(button.getSkin("disabledSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("disabledSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("disabledSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("disabledSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("disabledSkin")).style.borderWidth = 1;
			
			// 
			BElement(button.getSkin("selectedUpSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("selectedUpSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("selectedUpSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("selectedUpSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("selectedUpSkin")).style.borderWidth = 1;
			BElement(button.getSkin("selectedUpSkin")).style.borderBottomWidth = 0;
			
			BElement(button.getSkin("selectedOverSkin")).style.backgroundColor = 0x222222;
			BElement(button.getSkin("selectedOverSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("selectedOverSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("selectedOverSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("selectedOverSkin")).style.borderWidth = 1;
			BElement(button.getSkin("selectedOverSkin")).style.borderBottomWidth = 0;
			
			BElement(button.getSkin("selectedDownSkin")).style.backgroundColor = 0x555555;
			BElement(button.getSkin("selectedDownSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("selectedDownSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("selectedDownSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("selectedDownSkin")).style.borderWidth = 1;
			BElement(button.getSkin("selectedDownSkin")).style.borderBottomWidth = 0;
			
			BElement(button.getSkin("selectedDisabledSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("selectedDisabledSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("selectedDisabledSkin")).style.borderColor = 0xCCCCCC;
			BElement(button.getSkin("selectedDisabledSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("selectedDisabledSkin")).style.borderWidth = 1;
			BElement(button.getSkin("selectedDisabledSkin")).style.borderBottomWidth = 0;
			
		} // end function draw
		
		
		/**
		 * Set the size of the content
		 * @param width
		 * @param height
		 */
		internal function setContentSize(width:Number, height:Number):void
		{
			_content.width = width;
			_content.height = height;
		} // end function setContentSize
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * A referance to the BTab's internal button
		 */
		public function get button():BLabelButton
		{
			return _button;
		}
		
		
		/**
		 * 
		 */
		public function get content():DisplayObjectContainer
		{
			return _content.content;
		}
	
		
		/**
		 * The BTabGroup object to which this tab belongs.
		 */
		public function get group():BTabGroup
		{
			return _group;
		}
		public function set group(value:BTabGroup):void
		{
			_group = value;
			//value.addTab(this) 
		}
		
		
		/**
		 * Gets or sets the text label for the component.
		 * 
		 * @default ""
		 */
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
			_button.label = _label;
			draw();
		}
		
		
		/**
		 * Indicates whether a tab is currently selected (true) or deselected (false). 
		 * You can only set this value to true; setting it to false has no effect. 
		 * To achieve the desired effect, select a different tab in the same tab group.
		 * 
		 * @default false
		 */
		public function get selected():Boolean
		{
			return _button.selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (button.selected == value)
				return;
			
			_button.selected = value;
			_content.enabled = value;
			
		}
		
		
		
	}

}