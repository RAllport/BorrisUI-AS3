/* Author: Rohaan Allport
 * Date Created: 08/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The base Borris user interface component.
 * 
 * Todos:
	 * 
 * 
*/


package Borris.containers 
{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import Borris.controls.BUIComponent;
	import Borris.display.BStyle;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BFlexBox extends BUIComponent
	{
		// constants
		public static const HORIZONTAL:String = "horizontal";				// used for direction property
		public static const VERTICAL:String = "vertical";					// used for direction property
		//public static const HORIZONTAL_REVERSE:String = "horizontal";		// used for direction property
		//public static const VERTICAL_REVERSE:String = "vertical";			// used for direction property
		
		public static const NO_WRAP:String = "noWrap";						// used for wrap property
		public static const WRAP:String = "wrap";							// used for wrap property
		//public static const WRAP_REVERSE:String = "wrapReverse";			// used for wrap property
		
		public static const START:String = "start";							// used for alignItems, alignContent, justify property
		public static const END:String = "end";								// used for alignItems, alignContent, justify property
		public static const CENTER:String = "senter";						// used for alignItems, alignContent, justify property
		public static const SPACE_BETWEEN:String = "spaceBetween";			// used for alignContent, justify property
		public static const SPACE_AROUND:String = "spaceAround";			// used for alignContent, justify property
		public static const STRETCH:String = "stretch";						// used for alignItems, alignContent property
		//public static const BASELINE:String = "baseline";					
		
		public static const BOTH:String = "both";							// used for flex property
		public static const NONE:String = "none";							// used for flex property
		
		
		// assets
		protected var _container:Sprite = new Sprite();
		
		
		// other
		/**
		 * Force the flexbox to be flexed (stretched) by this container's dimentions.
		 */
		public var flexParent:DisplayObjectContainer;
		
		
		// set and get
		//private var _display:String = ""; 					// block or inline
		private var _direction:String = HORIZONTAL;
		private var _wrap:String = WRAP;
		private var _justify:String = START;
		private var _alignItems:String = START;
		private var _alignContent:String = START;
		
		private var _flex:String = VERTICAL;					// The flex property for the children.
		
		private var _margin:int = 0;
		//private var _spacing:int = 0;
		private var _horizontalSpacing:int = 0;
		private var _verticalSpacing:int = 0;
		
		private var _maxSize:Point;
		private var _minSize:Point;
		private var _preferedSize:Point;
		
		private var _fillWidth:Boolean;
		private var _fillHeight:Boolean;
		
		
		public function BFlexBox(direction:String = HORIZONTAL, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0)
		{
			// constructor code
			_direction = direction;
			super(parent, x, y);
			
			this.parent = parent;
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * @param event
		 */
		protected function resizeHandler(event:Event):void
		{
			draw();
		} // end function resizeHandler
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			
			// this is the _style shape.
			// overriding the addChild method puts it in the container.
			// so we need to move it into the flexbox.
			// Note: This doesn't seem to have a use anymore because of updated style object.
			/*if (_container.numChildren > 0)
			{
				super.addChild(_container.getChildAt(0));
			}*/
			
			//super.initialize();
			super.addChild(_container);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			
			if (hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				//trace("Has mouse down event!");
			}
			
			
			// set width and height
			if (flexParent)
			{
				_width = flexParent.width;
				_height = flexParent.height;
			}
			else
			{
				_width = parent.width;
				_height = parent.height;
			}
			
			
			doJustify();
			doAlignItems();
			//doAlignContent(); // I think I need to finish doWrap() before this can be finished.
			doWrap();
			
			//***************************** end calculation of position and dimentions
			
			super.draw();
			
		} // end function draw
		
		
		/**
		 * @inheritDoc
		 */
        override public function addChild(child:DisplayObject):DisplayObject
        {
            _container.addChild(child);
            //child.addEventListener(Event.RESIZE, resizeHandler);
			
			if(parent)
				draw();
            
				return child;
        } // end function addChild
		
		
        /**
		 * @inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
            _container.addChildAt(child, index);
            //child.addEventListener(Event.RESIZE, resizeHandler);
            
			if(parent)
				draw();
			
            return child;
        } // end function addChildAt
		
		
        /**
		 * @inheritDoc
		 */
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            _container.removeChild(child);
            child.removeEventListener(Event.RESIZE, resizeHandler);
            draw();
            return child;
        } // end function removeChild*/

        
		/**
		 * @inheritDoc
		 */
       override public function removeChildAt(index:int):DisplayObject
        {
            var child:DisplayObject = _container.removeChildAt(index);
            child.removeEventListener(Event.RESIZE, resizeHandler);
            draw();
            return child;
        } // end function removeChildAt

		
		/**
		 * Sets the amount of flex the flexbox's item (flex item) has.
		 * 
		 * <p>The flex parameter is a string, integer or fraction. <br>
		 * As a string, the it can be set to an integer with a "%" at the end, where the integer is greater than 0 and less then or equal to 100. eg "25%". <br>
		 * As an integer, the flex will be calculated as a ratio to the other flex items on the line. eg. 1. <br>
		 * As a faction
		 * </p>
		 * 
		 * @param item The item to be flexed.
		 * @param flex The amount of flex (stretching) the item should have.
		 * 
		 */
		public function setItemFlex(item:DisplayObject, flex:Object):void
		{
			if (flex is String)
			{
				var fs:String =  flex as String; // fs = flex string
				
				// compute 
				
			}
			else if(flex is Number || flex is int)
			{
				var fnt:Number = flex as Number; // fnt = flex number test 
				
				if (fnt < 0 || fnt > 100)
				{
					throw new ArgumentError("As an integer or fraction, the flex parameter must be greater than 0 and less than or equal to 100.");
				}
				else if(fnt < 1) // fraction
				{
					// compute 
					
				}
				else if (fnt >= 1) // integers
				{
					// compute 
					
				} // end else if
				
			} // end if
			
		} // end function setItemFlex
			
		
		/**
		 * Controls the position of the flex items.
		 * Controls y property if direction is horizontal and x property if direction is vertical.
		 */
		protected function doAlignItems():void
		{
			var child:DisplayObject;
			var i:int = 0;
			
			if (_direction == HORIZONTAL)
			{
				for(i = 0; i < _container.numChildren; i++)
				{
					child = _container.getChildAt(i);
					
					switch(_alignItems)
					{
						case START:
							child.y = 0;
							break;
							
						case END:
							child.y = _height - child.height;
							break;
							
						case CENTER:
							child.y = _height/2 - child.height/2;
							break;
							
						case STRETCH:
							child.y = 0;
							child.height = _height;
							break;
							
						/*case BASELINE:
							
							break;*/
							
					} // end switch
					
				} // end for 
			}
			else if (_direction == VERTICAL)
			{
				for(i = 0; i < _container.numChildren; i++)
				{
					child = _container.getChildAt(i);
					
					switch(_alignItems)
					{
						case START:
							child.x = 0;
							break;
							
						case END:
							child.x = _width - child.width;
							break;
							
						case CENTER:
							child.x = (_width - child.width) / 2;
							break;
							
						case STRETCH:
							child.x = 0;
							child.width = _width;
							break;
							
						/*case BASELINE:
							
							break;*/
						
					} // end switch
					
				} // end for
				
			} // end if else if 
			
		} // end function doAlignItems
		
		
		/**
		 * 
		 */
		protected function doAlignContent():void
		{
			
			if (_direction == HORIZONTAL)
			{
				//_container.x = _margin;
				
				switch(_alignContent)
				{
					case START:
						_container.y = _margin;
						break;
					
					case END:
						_container.y = _height - _container.height - _margin;
						break;
					
					case CENTER:
						_container.y = _height/2 - _container.height/2;
						break;
					
					case STRETCH:
						_container.y = _margin;
						_container.height = _height - margin * 2; // not really sure
						break;
					
					case SPACE_BETWEEN:
						_container.y = _margin;
						// ummm
						break;
					
					case SPACE_AROUND:
						_container.y = _margin;
						// ummm
						break;
					
				}
			}
			else if (_direction == VERTICAL)
			{
				
			} // end else if
			
		} // end function doAlignContent
		
		
		/**
		 * 
		 */
		protected function doJustify():void
		{
			var child:DisplayObject;
			var xPos:int = 0;
			var yPos:int = 0;
			var childrenWidth:int = 0;
			var childrenHeight:int = 0;
			var remainderWidth:int = 0;
			var remainderHeight:int = 0;
			
			var i:int;
			
			// Calculate the total width and height of all the children together.
			for(i = 0; i < _container.numChildren; i++)
			{
				child = _container.getChildAt(i);
				childrenWidth += child.width;
				childrenHeight += child.height;
			}
			
			if (_direction == HORIZONTAL)
			{
				
				// justify START, END, and CENTER
				if (_justify == START || _justify == END || _justify == CENTER)
				{
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						xPos += child.width + _horizontalSpacing;
						
					} // end for
					
					switch(_justify)
					{
						case START:
							_container.x = 0;
							break;
						
						case END:
							_container.x = _width - _container.width;
							break;
						
						case CENTER:
							_container.x = _width/2 - _container.width/2;
							break;
						
					} // end switch
					
				} // end if 
				
				
				//**************************************************** flexible spacing
				
				
				// Calculate the remaining width of the flexbox from the children's total width.
				remainderWidth = _width - childrenWidth;
				
				// 
				var spacingWidth:int;
				
				
				// SPACE_BEWTEEN
				if (_justify == SPACE_BETWEEN)
				{
					spacingWidth = remainderWidth / (_container.numChildren - 1);
					xPos = 0;
					
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						xPos += child.width + spacingWidth;
					}
				} // end if 
				
				
				// SPACE_AROUND
				if (_justify == SPACE_AROUND)
				{
					spacingWidth = remainderWidth / (_container.numChildren);
					xPos = spacingWidth / 2;
					
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						xPos += child.width + spacingWidth;
					}
				} // end if
				
			}
			else if (_direction == VERTICAL)
			{
				
				// justify START, END, and CENTER
				if (_justify == START || _justify == END || _justify == CENTER)
				{
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						yPos += child.height + _verticalSpacing;
						
					} // end for
					
					switch(_justify)
					{
						case START:
							_container.y = 0;
							break;
						
						case END:
							_container.y = _height - _container.height;
							break;
						
						case CENTER:
							_container.y = _height/2 - _container.height/2;
							break;
						
					} // end switch
					
				} // end if 
				
				
				//**************************************************** flexible spacing
				
				
				// Calculate the remaining height of the flexbox from the children's total height.
				remainderHeight = _height - childrenHeight;
				
				// 
				var spacingHeight:int;
				
				
				// SPACE_BEWTEEN
				if (_justify == SPACE_BETWEEN)
				{
					spacingHeight = remainderHeight / (_container.numChildren - 1);
					yPos = 0;
					
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						yPos += child.height + spacingHeight;
					}
				} // end if 
				
				
				// SPACE_AROUND
				if (_justify == SPACE_AROUND)
				{
					spacingHeight = remainderHeight / (_container.numChildren);
					yPos = spacingHeight / 2;
					
					for(i = 0; i < _container.numChildren; i++)
					{
						child = _container.getChildAt(i);
						child.x = xPos;
						child.y = yPos;
						yPos += child.height + spacingHeight;
					}
				} // end if
				
			} // end else if
			
		} // end function doJustify
		
		
		/**
		 * Controls wrapping
		 * 
		 * called in draw().
		 */
		protected function doWrap():void
		{
			
			if (_wrap == WRAP)
			{
				var lineArray:Array = [];
				
				var i:int;
				var rowWidth:int = 0;
				var columnHeight:int = 0;
				var child:DisplayObject;
				
				var xPos:int;
				var yPos:int;
				var biggestChildDimention:int = 0;
				var biggestChild:DisplayObject;
				var secondBiggestChild:DisplayObject;
				
				
				// loop through all the children
				for (i = 0; i < _container.numChildren; i++)
				{
					child = _container.getChildAt(i);
					lineArray.push(child);
					
					// set the biggest and second biggest child
					if (!biggestChild)
					{
						biggestChild = child;
						secondBiggestChild = child;
					}
					
					// do Horizontal calculations
					if (direction == HORIZONTAL)
					{
						// get the width of the row (what a row should be) by calculating the children width and the spacing
						rowWidth += child.width + _horizontalSpacing;
						
						child.x = xPos;
						child.y = yPos;
						//xPos += child.width + _horizontalSpacing;
						xPos = rowWidth;
						
						// get the last child on the row
						// child and lastRowChild may be the same thing
						//var lastRowChild:DisplayObject = lineArray[lineArray.length - 1];
						//lastRowChild.x = xPos;
						//lastRowChild.y = yPos;
						
						// update the x position
						//xPos += lastRowChild.width + _horizontalSpacing;
						
						
						// find the tallest child)
						if (child.height > biggestChild.height)
						{
							secondBiggestChild = biggestChild;
							biggestChild = child;
						} // end else if
						
						// 
						if (rowWidth > _width)
						{
							if (lineArray.length > 1)
							{
								rowWidth = 0;		// reset row width
								xPos = 0;			// reset the x position
								lineArray = [];		// reset the array
								i--;				// decrement i by 1 so that it picks up the last child as the first child for the new row
								
								// update y position for new row, using the largest child found (or second largest)
								child != biggestChild ? yPos += biggestChild.height + _verticalSpacing : yPos += secondBiggestChild.height + _verticalSpacing;
								
								// reset biggest, and second biggest child
								biggestChild = null;
								secondBiggestChild = null;
								
							} // end if
							
						} // end if
						
					}
					//  do vertical calculations
					else if (_direction == VERTICAL)
					{
						// get the width of the row (what a row should be) by calculating the children width and the spacing
						columnHeight += child.height + _verticalSpacing;
						
						child.x = xPos;
						child.y = yPos;
						//yPos += child.height + _verticalSpacing;
						yPos = columnHeight;
						
						// find the widest child)
						if (child.width > biggestChild.width)
						{
							secondBiggestChild = biggestChild;
							biggestChild = child;
						} // end else if
						
						// 
						if (columnHeight > _height)
						{
							if (lineArray.length > 1)
							{
								columnHeight = 0;	// reset column height
								yPos = 0;			// reset the y position
								lineArray = [];		// reset the array
								i--;				// decrement i by 1 so that it picks up the last child as the first child for the new row
								
								// update x position for new column, using the largest child found (or second largest)
								child != biggestChild ? xPos += biggestChild.width + _horizontalSpacing : xPos += secondBiggestChild.width + _horizontalSpacing;
								
								// reset biggest, and second biggest child
								biggestChild = null;
								secondBiggestChild = null;
								
							} // end if
							
						} // end if
						
					} // end else if
					
				} // end for
				
			} // end if
			
		} // end function doWrap
		
		
		/**
		 * 
		 */
		protected function calculateMaximumSize():void
		{
			
		}
		
		
		/**
		 * 
		 */
		protected function calculateMinimumSize():void
		{
			
		}
		
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets and sets the alignment of the flexbox's items.
		 * 
		 * <p>The alignItems property horizontally aligns the flexbox's items when <code>direction</code> is <code>BFlexBox.VERTICAL</code> or 
		 * vertically when <code>direction</code> is <code>BFlexBox.HORIZONTAL</code> 
		 * when the items do not use all available space on the cross-axis.</p>
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BFlexBox.START</li>
		 * 	<li>BFlexBox.END</li>
		 * 	<li>BFlexBox.CENTER</li>
		 * 	<li>BFlexBox.SRETCH</li>
		 * @private <li>BFlexBox.BASELINE</li>
		 * </ul>
		 * 
		 * @default BFlexBox.START
		 */
		public function get alignItems():String
		{
			return _alignItems;
		}
		
		public function set alignItems(value:String):void
		{
			_alignItems = value;
			doAlignItems();
		}
		
		
		/**
		 * Gets and sets the alignment of all the flexbox's content.
		 * 
		 * <p>The alignContent property modifies the behavior of the wrap property. It is similar to alignItems, 
		 * but instead of aligning flex items, it aligns flex lines.</p>
		 * 
		 * <p>The alignContent property horizontally aligns the flexbox's lines when <code>direction</code> is <code>BFlexBox.VERTICAL</code> or 
		 * vertically when <code>direction</code> is <code>BFlexBox.HORIZONTAL</code> 
		 * when the wrapping to a next line.</p>
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BFlexBox.START</li>
		 * 	<li>BFlexBox.END</li>
		 * 	<li>BFlexBox.CENTER</li>
		 * 	<li>BFlexBox.SPACE_BETWEEN</li>
		 * 	<li>BFlexBox.SPACE_AROUND</li>
		 * 	<li>BFlexBox.STRETCH</li>
		 * </ul>
		 * 
		 * @default BFlexBox.START
		 */
		public function get alignContent():String
		{
			return _alignContent;
		}
		
		public function set alignContent(value:String):void
		{
			_alignContent = value;
			doAlignItems();
		}
		
		
		/**
		 * gets or sets the axis of the flexbox, which defines the flow of the flex items (children) of the flexbox.
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BFlexBox.HORIZONTAL</li>
		 * 	<li>BFlexBox.VERTICAL</li>
		 * </ul>
		 * 
		 * @default BFlexBox.HORIZONTAL
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			_direction = value;
			draw();
		}
				
		
		/**
		 * Gets or sets whether how the flex items should be flexed.
		 * 
		 * <p>The flex property specifies the length of the flex item, relative to the rest of the flex items inside the same container.
		 * By default, the flex items will be flexed to be the same dimentions.</p>
		 * 
		 * @see setItemFlex()
		 */
		public function get flex():String
		{
			return _flex;
		}
		
		public function set flex(value:String):void
		{
			_flex = value;
			
			if(_flex == HORIZONTAL)
			{
				_width = parent.width;
				_height = getBounds(this).height;
			}
			else if(_flex == VERTICAL)
			{
				_width = getBounds(this).width;
				_height = parent.height;
			}
			else if(_flex ==  BOTH)
			{
				_width = parent.width;
				_height = parent.height;
			}
			else if (_flex == NONE)
			{
				_width = getBounds(this).width;
				_height = getBounds(this).height;
			}
			
			//draw();
		}
		
		
		/**
		 * Gets or sets the justification of the flex items.
		 * 
		 * <p>The justify property horizontally aligns the flexbox's items when the items do not use all available space on the main-axis.</p>
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * <ul>
		 * 	<li>BFlexBox.START</li>
		 * 	<li>BFlexBox.END</li>
		 * 	<li>BFlexBox.CENTER</li>
		 * 	<li>BFlexBox.SPACE_BETWEEN</li>
		 * 	<li>BFlexBox.SPACE_AROUND</li>
		 * </ul>
		 * 
		 * @default BFlexBox.SPACE_BETWEEN
		 */
		public function get justify():String
		{
			return _justify;
		}
		
		public function set justify(value:String):void
		{
			_justify = value;
			draw();
		}
		
		
		/**
		 * Gets or sets whether the flex items should be wrapped or not.
		 * 
		 * <p>In ActionScript, you can use the following constants to set this property:</p>
		 * 
		 * <ul>
		 * 	<li>BFlexBox.NO_WRAP</li>
		 * 	<li>BFlexBox.WRAP</li>
		 * </ul>
		 * 
		 * @default BFlexBox.NO_WRAP
		 */
		public function get wrap():String
		{
			return _wrap;
		}
		
		public function set wrap(value:String):void
		{
			_wrap = value;
			draw();
		}
		
		
		/***************************************************************************/
		
		
		/**
		 * ges or sets the margin of the the floxbox, the space between the edge of the flexbox and flex items.
		 */
		public function get margin():int
		{
			return _margin;
		}
		
		public function set margin(value:int):void
		{
			_margin = value;
			draw();
		}
		
		
		/**
		 * Gets or sets the horizontal space between each child in the flexbox.
		 */
		public function get horizontalSpacing():int
		{
			return _horizontalSpacing;
		}
		
		public function set horizontalSpacing(value:int):void
		{
			_horizontalSpacing = value;
			draw();
		}
		
		
		/**
		 * Gets or sets the vertical space between each child in the flexbox.
		 */
		public function get verticalSpacing():int
		{
			return _verticalSpacing;
		}
		
		public function set verticalSpacing(value:int):void
		{
			_verticalSpacing = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get maxSize():Point
		{
			return _maxSize;
		}
		
		public function set maxSize(value:Point):void
		{
			_maxSize = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get minSize():Point
		{
			return _minSize;
		}
		
		public function set minSize(value:Point):void
		{
			_minSize = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get preferedSize():Point
		{
			return _preferedSize;
		}
		
		public function set preferedSize(value:Point):void
		{
			_preferedSize = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get fillWidth():Boolean
		{
			return _fillWidth;
		}
		
		public function set fillWidth(value:Boolean):void
		{
			_fillWidth = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get fillHeight():Boolean
		{
			return _fillHeight;
		}
		
		public function set fillHeight(value:Boolean):void
		{
			_fillHeight = value;
			draw();
		}
		
		
		
		/****************************************************************************/
		
		/**
		 * @inheritDoc
		 */
		override public function set parent(value:DisplayObjectContainer):void
		{
			//trace("BFlexBox | Setting parent!");
			if (parent)
			{
				if (parent.hasEventListener(Event.RESIZE))
				{
					removeEventListener(Event.RESIZE, resizeHandler);
				}
				parent.removeChild(this);
			}
			
			value.addEventListener(Event.RESIZE, resizeHandler);
			value.addChild(this);
		}
	}

}