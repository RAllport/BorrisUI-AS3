/* Author: Rohaan Allport
 * Date Created: 30/04/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BBasePanelTab class is the base class for all panel tabs and panel tab functionality, defining properties and methods that are 
 * 				common to all panel tabs including states, events, styling and tab content.
 * 
*/


package Borris.panels
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.*;
	import Borris.containers.BScrollPane;
	
	
	public class BBasePanelTab extends BUIComponent
	{
		// assets
		protected var button:BLabelButton;
		
		
		// style
		protected var _overHighlightColor:uint = 0x0099CC;
		protected var _overHighlightTransparency:Number = 0.5;
		protected var _shineTransparency:Number = 0.4;
		protected var _borderColor:uint = 0x000000;
		protected var _borderOuterTransparency:Number = 0.6;
		protected var _borderInnerTransparency:Number = 0.4;
		
		protected var _textPadding:int = 5;
		
		
		// other
		protected var tweenSlideToX:int = 0;					// the value for the content to slide to during the tween when switching tabs
		
		
		// set and get
		protected var _label:String; 							// 
		protected var _selected:Boolean; 						// 
		protected var _disabled:Boolean;						// 
		protected var tabStates:Array;							// 
		
		
		protected var _minWidth:int;							// the minimum width of the tab. (make the panel resize to this if it was smaller b4 switching)
		protected var _maxWidth:int;							// I dont think ill need this :/
		
		protected var _content:BScrollPane;						// [read-only] the content belonging to this tab
		
		internal var _tabManager:Object;						// 
		
		
		
		public function BBasePanelTab(label:String = "Label") 
		{
			// constructor code
			
			_label = label;
			
			
			
			_width = 100;
			
			
			_selected = false;
			_disabled = false;
			
			_content = new BScrollPane();
			//_content = new Sprite();
			//_content.source = PanelPreview;
			//_content.enabled = false;
			
			
			// event handling
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function onAddedToStage
		// Positions and adds the content of this tab when the tab is added to stage.
		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);
			// we should do a check here to see if the Tab was added to a BPanelWindow or BPannelAttached2
			
			_content.x = 0;
			_content.y = 0;
			this.parent.addChild(_content);
			
			
			_content.backgroundColor = 0x006699;
			_content.backgroundTransparency = 0;
			_content.contentPadding = 10;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			draw();
		} // end function onAddedToStage
		
		
		// function mouseHandler
		// controls states based on the current mouse event
		protected function mouseHandler(event:MouseEvent):void
		{
			
		} // end function mouseHandler
		
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize asset variables
			// initialize the button;
			button = new BLabelButton(this, 0, 0, _label);
			//button.autoSize = false;
			//button.textField.x = buttonHeight;
			//button.setSkins(button.getSkin("upSkin"), button.getSkin("overSkin"), button.getSkin("downSkin"), button.getSkin("disabledSkin"));
			
			
			
			this.width = 100;
			
			// event handling
			//button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
		} // end function initialize
		
		
		// function setContentSize
		// Set the size of the content
		internal function setContentSize(width:Number, height:Number):void
		{
			_content.width = width;
			_content.height = height;
		} // end function setContentSize
		
		
		// function draw
		// draw this tab
		// will nomally be called in the BtabManager class
		override protected function draw():void
		{
			
		} // end function draw
		
		
		//***************************************** SET AND GET *****************************************
		
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
			button.label = _label;
			draw();
		}
		
		
		// selected
		public function set selected(value:Boolean):void
		{
			_selected = value;
			var tweenFade:Tween;
			var tweenSlide:Tween;
			
			if(value)
			{
				changeState(selectedUpSkin);
				tweenFade = new Tween(_content, "alpha", Regular.easeOut, 0, 1, 0.3, true);
				tweenSlide = new Tween(_content, "x", Regular.easeOut, tweenSlideToX + 200, tweenSlideToX, 0.3, true);
				//_content.visible = true;
				_content.enabled = true;
			}
			else
			{
				changeState(upSkin);
				tweenFade = new Tween(_content, "alpha", Regular.easeInOut, _content.alpha, 0, 0.3, true);
				tweenSlide = new Tween(_content, "x", Regular.easeOut, tweenSlideToX, tweenSlideToX -200, 0.3, true);
				//_content.visible = false;
				_content.enabled = false;
			}
			
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		// disabled
		
		
		// content
		public function get content():DisplayObjectContainer
		{
			return _content.content;
		}
	
		
		
	}

}