/* Author: Rohaan Allport
 * Date Created: 12/01/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.containers 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	import Borris.controls.BLabel;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BCanvas extends Sprite
	{
		// constants
		
		
		// assets
		protected var container:Sprite;									// container to hold the the grid and canvases
		protected var containerMask:Shape;								// the mask for the container
		
		protected var xLabelsContainer:Sprite;							// container for horizontal number labels
		protected var yLabelsContainer:Sprite;							// container for vertical number labels
		
		protected var xLabelMask:Shape;									// 
		protected var yLabelMask:Shape;									// 
		
		
		protected var background:Shape;									// The background of the graph
		protected var grid:Shape;										// The canvas for the lines (grid)
		//protected var canvas:Sprite;									// The actual display opject to draw into
		
		
		// set and get
		protected var _backgroundColor:uint = 0x000000;					// 
		protected var _backgroundTransparency:Number = 1;				// 
		
		protected var _labelColor:uint = 0xFFFFFF;						// 
		protected var _labelTransparency:Number = 1;					// 
		protected var _labelsPosition:String = "edge";					// The position of the number labels. Either "edge", "origin" or "center"
		
		protected var _axisLineColor:uint = 0xFFFFFF;					// 
		protected var _axisLineTransparency:Number = 0.5;				// 
		protected var _axisLineThickness:int = 2;						// 
		protected var _lineColor:uint = 0xFFFFFF;						// 
		protected var _lineTransparency:Number = 0.2;					// 
		protected var _lineThickness:int = 1;							// 
		protected var _lineSpacing:int = 30;							// 
		
		protected var _gridSize:uint = 60;								// 
		protected var _showGrid:Boolean = true;
		protected var _showLabels:Boolean = true;
		
		protected var _width:Number = 800;								// The width of the graph in pixels
		protected var _height:Number = 600;								// The height of the graph in pixels
		protected var _panX:int = 0;									// The x position of the container to the mask 
		protected var _panY:int = 0;									// The y position of the container to the mask 
		protected var _zoom:Number = 1;									// The scaling of the container (as percentage)
		
		
		
		public function BCanvas() 
		{
			initialize();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 */
		protected function initialize():void
		{
			// initialize assets
			container = new Sprite();
			
			containerMask = new Shape();
			containerMask.graphics.beginFill(0xFF00FF, 1);
			containerMask.graphics.drawRect(0, 0, 100, 100);
			containerMask.graphics.endFill();
			
			xLabelsContainer = new Sprite();
			yLabelsContainer = new Sprite();
			
			xLabelMask = new Shape();
			xLabelMask.graphics.beginFill(0xFF00FF, 1);
			xLabelMask.graphics.drawRect(0, 0, 100, 100);
			xLabelMask.graphics.endFill();
			
			yLabelMask = new Shape();
			yLabelMask.graphics.beginFill(0xFF00FF, 1);
			yLabelMask.graphics.drawRect(0, 0, 100, 100);
			yLabelMask.graphics.endFill();
		
			background = new Shape();
			grid = new Shape();
			
			
			// add assets to respective containers
			addChild(background);
			addChild(container);
			addChild(containerMask);
			addChild(xLabelsContainer);
			addChild(yLabelsContainer);
			addChild(xLabelMask);
			addChild(yLabelMask);
			
			
			container.addChild(grid);
			
			container.mask = containerMask;
			xLabelsContainer.mask = xLabelMask;
			yLabelsContainer.mask = yLabelMask;
			
			
			// draw
			draw();
			drawGrid();
			drawLabels();
			
			pan(0, 0);
			
			
			// event handling
			
		} // end function initialize
		
		
		/**
		 * 
		 */
		protected function draw():void
		{
			background.graphics.clear();
			background.graphics.beginFill(_backgroundColor, _backgroundTransparency);
			background.graphics.drawRect(0, 0, _width, _height);
			background.graphics.endFill();
			
			containerMask.width = _width;
			containerMask.height = _height;
			
			xLabelMask.width = _width;
			xLabelMask.height = _height;
			
			yLabelMask.width = _width;
			yLabelMask.height = _height;
			
		} // end function draw
		
		
		/**
		 * 
		 */
		protected function drawGrid():void
		{
			
			grid.graphics.clear();
			grid.graphics.lineStyle(_lineThickness, _lineColor, _lineTransparency, true, "none");
			
			for(var i:int = 0; i <= _gridSize; i++)
			{
				// draw x lines
				grid.graphics.moveTo( -_gridSize / 2 * _lineSpacing, -_gridSize / 2 * _lineSpacing + i * _lineSpacing);
				grid.graphics.lineTo(  _gridSize / 2 * _lineSpacing, -_gridSize / 2 * _lineSpacing + i * _lineSpacing);
				
				// draw y lines
				grid.graphics.moveTo( -_gridSize / 2 * _lineSpacing + i * _lineSpacing, -_gridSize / 2 * _lineSpacing);
				grid.graphics.lineTo( -_gridSize / 2 * _lineSpacing + i * _lineSpacing,  _gridSize / 2 * _lineSpacing);
				
			}
			
			// draw axis
			grid.graphics.lineStyle(_axisLineThickness, _axisLineColor, _axisLineTransparency, true, "none");
			
			// draw X axis
			grid.graphics.moveTo( -_gridSize / 2 * _lineSpacing, 0);
			grid.graphics.lineTo(  _gridSize / 2 * _lineSpacing, 0);
			
			// draw Y axis
			grid.graphics.moveTo(0, -_gridSize / 2 * _lineSpacing);
			grid.graphics.lineTo(0,  _gridSize / 2 * _lineSpacing);
			
			
		} // end function drawGrid
		
		
		/**
		 * 
		 */
		protected function drawLabels():void
		{
			var tempTF:TextFormat;
			
			xLabelsContainer.removeChildren();
			yLabelsContainer.removeChildren();
			
			var numberLabel:BLabel;
			
			for (var i:int = 0; i <= _gridSize; i++ )
			{
				// add x labels
				numberLabel = new BLabel(xLabelsContainer, ( -_gridSize / 2 * _lineSpacing + i * _lineSpacing), 0, ( -_gridSize / 2 + i).toString() );
				numberLabel.autoSize = TextFieldAutoSize.LEFT;
				
				// change color
				tempTF = numberLabel.textField.getTextFormat();
				tempTF.color = _labelColor;
				numberLabel.textField.setTextFormat(tempTF);
				
				
				// add y labels
				numberLabel = new BLabel(yLabelsContainer, 0, (-_gridSize / 2 * _lineSpacing + i * _lineSpacing), (_gridSize/2 - i).toString() );
				numberLabel.autoSize = TextFieldAutoSize.LEFT;
				
				// change color
				tempTF = numberLabel.textField.getTextFormat();
				tempTF.color = _labelColor;
				numberLabel.textField.setTextFormat(tempTF);
			}
			
			xLabelsContainer.alpha = _labelTransparency;
			yLabelsContainer.alpha = +labelTransparency;
			
		} // end function drawLabels
		
		
		/**
		 * 
		 */
		public function pan(x:int, y:int):void
		{
			_panX = x;
			_panY = y;
			
			// position the container
			container.x = _width/2 + _panX;
			container.y = _height/2 + _panY;
			
			
			// position the x labels
			xLabelsContainer.x = container.x //- xLabelsContainer.getChildAt(0).height/4;
			xLabelsContainer.y = _height - xLabelsContainer.height;
			
			// position the y labels
			yLabelsContainer.x = _width - yLabelsContainer.width;
			yLabelsContainer.y = container.y - yLabelsContainer.getChildAt(0).height / 2;
			
			if (_labelsPosition == "origin")
			{
				xLabelsContainer.y = container.y;
				yLabelsContainer.x = container.x;
			}
			else if(_labelsPosition == "edge")
			{
				xLabelsContainer.y = _height - xLabelsContainer.height;
				yLabelsContainer.x = _width - yLabelsContainer.width;
			}
			
		} // end function pan
		
		
		
		//**************************************** SET AND GET ******************************************
		
		/**
		 * 
		 */
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			draw();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		
		/**
		 * 
		 */
		public function set backgroundTransparency(value:Number):void
		{
			_backgroundTransparency = value;
			draw();
		}
		
		public function get backgroundTransparency():Number
		{
			return _backgroundTransparency;
		}
		
		
		/**
		 * 
		 */
		public function set labelColor(value:uint):void
		{
			_labelColor = value;
			drawLabels();
		}
		
		public function get labelColor():uint
		{
			return _labelColor;
		}
		
		
		/**
		 * 
		 */
		public function set labelTransparency(value:Number):void
		{
			_labelTransparency = value;
			drawLabels();
		}
		
		public function get labelTransparency():Number
		{
			return _labelTransparency;
		}
		
		
		/**
		 * 
		 */
		public function set labelsPosition(value:String):void
		{
			_labelsPosition = value;
			
			pan(_panX, _panY);
			
			//drawLabels();
		}
		
		public function get labelsPosition():String
		{
			return _labelsPosition;
		}
		
		
		/**
		 * 
		 */
		public function set axisLineColor(value:uint):void
		{
			_axisLineColor = value;
			drawGrid();
		}
		
		public function get axisLineColor():uint
		{
			return _axisLineColor;
		}
		
		
		/**
		 * 
		 */
		public function set axisLineTransparency(value:Number):void
		{
			_axisLineTransparency = value;
			drawGrid();
		}
		
		public function get axisLineTransparency():Number
		{
			return _axisLineTransparency;
		}
		
		
		/**
		 * 
		 */
		public function set axisLineThickness(value:uint):void
		{
			_axisLineThickness = value;
			drawGrid();
		}
		
		public function get axisLineThickness():uint
		{
			return _axisLineThickness;
		}
		
		
		/**
		 * 
		 */
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
			drawGrid();
		}
		
		public function get lineColor():uint
		{
			return _lineColor;
		}
		
		
		/**
		 * 
		 */
		public function set lineTransparency(value:Number):void
		{
			_lineTransparency = value;
			drawGrid();
		}
		
		public function get lineTransparency():Number
		{
			return _lineTransparency;
		}
		
		
		/**
		 * 
		 */
		public function set lineThickness(value:int):void
		{
			_lineThickness = value;
			drawGrid();
		}
		
		public function get lineThickness():int
		{
			return _lineThickness;
		}
		
		
		/**
		 * 
		 */
		public function set lineSpacing(value:uint):void
		{
			_lineSpacing = value;
			drawGrid();
			drawLabels();
		}
		
		public function get lineSpacing():uint
		{
			return _lineSpacing;
		}
		
		
		/**
		 * 
		 */
		public function set gridSize(value:uint):void
		{
			_gridSize = Math.ceil(value/2) * 2;
			drawGrid();
			drawLabels();
		}
		
		public function get gridSize():uint
		{
			return _gridSize;
		}
		
		
		/**
		 * 
		 */
		public function get showGrid():Boolean
		{
			return _showGrid;
		}
		
		public function set showGrid(value:Boolean):void
		{
			grid.visible = _showGrid = value;
		}
		
		
		/**
		 * 
		 */
		public function get showLabels():Boolean
		{
			return _showLabels;
		}
		
		public function set showLabels(value:Boolean):void
		{
			_showLabels = value;
			xLabelsContainer.visible = _showLabels;
			yLabelsContainer.visible = _showLabels;
		}
		
		
		/**
		 * 
		 */
		public function set panX(value:Number):void
		{
			_panX = value;
			pan(_panX, _panY);
		}
		
		public function get panX():Number
		{
			return _panX;
		}
		
		
		/**
		 * 
		 */
		public function set panY(value:Number):void
		{
			_panY = value;
			pan(_panX, _panY);
		}
		
		public function get panY():Number
		{
			return _panY;
		}
		
		
		/**
		 * 
		 */
		public function set zoom(value:Number):void
		{
			_zoom = value;
			if (_zoom <= 0.1)
			{
				_zoom = 0.1;
			}
			
			container.scaleX = container.scaleY = _zoom;
			
			for (var i:int = 0; i <= _gridSize; i++ )
			{
				BLabel(xLabelsContainer.getChildAt(i)).x = ( -_gridSize / 2 * _lineSpacing + i * _lineSpacing) * _zoom;
				BLabel(yLabelsContainer.getChildAt(i)).y = ( -_gridSize / 2 * _lineSpacing + i * _lineSpacing) * _zoom;
			}
		}
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		/**
		 * 
		 */
		override public function set width(value:Number):void
		{
			_width = value;
			draw();
			pan(_panX, _panY);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		
		/**
		 * 
		 */
		override public function set height(value:Number):void
		{
			_height = value;
			draw();
			pan(_panX, _panY);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		
		
	}

}