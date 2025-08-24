


package Borris.applications 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	//import flash.desktop.*; // AIR
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
	
	public class BWebApplication extends Sprite 
	{
		// constants
		public static const MAIN_MENU_HEIGHT: int = 25;
		public static const VERSION:String = "1.0";
		private static const SPALSH_SCREEN:BSlashScreen = new BSlashScreen(VERSION);
		
		
		private static var initialized:Boolean = false;			// 		
		
		// 
		private var panelRect:Rectangle;						// [read-only]
		
		
		// set and get private variables
		private static var _thisApplication:BWebApplication;	// [read-only]
		private static var _mainStage:Stage;					// [read-only] 
		private static var _menu:BNativeMenu;					// [read-only]
		private var _preferences:XML;							//  
		
		
		public function BWebApplication() 
		{
			// constructor code
			
			// check to see if a BWebApplication has already been made
			if(initialized)
			{
				throw new Error("Only one(1) BWebApplication Object can be created.");
			} // end if
			initialized = true;
			
			// 
			_thisApplication = this;
			
			if(stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
				
			
		}
		
		
		// function initialize
		// 
		private function initialize(event:Event = null):void
		{
			_mainStage = this.stage;

			
			_mainStage.align = StageAlign.TOP_LEFT;
			_mainStage.displayState = StageDisplayState.NORMAL;
			_mainStage.scaleMode = StageScaleMode.NO_SCALE;
			
			// stage
			this.stage.color = 0x111111;
			this.stage.stageWidth = 1280;
			this.stage.stageHeight = 720;
			
			
			
		} // end function initialize
		
		
		//***************************************** SET AND GET *******************************************************
		
		// thisAppliction
		public static function get thisApplication():BWebApplication
		{
			return _thisApplication;
		} // 
		
		
		// mainStage
		public static function get mainStage():Stage
		{
			return _mainStage;
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
