/* Author: Rohaan Allport
 * Date Created: 19/03/2016 (dd/mm/yyyy)
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
	import Borris.assets.cursors.CursorPanelResizeHeight;
	import flash.display.*;
	
	//import Borris.containers.
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BPanelBounds// extends BElement
	{
		// assets
		private var _container:DisplayObjectContainer;
		
		internal var topleftEdge:Sprite;
		internal var topRightEdge:Sprite;
		internal var bottomLeftEdge:Sprite;
		internal var bottomRightEdge:Sprite;
		internal var topEdge:Sprite;
		internal var bottomEdge:Sprite;
		internal var leftEdge:Sprite;
		internal var rightEdge:Sprite;
		
		
		// other
		
		
		// set and get 
		private var _padding:int = 0;
		private var _x:int = 0;
		private var _y:int = 0;
		private var _width:int = 0;
		private var _height:int = 0;
		
		private var _snappedPanels:Vector.<BPanel> = new Vector.<BPanel>;
		private var _snappedPanelVars:Vector.<Object> = new Vector.<Object>;
		
		private var _edgeThickness:uint = 5;				// The thickness of the resize grabbers. It would be wise to change this on mobile devices, or when a touch event is detected.
		
		
		
		public function BPanelBounds(container:DisplayObjectContainer)
		{
			// contructor code
			_container = container;
			
			// assets
			
			// resize grabbers
			topleftEdge = new Sprite();
			topRightEdge = new Sprite();
			bottomLeftEdge = new Sprite();
			bottomRightEdge = new Sprite();
			topEdge = new Sprite();
			bottomEdge = new Sprite();
			leftEdge = new Sprite();
			rightEdge = new Sprite();
			
			
			// add assets to respective containers
			_container.addChild(topleftEdge);
			_container.addChild(topRightEdge);
			_container.addChild(bottomLeftEdge);
			_container.addChild(bottomRightEdge);
			_container.addChild(topEdge);
			_container.addChild(bottomEdge);
			_container.addChild(leftEdge);
			_container.addChild(rightEdge);
			
			//graphics.beginFill(0xff0000, 0.5);
			//graphics.drawRect(0, 0, 100, 100);
			
			drawEdges();
			draw();
		}
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Draws the edges.
		 */
		private function drawEdges():void
		{
			var color:uint = 0x00FF00;
			var alpha:Number = 0;
			
			topleftEdge.scaleX = 
			topRightEdge.scaleX = 
			bottomLeftEdge.scaleX = 
			bottomRightEdge.scaleX = 
			topEdge.scaleX = 
			bottomEdge.scaleX = 
			leftEdge.scaleX = 
			rightEdge.scaleX = 
			
			topleftEdge.scaleY = 
			topRightEdge.scaleY = 
			bottomLeftEdge.scaleY = 
			bottomRightEdge.scaleY = 
			topEdge.scaleY = 
			bottomEdge.scaleY = 
			leftEdge.scaleY = 
			rightEdge.scaleY = 1;
			
			topleftEdge.alpha = 
			topRightEdge.alpha = 
			bottomLeftEdge.alpha = 
			bottomRightEdge.alpha = 
			topEdge.alpha = 
			bottomEdge.alpha = 
			leftEdge.alpha = 
			rightEdge.alpha = alpha;
			
			topleftEdge.graphics.clear();
			topRightEdge.graphics.clear();
			bottomLeftEdge.graphics.clear();
			bottomRightEdge.graphics.clear();
			topEdge.graphics.clear();
			bottomEdge.graphics.clear();
			leftEdge.graphics.clear();
			rightEdge.graphics.clear();
			
			
			var grabbersWidth:int = _width - _padding * 2;		// 
			var grabbersHeight:int = _height - _padding * 2;		// 
			
			topleftEdge.graphics.beginFill(color, 1);
			topRightEdge.graphics.beginFill(color, 1);
			bottomLeftEdge.graphics.beginFill(color, 1);
			bottomRightEdge.graphics.beginFill(color, 1);
			topEdge.graphics.beginFill(color, 1);
			bottomEdge.graphics.beginFill(color, 1);
			leftEdge.graphics.beginFill(color, 1);
			rightEdge.graphics.beginFill(color, 1);
			
			topleftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			topRightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			bottomLeftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			bottomRightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			topEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			bottomEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			leftEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			rightEdge.graphics.drawRect(0, 0, _edgeThickness, _edgeThickness);
			
			topleftEdge.graphics.endFill();
			topRightEdge.graphics.endFill();
			bottomLeftEdge.graphics.endFill();
			bottomRightEdge.graphics.endFill();
			topEdge.graphics.endFill();
			bottomEdge.graphics.endFill();
			leftEdge.graphics.endFill();
			rightEdge.graphics.endFill();
			
		} // end function drawEdges
		
		
		/**
		 * 
		 */
		protected function draw():void
		{
			// resize grabbers
			topleftEdge.x = _padding;
			topleftEdge.y = _padding;
			topRightEdge.x = _width - _padding - _edgeThickness;
			topRightEdge.y = _padding;
			bottomLeftEdge.x = _padding;
			bottomLeftEdge.y = _height - _padding - _edgeThickness;
			bottomRightEdge.x = _width - _padding - _edgeThickness;
			bottomRightEdge.y = _height - _padding - _edgeThickness;
			
			topEdge.x = _padding + _edgeThickness;
			topEdge.y = _padding;
			bottomEdge.x = _padding + _edgeThickness;
			bottomEdge.y = _height - _padding - _edgeThickness;
			leftEdge.x = _padding;
			leftEdge.y = _padding + _edgeThickness;
			rightEdge.x = _width - _padding - _edgeThickness;
			rightEdge.y = _padding + _edgeThickness;
			
			topEdge.width = _width - (_padding * 2) - (_edgeThickness * 2);
			bottomEdge.width = _width - (_padding * 2) - (_edgeThickness * 2);
			leftEdge.height = _height - (_padding * 2) - (_edgeThickness * 2);
			rightEdge.height = _height - (_padding * 2) - (_edgeThickness * 2);
			
		} // end function draw
		
		
		/**
		 * 
		 */
		internal function contains(panel:BPanel):Boolean
		{
			return (_snappedPanels.indexOf(panel) >= 0);
		} // enf function contains
		
		/**
		 * 
		 * @param	panel
		 */
		internal function addSnappedPanel(panel:BPanel, snappedPosition:String):void
		{
			/*if (!contains(panel))
			{
				
				
			} // end if*/
			
			_snappedPanelVars.push( { panel: panel, snapPosition: snappedPosition } );
			_snappedPanels.push(panel);
			
			//trace("snapped panel length: " + _snappedPanelVars.length);
		}
		
		/**
		 * 
		 * @param	panel
		 */
		internal function removeSnappedPanel(panel:BPanel):void
		{
			
			if (contains(panel))
			{
				_snappedPanels.splice(_snappedPanels.indexOf(panel), 1);
				_snappedPanelVars.splice(_snappedPanels.indexOf(panel), 1);
			} // end if
			
		}
		
		
		/**
		 * 
		 * @param	
		 */
		internal function getPanelAt(index:int):BPanel
		{
			return _snappedPanels[index];
		} // end function getPanelAt
		
		
		internal function getSnappedPosition(panel:BPanel):String
		{
			if (contains(panel))
			{
				return _snappedPanelVars[_snappedPanels.indexOf(panel)].snapPosition as String;
			}
			
			return "";
			
		} // end function getSnappedPosition
		
		/**
		 * 
		 */
		/*internal function forEachPanel(callBack:Function):void
		{
			var panel:BPanel;
			
			for(var i:int = 0; i < numPanels; i++)
			{
				panel = getPanelAt(i);
				callBack();
			} // end 
			
		} // end function forEachPanel*/
		
		
		//**************************************** SET AND GET ******************************************
		
		/**
		 * Gets or sets the container that this PanelBounds is registered in.
		 */
		public function get container():DisplayObjectContainer
		{
			return _container;
		}
		
		public function set container(value:DisplayObjectContainer):void
		{
			_container = container;
			
			_container.addChild(topleftEdge);
			_container.addChild(topRightEdge);
			_container.addChild(bottomLeftEdge);
			_container.addChild(bottomRightEdge);
			_container.addChild(topEdge);
			_container.addChild(bottomEdge);
			_container.addChild(leftEdge);
			_container.addChild(rightEdge);
		}
		
		
		/**
		 * Gets or sets the padding of the PanelBounds.
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
		 * Gets or sets the x coordinate of the top-left corner of the PanelBounds.
		 */
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
			draw();
		}
		
		
		/**
		 * Gets or sets the y coordinate of the top-left corner of the PanelBounds.
		 */
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value
			draw();
		}
		
		
		/**
		 * Gets or sets the width of the PanelBounds, in pixels.
		 */
		public function get width():int
		{
			return _y;
		}
		
		public function set width(value:int):void
		{
			_width = value
			draw();
		}
		
		
		/**
		 * Gets or sets the height of the PanelBounds, in pixels.
		 */
		public function get height():int
		{
			return _height;
		}
		
		public function set height(value:int):void
		{
			_height = value
			draw();
		}
		
		
		/**
		 * [read-only] The width of the bounderies, in pixels.
		 */
		public function get innerWidth():int
		{
			return _width - _padding * 2;
		}
		
		
		/**
		 * [read-only] The height of the bounderies, in pixels.
		 */
		public function get innerHeight():int
		{
			return _height - _padding * 2;
		}
		
		
		/**
		 * [read-only] The y coordinate of the top of the border bounderies.
		 * This is the sum of the y and padding properties.
		 */
		public function get top():int
		{
			return _y + _padding;
		}
		
		
		/**
		 * [read-only] The y coordinate of the bottom of the border bounderies.
		 * This is the sum of the y and height properties minus the padding property.
		 */
		public function get bottom():int
		{
			return _y + _height - _padding;
		}
		
		
		/**
		 * [read-only] The y=x coordinate of the left of the border bounderies.
		 * This is the sum of the x and padding properties.
		 */
		public function get left():int
		{
			return _x + _padding;
		}
		
		
		/**
		 * [read-only] The x coordinate of the right of the border bounderies.
		 * This is the sum of the x and width properties minus the padding property.
		 */
		public function get right():int
		{
			return _x + _width - _padding;
		}
		
		
		
		/**
		 * [read-only]
		 */
		public function get snappedPanels():Vector.<BPanel>
		{
			return _snappedPanels;
		}
		
		
		/**
		 * [read-only]
		 */
		public function get numPanels():int
		{
			return _snappedPanels.length;
		}
		
		
		/**
		 * Gets or sets the thickness of the boundery edges. 
		 * 
		 * <p>The Edges are used for snappable panels as a way to snap to the boundery. They cannot be seen by the user.</p>
		 * 
		 * @default 5
		 */
		public function get edgeThickness():uint
		{
			return _edgeThickness;
		}
		
		public function set edgeThickness(value:uint):void
		{
			_edgeThickness = value;
			drawEdges();
			draw();
		}
		
	}

}