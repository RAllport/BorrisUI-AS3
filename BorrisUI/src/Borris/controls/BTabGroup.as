/* Author: Rohaan Allport
 * Date Created: 18/01/2016 (dd/mm/yyyy)
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
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BTabGroup extends EventDispatcher
	{
		// assets
		internal var container:Sprite;
		private var _mask:DisplayObject;
		
		
		// style
		protected var _separatorColor:uint = 0xCCCCCC;
		protected var _separatorWidth:int = 1;
		protected var _separatorTransparancy:Number = 1;
		
		
		// set and get
		internal var _tabs:Array;
		protected var _name:String;
		protected var _selection:BTab;
		protected var _draggable:Boolean = false;
		protected var _tabHeight:Number = 32;
		//protected var _tabMode:String = "";
		
		
		/**
         * Creates a new BTabGroup component instance.
         *
         * @param name The name of the BTabGroup
         */
		public function BTabGroup(name:String) 
		{
			container = new Sprite();
			
			_name = name;
			_tabs = [];
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * 
		 * @param event
		 */
		private function mouseClickHandler(event:MouseEvent):void
		{
			switchTab(event.currentTarget as BTab);
		} // end function mouseClickHandler
		
		
		/**
		 * 
		 * @param event
		 */
		public function dragTab(event:MouseEvent = null):void
		{
			var tab:BTab = event.currentTarget as BTab;
			
			// bring this tab to the top of the display list
			container.setChildIndex(tab, container.numChildren - 1);
			
			// 
			_tabs.sortOn("x", Array.NUMERIC);
			
			// 
			tab.startDrag(false, new Rectangle(0, tab.y, container.width - tab.width, 0));
		
		} // end function dragTab
		
		
		/**
		 * 
		 * @param event
		 */
		public function dropTab(event:MouseEvent = null):void
		{
			var tab:BTab = event.currentTarget as BTab;
			
			tab.stopDrag();
			
			_tabs.sortOn("x", Array.NUMERIC);
			
			_tabs[0].x = 0;
			
			_tabs.forEach(function(element:DisplayObject, index:int, array:Array):void
			{
				if(index > 0)
				{
					//element.x = array[index - 1].x + array[index - 1].width - BPanelTab.RIGHT_SELECTED_OVERFLOW;
					element.x = array[index - 1].x + array[index - 1].width;
				}
				
			});
			
			
		} // end function dropTab
		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * 
		 * @param tab
		 */
		internal function clear(tab:BTab):void
		{
			for (var i:int = 0; i < numTabs; i++ )
			{
				if (_tabs[i] != tab)
				{
					_tabs[i].selected = false;
				}
				//_tabs[i].selected = false;
			}
		} // end function clear
		
		
		/**
		 * Updates the position of the tabs
		 */
		internal function update():void
		{
			//
			if (parent)
			{
				if (parent.stage)
				{
					setContentSize(parent.stage.stageWidth, parent.stage.stageHeight);
				}
				else
				{
					setContentSize(parent.width, parent.height);
				} // end if else
				
			} // end if
			
			var tab:BTab;
			var prevTab:BTab;
			
			for (var i:int = 0; i < _tabs.length; i++ )
			{
				tab = _tabs[i];
				tab.x = 0;
				tab.y = 0;
				tab.height = _tabHeight;
				tab.content.y = _tabHeight + _separatorWidth;
				
				if (i > 0)
				{
					prevTab = _tabs[i - 1];
					tab.x = prevTab.x + prevTab.width;
				}
				
			} // end for
			
			
			// draw the container
			container.graphics.clear();
			container.graphics.beginFill(_separatorColor, _separatorTransparancy);
			//container.graphics.drawRect(0, _tabHeight, tab.parent.stage.stageWidth, _separatorWidth);
			container.graphics.drawRect(0, _tabHeight - 1, tab.content.width + 1000, _separatorWidth);
			container.graphics.endFill();
			
		} // end function update
		
		
		/**
		 * Adds a tab at the bottom of the group.
		 * Adds a tab to the internal tab array for use with 
		 * tab group indexing, which allows for the selection of a single tab
		 * in a group of tabs. This method is used automatically by tabs, 
		 * but can also be manually used to explicitly add a tab to a group.
		 * 
		 * @param tab The BTab instance to be added to the current tab group.
		 */
		public function addTab(tab:BTab):void 
		{
			// if the group name of the button is not the name of this array, then change its group name
			if (tab.group != this) 
			{
				if (tab.group)
				{
					tab.group.removeTab(tab);
				}
				tab.group = this;
				_tabs.push(tab);
			}
			
			if (_tabs.length == 1)
			{
				_selection = tab;
			}
			if (tab.selected) 
			{ 
				selection = tab; 
			}
			
			container.addChild(tab);
			update();
			
			tab.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			draggable = _draggable;
			
		} // function addTab
		
		
		/**
		 * Inserts a tab at the specified position.
		 * 
		 * @param tab The BTab instance to be added to the current tab group.
		 * @param index The (zero-based) position in the group at which to insert the tab.
		 */
		public function addTabAt(tab:BTab, index:int):void
		{
			// if the group name of the button is not the name of this array, then change its group name
			if (tab.group != this) 
			{
				if (tab.group)
				{
					tab.group.removeTab(tab);
				}
				tab.group = this;
				_tabs.splice(index, 0, tab);
			}
			
			if (tab.selected) 
			{ 
				selection = tab; 
			}
			
			container.addChildAt(tab, index);
			update();
			
			tab.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			draggable = _draggable;
			
		} // end function addTabAt
		
		
		/** 
		 * Clears the Tab instance from the internal list of tabs.
		 * 
		 * @param tab The BTab instance to remove.
		 */
		public function removeTab(tab:BTab):void 
		{
			// radio button removal
			/*var i:int = getTabIndex(tab);
			
			if (i != -1) 
			{
				_tabs.splice(i, 1);
			}
			if (_selection == tab) 
			{ 
				_selection = null; 
			}*/
			
			
			// BTabManager removal
			
			// remove the event listeners from the tab
			tab.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			tab.removeEventListener(MouseEvent.MOUSE_DOWN, dragTab);
			tab.removeEventListener(MouseEvent.MOUSE_UP, dropTab);
			tab.removeEventListener(MouseEvent.ROLL_OUT, dropTab);
			
			
			// create a temporary tab
			var tempTab:BTab;
			
			// make sure the tab is not the left most tab.
			// find the tab to the left. If none, find the tab to the right
			if(_tabs.indexOf(tab) > 0)
			{
				var leftTab:BTab = _tabs[_tabs.indexOf(tab, 0) - 1];
				tempTab = leftTab;
			}
			else
			{
				var rightTab:BTab = _tabs[_tabs.indexOf(tab, 0) + 1];
				tempTab = rightTab;
			}
			/*else
			{
				// if no tabs -__-"
			}*/
			
			
			container.removeChild(tab);
			container.removeChild(tab.content.parent);
			
			switchTab(tempTab);
			
			_tabs.splice(_tabs.indexOf(tab), 1);
			
			
			_tabs.forEach(function(element:DisplayObject, index:int, array:Array):void
			{
				array[0].x = 0;
				if(index > 0)
				{
					element.x = array[index - 1].x + array[index - 1].width;
				}
				
			});
			
			//return tab;
			
		} // end 
		
		
		/**
		 * Removes and returns the tab at the specified index.
		 * 
		 * @param index The (zero-based) position of the tab to remove.
		 * 
		 * @return The BDetails object removed.
		 */ 
		public function removeTabAt(index:int):BTab
		{
			
			return null;
		} // end function removeTabAt
		
		
		/**
		 * Retrieves the BTab component at the specified index location.
		 * 
		 * @param index The index of the BTab component in the BTabGroup component, where the index of the first component is 0.
		 * 
		 * @return The specified BTab component.
		 */
		public function getTabAt(index:int):BTab 
		{
			return BTab(_tabs[index]);
		} // end 
		
		
		/**
		 * Returns the index of the specified BTab instance.
		 * 
		 * @param tab The BTab instance to locate in the current BTabGroup.
		 * 
		 * @return The index of the specified BTab component, or -1 if the specified BTab was not found.

		 */
		public function getTabIndex(tab:BTab):int 
		{
			return _tabs.indexOf(tab);
		} // end 

		
		/**
		 * 
		 * 
		 * @param tab
		 */
		public function switchTab(tab:BTab):void
		{
			if (_selection == tab)
			{
				return;
			}
			
			_tabs.forEach(function(element:BTab, index:int, array:Array):void
			{
				element.content.parent.visible = false;
			}
			);
			_selection.content.parent.visible = true;
			tab.content.parent.visible = true;
			
			var prevIndex:int = _tabs.indexOf(_selection);
			var newIndex:int = _tabs.indexOf(tab);
			var difference:int = prevIndex - newIndex;
			
			var tweenFade:Tween;
			var tweenSlide:Tween;
			var tweenSlideToX:int = 0;
			var slideDistance:int = 400;
			
			if (difference > 0)
			{
				tweenFade = new Tween(tab.content.parent, "alpha", Regular.easeOut, 0, 1, 0.3, true);
				tweenSlide = new Tween(tab.content.parent, "x", Regular.easeOut, tweenSlideToX - slideDistance, tweenSlideToX, 0.3, true);
				
				tweenFade = new Tween(_selection.content.parent, "alpha", Regular.easeInOut, _selection.content.parent.alpha, 0, 0.3, true);
				tweenSlide = new Tween(_selection.content.parent, "x", Regular.easeOut, tweenSlideToX, tweenSlideToX + slideDistance, 0.3, true);
			}
			else
			{
				tweenFade = new Tween(tab.content.parent, "alpha", Regular.easeOut, 0, 1, 0.3, true);
				tweenSlide = new Tween(tab.content.parent, "x", Regular.easeOut, tweenSlideToX + slideDistance, tweenSlideToX, 0.3, true);
				
				tweenFade = new Tween(_selection.content.parent, "alpha", Regular.easeInOut, _selection.content.parent.alpha, 0, 0.3, true);
				tweenSlide = new Tween(_selection.content.parent, "x", Regular.easeOut, tweenSlideToX, tweenSlideToX - slideDistance, 0.3, true);
			}
			
			
			
			// set all tabs to not selected
			for(var i:int = 0; i < _tabs.length; i++)
			{
				_tabs[i].selected = false;
			} // end for
			
			tab.selected = true;
			_selection = tab;
			container.setChildIndex(tab, container.numChildren - 1);
			
		} // end function switchTab
	
		
		/**
		 * 
		 */
		public function disableAll():void
		{
			for(var i:int = _tabs.length - 1; i >= 0; i--)
			{
				_tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = false;
				_tabs[i].alpha = 0.5;
				// perhaps disable the container instead. and remember to disbale the content of the tabs
			} // end for
		} // end function disableAll
		
		
		/**
		 * 
		 */
		public function enableAll():void
		{
			for(var i:int = _tabs.length - 1; i >= 0; i--)
			{
				_tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = true;
				_tabs[i].alpha = 1;
				// perhaps enable the container instead. and remember to enable the content of the tabs
			} // end for
		} // end function enableAll
		
		
		/**
		 * 
		 */
		public function setContentSize(width:int, height:int):void
		{
			_tabs.forEach(function(tab:BTab, index:int, array:Array):void
			{
				tab.setContentSize(width, height);
			});
		} // end function setContentSize
		
		
		//**************************************** SET AND GET ******************************************
		
		
		/**
		 * Gets or sets whether the tabs can be dragged and re-ordered physically with a mouse.
		 */
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if (value)
			{
				_tabs.forEach(function(element:BTab, index:int, array:Array):void
				{
					element.addEventListener(MouseEvent.MOUSE_DOWN, dragTab);
					element.addEventListener(MouseEvent.MOUSE_UP, dropTab);
					element.addEventListener(MouseEvent.ROLL_OUT, dropTab);
				}
				);
			}
			else
			{
				_tabs.forEach(function(element:BTab, index:int, array:Array):void
				{
					element.removeEventListener(MouseEvent.MOUSE_DOWN, dragTab);
					element.removeEventListener(MouseEvent.MOUSE_UP, dropTab);
					element.removeEventListener(MouseEvent.ROLL_OUT, dropTab);
				}
				);
			}
		}
		
		
		/**
		 * Gets the instance name of the tab.
		 */
		public function get name():String 
		{
			return _name;
		}

		
		/**
		 * Gets the number of tabs in this tab group.
		 */
		public function get numTabs():int 
		{
			return _tabs.length;
		}
		
		
		/**
		 * Gets or sets the DisplayObjectContainer in which the tabs and their content shoul dbe contained.
		 */
		public function get parent():DisplayObjectContainer
		{
			return container.parent;
		}
		
		public function set parent(value:DisplayObjectContainer):void
		{
			value.addChild(container);
			update();
		}
		
		
		/**
		 * Gets or sets a reference to the tab that is currently selected from the tab group.
		 */
		public function get selection():BTab 
		{
			return _selection;
		}

		public function set selection(value:BTab):void 
		{
			//_selection = value;
			switchTab(value);
		}
		
		
		/**
		 * 
		 */
		public function get separatorWidth():int
		{
			return _separatorWidth;
		}
		
		public function set saparatorWidth(value:int):void
		{
			_separatorWidth = value;
			update();
		}
		
		
		/**
		 * Gets 
		 */
		public function get tabs():Array
		{
			return _tabs;
		}
	}

}