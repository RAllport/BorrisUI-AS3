/* Author: Rohaan Allport
 * Date Created: 08/11/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls.charts 
{
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	import Borris.controls.BLabel;
	import Borris.containers.BCanvas;
	import Borris.equations.BEquation;
	
	
	public class BGraph extends BCanvas
	{
		// constants
		
		
		// assets
		protected var graphCanvas:Shape;								// The canvas for the graphs
		
		
		// other
		protected var equations:Vector.<BEquation>;						// 
		protected var graphs:Sprite;									// 
		
		
		// set and get
		protected var _graphColors:Vector.<uint> = new Vector.<uint>([0xFFFFFF, 0xFF0000, 0x00FF00, 0x3366FF, 0xFF6600]);	// 
		protected var _graphTransparancies:Vector.<Number> = new Vector.<Number>;											// 
		protected var _graphThicknesses:Vector.<int> = new Vector.<int>;													// 
		
		
		public function BGraph() 
		{
			//initialize();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		// function changeHandler
		// 
		protected function changeHandler(event:Event):void
		{
			drawGraphs();
			
		} // end function changeHandler
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		// function initialize
		//
		override protected function initialize():void
		{
			super.initialize();
			
			// initialize assets
			graphCanvas = new Shape();
			graphs = new Sprite();
			
			
			// add assets to respective containers
			container.addChild(graphCanvas);
			container.addChild(graphs);
			
			
			// other
			equations = new Vector.<BEquation>;
			
			
			// draw
			drawGraphs();
			
			
			// event handling
			//addEventListener(Event.CHANGE, changeHandler);
			
		} // end function initialize
		
		
		// function draw
		// 
		override protected function draw():void
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
		
		
		// function drawGraphs
		// 
		protected function drawGraphs():void
		{
			
			graphs.removeChildren();
			
			for (var i:int = 0; i < equations.length; i++ )
			{
				// set equation and properties
				var equation:BEquation = equations[i];
				
				// 
				var xPos:Number = ( -_lineSpacing * _gridSize / 2) ;
				equation.x = xPos;
				var yPos:Number = -equation.y;
				
				// set the graphics properties 
				var graph:Shape = new Shape();
				graph.graphics.clear();
				graph.graphics.lineStyle(2, 0xFF0000, 1, false, "none");
				graph.graphics.moveTo(xPos, yPos);
				
				// 
				for (var rangeX:int = 0; rangeX <= _lineSpacing * _gridSize; rangeX++ )
				{
					
					xPos = (rangeX -_gridSize/2 * _lineSpacing)/_lineSpacing;
					
					// 
					equation.x = xPos;
					
					yPos = -equation.y;
					
					graph.graphics.lineTo(xPos * _lineSpacing, yPos * _lineSpacing);
					
				} // end for
				
				
				// add the graph to the graphs sprite (container)
				graphs.addChild(graph);
				
			} // end for
			
		} // end function drawGraphs
		
		
		// 
		// 
		public function addEquation(equation:BEquation):BEquation
		{
			equations.push(equation);
			
			drawGraphs();
			
			return equation;
		} // end 
		
		
		// 
		// 
		public function addEquationAt(equation:BEquation, index:int):BEquation
		{
			equations.splice(index, 0, equation);
			drawGraphs();
			return equation;
		} // end 
		
		
		// 
		// 
		public function removeEquation(equation:BEquation):BEquation
		{
			equations.splice(equations.indexOf(equation), 1);
			drawGraphs();
			return equation;
		} // end 
		
		
		// 
		// 
		public function removeEquationAt(index:int):BEquation
		{
			var equation:BEquation = equations[index];
			equations.splice(index, 1);
			drawGraphs();
			return equation;
		} // end 
		
		
		
		//*************************************** SET AND GET **************************************
		
		
		//public function set graphColors:Vector.<uint> = new Vector.<uint>([0xFFFFFF, 0xFF0000, 0x00FF00, 0x3366FF, 0xFF6600]);
		//public function set graphTransparancies:Vector.<Number> = new Vector.<Number>;
		//public function set graphThicknesses:Vector.<int> = new Vector.<int>;
		
		
		
	}

}