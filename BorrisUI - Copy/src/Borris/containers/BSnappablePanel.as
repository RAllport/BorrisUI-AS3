/* Author: Rohaan Allport
 * Date Created: 26/02/2016 (dd/mm/yyyy)
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
	import flash.events.*;
	import flash.geom.Point;
	
	import Borris.display.BElement;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BSnappablePanel extends BPanel
	{
		// constants
		protected static const SNAP_BAR:BElement = new BElement();
		
		
		// static 
		//protected static var _snappblePanels:Vector.<BPanel> = new Vector.<BPanel>;
		
		
		// assets 
		
		
		// other
		//protected var _resizePosition:String = "";					// The position that the user is resizing the panel from. (topLeft, topRight, left, etc)
		
		protected var _ableToSnap:Boolean = false;					// Used to flag for whether the panel can potentially be snapped.
		protected var _ableToUnSnap:Boolean = false;				// Used to flag for whether the panel can potentially be unsnapped.
		protected var _snapTo:BSnappablePanel;								// Used to determine what panel this panel can be snapped to and what panel this is going to snap to.
		protected var _snapPosition:String = "";					// Used to dertermine the edge of the "snap to" panel to be snapped on.
		protected var _snappedTo:Array;								// Used for keeping track of all the panels this panel is snapped to,
																	// and all the positions at which this panel is snapped.
		protected var _totalSnappedWidth:int;
		protected var _totalSnappedHeight:int;
		protected var _panelToResize:BSnappablePanel;						// Used for checking and getting the panel to resize while this panel is being resized.
		protected var _panelsToResize:Object = new Object();
		
		
		// set and get
		protected var _snappable:Boolean = true;					// Get or set whether this Panel is snappble.
		protected var _snapped:Boolean = false;						// [read-only] Determines whether this panels is snapped or not.
		
		
		public function BSnappablePanel(title:String = "") 
		{
			// contructor code
			super(title);
			
			// set a few style for the snap bar
			SNAP_BAR.style.borderColor = 0x0099CC;
			SNAP_BAR.style.borderOpacity = 0.5;
			SNAP_BAR.style.backgroundColor = 0x000000;
			SNAP_BAR.style.backgroundOpacity = 0.5;
			
			
			snappable = _snappable;
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * Sets variables and and event listeners for resizing and snapping.
		 * 
		 * @param	event
		 */
		override protected function startResizePanel(event:MouseEvent):void
		{
			super.startResizePanel(event);
			
			// check to see if this panel is snapped
			if(_snapped)
			{
				// search throught all the panels this panel is snapped to
				for (var i:int = 0; i < _snappedTo.length; i++)
				{
					var panel:BSnappablePanel = BSnappablePanel(_snappedTo[i].panel);
					var snapPosition:String = String(_snappedTo[i].snapPosition);
					
					// set the penel to be resized. Note, there may be none.
					_panelToResize = panel;
					trace("Panel to resize: " + _panelToResize.title);
					
					if (_resizePosition == "left" && snapPosition == "right")
					{
						_totalSnappedWidth = _width + panel.width;
						break;
					}
					else if (_resizePosition == "right" && snapPosition == "left")
					{
						_totalSnappedWidth = _width + panel.width;
						break;
					}
					else if (_resizePosition == "top" && snapPosition == "bottom")
					{
						_totalSnappedHeight = _height + panel.height;
						break;
					}
					else if (_resizePosition == "bottom" && snapPosition == "top")
					{
						_totalSnappedHeight = _height + panel.height;
						break;
					}
					else
					{
						_panelToResize = null;
					}
					
					/*if (_resizePosition == "left" && snapPosition == "right")
					{
						_panelsToResize.left = panel;
						_panelsToResize.leftTotalSnappedWidth = _width + panel.width;
					}
					else
					{
						_panelsToResize.left = null;
					}
					
					if (_resizePosition == "right" && snapPosition == "left")
					{
						_panelsToResize.right = panel;
						_panelsToResize.rightTotalSnappedWidth = _width + panel.width;
					}
					else
					{
						_panelsToResize.right = null;
					}
					
					if (_resizePosition == "top" && snapPosition == "bottom")
					{
						_panelsToResize.top = panel;
						_panelsToResize.topTotalSnappedWidth = _height + panel.height;
					}
					else
					{
						_panelsToResize.top = null;
					}
					
					if (_resizePosition == "bottom" && snapPosition == "top")
					{
						_panelsToResize.bottom = panel;
						_panelsToResize.topTotalSnappedWidth = _height + panel.height;
					}
					else
					{
						_panelsToResize.bottom = null;
					}*/
					
					
				} // end for 
				
			} // end if
			
		} // end function startResizePanel
		
		
		/**
		 * @inheritDoc
		 */
		override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);
			
			// testing
			// resize any snapped panels while resizing this
			if (_snapped)
				resizeSnappedPenals();
				
		} // end function enterFrameHandler
		
		
		//**************************************** FUNCTIONS ********************************************
		
		/**
		 * 
		 * 
		 * @private Note: later I need to test for the corners and not just edges.
		 * Edges will be a little be more complicated. I want to first test whether 2 panels are already snapped togther.
		 * If so then i want this panel to be be abled (_ableToSnap) to the dimonsions of both panels.
		 * 
		 * This is basically done.
		 */
		protected function testSnappable():void
		{
			var mousePoint:Point = new Point(mouseX, mouseY);
			var testPosX:int = localToGlobal(mousePoint).x;
			var testPosY:int = localToGlobal(mousePoint).y;
			
			// 
			for each(var panel:BSnappablePanel in _panels)
			{
				/*Note: All three 'ifs' can probably be placed as 1 'if' with '&&'
				 * 
				 */
				
				// make sure the panel is not this panel
				if (panel != this)
				{
					// check to see the panels have the same parent
					if (panel.parent == parent)
					{
						// check to see if panel is snappable
						if (panel._snappable)
						{
							
							// left 
							if (panel.resizeGrabberLE.hitTestPoint(testPosX, testPosY))
							{
								// trace("Hitting left edge!");
								_ableToSnap = true;
								_snapPosition = "left";
								_snapTo = panel;
								alpha = 0.4;
								
								SNAP_BAR.style.borderRightWidth = 4;
								SNAP_BAR.style.borderTopLeftRadius = 4;
								SNAP_BAR.style.borderBottomLeftRadius = 4;
								SNAP_BAR.width = 24;
								SNAP_BAR.height = _snapTo.height;
								SNAP_BAR.x = _snapTo.x - SNAP_BAR.width;
								SNAP_BAR.y = _snapTo.y;
								parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
								
								break;
							}
							// right
							else if (panel.resizeGrabberRE.hitTestPoint(testPosX, testPosY))
							{
								// trace("Hitting right edge!");
								_ableToSnap = true;
								_snapPosition = "right";
								_snapTo = panel;
								alpha = 0.4;
								
								SNAP_BAR.style.borderLeftWidth = 4;
								SNAP_BAR.style.borderTopRightRadius = 4;
								SNAP_BAR.style.borderBottomRightRadius = 4;
								SNAP_BAR.width = 24;
								SNAP_BAR.height = _snapTo.height;
								SNAP_BAR.x = _snapTo.x + _snapTo.width;
								SNAP_BAR.y = _snapTo.y;
								parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
								
								break;
							}
							// top
							else if (panel.resizeGrabberTE.hitTestPoint(testPosX, testPosY))
							{
								// trace("Hitting top edge!");
								_ableToSnap = true;
								_snapPosition = "top";
								_snapTo = panel;
								alpha = 0.4;
								
								SNAP_BAR.style.borderBottomWidth = 4;
								SNAP_BAR.style.borderTopLeftRadius = 4;
								SNAP_BAR.style.borderTopRightRadius = 4;
								SNAP_BAR.width = _snapTo.width;
								SNAP_BAR.height = 24;
								SNAP_BAR.x = _snapTo.x;
								SNAP_BAR.y = _snapTo.y - SNAP_BAR.height;
								parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
								
								break;
							}
							// bottom
							else if (panel.resizeGrabberBE.hitTestPoint(testPosX, testPosY))
							{
								// trace("Hitting bottom edge!");
								_ableToSnap = true;
								_snapPosition = "bottom";
								_snapTo = panel;
								alpha = 0.4;
								
								SNAP_BAR.style.borderTopWidth = 4;
								SNAP_BAR.style.borderBottomLeftRadius = 4;
								SNAP_BAR.style.borderBottomRightRadius = 4;
								SNAP_BAR.width = _snapTo.width;
								SNAP_BAR.height = 24;
								SNAP_BAR.x = _snapTo.x;
								SNAP_BAR.y = _snapTo.y + _snapTo.height;
								parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
								
								break;
							}
							else
							{
								_ableToSnap = false;
								_snapPosition = "";
								_snapTo = null;
								alpha = 1;
								
								if (SNAP_BAR.parent)
								{
									// reset the some of the style properties of the snap bar.
									SNAP_BAR.parent.removeChild(SNAP_BAR);
									SNAP_BAR.style.borderLeftWidth = 0;
									SNAP_BAR.style.borderRightWidth = 0;
									SNAP_BAR.style.borderTopWidth = 0;
									SNAP_BAR.style.borderBottomWidth = 0;
									
									SNAP_BAR.style.borderTopLeftRadius = 0;
									SNAP_BAR.style.borderTopRightRadius = 0;
									SNAP_BAR.style.borderBottomLeftRadius = 0;
									SNAP_BAR.style.borderBottomRightRadius = 0;
								}
								
							} // end else ifs
							
							
							/*if snapped then allow unsnapping.
							 * Currently unsnapping will only occur is _ableToSnap is false.
							 * This could also probably just be set in snap() (because logically you should be able to unsnap once you are snapped).
							 * I'm leaving this here because later I could add functionality to to only be able to unsnap for a particular condition, 
							 * eg. only after the user drags the panel for set distance first, and I could leave an after image or a placeholder 
							 * panel the show the user where it is unsnapping from.
							 */
							if(_snapped)
							{
								_ableToUnSnap = true;
							}
							
							// check if the panel has bounderies
							if (panelBounds)
							{
								// left 
								if (panelBounds.leftEdge.hitTestPoint(testPosX, testPosY))
								{
									// trace("Hitting left edge!");
									_ableToSnap = true;
									_snapPosition = "right";
									alpha = 0.4;
									
									SNAP_BAR.style.borderLeftWidth = 4;
									SNAP_BAR.style.borderTopRightRadius = 4;
									SNAP_BAR.style.borderBottomRightRadius = 4;
									SNAP_BAR.width = 24;
									SNAP_BAR.height = panelBounds.innerHeight;
									SNAP_BAR.x = panelBounds.left;
									SNAP_BAR.y = panelBounds.top;
									parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
									
									break;
								}
								// right
								else if (panelBounds.rightEdge.hitTestPoint(testPosX, testPosY))
								{
									// trace("Hitting right edge!");
									_ableToSnap = true;
									_snapPosition = "left";
									alpha = 0.4;
									
									SNAP_BAR.style.borderRightWidth = 4;
									SNAP_BAR.style.borderTopLeftRadius = 4;
									SNAP_BAR.style.borderBottomLeftRadius = 4;
									SNAP_BAR.width = 24;
									SNAP_BAR.height = panelBounds.innerHeight;
									SNAP_BAR.x = panelBounds.right - SNAP_BAR.width;
									SNAP_BAR.y = panelBounds.top;
									parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
									
									break;
								}
								// top
								else if (panelBounds.topEdge.hitTestPoint(testPosX, testPosY))
								{
									// trace("Hitting top edge!");
									_ableToSnap = true;
									_snapPosition = "bottom";
									alpha = 0.4;
									
									SNAP_BAR.style.borderTopWidth = 4;
									SNAP_BAR.style.borderBottomLeftRadius = 4;
									SNAP_BAR.style.borderBottomRightRadius = 4;
									SNAP_BAR.width = panelBounds.innerWidth;
									SNAP_BAR.height = 24;
									SNAP_BAR.x = panelBounds.left;
									SNAP_BAR.y = panelBounds.top;
									parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
									
									break;
								}
								// bottom
								else if (panelBounds.bottomEdge.hitTestPoint(testPosX, testPosY))
								{
									// trace("Hitting bottom edge!");
									_ableToSnap = true;
									_snapPosition = "top";
									alpha = 0.4;
									
									SNAP_BAR.style.borderBottomWidth = 4;
									SNAP_BAR.style.borderTopLeftRadius = 4;
									SNAP_BAR.style.borderTopRightRadius = 4;
									SNAP_BAR.width = panelBounds.innerWidth;
									SNAP_BAR.height = 24;
									SNAP_BAR.x = panelBounds.left;
									SNAP_BAR.y = panelBounds.bottom - SNAP_BAR.height;
									parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
									
									break;
								}
							
								//parent.addChildAt(SNAP_BAR, parent.getChildIndex(this) - 1);
							
							} // end if
							
						} // end if
						
					} // end if
					
				} // end if
				
			} // end for 
			
			
		} // end function testSnappable
		
		
		/**
		 * 
		 */
		protected function snap(position:String = "left"):void
		{
			trace("\nSnapping...");
			
			// get opposite position first
			var oppPosition:String = "";
			switch(position)
			{
				case "left":
					oppPosition = "right";
					break;
				
				case "right":
					oppPosition = "left";
					break;
				
				
				case "top":
					oppPosition = "bottom";
					break;
				
				case "bottom":
					oppPosition = "top";
					break;
				
				
			} // end switch
			
			
			_ableToSnap = false;
			_ableToUnSnap = true;
			tempWidth = _snapped ? tempWidth : _width;
			tempHeight = _snapped ? tempWidth : _height;
			_snapped = true;
			
			alpha = 1;
			
			
			// check if snapping to another panel
			if (_snapTo)
			{
				// make the panel being snapped to also snapped.
				if (!_snapTo._snapped)
				{
					_snapTo._snapped = true;
					_snapTo._ableToUnSnap = true;
					_snapTo.tempWidth = _snapTo._width;
					_snapTo.tempHeight = _snapTo._height;
				} // end if 
				
				
				_snappedTo.push( {panel: _snapTo, snapPosition: position} );
				_snapTo._snappedTo.push( { panel: this, snapPosition: oppPosition } );
				
				trace(this.title + "\t| Snapped To: " + _snapTo.title + "\t| position: " + position)
				trace(_snapTo.title + "\t| Snapped To: " + this.title + "\t| position: " + oppPosition)
				
				
				// 
				switch(position)
				{
					case "left":
						//trace("Snapping to left!");
						//width = 300;
						height = _snapTo.height;
						x = _snapTo.x - _width;
						y = _snapTo.y;
						
						_snapTo._snapPosition = "right";
						
						break;
					
					case "right":
						//trace("Snapping to right!");
						//width = 300;
						height = _snapTo.height;
						x = _snapTo.x + _snapTo.width;
						y = _snapTo.y;
						
						_snapTo._snapPosition = "left";
						
						break;
					
					case "top":
						//trace("Snapping to top!");
						width = _snapTo.width;
						//height = 250;
						x = _snapTo.x;
						y = _snapTo.y - _height;
						
						_snapTo._snapPosition = "bottom";
						
						break;
					
					case "bottom":
						//trace("Snapping to bottom!");
						width = _snapTo.width;
						//height = 250;
						x = _snapTo.x;
						y = _snapTo.y + _snapTo.height;
						
						_snapTo._snapPosition = "top";
						
						break;
					
				} // end switch
			} 
			// check if snapping to bounderies
			else
			{
				var panel:BSnappablePanel;
				var snapPosition:String;
				
				// 
				if(_panelBounds.snappedPanels.length == 0)
				{
					width = _panelBounds.innerWidth;
					height = _panelBounds.innerHeight;
					x = _panelBounds.left;
					y = _panelBounds.top;
				} // end if
				else(_panelBounds.snappedPanels.length > 0)
				{
					switch(position)
					{
						case "left":
							height = _panelBounds.innerHeight;
							x = _panelBounds.right - _width;
							y = _panelBounds.top;
							break;
						
						case "right":
							height = _panelBounds.innerHeight;
							x = _panelBounds.left;
							y = _panelBounds.top;
							
							// get all snapped panels
							for(var i:int = 0; i < _panelBounds.numPanels; i++ )
							{
								//panel = _panelBounds.getPanelAt(i);
								if (_panelBounds.getPanelAt(i) is BSnappablePanel)
								{
									panel = _panelBounds.getPanelAt(i) as BSnappablePanel;
								}
								else
									break;
									
								snapPosition = _panelBounds.getSnappedPosition(panel);
								
								if (panel != this)
								{
									if (snapPosition == "right")
									{
										panel.width = _panelBounds.innerWidth - _width;
										panel.x = x + _width;
										
										_snappedTo.push( {panel: panel, snapPosition: "left"} );
										panel._snappedTo.push( { panel: this, snapPosition: "right" } );
										
									} // end if
								} // end if
								
							} // end for each
							
							break;
						
						case "top":
							width = _panelBounds.innerWidth;
							x = _panelBounds.left;
							y = _panelBounds.bottom - _height;
							break;
						
						case "bottom":
							width = _panelBounds.innerWidth;
							x = _panelBounds.left;
							y = _panelBounds.top;
							break;
						
					} // end switch
					
				} // end if else
				
				_panelBounds.addSnappedPanel(this, position);
				orderToBack();
				
			} // end if else
			
			// remove the snap indicator bar
			if (SNAP_BAR.parent)
			{
				SNAP_BAR.parent.removeChild(SNAP_BAR);
			} // end if
			
		} // end function snap
			
		
		/**
		 * 
		 */
		protected function unSnap():void
		{
			trace("\nUn Snapping...");
			_ableToUnSnap = false;
			_snapped = false;
			width = tempWidth;
			height = tempHeight;
			
			orderToFront();
			
			// search throught all the panels this panel is snapped to
			for (var i:int = 0; i < _snappedTo.length; i++)
			{
				var panel:BSnappablePanel = BSnappablePanel(_snappedTo[i].panel);
				
				// search through all the panels that the current seearch panel is snapped to. (starting from back)
				for (var j:int = panel._snappedTo.length - 1; j >= 0; j--)
				{
					var thisPanel:BSnappablePanel = BSnappablePanel(panel._snappedTo[j].panel);
					
					if (thisPanel == this)
					{
						trace("Panel unsnapped from " + panel.title + " \t| " + thisPanel.title);
						panel._snappedTo.splice(j, 1);
					} // end if
					
					if (panel._snappedTo.length == 0)
					{
						panel._snapped = false;
					} // end if
					
				} // end for 
				
			} // end for 
			
			// reset snapped to
			_snappedTo = [];
			
			// 
			if (_panelBounds)
			{
				trace("has panel bounds!");
				_panelBounds.removeSnappedPanel(this);
			} // end if
			
		} // end function unSnap
		
		
		/* 
		 * Done
		 */
		protected function snapMouseDownHandler(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, snapMouseMoveHandler);
		} // end function snapMouseDownHandler
		
		
		/* 
		 * Done
		 */
		private function snapMouseUpHandler(event:MouseEvent):void 
		{
			//trace("snape mouse up!");
			removeEventListener(MouseEvent.MOUSE_MOVE, snapMouseMoveHandler);
			
			if (_ableToSnap)
			{
				snap(_snapPosition);
			} // end if
			else if(_ableToUnSnap)
			{
				unSnap();
			} // else if
			
		} // end function snapMouseUpHandler
		
		
		/* 
		 * Done
		 */
		private function snapMouseMoveHandler(event:MouseEvent):void 
		{
			//trace("test snappable");
			testSnappable();
		} // end function snapMouseMoveHandler
		
		
		/**
		 * called in enterframeHandler()
		 */
		protected function resizeSnappedPenals():void
		{
			// check to if a panel should be resized
			if (_panelToResize)
			{
				if (_resizePosition == "left")
				{
					_panelToResize.width = _totalSnappedWidth - _width;
				}
				else if(_resizePosition == "right")
				{
					_panelToResize.width = _totalSnappedWidth - _width;
					_panelToResize.x = this.x + _width;
				}
				else if(_resizePosition == "top")
				{
					_panelToResize.height = _totalSnappedHeight - _height;
				}
				else if(_resizePosition == "bottom")
				{
					_panelToResize.height = _totalSnappedHeight - _height;
					_panelToResize.y = this.y + _height;
				} // end else if
				
				// testing. for multiple panels
				/*if (_resizePosition == "left")
				{
					BSnappablePanel(_panelsToResize.left).width = int(_panelsToResize.leftTotalSnappedWidth) - _width;
					//_panelToResize.x = this.x + _width;
				}
				else if(_resizePosition == "right")
				{
					BSnappablePanel(_panelsToResize.right).width = int(_panelsToResize.rightTotalSnappedWidth) - _width;
					BSnappablePanel(_panelsToResize.right).x = this.x + _width;
				}
				else if(_resizePosition == "top")
				{
					BSnappablePanel(_panelsToResize.top).height = int(_panelsToResize.topTotalSnappedHeight) - _height;
					//_panelToResize.y = this.y + _height;
				}
				else if(_resizePosition == "bottom")
				{
					BSnappablePanel(_panelsToResize.bottom).height = int(_panelsToResize.bottomTotalSnappedHeight) - _height;
					BSnappablePanel(_panelsToResize.bottom).y = this.y + _height;
				} // end else if*/
			
			} // end if
			
		} // end function resizeSnappedPenals
		
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets or sets whether the BSnappablePanel can be snapped to other BSnappablePanels, or the the edges if it's parent.
		 * 
		 * @see snap()
		 * @see unSnap()
		 * @see testSnappable()
		 * @see snapMouseDownHandler()
		 * @see snapMouseUpHandler() 
		 */
		public function get snappable():Boolean
		{
			return _snappable;
		}
		
		public function set snappable(value:Boolean):void
		{
			/*if (_snappable == value)
			{
				return;
			}*/
			
			_snappable = value;
			
			if (value)
			{
				_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, snapMouseDownHandler);
				_titleBar.addEventListener(MouseEvent.MOUSE_UP, snapMouseUpHandler);
			}
			else
			{
				_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, snapMouseDownHandler);
				_titleBar.removeEventListener(MouseEvent.MOUSE_UP, snapMouseUpHandler);
			} // end if else
			
			// testing
			_snappedTo = [];
			
		}
		
		
		/**
		 * [read-only] Indicates whether this BSnappablePanel Object is snapped or not.
		 */
		public function get snapped():Boolean
		{
			return _snapped;
		}
		
		
		
	}

}