/* Author: Rohaan Allport
 * Date Created: 13/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
 * Errors: Nested details keeps the conatiner for no reason.
 * - content for a detail must be added after inictializing the accordion.
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
	
	
	public class BDetails extends BUIComponent
	{
		// constants
		
		
		
		// assets variables
		protected var container:Sprite;							// A container to hold the items of the details Object
		protected var button:BLabelButton;
		
		protected var arrowIcon:Shape;							// An arrow icon that displays to the left of the label. It rotates when the details Object is opened and closed;
		protected var mk:Shape;									// A make to mask out overflow of the container from the bottom and right.
		
		
		// text stuff
		
		
		// other
		private var heightFlag:Boolean = false;					// A flag that's only used to as... ummm meh
		protected var buttonWidth:int;
		protected var buttonHeight:int = 30;
		
		
		// set and get private variables
		protected var _label:String;							// 
		protected var _open:Boolean = false;					// 
		protected var _indent:int = 0;							// 
		protected var _lineHeight:int = 24;						// 
		protected var _rowHeight:int = 24;						// 
		protected var _columnWidth:int = 24;					// 
		protected var _tweened:Boolean = false;					// 
		
		//protected var _buttonWidth:in
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BDetails component instance.
         *
		 * @param label The text label for the component.
         */
		public function BDetails(label:String = "Label") 
		{
			_label = label;
			super(null, 0, 0);
			initialize();
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		
		/**
		 * 
		 * @param event
		 */
		protected function mouseClickHandler(event:MouseEvent):void
		{
			opened = !opened; // opened propertie to the oposite value. (see set and get )
			this.dispatchEvent(new Event(Event.SELECT, true, false));
		} // end function mouseClickHandler
		
		
		//*************************************** FUNCTIONS **************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize asset variables
			container = new Sprite();
			container.x = _indent;
			container.y = buttonHeight;
			container.graphics.beginFill(0x000000, 0);
			container.graphics.drawRect(0, 0, 1, 1);
			container.graphics.endFill();
			
			// initialize the button;
			button = new BLabelButton(this, 0, 0, _label);
			button.autoSize = false;
			button.textField.x = buttonHeight;
			button.setStateColors(0x0000, 0x000000, 0x333333, 0x000000, 0x000000, 0x000000, 0x333333, 0x000000);
			
			// icons
			arrowIcon = new Shape();
			/*arrowIcon.graphics.beginFill(0xCCCCCC, 1);
			arrowIcon.graphics.moveTo( -2.5, -5);
			arrowIcon.graphics.lineTo(2.5, 0);
			arrowIcon.graphics.lineTo(-2.5, 5);
			arrowIcon.graphics.endFill();
			arrowIcon.mouseEnabled = false;
			arrowIcon.x = 10;
			arrowIcon.y = 10;*/
			
			arrowIcon.graphics.lineStyle(1, 0xCCCCCC, 1, false, "normal", "none");
			arrowIcon.graphics.moveTo(-2.5, -5);
			arrowIcon.graphics.lineTo(2.5, 0);
			arrowIcon.graphics.lineTo( -2.5, 5);
			arrowIcon.rotation = 0;
			
			button.icon = arrowIcon;
			button.setIconBounds(buttonHeight/2, buttonHeight/2);
			
			mk = new Shape();
			mk.graphics.beginFill(0xff00ff, 0.5);
			mk.graphics.drawRect(0, 0, 100, 100);
			mk.graphics.endFill();
			mk.x = 0;
			mk.y = buttonHeight;
			mk.height = 0;
			
			container.mask = mk;
			
			// add assets to stage
			addChild(container);
			addChild(mk);
			
			this.width = 300;
			
			// event handling
			button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			//super.draw();
			
			container.x = _indent;
			buttonWidth = _width;
			
			// draw skins
			button.width = _width;
			button.height = buttonHeight;
			
			//BElement(button.getSkin("upSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("upSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderColor = 0x666666;
			BElement(button.getSkin("upSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("upSkin")).style.borderWidth = 2;
			
			//BElement(button.getSkin("overSkin")).style.backgroundColor = 0x000000;
			BElement(button.getSkin("overSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderColor = 0x999999;
			BElement(button.getSkin("overSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("overSkin")).style.borderWidth = 2;
			
			//BElement(button.getSkin("downSkin")).style.backgroundColor = 0x333333;
			BElement(button.getSkin("downSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderColor = 0x666666;
			BElement(button.getSkin("downSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("downSkin")).style.borderWidth = 2;
			
			//BElement(button.getSkin("disabledSkin")).style.backgroundColor = 0x666666;
			BElement(button.getSkin("disabledSkin")).style.backgroundOpacity = 1;
			BElement(button.getSkin("disabledSkin")).style.borderColor = 0x666666;
			BElement(button.getSkin("disabledSkin")).style.borderOpacity = 1;
			BElement(button.getSkin("disabledSkin")).style.borderWidth = 2;
			
			
			mk.x = 0;
			mk.y = buttonHeight;
			mk.width = _width;
			//mk.height = _height - buttonHeight;
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
		override public function setSize(width:Number, height:Number):void
		{
			// I was lazy :'D. Same thing anyway
			this.width = width;
			this.height = height;
		} // end function setSize
		
		
		/**
		 * 
		 */
		public function showGrid():void
		{
			//trace("BDetails | showGrid(): This function does nothing.");
		} // end function showGrid
		
		
		/**
		 * 
		 * @param item
		 * @return
		 */
		public function addItem(item:DisplayObject):DisplayObject
		{
			container.addChild(item);
			draw();
			//trace("container: " + container.height);
			return item;
		} // end function addItem
		
		
		/**
		 * 
		 * @param item
		 * @param index
		 * @return
		 */
		public function addItemAt(item:DisplayObject, index:int):DisplayObject
		{
			container.addChildAt(item, index);
			draw();
			return item;
		} // end function addItemAt
		
		
		/**
		 * 
		 * @param item
		 * @return
		 */
		public function removeItem(item:DisplayObject):DisplayObject
		{
			container.removeChild(item);
			draw();
			return item;
		} // end function removeItem
		
		
		/**
		 * 
		 * @param item
		 * @param index
		 * 
		 * @return
		 */
		public function removeItemAt(item:DisplayObject, index:int):DisplayObject
		{
			container.addChildAt(item, index);
			draw();
			return item;
		} // end function removeItemAt
		
		
		/**
		 * 
		 * @param item
		 * @param x
		 * @param y
		 * 
		 * @return
		 */
		public function addItemAtPosition(item:DisplayObject, x:int = 0, y:int = 0):DisplayObject
		{
			item.x = x;
			item.y = y;
			container.addChild(item);
			draw();
			return item;
		} // end function addItemAtPosition
		
		
		/**
		 * 
		 * @param index
		 * 
		 * @return
		 */
		public function getItemAt(index:int):DisplayObject
		{
			return container.getChildAt(index);
		} // end function getItemAt
		
		
		/**
		 * 
		 * @param name
		 * 
		 * @return
		 */
		public function getItemByName(name:String):DisplayObject
		{
			return container.getChildByName(name);
		} // end function getItemByName
		
		
		/**
		 * 
		 * @param item
		 * 
		 * @return
		 */
		public function getItemIndex(item:DisplayObject):int
		{
			return container.getChildIndex(item);
		} //  end function getItemIndex
		
		
		/**
		 * 
		 * @param point
		 * 
		 * @return
		 */
		public function getItemUnderPoint(point:Point):Array
		{
			return container.getObjectsUnderPoint(point);
		} //  end function getItemUnderPoint
		
		
		
		//*************************************** SET AND GET **************************************
		
		
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
		
		
		/**
		 * 
		 */
		public function get opened():Boolean
		{
			return _open;
		}
		public function set opened(value:Boolean):void
		{
			_open = value;
			var tween:Tween;
			
			if(value)
			{
				
				//arrowIcon.rotation = 90;
				tween = new Tween(arrowIcon, "rotation", Regular.easeOut, 0, 90, 0.3, true);
				tween = new Tween(mk, "height", Regular.easeInOut, 0, _height - buttonHeight, 0.3, true);
				this.dispatchEvent(new Event(Event.OPEN, true, false));
			}
			else
			{
				
				//arrowIcon.rotation = 0;
				tween = new Tween(arrowIcon, "rotation", Regular.easeOut, 90, 0, 0.3, true);
				tween = new Tween(mk, "height", Regular.easeInOut, _height - buttonHeight, 0, 0.3, true);
				dispatchEvent(new Event(Event.CLOSE, true, false));
			}
			draw();
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		
		/**
		 * 
		 */
		public function get indent():int
		{
			return _indent;
		}
		public function set indent(value:int):void
		{
			_indent = value;
			
			container.x = value;
		}
		
		
		/**
		 * 
		 */
		public function get lineHeight():int
		{
			return _lineHeight;
		}
		public function set lineHeight(value:int):void
		{
			_lineHeight = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get rowHeight():int
		{
			return _rowHeight;
		}
		public function set rowHeight(value:int):void
		{
			_rowHeight = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get columnWidth():int
		{
			return _columnWidth;
		}
		public function set columnWidth(value:int):void
		{
			_columnWidth = value;
			draw();
		}
		
		
		// tweened
		/*public function set tweened(value:Boolean):void
		{
			_tweened = value;
		}
		
		public function get tweened():Boolean
		{
			return _tweened;
		}
		*/
		
		
		/**
		 * Container for content added to this details. 
		 * The content is masked, so it is best to add children to content, rather than directly to the details.
		 */
		public function get content():DisplayObjectContainer
		{
			return container;
		}
		
		
		/**
		 * Gets or sets the height of the component. A closed BDetail's height will only be that of its button
		 * 
		 * <p>The height of the BDetails cannot be less than the height of its internal button.</p>
		 * 
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			if(!heightFlag)
			{
				if(_open)
				{
					mk.height = container.height;
					return _height = container.height + buttonHeight;
				}
				else
				{
					return buttonHeight;
				}
			} // end if
			
			if(contains(container))
			{
				return mk.height + buttonHeight;
			}
			else
			{
				return buttonHeight;
			}
			return _height;
		}
		override public function set height(value:Number):void
		{
			heightFlag = true;
			
			if (value < buttonHeight)
			{
				value = buttonHeight;
			}
			
			mk.height = value - buttonHeight;
			super.height = value;
		}
		
		
	}

}