/* Author: Rohaan Allport
 * Date Created: 10/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * 
*/


package Borris.applications
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.desktop.*; // AIR
	import flash.geom.*;
	import flash.net.FileReference;
	import flash.net.FileFilter;

	import fl.managers.StyleManager;

	import Borris.display.*;
	import Borris.desktop.*;
	import Borris.menus.*;
	import Borris.panels.*;
	import Borris.ui.*;
	import Borris.controls.*;
	import Borris.containers.*;
	import Borris.BSlashScreen;


	[SWF(width = '1280', height = '720', backgroundColor = '#333333', frameRate = '30')]
	
	public class BDesktopApplication extends Sprite
	{
		// constants
		public static const MAIN_MENU_HEIGHT: int = 25;
		public static const VERSION:String = "1.0";
		private static const SPALSH_SCREEN:BSlashScreen = new BSlashScreen(VERSION);
		
		
		private static var initialized:Boolean = false;			// 		
		
		// 
		private var panelRect:Rectangle;						// [read-only]
		
		
		// set and get private variables
		private static var _thisApplication:NativeApplication;	// [read-only]
		private static var _mainWindow:NativeWindow;			// [read-only] 
		private static var _menu:BNativeMenu;					// [read-only]
		private var _preferences:XML;							// 
		

		public function BDesktopApplication()
		{
			// constructor code
			
			// check to see if a BDestopApplication has already been made
			if(initialized)
			{
				throw new Error("Only one(1) BDesktopnApplication Object can be created.");
			} // end if
			
			// 
			_thisApplication = NativeApplication.nativeApplication;
			
			
			//_mainWindow = thisApplication.openedWindows[0];
			_mainWindow = stage.nativeWindow;
			_mainWindow.alwaysInFront = false;
			_mainWindow.title = "A BDesktopApplication";
			//_mainWindow.maximize();
			//_mainWindow.menu = appMenu;

			//_mainWindow.bounds = new Rectangle(0, 0, 300, 40);
			//_mainWindow.maxSize = new Point(1000, 40);
			//_mainWindow.minSize = new Point(200, 40);
			//_mainWindow.width = 300;
			//_mainWindow.height = 40;
			_mainWindow.x = Screen.mainScreen.bounds.width / 2 - _mainWindow.width / 2;
			_mainWindow.y = 100;
			_mainWindow.visible = true;

			_mainWindow.stage.align = StageAlign.TOP_LEFT;
			_mainWindow.stage.displayState = StageDisplayState.NORMAL;
			_mainWindow.stage.scaleMode = StageScaleMode.NO_SCALE;

			_mainWindow.activate();
			
			initialized = true;
			
			// stage
			this.stage.stageWidth = 1280;
			this.stage.stageHeight = 720;
			
			
		}
		
		
		// 
		// 
		private function adjustWorkspaceRect():void
		{
			trace("hi man!");
			if(menu == null)
			{
				for(var i:int = 0; i < numChildren - 1; i++)
				{
					getChildAt(i).y -= MAIN_MENU_HEIGHT;
				} //  end for
			} // end if
			
		} // 
		
		
		// 
		
		
		
		//***************************************** SET AND GET *******************************************************
		
		// thisAppliction
		public static function get thisApplication():NativeApplication
		{
			return _thisApplication;
		} // 
		
		
		// mainWindow
		public static function get mainWindow():NativeWindow
		{
			return _mainWindow;
		}
		
		
		// menu
		public static function set menu(value:BNativeMenu):void
		{
			_menu = value;
		}


		public static function get menu():BNativeMenu
		{
			return _menu;
		}


		//***************************************** SET AND GET OVERRIDES************************************************

		override public function addChild(child: DisplayObject): DisplayObject
		{
			if(menu)
			{
				child.y += MAIN_MENU_HEIGHT;
			}
			stage.addChild(child);
			return child;
		}

		override public function addChildAt(child: DisplayObject, index: int): DisplayObject
		{
			if(menu)
			{
				child.y += MAIN_MENU_HEIGHT;
			}
			stage.addChild(child);
			return child;
		}


	}
	
}
