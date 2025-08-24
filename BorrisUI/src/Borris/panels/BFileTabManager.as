/* Author: Rohaan Allport
 * Date Created: 01/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: An object to manage the file tabs of a BFilesAttached or BPanelAttached(2) Object
 * 
 * 
*/


package Borris.panels
{
	import flash.display.*;
	import flash.desktop.*;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	import Borris.panels.*;
	
	
	public class BFileTabManager 
	{
		
		internal var container:Sprite;
		private var _mask:DisplayObject;
		
		// set and get private variables
		private var _tabs:Array;
		
		private var _panel:BFilesAttached;			 		// [read-only]. a refernce to the panel containing this tab manager
		//private var _panel:Object;							// [read-only] a refernce to the panel containing this tab manager
		private var _panelStage:DisplayObjectContainer; 	// [read-only]. a refernce to the panel's stage containing this tab manager
		private var _selectedTab:BFileTab; 					// [read-only]. the currenty selected tab
		
		private var _collapsed:Boolean;						// [read-only] Eventually give this an Accordion behavior
		
		
		public function BFileTabManager(panel:BFilesAttached) 
		{
			// constructor code
			_panel = panel;
			container = new Sprite();
			//panel.stage.addChild(container);
			//container = panel;
			
			_tabs = new Array();
			
			// event handling
			panel.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		// function onAddedToStage
		// 
		private function onAddedToStage(event:Event):void
		{
			//container.x = 10;
			//container.y = 10;
			panel.addChild(container);
			
			if(panel.hasEventListener(Event.ADDED_TO_STAGE))
				panel.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		} // end function onAddedToStage
		
		
		// function update
		// refreshes the FileTabManager container based on the width and height specified
		internal function update():void
		{
			
			_tabs.forEach(function(tab:BFileTab, index:int, array:Array):void
							{
								//tab.setContentSize(panel.width - 92, panel.height - 43 - 4 - 2);
								//tab.setContentSize(panel.width - BFilesAttached.BORDER_WIDTH*2 - BFilesAttached.CONTENT_MARGIN*2 - BFilesAttached.SIZE_OFFSET, panel.height - BFilesAttached.TOP_BORDER_HEIGHT - BFilesAttached.TAB_AREA_HEIGHT - BFilesAttached.BORDER_WIDTH - BFilesAttached.CONTENT_MARGIN*2);
								tab.setContentSize(panel.panelWidth - BFilesAttached.BORDER_WIDTH*2 - BFilesAttached.CONTENT_MARGIN*2 - BFilesAttached.SIZE_OFFSET, panel.panelHeight - BFilesAttached.TOP_BORDER_HEIGHT - BFilesAttached.TAB_AREA_HEIGHT - BFilesAttached.BORDER_WIDTH - BFilesAttached.CONTENT_MARGIN*2);
							});
							
		} // end function update
		
		
		// function addTab
		// 
		public function addTab(tab:BFileTab):BFileTab
		{
			container.addChild(tab);
			tab.x = BFilesAttached.BORDER_WIDTH + BFilesAttached.CONTENT_MARGIN;
			tab.y = BFilesAttached.TAB_AREA_TOP_MARGIN + BFilesAttached.TAB_AREA_HEIGHT - tab.height + 2;
			_tabs.push(tab);
			tab._tabManager = this;
			

			if(_tabs.length == 1)
			{
				tab.selected = true;
			}
			else
				tab.selected = false;
			
			if(_tabs.length > 1)
			{
				// tabs.length - 2 because, -1 for array length offset (the positions start at 0), and -1 again to get the tab to the left
				tab.x = _tabs[_tabs.length - 2].x + _tabs[_tabs.length - 2].width - BFileTab.RIGHT_SELECTED_OVERFLOW;
			}
			
			update();
			
			tab.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			tab.addEventListener(MouseEvent.MOUSE_DOWN, dragTab);
			tab.addEventListener(MouseEvent.MOUSE_UP, dropTab);
			tab.addEventListener(MouseEvent.ROLL_OUT, dropTab);
			
			return tab;
		} // end function addTab
		
		
		// function addTabAt
		// 
		public function addTabAt(tab:BFileTab, index:int):BFileTab
		{
			
			return tab;
		} // end function addTabAt
		
		
		// function removeTab
		// 
		public function removeTab(tab:BFileTab):BFileTab
		{
			//_tabs[_tabs.indexOf(tab, 0) - 1].content = tab.content;
			
			// remove the event listeners from the tab
			tab.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			tab.removeEventListener(MouseEvent.MOUSE_DOWN, dragTab);
			tab.removeEventListener(MouseEvent.MOUSE_UP, dropTab);
			tab.removeEventListener(MouseEvent.ROLL_OUT, dropTab);
			
			
			// create a temporary tab
			var tempTab:BFileTab;
			
			// make sure the tab is not the left most tab.
			// find the tab to the left. If none, find the tab to the right
			if(_tabs.indexOf(tab) > 0)
			{
				//trace("Tab Index: " + _tabs.indexOf(tab));
				var leftTab:BFileTab = _tabs[_tabs.indexOf(tab, 0) - 1];
				tempTab = leftTab;
			}
			else
			{
				var rightTab:BFileTab = _tabs[_tabs.indexOf(tab, 0) + 1];
				tempTab = rightTab;
			}
			/*else
			{
				// if no tabs -__-"
			}*/
			
			
			switchTab(tempTab);
			
			//container.removeChild(tab);
			_tabs.splice(_tabs.indexOf(tab), 1);
			
			
			_tabs.forEach(function(element:DisplayObject, index:int, array:Array):void
							{
								array[0].x = BFilesAttached.BORDER_WIDTH + BFilesAttached.CONTENT_MARGIN;
								if(index > 0)
								{
									//element.x = array[index - 1].x + array[index - 1].width - BFileTab.RIGHT_SELECTED_OVERFLOW;
									element.x = array[index - 1].x + array[index - 1].width - BFileTab.RIGHT_OVERFLOW - BFileTab.LEFT_OVERFLOW;
								}
								
							});
			
			
			return tab;
		} // end function removeTab
		
		
		// function removeTabAt
		// 
		public function removeTabAt(index:int):BFileTab
		{
			
			return null;
		} // end function removeTabAt
		
		
		// function switchTab
		// 
		public function switchTab(tab:BFileTab):void
		{
			//var tab:BFileTab = event.currentTarget as BFileTab;
			
			for(var i:int = 0; i < _tabs.length; i++)
			{
				_tabs[i].selected = false;
				if(tab == _tabs[i])
				{
					tab.selected = true;
					_selectedTab = tab;
					container.setChildIndex(tab, container.numChildren - 1);
				}
			}
			
			trace("selected tab: " + _selectedTab.label)
			
		} // function switchTab
	
		
		// function dragTab
		// 
		public function dragTab(event:MouseEvent = null):void
		{
			var tab:BFileTab = event.currentTarget as BFileTab;
			
			// bring this tab to to top of the display list
			for(var i:int = 0; i < _tabs.length; i++)
			{
				if(tab == _tabs[i])
				{
					container.setChildIndex(tab, container.numChildren - 1);
				}
			}
			
			_tabs.sortOn("x", Array.NUMERIC);
			//trace(_tabs.indexOf(tab, 0));
			
			//tab.startDrag(false, new Rectangle(BFilesAttached.BORDER_WIDTH, tab.y, container.width - BFilesAttached.SIZE_OFFSET - tab.width - BFilesAttached.BORDER_WIDTH, 0));
			tab.startDrag(false, new Rectangle(BFilesAttached.BORDER_WIDTH, tab.y, container.width - tab.width - BFilesAttached.BORDER_WIDTH, 0));
			//tab.startDrag(false, new Rectangle(4, tab.y, _panel.width - 82 - tab.width - 4, 0));
		
		} // end function dragTab
		
		
		// function dropTab
		// 
		public function dropTab(event:MouseEvent = null):void
		{
			var tab:BFileTab = event.currentTarget as BFileTab;
			
			tab.stopDrag();
			
			_tabs.sortOn("x", Array.NUMERIC);
			//trace(_tabs.indexOf(tab, 0));
			
			_tabs[0].x = BFilesAttached.BORDER_WIDTH + BFilesAttached.CONTENT_MARGIN;
			
			_tabs.forEach(function(element:DisplayObject, index:int, array:Array):void
							{
								array[0].x = BFilesAttached.BORDER_WIDTH + BFilesAttached.CONTENT_MARGIN;
								if(index > 0)
								{
									//element.x = array[index - 1].x + array[index - 1].width - BFileTab.RIGHT_SELECTED_OVERFLOW;
									element.x = array[index - 1].x + array[index - 1].width - BFileTab.RIGHT_OVERFLOW - BFileTab.LEFT_OVERFLOW;
								}
								
							});
			
			/*for(var i:int = _tabs.length - 1; i >= 0; i--)
			{
				container.setChildIndex(_tabs[i], i);
				if(_tabs[i].selected)
				{
					container.setChildIndex(_tabs[i], _tabs.length - 1);
				}
			} // end for*/
			
		} // end function dropTab
		
		
		// function disableAll
		// 
		public function disableAll():void
		{
			for(var i:int = _tabs.length - 1; i >= 0; i--)
			{
				_tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = false;
				_tabs[i].alpha = 0.5;
				// perhaps disable the container instead. and remember to disbale the content of the tabs
			} // end for
		} // end function disableAll
		
		
		// function enableAll
		// 
		public function enableAll():void
		{
			for(var i:int = _tabs.length - 1; i >= 0; i--)
			{
				_tabs[i].tabChildren = _tabs[i].tabEnabled = _tabs[i].mouseChildren = _tabs[i].mouseEnabled = true;
				_tabs[i].alpha = 1;
				// perhaps enable the container instead. and remember to enable the content of the tabs
			} // end for
		} // end function enableAll
		
		
		// ************************************** EVENT HANDLING **************************************
		
		// function mouseClickHandler
		// 
		private function mouseClickHandler(event:MouseEvent):void
		{
			switchTab(event.currentTarget as BFileTab);
		} // end function mouseClickHandler

		
		
		//*************************************** SET AND GET *****************************************
		
		// tabs
		public function get tabs():Array
		{
			return _tabs;
		}
		
		// numTabs
		public function get numTabs():int
		{
			return _tabs.length;
		}
		
		// panel
		public function get panel():BFilesAttached
		{
			return _panel;
		}
		
		// panel
		private function get panelStage():DisplayObjectContainer
		{
			return _panelStage;
		}
		
		// selctedTab
		public function get selectedTab():BFileTab
		{
			return _selectedTab;
		}
		
		// mask
		internal function set mask(value:DisplayObject):void
		{
			container.mask = value;
		}
		
		
	}
	
}
