/* Author: Rohaan Allport
 * Date Created: 08/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos: - recalculate gradient matrixes
	 * 
 * 
*/



package Borris.display 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.text.*;
	import flash.geom.Matrix;
	import flash.filters.*;
	import flash.utils.*;
	
	import Borris.controls.BUIComponent;
	import Borris.events.BStyleEvent;
	
	
	public class BStyle extends EventDispatcher implements IBStyleable
	{
		// assets
		private var _container:DisplayObjectContainer;
		private var _canvas:Shape;
		private var _graphics:Graphics;
		
		
		// other 
		private var _values:Object = { };
		private var _placeHolderFlag:Boolean = false;			// Flag used to know whether a place holder container was made in the contructor.
		
		
		//private var textField:TextField = new TextField();
		//private var textFormat:TextFormat = new TextFormat("Calibri", 16, 0xFFFFFF, false);
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		
		// set and get and styles
		private var _theme:Object;
		
		private var _margin:Object = 10;
		private var _padding:Object;
		
		
		// background
		//private var _background:Object;
		//private var _backgroundAttachment:Object;
		private var _backgroundColor:Object// = 0xffffff;
		//private var _backgroundImage:Object;
		//private var _backgroundPosition:Object;
		//private var _backgroundRepeat:Object;
		private var _backgroundOpacity:Number = 1;
		
		
		// border
		private var _border:Object;
		private var _borderStyle:Object = "solid";
		private var _borderWidth:Object = 0;
		private var _borderColor:Object = 0xff0000;
		private var _borderRadius:Object = 0;
		private var _borderOpacity:Number = 1;
		
		private var _borderBottom:Object;
		private var _borderBottomColor:Object;
		private var _borderBottomStyle:Object;
		private var _borderBottomWidth:Object;
		
		private var _borderLeft:Object;
		private var _borderLeftColor:Object;
		private var _borderLeftStyle:Object;
		private var _borderLeftWidth:Object;
		
		private var _borderRight:Object;
		private var _borderRightColor:Object;
		private var _borderRightStyle:Object;
		private var _borderRightWidth:Object;
		
		private var _borderTop:Object;
		private var _borderTopColor:Object;
		private var _borderTopStyle:Object;
		private var _borderTopWidth:Object;
		
		private var _borderBottomLeftRadius:Object;
		private var _borderBottomRightRadius:Object;
		private var _borderTopLeftRadius:Object;
		private var _borderTopRightRadius:Object;
		
		
		// text and font
		private var _color:Object;
		private var _font:Object;
		//private var _fontColor:Object;
		private var _fontFamily:Object;
		private var _fontSize:Object;
		private var _fontStyle:Object;
		private var _fontVarient:Object;
		private var _fontWeight:Object;
		//private var _textPadding:Number = 5;			// The spacing between the text and the edges of the component, and the spacing between the text and the icon, in pixels. The default value is 5.
		
		
		// misc styles
		//protected var _overHighlightColor:uint = 0x0099CC;
		//protected var _overHighlightTransparency:Number = 0.5;
		protected var _highlightColor:Object = 0xffffff;
		protected var _highlightHeight:Number = 0;				// Nice values incluse 4;
		protected var _highlightPosition:String = "top";		// Values include "top", "bottom", "left", "right". later should be changed to Object
																// and be syntaxed as {top: 0, left: 5}
		protected var _highlightOpacity:Number = 1;
		protected var _shineHeight:Number = 0; 					// Nice values inclue 1 and 50%.
		protected var _shineOpacity:Number = 0;					// The shine color is always white. Nice values include 0.4 and 0.7.
		//protected var _borderOuterTransparency:Number = 0.6;
		//protected var _borderInnerTransparency:Number = 0.4;
		protected var _borderBevel:Object = 0;
		protected var _borderBevels:uint = 1;
		
		
		//private var _:Object;
		
		
		public function BStyle(owner:DisplayObjectContainer = null) 
		{
			//container = owner as DisplayObjectContainer;
			
			// check to see if the owner is a regular DisplayObjectContainer or a Sprite.
			if (owner is Sprite)
			{
				_graphics = Sprite(owner).graphics;
				_container = owner as DisplayObjectContainer;
			}
			else if (owner is DisplayObjectContainer)
			{
				_container = owner as DisplayObjectContainer;
				_canvas = new Shape();
				_graphics = _canvas.graphics;
				_container.addChild(_canvas);
			}
			else if(!owner)
			{
				_container = new Sprite();
				_graphics = Sprite(_container).graphics;
				_placeHolderFlag = true;
			}
			
			
			// populate the _values object with all readable and writable properties
			var typeDef:XML = describeType(this);
			var props:Array = [];
			
			for each(var propXML:XML in typeDef.accessor.(@access == "readwrite")) 
			{
				props.push(propXML.@name);
			}
			
			for each(var prop:String in props) 
			{
				_values[prop] = this[prop];
			}
			
			
			// eventHandling
			//_container.addEventListener(BStyleEvent.STYLE_CHANGE, styleChangeHandler);
			
		}
		
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/*private function styleChangeHandler(event:BStyleEvent):void 
		{
			// clear the graphics
			_graphics.clear();
			
			// remove the canvas Shape object if there is one. 
			// (A canvas is made when the owner is just a regular DisplayObjectContainer and not a Sprite)
			if (_canvas)
			{
				_container.removeChild(_canvas);
			} // end if
			
			// TBH, I don't think I really need this.
			if (_placeHolderFlag)
			{
				_container = null;
			}
			
			
			// set the new container
			_container = event.styleOwner;
			
			// check to see if the container is a regular DisplayObjectContainer or a Sprite.
			if (_container is Sprite)
			{
				_graphics = Sprite(_container).graphics;
				_container = owner as DisplayObjectContainer;
			}
			else if (_container is DisplayObjectContainer)
			{
				// keep the previous Shape object so that we dont have to create a new own, and dumb the old one.
				// just use the one we already have.
				
				//_canvas = new Shape();
				//_graphics = _canvas.graphics;
				_container.addChild(_canvas);
			}
			
			trace("style change!");
			
		} // end function styleChangeHandler*/
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Draws the shapes.
		 * Shapes include:
		 * - background
		 * - border
		 * - outine
		 * - miscShape
		 */
		private function draw():void
		{
			// a tonne of ifs, fors and switch-case to set styles
			
			// Note: Drawing is now done directly on the owner
			
			// set the width and height of the style so that the shapes can be drawn.
			_width = _container.width;
			_height = _container.height;
			
			// create some varibales for drawing and making sure they are all numeric values.
			var bW:Number = setBorderWidth(_borderWidth);
			var bR:Number = setBorderRadius(_borderRadius);					// 
			var innerBR:Number = Math.max(bR - (bW * 2), 0);				// 
			
			/*var btw:Number = setBorderWidth(_borderTopWidth);				// border top width
			var bbw:Number = setBorderWidth(_borderBottomWidth);			// border bottom width
			var blw:Number = setBorderWidth(_borderLeftWidth);				// border left width
			var brw:Number = setBorderWidth(_borderRightWidth);				// border right width
			
			var btlr:Number = setBorderRadius(_borderTopLeftRadius);		// border top left radius
			var btrr:Number = setBorderRadius(_borderTopRightRadius);		// border top right radius
			var bblr:Number = setBorderRadius(_borderBottomLeftRadius);		// border bottom left radius
			var bbrr:Number = setBorderRadius(_borderBottomRightRadius);	// border bottom right radius*/
			
			var btw:Number = (_borderTopWidth != null) 			? setBorderWidth(_borderTopWidth) 			: bW;	// border top width
			var bbw:Number = (_borderBottomWidth != null) 		? setBorderWidth(_borderBottomWidth) 		: bW;	// border bottom width
			var blw:Number = (_borderLeftWidth != null) 		? setBorderWidth(_borderLeftWidth) 			: bW;	// border left width
			var brw:Number = (_borderRightWidth != null) 		? setBorderWidth(_borderRightWidth) 		: bW;	// border right width
			
			var btlr:Number = (_borderTopLeftRadius != null) 	? setBorderRadius(_borderTopLeftRadius) 	: bR;	// border top left radius
			var btrr:Number = (_borderTopRightRadius != null) 	? setBorderRadius(_borderTopRightRadius) 	: bR;	// border top right radius
			var bblr:Number = (_borderBottomLeftRadius != null) ? setBorderRadius(_borderBottomLeftRadius) 	: bR;	// border bottom left radius
			var bbrr:Number = (_borderBottomRightRadius != null)? setBorderRadius(_borderBottomRightRadius) : bR;	// border bottom right radius
			
			
			// I'm not really sure, but these culculations seem good so far.
			var ibtlr:Number = Math.max(btlr - (btw + blw)/2, 0);			// inner border top left radius
			var ibtrr:Number = Math.max(btrr - (btw + brw)/2, 0);			// inner border top right radius
			var ibblr:Number = Math.max(bblr - (bbw + blw)/2, 0);			// inner border bottom left radius
			var ibbrr:Number = Math.max(bbrr - (bbw + brw)/2, 0);			// inner border bottom right radius
			
			
			// variables for gradient fills
			var g:Gradient;
			//var matrix:Matrix;
			
			// variables for bevels
			//var bBs:uint;
			
			var makeGradientMatrix:Function = function(style:String):Matrix
			{
				var matrix:Matrix = new Matrix();
				
				switch(style)
				{
					// Note: might have to translate the position of the gradient. (last 2 values)
					
					case "background":
						matrix.createGradientBox(_width - (bW * 2), _height - (bW * 2), g.angle * Math.PI/180, 0, 0);
						break;
					
					case "border":
						matrix.createGradientBox(_width, _height, g.angle * Math.PI / 180, 0, 0);
						break;
					
					case "highlight":
						matrix.createGradientBox(_width - (bW * 2), Math.min(_highlightHeight, _height - (bW * 2)), g.angle * Math.PI / 180, 0, 0);
						break;
					
					case "outline":
						matrix.createGradientBox(_width + 2, _height + 2, g.angle * Math.PI / 180, 0, 0);
						break;
				} // end switch 
				
				return matrix;
			}
			
			/**
			 * Test the color type (uint, string, gradient).
			 * 
			 * @see setGraphicsColorByString
			 * Sets the graphics color and alpha.
			 * 
			 * Creates and appropriate matrix for style if colorType is Gradient.
			 * 
			 * @param colorType
			 * @param alpha
			 * @param style
			 * 
			 */
			var testAndSetColorTypeOfStyle:Function = function(colorType:Object, alpha:Number, style:String):void
			{
				if (colorType is uint)
				{
					_graphics.beginFill(colorType as uint, alpha);
				}
				else if (colorType is String)
				{
					setGraphicsColorByString(_graphics, colorType as String, alpha);
				}
				else if (colorType is Gradient)
				{
					g = colorType as Gradient;
					_graphics.beginGradientFill(g.type, g.colors, g.alphas, g.ratios, makeGradientMatrix(style));
				}
				
			}
			
			
			/*
			 * Started doing code for bevel. Going well but got tired.
			 */
			// starting at the top left
			/*border.graphics.moveTo(bR, 0);
			border.graphics.lineTo(_width - bR, 0);
			border.graphics.lineTo(_width, bR);
			border.graphics.lineTo(_width, _height - bR);
			border.graphics.lineTo(_width - bR, _height);
			border.graphics.lineTo(bR, _height);
			border.graphics.lineTo(0, _height - bR);
			border.graphics.lineTo(0, bR);
			
			border.graphics.moveTo(bR, bW);
			border.graphics.lineTo(_width - bR, bW);
			border.graphics.lineTo(_width - bW, bR);
			border.graphics.lineTo(_width - bW, _height - bR);
			border.graphics.lineTo(_width - bR, _height - bW);
			border.graphics.lineTo(bR, _height - bW);
			border.graphics.lineTo(bW, _height - bR);
			border.graphics.lineTo(bW, bR);*/
			
			
			// clear the graphics
			_graphics.clear();
			
			// draw the margin
			
			
			// draw the background
			testAndSetColorTypeOfStyle(_backgroundColor, _backgroundOpacity, "background");
			_graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), _height - (btw + bbw), ibtlr, ibtrr, ibblr, ibbrr);
			_graphics.endFill();
			
			
			// draw the border
			testAndSetColorTypeOfStyle(_borderColor, _borderOpacity, "border");
			_graphics.drawRoundRectComplex(0, 0, _width, _height, btlr, btrr, bblr, bbrr);
			_graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), _height - (btw + bbw), ibtlr, ibtrr, ibblr, ibbrr);
			
			
			// draw the misc shapes
			testAndSetColorTypeOfStyle(_highlightColor, _highlightOpacity, "highlight");
			_graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), Math.min(_highlightHeight, _height - (btw + bbw)), ibtlr, ibtrr, ibblr, ibbrr);
			_graphics.endFill();
			
			
			// draw the shine
			_graphics.beginFill(0xFFFFFF, _shineOpacity);
			_graphics.drawRoundRectComplex(blw, btw, _width - (blw + brw), Math.min(_shineHeight, _height - (btw + bbw)), ibtlr, ibtrr, ibblr, ibbrr);
			_graphics.endFill();
			
			
			// draw the outline
			
			
			// format the textfield
			
			
		} // end function draw
		
		
		/**
		 * Clears all the graphics that were drawn to this style's shapes.
		 */
		public function clear():void
		{
			_graphics.clear();
			
			// clear the properties too
			
		} // end function clear
		
		
		// function setShapeColorByString
		// Sets the color of a shape using a string.
		// There are so many CSS color strongs that it would be insane to add a switch statement for each shape
		/**
		 * 
		 * 
		 * @param shape
		 * @param color
		 */
		private function setGraphicsColorByString(g:Graphics, color:String, opacity:Number = 1):void
		{
			//http://www.w3schools.com/cssref/css_colornames.asp
			
			switch(color)
			{
				case "red":
					g.beginFill(0xFF0000, opacity);
					break;
					
				case "green":
					g.beginFill(0x00FF00, opacity);
					break;
				
				case "blue":
					g.beginFill(0x0000FF, opacity);
					break;
				
				case "yellow":
					g.beginFill(0xFFFF00, opacity);
					break;
				
				case "white":
					g.beginFill(0xFFFFFF, opacity);
					break;
				
				case "black":
					g.beginFill(0x000000, opacity);
					break;
						
			} // end switch
			
			
			return;
			
			/*if (shape == outline)
			{
				switch(color)
				{
					case "red":
						border.graphics.lineStyle(_borderWidth as uint, 0xFF0000, opacity);
						break;
						
					case "green":
						border.graphics.lineStyle(_borderWidth as uint, 0x00FF00, opacity);
						break;
					
					case "blue":
						border.graphics.lineStyle(_borderWidth as uint, 0x0000FF, opacity);
						break;
					
					case "yellow":
						border.graphics.lineStyle(_borderWidth as uint, 0xFFFF00, opacity);
						break;
					
					case "white":
						border.graphics.lineStyle(_borderWidth as uint, 0xFFFFFF, opacity);
						break;
					
					case "black":
						border.graphics.lineStyle(_borderWidth as uint, 0x000000, opacity);
						break;
						
				} // end switch
			}
			*/
				
		} // end function setShapeColorByString
		
		
		/**
		 * 
		 * 
		 * @param width
		 * @return
		 */
		private function setBorderWidth(width:Object):Number
		{
			//trace("border width:" + width);
			if (width is Number)
			{
				return width as Number;
			}
			else if (width is String)
			{
				switch(width)
				{
					case "medium":
						return 3;
						break;
					
					case "thick":
						return 5;
						break;
					
					case "thin":
						return 1;
						break;
				}
			}
			
			return 0;
		} // end function setBorderWidth
		
		
		/**
		 * 
		 * 
		 * @param radius
		 * @return
		 */
		private function setBorderRadius(radius:Object):Number
		{
			if (radius is Number)
			{
				return Math.max(0, radius as Number);
			}
			else if (radius is String)
			{
				var tempstring:String = radius as String;
				
				var i:int = tempstring.search("%");
				
				if (i >= 0)
				{
					if (i == tempstring.length - 1)
					{
						var number:Number = tempstring.substring(0, tempstring.length - 2) as Number;
						return Math.min(_width, _height) * (number / 100);
					}
					else
					{
						return 0;
					}
					
				}
			}
			
			return 0;
		} // end function setBorderRadius
		
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * [read-only] The DisplayObjectContainer this style belongs to.
		 * 
		 * @private Gets or sets the owner DisplayObjectContainer of this BStyle object.
		 */
		public function get owner():DisplayObjectContainer
		{
			return _container;
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
			//_container = value;
			
			// clear the graphics
			_graphics.clear();
			
			// remove the canvas Shape object if there is one. 
			// (A canvas is made when the owner is just a regular DisplayObjectContainer and not a Sprite)
			if (_canvas)
			{
				_container.removeChild(_canvas);
			} // end if
			
			// TBH, I don't think I really need this.
			if (_placeHolderFlag)
			{
				_container = null;
			}
			
			
			// set the new container
			//_container = event.styleOwner;
			_container = value;
			
			// check to see if the container is a regular DisplayObjectContainer or a Sprite.
			if (_container is Sprite)
			{
				_graphics = Sprite(_container).graphics;
				_container = owner as DisplayObjectContainer;
			}
			else if (_container is DisplayObjectContainer)
			{
				// keep the previous Shape object so that we dont have to create a new own, and dumb the old one.
				// just use the one we already have.
				
				//_canvas = new Shape();
				//_graphics = _canvas.graphics;
				_container.addChild(_canvas);
			}
		}
		
		
		//==========================
		// BACKGROUND STUFF
		//==========================
		
		/**
		 * 
		 */
		public function get backgroundColor():Object
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:Object):void
		{
			_backgroundColor = value;
			_values.backgroundColor = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * 
		 */
		public function get backgroundOpacity():Number
		{
			return _backgroundOpacity;
		}
		
		public function set backgroundOpacity(value:Number):void
		{
			_backgroundOpacity = value;
			_values.backgroundOpacity = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		//==========================
		// BORDER STUFF
		//==========================
		
		/**
		 * Gets or sets 
		 */
		public function get borderBevel():Object
		{
			return _borderBevel;
		}
		
		public function set borderBevel(value:Object):void
		{
			_borderBevel = value;
			_values.borderBevel = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderBevels():uint
		{
			return _borderBevels;
		}
		
		public function set borderBevels(value:uint):void
		{
			_borderBevels = value;
			_values.borderBevels = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderColor():Object
		{
			return _borderColor
		}
		
		public function set borderColor(value:Object):void
		{
			_borderColor = value;
			_values.borderColor = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderOpacity():Number
		{
			return _borderOpacity;
		}
		
		public function set borderOpacity(value:Number):void
		{
			_borderOpacity = value;
			_values.borderOpacity = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderRadius():Object
		{
			return _borderRadius;
		}
		
		public function set borderRadius(value:Object):void
		{
			_borderRadius = value;
			_values.borderRadius = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
			
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderWidth():Object
		{
			return _borderWidth;
		}
		 
		public function set borderWidth(value:Object):void
		{
			_borderWidth = value;
			_values.borderWidth = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		//==========================
		// INDIVIDUAL BORDER STUFF
		//==========================
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderBottom():Object
		{
			return _borderBottom;
		}
		
		public function set borderBottom(value:Object):void
		{
			_borderBottom = value;
			draw();
		}
		
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderBottomColor():Object
		{
			return _borderBottomColor;
		}
		
		public function set borderBottomColor(value:Object):void
		{
			_borderBottomColor = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderBottomStyle():Object
		{
			return _borderBottomStyle;
		}
		
		public function set borderBottomStyle(value:Object):void
		{
			_borderBottomStyle = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		public function get borderBottomWidth():Object
		{
			return _borderBottomWidth;
		}
		
		public function set borderBottomWidth(value:Object):void
		{
			_borderBottomWidth = value;
			_values.borderBottomWidth = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderLeft():Object
		{
			return _borderLeft;
		}
		
		public function set borderLeft(value:Object):void
		{
			_borderLeft = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderLeftColor():Object
		{
			return _borderLeftColor;
		}
		
		public function set borderLeftColor(value:Object):void
		{
			_borderLeftColor = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderLeftStyle():Object
		{
			return _borderLeftStyle;
		}
		
		public function set borderLeftStyle(value:Object):void
		{
			_borderLeftStyle = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		public function get borderLeftWidth():Object
		{
			return _borderLeftWidth;
		}
		
		public function set borderLeftWidth(value:Object):void
		{
			_borderLeftWidth = value;
			_values.borderLeftWidth = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderRight():Object
		{
			return _borderRight;
		}
		
		public function set borderRight(value:Object):void
		{
			_borderRight = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderRightColor():Object
		{
			return _borderRightColor;
		}
		
		public function set borderRightColor(value:Object):void
		{
			_borderRightColor = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderRightStyle():Object
		{
			return _borderRightStyle;
		}
		
		public function set borderRightStyle(value:Object):void
		{
			_borderRightStyle = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		public function get borderRightWidth():Object
		{
			return _borderRightWidth;
		}
		
		public function set borderRightWidth(value:Object):void
		{
			_borderRightWidth = value;
			_values.borderRightWidth = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderTop():Object
		{
			return _borderTop;
		}
		
		public function set borderTop(value:Object):void
		{
			_borderTop = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderTopColor():Object
		{
			return _borderTopColor;
		}
		
		public function set borderTopColor(value:Object):void
		{
			_borderTopColor = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		/*public function get borderTopStyle():Object
		{
			return _borderTopStyle;
		}
		
		public function set borderTopStyle(value:Object):void
		{
			_borderTopStyle = value;
			draw();
		}
		*/
		
		/**
		 * Gets or sets 
		 */
		public function get borderTopWidth():Object
		{
			return _borderTopWidth;
		}
		
		public function set borderTopWidth(value:Object):void
		{
			_borderTopWidth = value;
			_values.borderTopWidth = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderBottomLeftRadius():Object
		{
			return _borderBottomLeftRadius;
		}
		
		public function set borderBottomLeftRadius(value:Object):void
		{
			_borderBottomLeftRadius = value;
			_values.borderBottomLeftRadius = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderBottomRightRadius():Object
		{
			return _borderBottomRightRadius;
		}
		
		public function set borderBottomRightRadius(value:Object):void
		{
			_borderBottomRightRadius = value;
			_values.borderBottomRightRadius = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderTopLeftRadius():Object
		{
			return _borderTopLeftRadius;
		}
		
		public function set borderTopLeftRadius(value:Object):void
		{
			_borderTopLeftRadius = value;
			_values.borderTopLeftRadius = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		/**
		 * Gets or sets 
		 */
		public function get borderTopRightRadius():Object
		{
			return _borderTopRightRadius;
		}
		
		public function set borderTopRightRadius(value:Object):void
		{
			_borderTopRightRadius = value;
			_values.borderTopRightRadius = value;
			draw();
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		
		
		
		
		/**
		 * 
		 */
		public function get filters():Array
		{
			return _container.filters;
		}
		 
		public function set filters(value:Array):void
		{
			_container.filters = value;
			_values.filters = value;
			dispatchEvent(new BStyleEvent(BStyleEvent.STYLE_CHANGE));
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 
		 */
		public function get highlightColor():Object
		{
			return _highlightColor;
		}
		
		public function set highlightColor(value:Object):void
		{
			_highlightColor = value;
			_values.highlightColor = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get highlightHeight():Number
		{
			return _highlightHeight;
		}
		
		public function set highlightHeight(value:Number):void
		{
			_highlightHeight = value;
			_values.highlightHeight = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get highlightOpacity():Number
		{
			return _highlightOpacity;
		}
		
		public function set highlightOpacity(value:Number):void
		{
			_highlightOpacity = value;
			_values.highlightOpacity = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get shineHeight():Number
		{
			return _shineHeight;
		}
		
		public function set shineHeight(value:Number):void
		{
			_shineHeight = value;
			_values.shineHeight = value;
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get shineOpacity():Number
		{
			return _shineOpacity;
		}
		
		public function set shineOpacity(value:Number):void
		{
			_shineOpacity = value;
			_values.shineOpacity = value;
			draw();
		}
		
		
		
		public function get values():Object
		{
			return _values;
		}
		
		public function set values(value:Object):void
		{
			_values = value;
			
			//_margin = _values.margin;
			//_padding = _values.padding;
			//_background = _values.background;
			//_backgroundAttachment = _values.backgroundAttachment;
			_backgroundColor = _values.backgroundColor;
			//_backgroundImage = _values.backgroundImage;
			//_backgroundPosition = _values.backgroundPosition;
			//_backgroundRepeat = _values.backgroundRepeat;
			_backgroundOpacity = _values.backgroundOpacity;
			
			
			// border
			//_border = _values.border;
			//_borderStyle = _values.borderStyle;
			_borderWidth = _values.borderWidth;
			_borderColor = _values.borderColor;
			_borderRadius = _values.borderRadius;
			_borderOpacity = _values.borderOpacity;
			
			//_borderBottom = _values.borderBottom;
			_borderBottomColor = _values.borderBottomColor;
			_borderBottomStyle = _values.borderBottomStyle;
			_borderBottomWidth = _values.borderBottomWidth;
			
			//_borderLeft = _values.borderLeft;
			_borderLeftColor = _values.borderLeftColor;
			_borderLeftStyle = _values.borderLeftStyle;
			_borderLeftWidth = _values.borderLeftWidth;
			
			//_borderRight = _values.borderRight;
			_borderRightColor = _values.borderRightColor;
			_borderRightStyle = _values.borderRightStyle;
			_borderRightWidth = _values.borderRightWidth;
			
			//_borderTop = _values.borderTop;
			_borderTopColor = _values.borderTopColor;
			_borderTopStyle = _values.borderTopStyle;
			_borderTopWidth = _values.borderTopWidth;
			
			_borderBottomLeftRadius = _values.borderBottomLeftRadius;
			_borderBottomRightRadius = _values.borderBottomRightRadius;
			_borderTopLeftRadius = _values.borderTopLeftRadius;
			_borderTopRightRadius = _values.borderTopRightRadius;
			
			
			//_color = _values.;
			//_font = _values.;
			//_fontColor = _values.;
			//_fontFamily = _values.;
			//_fontSize = _values.;
			//_fontStyle = _values.;
			//_fontVarient = _values.;
			//_fontWeight = _values.;
			//_textPadding = _values.;
			
			//_overHighlightColor = ;
			//_overHighlightTransparency = ;
			_highlightColor = _values.highlightColor;
			_highlightHeight = _values.highlightHeight;
			_highlightPosition = _values.highlightPosition;
			_highlightOpacity = _values.highlightOpacity;
			_shineHeight = _values.shineHeight;
			_shineOpacity = _values.shineOpacity;
			//_borderOuterTransparency = _values.borderOuterTransparency;
			//_borderInnerTransparency = _values.borderInnerTransparency;
			_borderBevel = _values.borderBevel;
			_borderBevels = _values.borderBevels;
			
			
			draw();
		}
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		
	}

}