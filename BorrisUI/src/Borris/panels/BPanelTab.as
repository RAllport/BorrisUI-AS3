/* Author: Rohaan Allport
 * Date Created: 30/04/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Tab that has a content that can hold DisplayObjects such as UI elements and can be switched and dragged around.
 * 				It is also sort of like a button, in that it has different states such as up, over, and selected.
 * 
 * 
*/


package Borris.panels
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import Borris.controls.*;
	import Borris.containers.BScrollPane;
	
	
	public class BPanelTab extends BBasePanelTab
	{
		internal static const TOP_BORDER_HEIGHT:uint = 0;				// 
		internal static const BOTTOM_BORDER_HEIGHT:uint = 0;			// 
		internal static const LEFT_BORDER_WIDTH:uint = 5;				// 
		internal static const RIGHT_BORDER_WIDTH:uint = 5;				// 
		
		internal static const LEFT_OVERFLOW:uint = 0;					// 
		internal static const RIGHT_OVERFLOW:uint = 0;					// 
		internal static const LEFT_SELECTED_OVERFLOW:uint = 0;			// 
		internal static const RIGHT_SELECTED_OVERFLOW:uint = 4;			// 
		
		internal static const LABEL_LEFT_MARGIN:uint = 1;				// 
		internal static const LABEL_RIGHT_MARGIN:uint = 1;				// 
		
		
		// assets
		
		
		// set and get
		
		

		public function BPanelTab(label:String = "Label") 
		{
			// constructor code
			super(label);
			
			labelText.x = BPanelTab.LEFT_BORDER_WIDTH;;
			
			_width = Math.ceil(labelText.width) + BPanelTab.LEFT_BORDER_WIDTH + BPanelTab.RIGHT_BORDER_WIDTH + BPanelTab.LABEL_LEFT_MARGIN + BPanelTab.LABEL_RIGHT_MARGIN;
			
			// event handling
		}
		
		
		// function onAddedToStage
		// 
		override protected function onAddedToStage(event:Event):void
		{
			_upColor = 0x000000;	
			_overColor = 0x000000;	
			_downColor = 0x333333;	
			_disabledColor = 0x000000;	
			
			_selectedUpColor = 0x000000;
			_selectedOverColor = 0x222222;
			_selectedDownColor = 0x555555;
			_selectedDisabledColor = 0x000000;
			
			_upAlpha = 1;	
			_overAlpha = 1;	
			_downAlpha = 1;	
			_disabledAlpha = 1;	
			
			_selectedUpAlpha = 1;
			_selectedOverAlpha = 1;
			_selectedDownAlpha = 1;
			_selectedDisabledAlpha = 1;
			
			_overHighlightColor = 0x0099CC;
			_overHighlightTransparency = 1;
			_shineTransparency = 0;
			_borderColor = 0xCCCCCC;
			_borderOuterTransparency = 1;
			_borderInnerTransparency = 0;
			
			
			super.onAddedToStage(event);
			
			_content.x = BPanelAttached.BORDER_WIDTH + BPanelAttached.CONTENT_MARGIN;
			_content.y = BPanelAttached.TOP_BORDER_HEIGHT + BPanelAttached.TOP_BORDER_MARGIN + BPanelAttached.TAB_AREA_HEIGHT + BPanelAttached.CONTENT_MARGIN;
			tweenSlideToX = _content.x;
			
		} // end function onAddedToStage
		
		
		// function draw
		// 
		override internal function draw(width:Number):void
		{
			scaleX = scaleY = 1;
			
			// some drawing variables
			var tabHeight:int = 20;									// 
			var selectedTabHeight:int = 25;							// 
			var highLightHeight:int = 4;							// 
			var shineHeight:int = 1;								// 
			var borderThickness:int = 1;							// 
			var unselectedYOffset:int = 0;							// The offset of the bottom of the unselected states to the selected states
			
			var unselectedYPos:int = selectedTabHeight - tabHeight - unselectedYOffset;
			
			
			// up skin
			upSkin.graphics.clear();
			upSkin.graphics.beginFill(_upColor, _upAlpha);										// main color
			upSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight); 
			
			upSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);					// border
			upSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight); 
			upSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2)); 
			
			upSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);					// grad (only for left and right)
			upSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2));
			upSkin.graphics.drawRect((borderThickness * 2), (unselectedYPos + borderThickness), _width - (borderThickness * 4), tabHeight - (borderThickness * 2));
			
			upSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);							// shine
			upSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), shineHeight); 
			upSkin.graphics.endFill();
			
			
			// over skin
			overSkin.graphics.clear();
			overSkin.graphics.beginFill(_overColor, _overAlpha);								// main color
			overSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			
			overSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);				// border
			overSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			overSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2)); 
			
			overSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);				// grad (only for left and right)
			overSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2));
			overSkin.graphics.drawRect((borderThickness * 2), (unselectedYPos + borderThickness), _width - (borderThickness * 4), tabHeight - (borderThickness * 2));
			
			overSkin.graphics.beginFill(_overHighlightColor, _overHighlightTransparency);		// light blue highlight
			overSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), highLightHeight);
			
			overSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);							// shine
			overSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), shineHeight);
			overSkin.graphics.endFill();
			
			
			// down skin
			downSkin.graphics.clear();
			downSkin.graphics.beginFill(_downColor, _downAlpha);								// main color
			downSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			
			downSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);				// border
			downSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			downSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2)); 
			
			downSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);				// grad (only for left and right)
			downSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2));
			downSkin.graphics.drawRect((borderThickness * 2), (unselectedYPos + borderThickness), _width - (borderThickness * 4), tabHeight - (borderThickness * 2));
			
			downSkin.graphics.beginFill(_overHighlightColor, _overHighlightTransparency);		// light blue highlight
			downSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), highLightHeight);
			
			downSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);							// shine
			downSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), shineHeight);
			downSkin.graphics.endFill();
			
			
			// disabled skin
			disabledSkin.graphics.clear();
			disabledSkin.graphics.beginFill(_disabledColor, _disabledAlpha);								// main color
			disabledSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			
			disabledSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);				// border
			disabledSkin.graphics.drawRect(0, unselectedYPos, _width, tabHeight);
			disabledSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2)); 
			
			disabledSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);				// grad (only for left and right)
			disabledSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), tabHeight - (borderThickness * 2));
			disabledSkin.graphics.drawRect((borderThickness * 2), (unselectedYPos + borderThickness), _width - (borderThickness * 4), tabHeight - (borderThickness * 2));
			
			disabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);							// shine
			disabledSkin.graphics.drawRect(borderThickness, (unselectedYPos + borderThickness), _width - (borderThickness * 2), shineHeight);
			disabledSkin.graphics.endFill();
			
			
			// selected skins
			
			// selected up skins
			selectedUpSkin.graphics.clear();
			selectedUpSkin.graphics.beginFill(_selectedUpColor, _selectedUpAlpha);				// main color
			selectedUpSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			
			selectedUpSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedUpSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			selectedUpSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			
			selectedUpSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad (only for left and right)
			selectedUpSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			selectedUpSkin.graphics.drawRect((borderThickness * 2), borderThickness, _width - (borderThickness * 4), selectedTabHeight - borderThickness);
			
			selectedUpSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);					// shine
			selectedUpSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), shineHeight);
			selectedUpSkin.graphics.endFill();
			
			
			// selected over skins
			selectedOverSkin.graphics.clear();
			selectedOverSkin.graphics.beginFill(_selectedOverColor, _selectedOverAlpha);				// main color
			selectedOverSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			
			selectedOverSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedOverSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			selectedOverSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			
			selectedOverSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad (only for left and right)
			selectedOverSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			selectedOverSkin.graphics.drawRect((borderThickness * 2), borderThickness, _width - (borderThickness * 4), selectedTabHeight - borderThickness);
			
			selectedOverSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);					// shine
			selectedOverSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), shineHeight);
			selectedOverSkin.graphics.endFill();
			
			
			// selected down skins
			selectedDownSkin.graphics.clear();
			selectedDownSkin.graphics.beginFill(_selectedDownColor, _selectedDownAlpha);				// main color
			selectedDownSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			
			selectedDownSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedDownSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			selectedDownSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			
			selectedDownSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad (only for left and right)
			selectedDownSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			selectedDownSkin.graphics.drawRect((borderThickness * 2), borderThickness, _width - (borderThickness * 4), selectedTabHeight - borderThickness);
			
			selectedDownSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);					// shine
			selectedDownSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), shineHeight);
			selectedDownSkin.graphics.endFill();
			
			
			// selected disabled skins
			selectedDisabledSkin.graphics.clear();
			selectedDisabledSkin.graphics.beginFill(_selectedDisabledColor, _selectedDisabledAlpha);				// main color
			selectedDisabledSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			
			selectedDisabledSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedDisabledSkin.graphics.drawRect(0, 0, _width, selectedTabHeight);
			selectedDisabledSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			
			selectedDisabledSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad (only for left and right)
			selectedDisabledSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), selectedTabHeight - borderThickness);
			selectedDisabledSkin.graphics.drawRect((borderThickness * 2), borderThickness, _width - (borderThickness * 4), selectedTabHeight - borderThickness);
			
			selectedDisabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);					// shine
			selectedDisabledSkin.graphics.drawRect(borderThickness, borderThickness, _width - (borderThickness * 2), shineHeight);
			selectedDisabledSkin.graphics.endFill();
			
			
		} // end function draw
		
		
		
		
		//***************************************** SET AND GET *****************************************
		
		
	}
	
}
