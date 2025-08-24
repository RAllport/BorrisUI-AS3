/* Author: Rohaan Allport
 * Date Created: 07/06/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The BMouseCursor class is an enumeration of constant values used in setting the cursor property of the Mouse class.
 * 
 * 
*/


package Borris.ui
{
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.geom.Point;
	import Borris.assets.cursors.*;
	
	
	public class BMouseCursor 
	{
		// custom cursor
		private static var cursorData:MouseCursorData = new MouseCursorData();
		
		private static var tempVec:Vector.<BitmapData> = new Vector.<BitmapData>;
		
		// move cursor
		tempVec[0] = new CursorMove();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 11);
		Mouse.registerCursor("move", cursorData);
		
		// resize top left cursor
		tempVec[0] = new CursorResizeCorner1();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(8, 8);
		Mouse.registerCursor("resize top left", cursorData);
		
		// resize bottom right cursor
		//tempVec[0] = new CursorResizeCorner1();
		//cursorData.data = tempVec;
		cursorData.hotSpot = new Point(7, 7);
		Mouse.registerCursor("resize bottom right", cursorData);
		
		// resize top right cursor
		tempVec = new Vector.<BitmapData>;
		tempVec.push(new CursorResizeCorner2());
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(8, 7);
		Mouse.registerCursor("resize top right", cursorData);
		
		// resize bottom left cursor
		//tempVec[0] = new CursorResizeCorner2();
		//cursorData.data = tempVec;
		cursorData.hotSpot = new Point(7, 8);
		Mouse.registerCursor("resize bottom left", cursorData);
		
		// resize top edge cursor
		tempVec[0] = new CursorResizeEdgeV();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 11);
		Mouse.registerCursor("resize top", cursorData);
		
		// resize bottom edge cursor
		//tempVec[0] = new CursorResizeEdgeV();
		//cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 10);
		Mouse.registerCursor("resize bottom", cursorData);
		
		// resize left edge cursor
		tempVec[0] = new CursorResizeEdgeH();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 11);
		Mouse.registerCursor("resize left", cursorData);
		
		// resize right edge cursor
		//tempVec[0] = new CursorResizeEdgeH();
		//cursorData.data = tempVec;
		cursorData.hotSpot = new Point(10, 11);
		Mouse.registerCursor("resize right", cursorData);
		
		// resize panel width cursor
		tempVec[0] = new CursorPanelResizeWidth();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 9);
		Mouse.registerCursor("resize width", cursorData);
		
		// resize panel height cursor
		tempVec[0] = new CursorPanelResizeHeight();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 9);
		Mouse.registerCursor("resize height", cursorData);
		
		
		// target
		tempVec[0] = new CursorTarget();
		cursorData.data = tempVec;
		cursorData.hotSpot = new Point(11, 9);
		Mouse.registerCursor("target", cursorData);
		
		
		// window moving
		public static const MOVE:String = "move";
		
		// window resizing
		public static const RESIZE_TOP_LEFT:String = "resize top left";
		public static const RESIZE_TOP_RIGHT:String = "resize top right";
		public static const RESIZE_BOTTOM_LEFT:String = "resize bottom left";
		public static const RESIZE_BOTTOM_RIGHT:String = "resize bottom right";
		public static const RESIZE_TOP:String = "resize top";
		public static const RESIZE_BOTTOM:String = "resize bottom";
		public static const RESIZE_LEFT:String = "resize left";
		public static const RESIZE_RIGHT:String = "resize right";
		
		// panel resizing
		//public static const RESIZE_HEIGHT_TOP:String = "resize height top";
		public static const RESIZE_WIDTH:String = "resize width";
		public static const RESIZE_HEIGHT:String = "resize height";
		
		//misc
		public static const TARGET:String = "target";

		

	}
	
}
