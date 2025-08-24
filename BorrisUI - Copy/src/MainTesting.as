/* Author: Rohaan Allport
 * Date Created: 31/07/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 *
 *
 *
 *
 */


package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.desktop.*; // AIR
	import flash.geom.*;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.Timer;
	import flash.filters.*;

	import Borris.display.*;
	import Borris.desktop.*;
	import Borris.menus.*;
	import Borris.panels.*;
	import Borris.ui.*;
	import Borris.controls.*;
	import Borris.containers.*;
	import Borris.assets.icons.*;
	
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	[SWF(width = '1280', height = '720', backgroundColor = '#333333', frameRate = '30')]
	public class MainTesting extends Sprite
	{
		// windows
		private var mainWindow:BMainWindow;
		private var newWindow:BNativeWindow;
		
		
		// Panels
		public static var panels: Array;
		
		private var newPanel1:BPanel;
		private var newPanel2:BPanel;
		private var newPanel3:BPanel;
		private var newPanel4:BPanel;
		private var newPanel5:BPanel;
		private var newPanel6:BPanel;
		
		
		public function MainTesting() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left
			
			
			// initialize windows
			mainWindow = new BMainWindow();
			mainWindow.style.backgroundColor = 0x333333;
			
			newWindow = new BNativeWindow();
			newWindow.activate();
			
			newWindow.title = "Borris window";
			newWindow.backgroundDrag = true;
			newWindow.backgroundDrag = false;
			newWindow.alwaysInFront = false;
			
			
			// initialize panels
			/*newPanel1 = new BPanel("New Panel 1");
			newPanel1.panelBounds = mainWindow.panelBounds;
			newPanel1.activate();
			
			newPanel2 = new BPanel("New Panel 2");
			newPanel2.panelBounds = mainWindow.panelBounds;
			newPanel2.activate();
			
			newPanel3 = new BPanel("New Panel 3");
			newPanel3.panelBounds = mainWindow.panelBounds;
			newPanel3.activate();
			newPanel3.x = 2000;
			
			newPanel4 = new BPanel("New Panel 4");
			newPanel4.panelBounds = mainWindow.panelBounds;
			newPanel4.activate();
			newPanel4.width = 3000;
			newPanel4.height = 2000;
			
			newPanel5 = new BPanel("New Panel 5");
			newPanel5.panelBounds = mainWindow.panelBounds;
			newPanel5.activate();
			
			newPanel6 = new BPanel("New Panel 6");
			newPanel6.panelBounds = mainWindow.panelBounds;
			newPanel6.activate();*/
			
			newPanel1 = new BSnappablePanel("New Panel 1");
			newPanel1.panelBounds = mainWindow.panelBounds;
			newPanel1.activate();
			
			newPanel2 = new BSnappablePanel("New Panel 2");
			newPanel2.panelBounds = mainWindow.panelBounds;
			newPanel2.activate();
			
			newPanel3 = new BSnappablePanel("New Panel 3");
			newPanel3.panelBounds = mainWindow.panelBounds;
			newPanel3.activate();
			newPanel3.x = 2000;
			
			newPanel4 = new BSnappablePanel("New Panel 4");
			newPanel4.panelBounds = mainWindow.panelBounds;
			newPanel4.activate();
			newPanel4.width = 3000;
			newPanel4.height = 2000;
			
			newPanel5 = new BSnappablePanel("New Panel 5");
			newPanel5.panelBounds = mainWindow.panelBounds;
			newPanel5.activate();
			
			newPanel6 = new BSnappablePanel("New Panel 6");
			newPanel6.panelBounds = mainWindow.panelBounds;
			newPanel6.activate();
			
			// add panels to appropriate window
			mainWindow.content.addChild(newPanel1);
			mainWindow.content.addChild(newPanel2);
			mainWindow.content.addChild(newPanel3);
			mainWindow.content.addChild(newPanel4);
			mainWindow.content.addChild(newPanel5);
			mainWindow.content.addChild(newPanel6);
			
			
			// run initialization functions
			initializeButtons();
		}
		
		
		/**
		 * 
		 */
		public function initializeButtons():void
		{
			
			
			
		} // end function
		
	}

}