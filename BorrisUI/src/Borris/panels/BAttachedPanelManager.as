/* Author: Rohaan Allport
 * Date Created: 20/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A test class class for trying to create panels that are attached to each other ot the edge of a container
 * 
 * 
*/


package Borris.panels
{
	import flash.display.*;
	import flash.desktop.*;
	import flash.events.*;
	
	
	public class BAttachedPanelManager
	{
		private var container:Sprite;
		private var mh:int = 25; // the height of the menu bar
		
		
		// panel drop target vars
		private var _dropTargets:Array;
		
		
		// panel variables
		private var _panels:Vector.<BPanelAttached>; // read-only. and aray of all the panels.
		private var _openPanels:Vector.<BPanelAttached>; // real-only. the array of all the open panels
		private var _closedPanels:Vector.<BPanelAttached>; //  read-only. the array of all the open panels
		
		private var _window:NativeWindow; // read-only. the winodw of this panel manager
		

		public function BAttachedPanelManager(window:NativeWindow) 
		{
			// constructor code
			_window = window;
			trace("Winodw title: " + _window.title);
			
			// init container
			container = new Sprite();
			container.x = 0;
			container.y = mh; // the height of th main menu.
			_window.stage.addChild(container);
			
			// init panel variables
			_panels = new Vector.<BPanelAttached>;
			_openPanels = new Vector.<BPanelAttached>;
			_closedPanels = new Vector.<BPanelAttached>;
			
			
			// event handling
			//_window.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeAlign);
			//_window.addEventListener(NativeWindowBoundsEvent.RESIZING, resizeAlign);
			
			
			//dropTargets();
			/*var aPanel1:BPanelAttached = new BPanelAttached("right");
			aPanel1.panelWidth = 50;
			aPanel1.panelHeight = _window.stage.stageHeight - mh;
			addPanel(aPanel1);*/
			
			var aPanel2:BPanelAttached = new BPanelAttached("left");
			aPanel2.panelWidth = 50;
			aPanel2.panelHeight = _window.stage.stageHeight - mh;
			addPanel(aPanel2);
			
			/*var aPanel3:BPanelAttached = new BPanelAttached("top");
			aPanel3.panelWidth = 50;
			aPanel3.panelHeight = _window.stage.stageHeight - mh;
			addPanel(aPanel3);*/
		}
		
		
		// function dropTargets
		// a test function
		private function dropTargets():void
		{
			
		} // end function dropTargets
		
		
		// function addPanel
		// 
		public function addPanel(panel:BPanelAttached):BPanelAttached
		{
			trace("Panel height: " + panel.panelHeight);
			
			_panels.push(panel);
			
			// set panel width ad height bass on its position property
			if(panel.position == PanelPosition.LEFT)
			{
				panel.x = 0;
			}
			else if(panel.position == PanelPosition.RIGHT)
			{
				panel.x = _window.stage.stageWidth;
			}
			
			container.addChild(panel);
			
			return panel;
		} // end function addPanel
		
		
		// function removePanel
		// 
		public function removePanel(panel:BPanelAttached):BPanelAttached
		{
			return new BPanelAttached();
		} // end function removePanel
		
		
		// function dragPanel
		// 
		private function dragPanel():void
		{
			
		} // end function dragPanel
		
		
		// function dropPanel
		// 
		private function dropPanel():void
		{
			
		} // end function dropPanel
		
		
		// function resizePanels
		// 
		private function resizePanels():void
		{
			
		} // end function resizePanels
		
		
		// function resizeAlign
		// 
		private function resizeAlign(event:Event = null):void
		{
			for(var i:int = 0; i < _panels.length; i++)
			{
				_panels[i].panelHeight = _window.stage.stageHeight - mh;
				trace(_panels[i].panelHeight);
				
				// set panel width ad height bass on its position property
				if(_panels[i].position == PanelPosition.LEFT)
				{
					_panels[i].x = 0;
					_panels[i].positionAlign(PanelPosition.LEFT);
					trace(_panels[i].panelWidth)
				}
				else if(_panels[i].position == PanelPosition.RIGHT)
				{
					_panels[i].x = _window.stage.stageWidth;
				}
			}
		} // end function resizeAlign
		
		
		
		// ***************************************** SET AND GET *****************************************
		
		
		
	}
	
}
