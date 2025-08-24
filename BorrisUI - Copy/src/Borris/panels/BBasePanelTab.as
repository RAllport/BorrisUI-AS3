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
	
	import Borris.controls.BButton;
	import Borris.containers.BScrollPane;
	
	
	public class BBasePanelTab extends Sprite
	{
		// assets
		protected var upSkin:Sprite;							// The up skin of this details Object.
		protected var overSkin:Sprite;							// The over skin of this details Object.
		protected var downSkin:Sprite;							// The down skin of this details Object.
		protected var disabledSkin:Sprite;						// The disabled skin of this details Object.
		
		protected var selectedUpSkin:Sprite;
		protected var selectedOverSkin:Sprite;
		protected var selectedDownSkin:Sprite;
		protected var selectedDisabledSkin:Sprite;
		
		protected var labelText:TextField;						// 
		
		
		// style
		protected var _upColor:uint = 0x353535;	
		protected var _overColor:uint = 0x353535;	
		protected var _downColor:uint = 0x252525;	
		protected var _disabledColor:uint = 0x353535;	
		
		protected var _selectedUpColor:uint = 0x454545;
		protected var _selectedOverColor:uint = 0x555555;
		protected var _selectedDownColor:uint = 0x353535;
		protected var _selectedDisabledColor:uint = 0x454545;
		
		protected var _upAlpha:Number = 1;	
		protected var _overAlpha:Number = 1;	
		protected var _downAlpha:Number = 1;	
		protected var _disabledAlpha:Number = 1;	
		
		protected var _selectedUpAlpha:Number = 1;
		protected var _selectedOverAlpha:Number = 1;
		protected var _selectedDownAlpha:Number = 1;
		protected var _selectedDisabledAlpha:Number = 1;
		
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
		
		protected var _width:int;								// 
		
		
		protected var _minWidth:int;							// the minimum width of the tab. (make the panel resize to this if it was smaller b4 switching)
		protected var _maxWidth:int;							// I dont think ill need this :/
		
		protected var _content:BScrollPane;						// [read-only] the content belonging to this tab
		
		internal var _tabManager:Object;						// 
		
		
		
		public function BBasePanelTab(label:String = "Label") 
		{
			// constructor code
			upSkin = new Sprite();
			overSkin = new Sprite();
			downSkin = new Sprite()
			disabledSkin = new Sprite();
			
			selectedUpSkin = new Sprite();
			selectedOverSkin = new Sprite();
			selectedDownSkin = new Sprite();
			selectedDisabledSkin = new Sprite();
			
			addChild(upSkin);
			addChild(overSkin);
			addChild(downSkin);
			addChild(disabledSkin);
			
			addChild(selectedUpSkin);
			addChild(selectedOverSkin);
			addChild(selectedDownSkin);
			addChild(selectedDisabledSkin);
			
			
			// label
			_label = label;
			
			labelText = new TextField();
			labelText.text = label;
			labelText.type = TextFieldType.DYNAMIC;
			labelText.selectable = false;
			labelText.x = 5;
			labelText.y = 5;
			//labelText.width = 58;
			labelText.height = 19;
			labelText.setTextFormat(new TextFormat("Calibri", 12, 0xCCCCCC, true));
			labelText.defaultTextFormat = new TextFormat("Calibri", 12, 0xCCCCCC, true);
			labelText.autoSize = TextFieldAutoSize.LEFT;
			addChild(labelText);
			
			_width = 100;
			tabStates = new Array(upSkin, overSkin, downSkin, disabledSkin ,selectedUpSkin, selectedOverSkin, selectedDownSkin, selectedDisabledSkin);
			changeState(upSkin);
			
			_selected = false;
			_disabled = false;
			
			_content = new BScrollPane();
			//_content = new Sprite();
			//_content.source = PanelPreview;
			//_content.enabled = false;
			
			
			// event handling
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		
		// function onAddedToStage
		// Positions and adds the content of this tab when the tab is added to stage.
		protected function onAddedToStage(event:Event):void
		{
			// we should do a check here to see if the Tab was added to a BPanelWindow or BPannelAttached2
			
			_content.x = 0;
			_content.y = 0;
			this.parent.addChild(_content);
			
			_content.contentPadding = 10;
			_content.style.backgroundColor = 0x006699;
			_content.style.backgroundOpacity = 0.5;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			draw(_width);
		} // end function onAddedToStage
		
		
		// function mouseHandler
		// controls states based on the current mouse event
		protected function mouseHandler(event:MouseEvent):void
		{
			
			if (_selected)
			{
				switch(event.type)
					{
						case MouseEvent.ROLL_OVER:
							changeState(selectedOverSkin);
							break;
							
						case MouseEvent.ROLL_OUT:
							changeState(selectedUpSkin);
							break;
							
						case MouseEvent.MOUSE_DOWN:
							changeState(selectedDownSkin);
							break;
							
						case MouseEvent.MOUSE_UP:
							changeState(selectedOverSkin);
							break;
							
						case MouseEvent.CLICK:
							changeState(selectedOverSkin);
							break;
						
					} // end switch
			}
			else 
			{
				switch(event.type)
				{
					case MouseEvent.ROLL_OVER:
						changeState(overSkin);
						break;
						
					case MouseEvent.ROLL_OUT:
						changeState(upSkin);
						break;
						
					case MouseEvent.MOUSE_DOWN:
						changeState(downSkin);
						break;
						
					case MouseEvent.MOUSE_UP:
						changeState(overSkin);
						break;
						
					case MouseEvent.CLICK:
						changeState(overSkin);
						break;
					
				} // end switch
			}
			
		} // end function mouseHandler
		
		
		// function changeState
		// Set the skin of the tab to a spefifed display object
		protected function changeState(state:DisplayObject):void
		{
			for(var i:int = 0; i < tabStates.length; i++)
			{
				var tempState:DisplayObject = tabStates[i]; 
				if(state == tempState)
				{
					tempState.visible = true;
				}
				else 
					tempState.visible = false;
			}
		} // end function changeState
		
		
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
		internal function draw(width:Number):void
		{
			
		} // end function draw
		
		
		//***************************************** SET AND GET *****************************************
		
		// label
		public function set label(value:String):void
		{
			_label = value;
			labelText.text = label;
		}
		
		public function get label():String
		{
			return _label;
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