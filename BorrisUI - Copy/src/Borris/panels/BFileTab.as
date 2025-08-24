/* Author: Rohaan Allport
 * Date Created: 30/04/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: A Tab that has a content that can hold DisplayObjects such as the data of a file and can be switched and dragged around and closed.
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
	import Borris.assets.icons.*;
	
	
	public class BFileTab extends BBasePanelTab
	{
		internal static const TOP_BORDER_HEIGHT:uint = 0;				// 
		internal static const BOTTOM_BORDER_HEIGHT:uint = 0;			// 
		internal static const LEFT_BORDER_WIDTH:uint = 8;				// 
		internal static const RIGHT_BORDER_WIDTH:uint = 32;				// 
		
		internal static const LEFT_OVERFLOW:uint = 4;					// 
		internal static const RIGHT_OVERFLOW:uint = 16;					// 
		internal static const LEFT_SELECTED_OVERFLOW:uint = 0;			// 
		internal static const RIGHT_SELECTED_OVERFLOW:uint = 16;		// 
		
		internal static const LABEL_LEFT_MARGIN:uint = 12;				// 
		internal static const LABEL_RIGHT_MARGIN:uint = 1;				// 
		
		
		// asset variables
		private var closeButton:BButton; 								// a button allowing the user to close the tab
		//private var closeButton:BBaseButton;
		
		
		// set and get
		
		
		
		public function BFileTab(label:String = "Label") 
		{
			// constructor code
			super(label);
			
			labelText.x = BFileTab.LEFT_BORDER_WIDTH + BFileTab.LABEL_LEFT_MARGIN;
			
			_width = Math.ceil(labelText.width) + BFileTab.LEFT_BORDER_WIDTH + BFileTab.RIGHT_BORDER_WIDTH + BFileTab.LABEL_RIGHT_MARGIN + BFileTab.LABEL_LEFT_MARGIN;
			
			
			// close button
			closeButton = new BButton(this, BFileTab.LEFT_BORDER_WIDTH, 8);
			closeButton.setSize(12, 12);
			closeButton.setStateColors(0x00000000, 0xcc0000, 0xFF6666, 0x000000, 0x0099cc, 0x00ccff, 0x006699, 0x0099cc); 
			closeButton.setStateAlphas(0, 1, 1, 1, 1, 1, 1, 1);
			closeButton.icon = new XIcon10x10();
			
			trace("bounds height: " + closeButton.getBounds(closeButton).height);
			
			// event handling
			closeButton.addEventListener(MouseEvent.CLICK, closeTab);
			
			draw(100);
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
			
			_content.x = BFilesAttached.BORDER_WIDTH;
			_content.y = BFilesAttached.TOP_BORDER_HEIGHT + BFilesAttached.TOP_BORDER_MARGIN;
			tweenSlideToX = _content.x;
			
		} // end function onAddedToStage
		
		
		
		
		
		// function draw
		// 
		override internal function draw(width:Number):void
		{
			scaleX = scaleY = 1;
			
			// some drawing variables
			var tabHeight:int = 21;									// 
			var selectedTabHeight:int = 24;							// 
			var highLightHeight:int = 4;							// 
			var shineHeight:int = 1;								// 
			var borderThickness:int = 1;							// 
			var unselectedYOffset:int = 1;							// The offset of the bottom of the unselected states to the selected states
			
			var unselectedYPos:int = selectedTabHeight - tabHeight - unselectedYOffset;
			
			var bevelSize:int = 19;
			var selectedBevelSize:int = 22;
			var edgeBevelSize:int = 4;
			
			// grey boomy theme
			
			// upskin
			upSkin.graphics.clear();
			upSkin.graphics.beginFill(_upColor, _upAlpha);			// main color
			upSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			upSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			upSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			upSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			upSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			upSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			upSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			upSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			upSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			upSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			upSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			upSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			upSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			upSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			upSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			upSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			upSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			upSkin.graphics.moveTo(borderThickness, (unselectedYPos + tabHeight - borderThickness) );
			upSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			upSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (edgeBevelSize + unselectedYPos + borderThickness));
			upSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), unselectedYPos + borderThickness);
			upSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			upSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			
			
			upSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			upSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			upSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + unselectedYPos + borderThickness));
			upSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), (unselectedYPos + borderThickness) );
			upSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), (unselectedYPos + borderThickness) );
			upSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + edgeBevelSize + borderThickness));
			upSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + tabHeight - edgeBevelSize - borderThickness - 1));
			
			upSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			upSkin.graphics.moveTo( (edgeBevelSize * 2), (unselectedYPos + borderThickness + shineHeight));
			upSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), (unselectedYPos + borderThickness));
			upSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			upSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			
			upSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			upSkin.graphics.moveTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness + shineHeight) );
			upSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			upSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			upSkin.graphics.lineTo(_width - borderThickness - shineHeight, (unselectedYPos + tabHeight - borderThickness));
			
			
			// over skin
			overSkin.graphics.clear();
			overSkin.graphics.beginFill(_overColor, _overAlpha);			// main color
			overSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			overSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			overSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			overSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			overSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			overSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			overSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			overSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			overSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			overSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			overSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			overSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			overSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			overSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			overSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			overSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			overSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			overSkin.graphics.moveTo(borderThickness, (unselectedYPos + tabHeight - borderThickness) );
			overSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			overSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (edgeBevelSize + unselectedYPos + borderThickness));
			overSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), unselectedYPos + borderThickness);
			overSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			overSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			
			overSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			overSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			overSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + unselectedYPos + borderThickness));
			overSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), (unselectedYPos + borderThickness) );
			overSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), (unselectedYPos + borderThickness) );
			overSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + edgeBevelSize + borderThickness));
			overSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + tabHeight - edgeBevelSize - borderThickness - 1));
			
			overSkin.graphics.beginFill(0x0099CC, 0.5);				// light blue highlight
			overSkin.graphics.moveTo(5, 7);
			overSkin.graphics.lineTo(9, 3);
			overSkin.graphics.lineTo(_width - 19 - 1, 3);
			overSkin.graphics.lineTo(_width - 19 + 3, 7);
			
			overSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			overSkin.graphics.moveTo( (edgeBevelSize * 2), (unselectedYPos + borderThickness + shineHeight));
			overSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), (unselectedYPos + borderThickness));
			overSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			overSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			
			overSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			overSkin.graphics.moveTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness + shineHeight) );
			overSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			overSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			overSkin.graphics.lineTo(_width - borderThickness - shineHeight, (unselectedYPos + tabHeight - borderThickness));
			
			// down skin
			downSkin.graphics.clear();
			downSkin.graphics.beginFill(_downColor, _downAlpha);			// main color
			downSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			downSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			downSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			downSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			downSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			downSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			downSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			downSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			downSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			downSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			downSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			downSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			downSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			downSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			downSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			downSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			downSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			downSkin.graphics.moveTo(borderThickness, (unselectedYPos + tabHeight - borderThickness) );
			downSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			downSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (edgeBevelSize + unselectedYPos + borderThickness));
			downSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), unselectedYPos + borderThickness);
			downSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			downSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			
			
			downSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			downSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			downSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + unselectedYPos + borderThickness));
			downSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), (unselectedYPos + borderThickness) );
			downSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), (unselectedYPos + borderThickness) );
			downSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + edgeBevelSize + borderThickness));
			downSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + tabHeight - edgeBevelSize - borderThickness - 1));
			
			downSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			downSkin.graphics.moveTo( (edgeBevelSize * 2), (unselectedYPos + borderThickness + shineHeight));
			downSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), (unselectedYPos + borderThickness));
			downSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			downSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			
			downSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			downSkin.graphics.moveTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness + shineHeight) );
			downSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			downSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			downSkin.graphics.lineTo(_width - borderThickness - shineHeight, (unselectedYPos + tabHeight - borderThickness));
			
			
			// disabled skin
			disabledSkin.graphics.clear();
			disabledSkin.graphics.beginFill(_disabledColor, _disabledAlpha);			// main color
			disabledSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			disabledSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			disabledSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			disabledSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			disabledSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			disabledSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			disabledSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			disabledSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			disabledSkin.graphics.moveTo(0, (unselectedYPos + tabHeight - 1));
			disabledSkin.graphics.lineTo(edgeBevelSize, ((unselectedYPos + tabHeight - 1 - edgeBevelSize)));
			disabledSkin.graphics.lineTo(edgeBevelSize, (edgeBevelSize + unselectedYPos) );
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2), unselectedYPos);
			disabledSkin.graphics.lineTo(_width - bevelSize, unselectedYPos);
			disabledSkin.graphics.lineTo(_width, (bevelSize + unselectedYPos));
			disabledSkin.graphics.lineTo(_width, (unselectedYPos + tabHeight));
			disabledSkin.graphics.lineTo(0, (unselectedYPos + tabHeight));
			
			disabledSkin.graphics.moveTo(borderThickness, (unselectedYPos + tabHeight - borderThickness) );
			disabledSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			disabledSkin.graphics.lineTo( (borderThickness + edgeBevelSize), (edgeBevelSize + unselectedYPos + borderThickness));
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), unselectedYPos + borderThickness);
			disabledSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			disabledSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			
			
			disabledSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			disabledSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (unselectedYPos + tabHeight - edgeBevelSize - 1));
			disabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + unselectedYPos + borderThickness));
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), (unselectedYPos + borderThickness) );
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), (unselectedYPos + borderThickness) );
			disabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + edgeBevelSize + borderThickness));
			disabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (unselectedYPos + tabHeight - edgeBevelSize - borderThickness - 1));
			
			disabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			disabledSkin.graphics.moveTo( (edgeBevelSize * 2), (unselectedYPos + borderThickness + shineHeight));
			disabledSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), (unselectedYPos + borderThickness));
			disabledSkin.graphics.lineTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness));
			disabledSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			
			disabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			disabledSkin.graphics.moveTo(_width - bevelSize - borderThickness, (unselectedYPos + borderThickness + shineHeight) );
			disabledSkin.graphics.lineTo(_width - bevelSize, (unselectedYPos + borderThickness + shineHeight));
			disabledSkin.graphics.lineTo(_width - borderThickness, (unselectedYPos + tabHeight - borderThickness));
			disabledSkin.graphics.lineTo(_width - borderThickness - shineHeight, (unselectedYPos + tabHeight - borderThickness));
			
			
			
			// selected skins
			
			// selected up skin
			selectedUpSkin.graphics.clear();
			selectedUpSkin.graphics.beginFill(_selectedUpColor, _selectedUpAlpha);			// main color
			selectedUpSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedUpSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedUpSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedUpSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedUpSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedUpSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedUpSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedUpSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedUpSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedUpSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedUpSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedUpSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedUpSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedUpSkin.graphics.moveTo(0, selectedTabHeight);
			selectedUpSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedUpSkin.graphics.lineTo(_width, selectedTabHeight);
			
			selectedUpSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			selectedUpSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), borderThickness);
			selectedUpSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (edgeBevelSize + borderThickness));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (selectedTabHeight - edgeBevelSize - borderThickness * 2) );
			
			selectedUpSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			selectedUpSkin.graphics.moveTo( (edgeBevelSize * 2), (borderThickness + shineHeight));
			selectedUpSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), borderThickness);
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			
			selectedUpSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			selectedUpSkin.graphics.moveTo(_width - selectedBevelSize - shineHeight, (borderThickness + shineHeight));
			selectedUpSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			selectedUpSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedUpSkin.graphics.lineTo(_width - shineHeight, selectedTabHeight);
			
			
			// selected over skin
			selectedOverSkin.graphics.clear();
			selectedOverSkin.graphics.beginFill(_selectedOverColor, _selectedOverAlpha);			// main color
			selectedOverSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedOverSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedOverSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedOverSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedOverSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedOverSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedOverSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedOverSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedOverSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedOverSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedOverSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedOverSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedOverSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedOverSkin.graphics.moveTo(0, selectedTabHeight);
			selectedOverSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedOverSkin.graphics.lineTo(_width, selectedTabHeight);
			
			selectedOverSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			selectedOverSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), borderThickness);
			selectedOverSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (edgeBevelSize + borderThickness));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (selectedTabHeight - edgeBevelSize - borderThickness * 2) );
			
			selectedOverSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			selectedOverSkin.graphics.moveTo( (edgeBevelSize * 2), (borderThickness + shineHeight));
			selectedOverSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), borderThickness);
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			
			selectedOverSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			selectedOverSkin.graphics.moveTo(_width - selectedBevelSize - shineHeight, (borderThickness + shineHeight));
			selectedOverSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			selectedOverSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedOverSkin.graphics.lineTo(_width - shineHeight, selectedTabHeight);
			
			
			// selected down skin
			selectedDownSkin.graphics.clear();
			selectedDownSkin.graphics.beginFill(_selectedDownColor, _selectedDownAlpha);			// main color
			selectedDownSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedDownSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedDownSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedDownSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedDownSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDownSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedDownSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedDownSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedDownSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedDownSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedDownSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedDownSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDownSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedDownSkin.graphics.moveTo(0, selectedTabHeight);
			selectedDownSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedDownSkin.graphics.lineTo(_width, selectedTabHeight);
			
			selectedDownSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			selectedDownSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), borderThickness);
			selectedDownSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (edgeBevelSize + borderThickness));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (selectedTabHeight - edgeBevelSize - borderThickness * 2) );
			
			selectedDownSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			selectedDownSkin.graphics.moveTo( (edgeBevelSize * 2), (borderThickness + shineHeight));
			selectedDownSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), borderThickness);
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			
			selectedDownSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			selectedDownSkin.graphics.moveTo(_width - selectedBevelSize - shineHeight, (borderThickness + shineHeight));
			selectedDownSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			selectedDownSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDownSkin.graphics.lineTo(_width - shineHeight, selectedTabHeight);
			
			
			// selected disabled skin
			selectedDisabledSkin.graphics.clear();
			selectedDisabledSkin.graphics.beginFill(_selectedDisabledColor, _selectedDisabledAlpha);			// main color
			selectedDisabledSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedDisabledSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedDisabledSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedDisabledSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedDisabledSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDisabledSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedDisabledSkin.graphics.beginFill(_borderColor, _borderOuterTransparency);			// border
			selectedDisabledSkin.graphics.moveTo(0, (selectedTabHeight - borderThickness - 1) );
			selectedDisabledSkin.graphics.lineTo(edgeBevelSize, (selectedTabHeight - borderThickness - edgeBevelSize - 1));
			selectedDisabledSkin.graphics.lineTo(edgeBevelSize, edgeBevelSize);
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2), 0);
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize, 0);
			selectedDisabledSkin.graphics.lineTo(_width, selectedBevelSize);
			selectedDisabledSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDisabledSkin.graphics.lineTo(0, selectedTabHeight);
			
			selectedDisabledSkin.graphics.moveTo(0, selectedTabHeight);
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedDisabledSkin.graphics.lineTo(_width, selectedTabHeight);
			
			selectedDisabledSkin.graphics.beginFill(_borderColor, _borderInnerTransparency);			// grad
			selectedDisabledSkin.graphics.moveTo( (edgeBevelSize + borderThickness), (selectedTabHeight - edgeBevelSize - borderThickness));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness), (edgeBevelSize + borderThickness));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness), borderThickness);
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2 + borderThickness * 2), borderThickness);
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (edgeBevelSize + borderThickness));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize + borderThickness * 2), (selectedTabHeight - edgeBevelSize - borderThickness * 2) );
			
			selectedDisabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency);			// shine
			selectedDisabledSkin.graphics.moveTo( (edgeBevelSize * 2), (borderThickness + shineHeight));
			selectedDisabledSkin.graphics.lineTo( (edgeBevelSize * 2 + shineHeight), borderThickness);
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize - borderThickness, borderThickness);
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			
			selectedDisabledSkin.graphics.beginFill(0xFFFFFF, _shineTransparency * 0.75);			// shine
			selectedDisabledSkin.graphics.moveTo(_width - selectedBevelSize - shineHeight, (borderThickness + shineHeight));
			selectedDisabledSkin.graphics.lineTo(_width - selectedBevelSize, (borderThickness + shineHeight));
			selectedDisabledSkin.graphics.lineTo(_width, selectedTabHeight);
			selectedDisabledSkin.graphics.lineTo(_width - shineHeight, selectedTabHeight);
			
		} // end function draw
		
		
		// function closeTab
		// 
		private function closeTab(event:MouseEvent):BFileTab
		{
			trace("File tabe close button clicked");
			// may have to make a custom event
			// Psudocode: 
			// dispatch new TabEvent.TAB_CLOSE
			// - make the tab manager do the rest...
			// splice from tab array
			// remove from tab container
			// 
			
			this.parent.removeChild(this);
			_content.parent.removeChild(_content);
			
			// remove event handlers
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			closeButton.addEventListener(MouseEvent.CLICK, closeTab);

			
			// easy gritty way
			if(this._tabManager)
				this._tabManager.removeTab(this);
			
			return this;
		} // end function closeTab
		
		
		//***************************************** SET AND GET *****************************************
		
		
	}
	
}
