/* Author: Rohaan Allport
 * Date Created: 19/11/2015 (dd/mm/yyyy)
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
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.utils.Timer;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	
	public class BTooltip extends BUIComponent
	{
		// constants
		
		
		// assets
		protected var container:Sprite;
		protected var labelText:BLabel;
		protected var tipText:TextField;
		protected var preview:DisplayObject;
		protected var arrow:Shape;
		protected var border:Shape;
		protected var background:Shape;
		
		
		// style
		protected var _borderColor:uint = 0xCCCCCC;
		protected var _borderThickness:int = 1;
		protected var _borderTransparency:Number = 1;
		protected var _backgroundColor:uint = 0x111111;
		protected var _backgroundTransparency:Number = 1;
		protected var _padding:int = 5;
		protected var _arrowHeight:int = 12;
		
		// text stuff
		protected var enabledTF:TextFormat;
		protected var disabledTF:TextFormat;
		protected var disabledTextAlpha:Number = 0.5;
		
		
		// other
		
		
		
		// set and get
		protected var _label:String;
		protected var _tipText:String;
		protected var _displayPosition:String = "bottomRight";
		//protected var _displayDirection:String = "bottom";
		protected var _tooltipMode:String = "labelOnly";
		protected var _autoSize:Boolean = false;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BTooltip component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
		 * @param label The text label for the component.
		 * @param tipText The helpfull text to be shown by the BTooltip component.
         */
		public function BTooltip(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, label:String = "", tipText:String = "") 
		{
			// constructor code
			_label = label;
			_tipText = tipText;
			
			super(parent, x, y);
			initialize();
			setSize(200, 200);
			//draw();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// 
			container = new Sprite();
			arrow = new Shape();
			border = new Shape();
			background = new Shape();
			
			// initialize label
			labelText = new BLabel(this, _padding, 0, _label);
			labelText.autoSize = TextFieldAutoSize.LEFT;
			
			// initialize the text feilds and formats
			enabledTF = new TextFormat("Calibri", 16, 0xFFFFFF, false);
			disabledTF = new TextFormat("Calibri", 16, 0xCCCCCC, false);
			
			// tipText
			tipText = new TextField();
			tipText.text = _tipText;
			tipText.type = TextFieldType.DYNAMIC;
			tipText.selectable = false;
			tipText.x = _padding;
			tipText.y = labelText.y + labelText.height;
			tipText.width = _width - _padding * 2;
			tipText.height = _height;
			tipText.setTextFormat(enabledTF);
			tipText.defaultTextFormat = enabledTF;
			tipText.mouseEnabled = false;
			//tipText.autoSize = TextFieldAutoSize.NONE;
			tipText.antiAliasType = AntiAliasType.ADVANCED;
			tipText.wordWrap = true;
			//trace("tip text: " + tipText.text);
			
			// add assets the respective containers
			addChild(container);
			addChild(arrow);
			container.addChild(border);
			container.addChild(background);
			container.addChild(labelText);
			container.addChild(tipText);
			
			// hide the tooltip by default
			hide();
			
			this.filters = [new DropShadowFilter(4, 45, 0x000000, 1, 8, 8, 1, 3, false)];
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			// draw the arrow
			arrow.graphics.clear();
			//arrow.graphics.beginFill(_backgroundColor, _backgroundTransparency);
			//arrow.graphics.lineTo(_arrowHeight, _arrowHeight);
			//arrow.graphics.lineTo( -_arrowHeight, _arrowHeight);
			
			arrow.graphics.beginFill(_borderColor, _borderTransparency); 			// border
			arrow.graphics.lineTo(_arrowHeight + _borderThickness, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo( -_arrowHeight - _borderThickness, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo(0, 0);
			arrow.graphics.endFill();
			
			arrow.graphics.moveTo(0, _borderThickness);								// cut out 
			arrow.graphics.lineTo(_arrowHeight, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo( -_arrowHeight, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo(0, _borderThickness);
			
			arrow.graphics.beginFill(_backgroundColor, _backgroundTransparency);	// main color
			arrow.graphics.moveTo(0, _borderThickness);
			arrow.graphics.lineTo(_arrowHeight, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo( -_arrowHeight, _arrowHeight + _borderThickness);
			arrow.graphics.lineTo(0, _borderThickness);
			
			arrow.graphics.endFill();
			
			// draw the border
			border.graphics.clear();
			border.graphics.beginFill(_borderColor, _borderTransparency);
			border.graphics.drawRect(0, 0, _width, _height);
			border.graphics.drawRect(_borderThickness, _borderThickness, _width - (_borderThickness * 2), _height - (_borderThickness * 2));
			border.graphics.endFill();
			
			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
			background.graphics.drawRect(_borderThickness, _borderThickness, _width - (_borderThickness * 2), _height - (_borderThickness * 2));
			background.graphics.endFill();
			
			// 
			labelText.x = _padding;
			labelText.y = _padding;
			labelText.width = _width - _padding * 2;
			
			
			// 
			positionAssets();
			
		} // end function draw
		
		
		/**
		 * Display the tooltip.
		 */
		public function display():void
		{
			
			//
			positionAssets();
			
			// animate
			var tweenScaleX:Tween = new Tween(this, "scaleX", Regular.easeOut, scaleX, 1, 0.25, true);
			var tweenScaleY:Tween = new Tween(this, "scaleY", Regular.easeOut, scaleY, 1, 0.25, true);
			var tweenAlpha:Tween = new Tween(this, "alpha", Regular.easeOut, alpha, 1, 0.25, true);
			visible = true;
			
			var timer:Timer = new Timer(250, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
			function(event:TimerEvent):void
			{
				scaleX = scaleY = 1;
				alpha = 1;
			}
			);
			
			timer.start();
			
		} // end function display
		
		
		/**
		 * Hide the tooltip.
		 */
		public function hide():void
		{
			// animate
			var tweenScaleX:Tween = new Tween(this, "scaleX", Regular.easeOut, scaleX, 0, 0.25, true);
			var tweenScaleY:Tween = new Tween(this, "scaleY", Regular.easeOut, scaleY, 0, 0.25, true);
			var tweenAlpha:Tween = new Tween(this, "alpha", Regular.easeOut, alpha, 0, 0.25, true);
			
			var timer:Timer = new Timer(250, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, 
			function(event:TimerEvent):void
			{
				scaleX = scaleY = 0;
				alpha = 0;
				visible = false;
			}
			);
			
			timer.start();
			
		}// end function hide
			
		
		/**
		 * 
		 */
		protected function positionAssets():void
		{
			// 
			switch(_tooltipMode)
			{
				case "labelOnly":
					labelText.visible = true;
					tipText.visible = false;
					if(preview) { preview.visible = false; }
					_width = labelText.width + _padding * 2;
					_height = labelText.height + _padding * 2;
					break;
					
				case "tipOnly":
					labelText.visible = false;
					tipText.visible = true;
					if(preview) { preview.visible = false; }
					_width = tipText.width + _padding * 2;
					_height = tipText.height + _padding * 2;
					break;
					
				case "previewOnly":
					labelText.visible = false;
					tipText.visible = false;
					if (preview) 
					{ 
						preview.visible = true;
						_width = labelText.width + _padding * 2;
						_height = labelText.height + _padding * 2;
					}
					break;
					
				case "labelAndtip":
					labelText.visible = true;
					tipText.visible = true;
					if(preview) { preview.visible = false; }
					_width = Math.max(labelText.width, tipText.width) + _padding * 2;
					_height = labelText.height + tipText.width + _padding * 2;
					break;
					
				case "labelAndPreview":
					labelText.visible = true;
					tipText.visible = false;
					if(preview) { preview.visible = true; }
					_width = Math.max(labelText.width, preview.width) + _padding * 2;
					_height = labelText.height + preview.height + _padding * 2;
					break;
					
				case "tipAndPreview":
					labelText.visible = true;
					tipText.visible = false;
					if(preview) { preview.visible = false; }
					_width = labelText.width + _padding * 2;
					_height = labelText.height + _padding * 2;
					break;
					
				case "all":
					labelText.visible = true;
					tipText.visible = true;
					if(preview) { preview.visible = true; }
					_width = Math.max(labelText.width, tipText.width, preview.width) + _padding * 2;
					_height = labelText.height + tipText.height + preview.height + _padding * 2;
					break;
					
				
				
			} // end switch
			
			// 
			tipText.x = _padding;
			//tipText.y = labelText.y + labelText.height;
			tipText.y = labelText.y + 24;
			tipText.width = _width - _padding * 2;
			//tipText.height = _height - labelText.height - _padding * 2;
			tipText.height = _height - 24 - _padding * 2;
			
			if (preview)
			{
				preview.x = _padding;
				preview.y = _padding;
				preview.width = _width - _padding * 2;
				preview.height = _height - 80;
				
				labelText.y = preview.y + preview.height;
				
				// readjust the tip text
				tipText.y = labelText.y + labelText.height;
				tipText.height -= preview.height;
			}
			
			// 
			switch(_displayPosition)
			{
				case "top":
					arrow.rotation = 180;
					
					container.x = -container.width/2;
					container.y = -_arrowHeight - container.height;
					break;
				
				case "bottom":
					arrow.rotation = 0;
					
					container.x = -container.width/2;
					container.y = _arrowHeight;
					break;
					
				case "left":
					arrow.rotation = 90;
					
					container.x = -_arrowHeight - container.width;
					container.y = -container.height/2;
					break;
					
				case "right":
					arrow.rotation = -90;
					
					container.x = _arrowHeight;
					container.y = -container.height/2;
					break;
					
				case "topLeft":
					arrow.rotation = 180;
					
					container.x = _arrowHeight + _padding - container.width;
					container.y = -_arrowHeight - container.height;
					break;
					
				case "topRight":
					arrow.rotation = 180;
					
					container.x = -_arrowHeight - _padding;
					container.y = -_arrowHeight - container.height;
					break;
					
				case "bottomLeft":
					arrow.rotation = 0;
					
					container.x = _arrowHeight + _padding - container.width;
					container.y = _arrowHeight;
					break;
					
				case "bottomRight":
					arrow.rotation = 0;
					
					container.x = -_arrowHeight - _padding;
					container.y = _arrowHeight;
					break;
				
				case "leftTop":
					arrow.rotation = 90;
					
					container.x = -_arrowHeight - container.width;
					container.y = _arrowHeight + _padding - container.height;
					break;
				
				case "leftBottom":
					arrow.rotation = 90;
					
					container.x = -_arrowHeight - container.width;
					container.y = -_arrowHeight - _padding;
					break;
				
				case "rightTop":
					arrow.rotation = -90;
					
					container.x = _arrowHeight;
					container.y = _arrowHeight + _padding - container.height;
					break;
				
				case "rightBottom":
					arrow.rotation = -90;
					
					container.x = _arrowHeight;
					container.y = -_arrowHeight - _padding;
					break;
				
				case "auto":
					
					break;
				
				
			} // end switch
			
		} // end function positionAssets
		
		
		/**
		 * @inheritDoc
		 */
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			positionAssets();
			
		} // end function setSize
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets or sets the text label for the component. By default, the label text appears on the bottom left of the tooltip.
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
			labelText.text = value;
		}
		
		
		/**
		 * Gets or sets the tip text for the component. By default, the tip text appears centered on the bottom left of the tooltip.
		 * 
		 * @default ""
		 */
		public function get tip():String
		{
			return _tipText;
		}
		public function set tip(value:String):void
		{
			_tipText = value;
			tipText.text = value;
		}
		
		
		/**
		 * 
		 */
		public function get displayPosition():String
		{
			return _displayPosition;
		}
		public function set displayPosition(value:String):void
		{
			_displayPosition = value;
			positionAssets();
		}
		
		
		/**
		 * 
		 */
		public function get tooltipMode():String
		{
			return _tooltipMode;
		}
		public function set tooltipMode(value:String):void
		{
			_tooltipMode = value;
			positionAssets();
		}
		
		
		/**
		 * 
		 */
		public function get borderColor():uint
		{
			return _borderColor;
		}
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get borderThickness():int
		{
			return _borderThickness;
		}
		public function set borderThickness(value:int):void
		{
			_borderThickness = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get borderTransparency():Number
		{
			return _borderTransparency;
		}
		public function set borderTransparency(value:Number):void
		{
			_borderTransparency = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get backgroundColor():uint
		{
			return +backgroundColor;  
		}
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get backgroundTransparency():Number
		{
			return _backgroundTransparency;
		}
		public function set backgroundTransparency(value:Number):void
		{
			_backgroundTransparency = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get padding():int
		{
			return _padding;
		}
		public function set padding(value:int):void
		{
			_padding = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get arrowHeight():int
		{
			return _arrowHeight;
		}
		public function set arrowHeight(value:int):void
		{
			_arrowHeight = value;
			draw();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			positionAssets();
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			positionAssets();
		}
		
	}

}