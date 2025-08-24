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
	import Borris.controls.datePickerClasses.BDateCell;
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
	
	public class Main extends Sprite 
	{
		private var newWindowInitOption:NativeWindowInitOptions;
		
		private var mainWindow:BMainWindow;
		private var newWindow:BNativeWindow;
		//private var newWindow:BPanel;
		//private var mainWindow:BPanel;
		private var newWindow2:BPanel;
		
		// menus
		private var mainMenu:BApplicationMenu;
		private var rightClickMenu:BContextMenu;
		private var rightClickMenu2:BCircleMenu;
		
		
		public function Main():void 
		{
			//var bui:BUIComponent = new BUIComponent();
			
			
			trace("Hello world");
			
			// initialize main window
			mainWindow = new BMainWindow();
			//mainWindow.resize(500, 500);
			//mainWindow.content.scaleX = mainWindow.content.scaleY = 3;
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; // set the alignment to the top left
			
			newWindowInitOption = new NativeWindowInitOptions();
			newWindowInitOption.maximizable = true;
			newWindowInitOption.minimizable = true;
			//newWindowInitOption.owner = NativeApplication.nativeApplication.openedWindows[0];
			newWindowInitOption.renderMode = NativeWindowRenderMode.AUTO;
			newWindowInitOption.resizable = true;
			newWindowInitOption.systemChrome = NativeWindowSystemChrome.NONE;
			newWindowInitOption.transparent = true; // SystemChrome must be set to 'none'/'NativeWindowSystemChrome.NONE' to allow this feature
			newWindowInitOption.type = NativeWindowType.NORMAL;
			
			
			//newWindow = new BNativeWindow(newWindowInitOption, new Rectangle(0, 0, 800, 800));
			newWindow = new BNativeWindow();
			newWindow.activate();
			
			// create a BNativeMenu for the newWindow
			//newWindow.bMenu = new BNativeMenu();
			//newWindow.bMenu.addItem(new BNativeMenuItem("Menu Item 1", false, true));
			//newWindow.bMenu.addItem(new BNativeMenuItem("Menu Item 2", false, true));
			//newWindow.bMenu.addItem(new BNativeMenuItem("Menu Item 3", false, true));
			
			newWindow.style.backgroundColor = 0x000000;
			newWindow.style.backgroundOpacity = 1;
			
			newWindow.style.borderColor = 0xff0000;
			newWindow.style.borderOpacity = 1;
			newWindow.style.borderWidth = 2;
			
			newWindow.titleBar.style.backgroundColor = 0x006699;
			newWindow.titleBar.style.backgroundOpacity = 1;
			newWindow.titleBar.style.borderColor = 0x00CCFF;
			newWindow.titleBar.style.borderOpacity = 1;
			newWindow.titleBar.style.borderBottomWidth = 2;
			
			newWindow.title = "Borris window";
			newWindow.backgroundDrag = true;
			newWindow.backgroundDrag = false;
			newWindow.alwaysInFront = false;
			newWindow.windowShape = BNativeWindowShape.RECTANGULAR;
			newWindow.content.scaleX = newWindow.content.scaleY = 1;
			
			
			/*mainWindow = new BPanel("Main Window");
			addChild(mainWindow);
			mainWindow.activate();
			
			newWindow = new BPanel("New Window");
			addChild(newWindow);
			newWindow.activate();*/
			
			newWindow2 = new BPanel("New Window 2");
			mainWindow.content.addChild(newWindow2);
			newWindow2.activate();
			
			
			initializeMenu();
			initializeButtons();
			initializePanels();
			
		}
		
		
		// function initializeMenu
		// 
		private function initializeMenu():void
		{
			trace("menu init");
			
			// make a main menu
			mainMenu = new BApplicationMenu(false);
			mainMenu.display(this.stage, 200, 100);
			newWindow.bMenu = mainMenu;

			var mainMenuFileItem: BNativeMenuItem = new BNativeMenuItem("File", false);
			mainMenuFileItem.keyEquivalentModifiers = [Keyboard.ALTERNATE];
			mainMenuFileItem.keyEquivalent = "A";

			// add items to mainMenu
			mainMenu.addItem(mainMenuFileItem);
			mainMenu.addItem(new BNativeMenuItem("Edit", false));
			mainMenu.addItem(new BNativeMenuItem("View", false));
			mainMenu.addItem(new BNativeMenuItem("Windos", false));
			mainMenu.addItem(new BNativeMenuItem("Help", false));
			mainMenu.addItem(new BNativeMenuItem("", true));
			
			var submenu2:BContextMenu = new BContextMenu();
			submenu2.addItem(new BNativeMenuItem("Menu Item 1", false));
			submenu2.addItem(new BNativeMenuItem("Menu Item 2", false));
			submenu2.addItem(new BNativeMenuItem("Menu Item 3", false));
			submenu2.addItem(new BNativeMenuItem("Menu Item 4", false));
			submenu2.addItem(new BNativeMenuItem("", true));
			submenu2.addItem(new BNativeMenuItem("Menu Item 5", false));
			submenu2.addItem(new BNativeMenuItem("Menu Item 6", false));
			
			var submenu3:BContextMenu = new BContextMenu();
			submenu3.addItem(new BNativeMenuItem("Menu Item 1", false));
			submenu3.addItem(new BNativeMenuItem("Menu Item 2", false));
			submenu3.addItem(new BNativeMenuItem("Menu Item 3", false));
			submenu3.addItem(new BNativeMenuItem("Menu Item 4", false));
			submenu3.addItem(new BNativeMenuItem("", true));
			submenu3.addItem(new BNativeMenuItem("Menu Item 5", false));
			submenu3.addItem(new BNativeMenuItem("Menu Item 6", false));
			
			var editMenu:BContextMenu = new BContextMenu();
			editMenu.addItem(new BNativeMenuItem("Undo", false, true));
			editMenu.addItem(new BNativeMenuItem("Redo", false, false));
			editMenu.addItem(new BNativeMenuItem("", true));
			editMenu.addItem(new BNativeMenuItem("Cut", false, false));
			editMenu.addItem(new BNativeMenuItem("Copy", false, false));
			editMenu.addItem(new BNativeMenuItem("Paste", false, false));
			editMenu.addItem(new BNativeMenuItem("Paste Special", false, false));
			editMenu.addItem(new BNativeMenuItem("Clear", false, false));
			editMenu.addItem(new BNativeMenuItem("", true, false));
			editMenu.addItem(new BNativeMenuItem("Duplicate", false, false));
			editMenu.addItem(new BNativeMenuItem("Select All", false, false));
			
			editMenu.getItemByLabel("Undo").keyEquivalentModifiers = [Keyboard.ALTERNATE];
			editMenu.getItemByLabel("Undo").keyEquivalent = "z";
			editMenu.getItemByLabel("Redo").keyEquivalentModifiers = [Keyboard.ALTERNATE, Keyboard.SHIFT, Keyboard.CONTROL];
			editMenu.getItemByLabel("Redo").keyEquivalent = "y";
			editMenu.getItemByLabel("Undo").keyEquivalentModifiers = [Keyboard.ALTERNATE, Keyboard.SHIFT, Keyboard.CONTROL];
			
			var viewMenu:BContextMenu = new BContextMenu();
			viewMenu.addItem(new BNativeMenuItem("Goto", false, true));
			viewMenu.addItem(new BNativeMenuItem("", true));
			viewMenu.addItem(new BNativeMenuItem("Zoom In", false, true));
			viewMenu.addItem(new BNativeMenuItem("Zoom Out", false, true));
			viewMenu.addItem(new BNativeMenuItem("Magnification", false, true));
			viewMenu.addItem(new BNativeMenuItem("", true, false));
			viewMenu.addItem(new BNativeMenuItem("Rulers", false, false));
			viewMenu.addItem(new BNativeMenuItem("Grid", false, false));
			
			var magnificationSubmenu:BContextMenu = new BContextMenu();
			magnificationSubmenu.addItem(new BNativeMenuItem("Fit in Window", false, true));
			magnificationSubmenu.addItem(new BNativeMenuItem("Center the Stage", false, true));
			magnificationSubmenu.addItem(new BNativeMenuItem("", true));
			magnificationSubmenu.addItem(new BNativeMenuItem("25%", false, true));
			magnificationSubmenu.addItem(new BNativeMenuItem("50%", false, true));
			magnificationSubmenu.addItem(new BNativeMenuItem("100%", false, true));
			magnificationSubmenu.addItem(new BNativeMenuItem("200%", false, false));
			magnificationSubmenu.addItem(new BNativeMenuItem("400%", false, false));
			magnificationSubmenu.addItem(new BNativeMenuItem("800%", false, false));
			magnificationSubmenu.addItem(new BNativeMenuItem("", true, false));
			magnificationSubmenu.addItem(new BNativeMenuItem("Show All", false, false));
			
			mainMenuFileItem.submenu = submenu2;
			mainMenu.getItemAt(1).submenu = editMenu;
			mainMenu.getItemAt(2).submenu = viewMenu;
			viewMenu.getItemByLabel("Magnification").submenu = magnificationSubmenu;
			
			submenu2.getItemAt(5).submenu = submenu3;

			// make an arbitray right click menu
			rightClickMenu = new BContextMenu();
			rightClickMenu2 = new BCircleMenu();
			rightClickMenu2.display(this.stage, 700, 400);
			rightClickMenu2.addItem(new BNativeMenuItem("Cuttt", false));
			rightClickMenu2.addItem(new BNativeMenuItem("Copy", false));
			rightClickMenu2.addItem(new BNativeMenuItem("Paste", false));
			//rightClickMenu2.addItem(new BNativeMenuItem("Clear", false));

			var nMI: BNativeMenuItem = new BNativeMenuItem("Menu item test", false);
			nMI.checked = true;
			nMI.enabled = false;
			nMI.keyEquivalentModifiers = [Keyboard.ALTERNATE];
			nMI.keyEquivalent = "A";
			
			// make a submenu for one of the items in the rightClickMenu
			var submenu1:BContextMenu = new BContextMenu();
			submenu1.addItem(new BNativeMenuItem("Menu Item 1", false));
			submenu1.addItem(new BNativeMenuItem("Menu Item 2", false));
			submenu1.addItem(new BNativeMenuItem("Menu Item 3", false));
			submenu1.addItem(new BNativeMenuItem("Menu Item 4", false));
			submenu1.addItem(new BNativeMenuItem("", true));
			submenu1.addItem(new BNativeMenuItem("Menu Item 5", false));
			submenu1.addItem(new BNativeMenuItem("Menu Item 6", false));
			
			
			var nMI2: BNativeMenuItem = new BNativeMenuItem("Menu item test 2 is a long menu item", false);
			nMI2.checked = true;
			nMI2.enabled = true;
			nMI2.keyEquivalentModifiers = [Keyboard.SHIFT, Keyboard.ALTERNATE];
			nMI2.keyEquivalent = "K";
			nMI2.icon = null;
			nMI2.submenu = submenu1;

			var nMI3: BNativeMenuItem = new BNativeMenuItem("Menu item test 3", false);
			nMI3.checked = false;
			nMI3.enabled = true;
			nMI3.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT, Keyboard.ALTERNATE];
			nMI3.keyEquivalent = "u";
			//nMI3.icon = new AddIcon();
			//nMI3.icon = new ArrowIcon();
			//nMI3.icon = new EditDeleteIcon();

			rightClickMenu.addItem(new BNativeMenuItem("Cut", false));
			rightClickMenu.addItem(new BNativeMenuItem("Copy", false));
			rightClickMenu.addItem(new BNativeMenuItem("Paste", false));
			rightClickMenu.addItem(new BNativeMenuItem("Delete", false));
			rightClickMenu.addItem(new BNativeMenuItem("", true));
			rightClickMenu.addItem(nMI);
			rightClickMenu.addItemAt(nMI2, 8);
			rightClickMenu.addItemAt(nMI3, 9);
			rightClickMenu.addItem(new BNativeMenuItem("", true));
			rightClickMenu.addItem(new BNativeMenuItem("Last Context Item", false));
			//rightClickMenu.getItemAt(2).addEventListener(Event.SELECT, onBrowse);

			if (rightClickMenu.containsItem(nMI))
			{
				trace("rightClickMenu contains nMI");
			}

			//rightClickMenu.display(this.stage, 200, 100);

			//nMI3.addEventListener(MouseEvent.CLICK, onBrowse);

			this.stage.addEventListener(MouseEvent.RIGHT_CLICK, showRightClickMenu);
			
		} // end function initializeMenu
		
		
		// function initializeButtons
		// 
		private function initializeButtons():void
		{
			// make a list
			var list:BList = new BList(mainWindow.content, 50, 50);
			list.autoSize = false;
			list.width = 300;
			list.height = 100;
			list.addItem(new BListItem("this is an item", "data 1"));
			list.addItem(new BListItem("", "data 2"));
			list.addItem(new BListItem("", "data 3"));
			list.addItem(new BListItem("", "data 4"));
			list.addItem(new BListItem("", "data 5"));
			list.addItem(new BListItem("", "data 6"));
			list.addItem(new BListItem("", "data 7"));
			list.addItem(new BListItem("", "data 8"));
			list.addItem(new BListItem("", "data 9"));
			list.addItem(new BListItem("", "data 10"));
			list.addItem(new BListItem("", "data 11"));
			
			list.height = 300;
			list.autoSize = true;
			
			
			trace("List 2 length: " + list.length);
			trace("List 2 row count: " + list.rowCount);
			
			
			/*list.addEventListener(Event.CHANGE, 
			function(event:Event):void
			{
				trace(list
			}
			);*/
			
			
			// make a detail to add to an accordian later
			var details1:BDetails = new BDetails("Details 1");
			
			// make an accordian and add details to it
			var accordion1:BAccordion = new BAccordion(mainWindow.content, 50, 250);
			accordion1.addDetails(details1);
			
			details1.addItem(new AddIconFlat256_256());
			details1.addItem(new BButton(null, 50, 100, "abdcsdbckis"));
			details1.addItem(new BButton(null, 50, 130, "abdcsdbckis"));
			accordion1.getDetailsAt(0).addItem(new BButton(null, 50, 100, "abdcsdbckis"));
			accordion1.addDetails(new BDetails("Details 2"));
			accordion1.getDetailsAt(1).addItem(new BButton(null, 50, 80, "abdcsdbckis"));
			//accordion1.getDetailsAt(1).height = 150;
			accordion1.addDetails(new BDetails("Details 3 HAHAHAHA"));
			accordion1.getDetailsAt(2).addItem(new BButton(null, 50, 100, "abdcsdbckis"));
			accordion1.getDetailsAt(2).indent = 20;
			accordion1.addDetails(new BDetails("Details 4 has a sub details."));
			accordion1.getDetailsAt(3).addItem(new BButton(null, 10, 30, ("Button 1")));
			for (var row:int = 0; row < 10; row++ )
			{
				for (var column:int = 0; column < 10; column++ )
				{
					accordion1.getDetailsAt(3).addItem(new BButton(accordion1.getDetailsAt(3), column * 110, row * 30, ("Button " + row.toString() + "-" + column.toString())));
					//trace(accordion1.getDetailsAt(3).label);
					
				}
			}
			accordion1.addDetails(new BDetails("Details 5"));
			accordion1.getDetailsAt(4).addItem(new BButton(null, 10, 30, ("Button 1")));
			//accordion1.getDetailsAt(3).indent = 20;
			
			
			
			// make arbitrary radio buttons
			var radioButton1:BRadioButton = new BRadioButton(mainWindow.content, 50, 410, "Radio 1");
			var radioButton2:BRadioButton = new BRadioButton(mainWindow.content, 50, 440, "Radio 2", false);
			var radioButton3:BRadioButton = new BRadioButton(mainWindow.content, 50, 470, "Radio 3", false);
			var radioButton4:BRadioButton = new BRadioButton(mainWindow.content, 50, 500, "Radio 4", false);
			var radioButton5:BRadioButton = new BRadioButton(mainWindow.content, 50, 530, "Radio 5", false);
			
			// make a radio button group
			var radioGroup1:BRadioButtonGroup = new BRadioButtonGroup("radio group 1");
			radioGroup1.addRadioButton(radioButton1);
			radioGroup1.addRadioButton(radioButton2);
			radioGroup1.addRadioButton(radioButton3);
			radioGroup1.addRadioButton(radioButton4);
			radioGroup1.addRadioButton(radioButton5);
			trace("num buttons: " + radioGroup1.numRadioButtons);
			
			
			// make an arbitrary icon radio button
			var iRadioButton1:BIconRadioButton = new BIconRadioButton(mainWindow.content, 200, 560, "Icon radio button 1");
			var iRadioButton2:BIconRadioButton = new BIconRadioButton(mainWindow.content, 230, 560, "Icon radio button 2");
			var iRadioButton3:BIconRadioButton = new BIconRadioButton(mainWindow.content, 200, 590, "Icon radio button 3");
			var iRadioButton4:BIconRadioButton = new BIconRadioButton(mainWindow.content, 230, 590, "Icon radio button 4");
			var iRadioButton5:BIconRadioButton = new BIconRadioButton(mainWindow.content, 200, 620, "Icon radio button 5");
			var iRadioButton6:BIconRadioButton = new BIconRadioButton(mainWindow.content, 230, 620, "Icon radio button 6");
			
			//iRadioButton1.setStateColors(0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000, 0xff0000);
			
			var radioGroup2:BRadioButtonGroup = new BRadioButtonGroup("radio group 2");
			radioGroup2.addRadioButton(iRadioButton1);
			radioGroup2.addRadioButton(iRadioButton2);
			radioGroup2.addRadioButton(iRadioButton3);
			radioGroup2.addRadioButton(iRadioButton4);
			radioGroup2.addRadioButton(iRadioButton5);
			radioGroup2.addRadioButton(iRadioButton6);
			
			iRadioButton1.setIcon(null, new PaletteIcon32x32(), new XIcon10x10(), new ArrowIcon32x32(), null, new WindowIcon10x10());
			iRadioButton1.label = "Icon Radio Button 1";
			
			
			//iRadioButton2.setIcon(new BorrisRadioButton_upIcon(), new BorrisRadioButton_overIcon(), new BorrisRadioButton_downIcon(), new BorrisRadioButton_disabledIcon(), new BorrisRadioButton_selectedUpIcon(), new BorrisRadioButton_selectedOverIcon(), new BorrisRadioButton_selectedDownIcon(), new BorrisRadioButton_selectedDisabledIcon());
			iRadioButton2.label = "Icon Radio Button 2 asnxnoaisjoiash[cdoiadshocis";
			
			//iRadioButton3.setIcon(new BorrisRadioButton_upIcon(), new BorrisRadioButton_overIcon(), new BorrisRadioButton_downIcon(), new BorrisRadioButton_disabledIcon(), new BorrisRadioButton_selectedUpIcon(), new BorrisRadioButton_selectedOverIcon(), new BorrisRadioButton_selectedDownIcon(), new BorrisRadioButton_selectedDisabledIcon());
			iRadioButton3.showTooltip = false;
			
			
			
			// make the 3 main button types
			var bBaseButton:BBaseButton = new BBaseButton(mainWindow.content, 400, 50);
			var bLabelButton:BLabelButton = new BLabelButton(mainWindow.content, 400, 80, "B Lable Button 1");
			var bButton:BButton = new BButton(mainWindow.content, 400, 110, "B Button 1");
			
			bLabelButton.setStateColors(0x666666, 0xff0000, 0x00ff00);
			bLabelButton.autoSize = false;
			//bLabelButton.setSize(200, 100);
			//bLabelButton.toggle = true;							// working
			//bLabelButton.setStateColors(-1);						// working
			//bLabelButton.setStateAlphas(0, 0, 0, 0, 0, 0, 0, 0);	// working
			//bLabelButton.enabled = false;							// worning
			//bLabelButton.setSize(100, 100);						// idek anymore
			//bLabelButton.setIcon(new ArrowIcon10x5());			// seems to be working. continue to test a bit longer
			//bLabelButton.setIcon();								// seems to be working.							
			//bLabelButton.setIcon(null, new AlarmIcon32x32(), new ArrowIcon32x32()); same
			//bLabelButton.setIcon(null, new ArrowIcon32x32(), new AlarmIcon32x32()); same
			//bLabelButton.labelPlacement = BButtonLabelPlacement.RIGHT;		// seems to be working
			
			// make check boxes
			var bCheckBox1:BCheckBox = new BCheckBox(mainWindow.content, 200, 410, "B checkbox 1");
			var bCheckBox2:BCheckBox = new BCheckBox(mainWindow.content, 200, 440, "B checkbox 2");
			var bCheckBox3:BCheckBox = new BCheckBox(mainWindow.content, 200, 470, "B checkbox 3");
			var bCheckBox4:BCheckBox = new BCheckBox(mainWindow.content, 200, 500, "B checkbox 4");
			bCheckBox1.selected = true;
			
			// make toggle bottons
			/*var bToggle1:BToggleButton = new BToggleButton(mainWindow.content, 200, 410, "B toggle 1");
			var bToggle2:BToggleButton = new BToggleButton(mainWindow.content, 200, 440, "B toggle 2");
			var bToggle3:BToggleButton = new BToggleButton(mainWindow.content, 200, 470, "B toggle 3");
			var bToggle4:BToggleButton = new BToggleButton(mainWindow.content, 200, 500, "B toggle 4");
			bToggle1.selected = true;
			*/
			// create labels
			var bLabel:BLabel = new BLabel(mainWindow.content, 100, 650, "A List");
			var bLabe2:BLabel = new BLabel(mainWindow.content, 100, 670, "An Accordian");
			var bLabe3:BLabel = new BLabel(mainWindow.content, 100, 690, "Radio Buttons");
			var bLabe4:BLabel = new BLabel(mainWindow.content, 100, 710, "Icon Radio Buttons");
			var bLabe5:BLabel = new BLabel(mainWindow.content, 100, 730, "Check Boxes");
			var bLabe6:BLabel = new BLabel(mainWindow.content, 100, 750, "Buttons");
			
			
			// create sliders
			var bSlider1:BSlider = new BSlider(BSliderOrientation.HORIZONTAL, mainWindow.content, 550, 50);
			bSlider1.labelMode = BSliderLabelMode.MOVE;
			var bSlider2:BSlider = new BSlider(BSliderOrientation.HORIZONTAL, mainWindow.content, 550, 100);
			bSlider2.tickInterval = 20;
			bSlider2.snapInterval = 20;
			var bSlider3:BSlider = new BSlider(BSliderOrientation.VERTICAL, mainWindow.content, 550, 150);
			var bSlider4:BSlider = new BSlider(BSliderOrientation.VERTICAL, mainWindow.content, 600, 150);
			bSlider4.tickInterval = 20;
			bSlider4.snapInterval = 20;
			
			
			// creat range sliders
			var bRangeSlider1:BRangeSlider = new BRangeSlider(BSliderOrientation.HORIZONTAL, mainWindow.content, 550, 400);
			bRangeSlider1.labelMode = BSliderLabelMode.MOVE;
			var bRangeSlider2:BRangeSlider = new BRangeSlider(BSliderOrientation.HORIZONTAL, mainWindow.content, 550, 450);
			bRangeSlider2.tickInterval = 20;
			bRangeSlider2.snapInterval = 20;
			var bRangeSlider3:BRangeSlider = new BRangeSlider(BSliderOrientation.VERTICAL, mainWindow.content, 550, 500);
			var bRangeSlider4:BRangeSlider = new BRangeSlider(BSliderOrientation.VERTICAL, mainWindow.content, 600, 500);
			bRangeSlider4.tickInterval = 10;
			bRangeSlider4.snapInterval = 30;
			
			
			// create text inputs
			var bTextInput1:BTextInput = new BTextInput(mainWindow.content, 50, 560, "Enter text");
			var bTextInput2:BTextInput = new BTextInput(mainWindow.content, 50, 590, "Some pre text");
			var bTextInput3:BTextInput = new BTextInput(mainWindow.content, 50, 620, "width 150");
			bTextInput2.displayAsPassword = true;
			bTextInput3.width = 150;
			
			
			// scrollbars
			var bScrollBar1:BScrollBar = new BScrollBar(BScrollBarOrientation.VERTICAL, mainWindow.content, 450, 500);
			bScrollBar1.scrollBarMode = BScrollBarMode.BUTTONS_ONLY;
			bScrollBar1.scrollBarMode = BScrollBarMode.SLIDER_ONLY;
			bScrollBar1.scrollBarMode = BScrollBarMode.ALL;
			var bScrollBar2:BScrollBar = new BScrollBar(BScrollBarOrientation.VERTICAL, mainWindow.content, 480, 500);
			
			var text:TextField = new TextField();
			text.x = 350;
			text.y = 500;
			text.type = TextFieldType.DYNAMIC;
			text.setTextFormat(new TextFormat(null, 14, 0xffffff));
			text.defaultTextFormat = new TextFormat("Calibri", 14, 0xffffff);
			//text.autoSize = TextFieldAutoSize.LEFT;
			text.multiline = true;
			text.wordWrap = true;
			text.height = 200;
			text.text = "ufvb;rsirhve;orifhe oifehro giher \ngoirh goir hgowirehgoerig ho ioe \n rhiewrhgoiersvho erhgowrihgo;esi hgo; \n irehgorih voeirhgoiwrehg eorihgoeri \n hgoeri ghowerihg eorgih erogiw \n hrgise hils hrlig uhsergiu \n hrgiluehrg ieurhgi";
			text.appendText("\nsbdcsadhciasdhc iuhcfoiaweh \nfoiwehfwei hfoiew fhwoeifh  o ihefpowiahf oiaweh foiaehfoiw hef ihewi fhwoeiahf oihf ius hfie");
			mainWindow.content.addChild(text);
			bScrollBar1.scrollTarget = text;
			
			
			// create a color chooser
			var bColorChooser:BColorChooser = new BColorChooser(mainWindow.content, 800, 400, 0xff0000);
			
			// create and advanced color chooser
			var bAdvColorChooser:BColorChooserAdvanced = new BColorChooserAdvanced(mainWindow.content, 700, 300, 0x00ff00);
			
			// create a numeric stepper
			var numericStepper:BNumericStepper = new BNumericStepper(mainWindow.content, 400, 150);
			numericStepper.buttonPlacement = BNumericStepperButtonPlacement.HORIZONTAL;
			numericStepper.editable = false;
			
			
			
			// create a combo box
			var comboBox:BComboBox = new BComboBox(mainWindow.content, 400, 200);
			//comboBox.dropdown.width = 300;
			comboBox.dropdown.addItem(new BListItem("this is an item", "data 1"));
			comboBox.dropdown.addItem(new BListItem("", "data 2"));
			comboBox.dropdown.addItem(new BListItem("", "data 3"));
			comboBox.dropdown.addItem(new BListItem("", "data 4"));
			comboBox.dropdown.addItem(new BListItem("", "data 5"));
			comboBox.dropdown.addItem(new BListItem("", "data 6"));
			comboBox.dropdown.addItem(new BListItem("", "data 7"));
			comboBox.dropdown.addItem(new BListItem("", "data 8"));
			comboBox.dropdown.addItem(new BListItem("", "data 9"));
			comboBox.dropdown.addItem(new BListItem("", "data 10"));
			comboBox.dropdown.addItem(new BListItem("", "data 11"));
			//comboBox.editable = true;
			//trace("combo box dropdown width: " + comboBox.dropdown.width);
			//comboBox.drawNow();
			//comboBox.setSize(300, 100)
			
			
			// stuff for the custom window
			//newWindow.content.alpha = 0;
			// 
			var sp:BScrollPane = new BScrollPane(newWindow.content, 50, 200);
			sp.setSize(500, 500);
			sp.setSize(300, 300);
			sp.contentPadding = 40;
			sp.style.backgroundColor = 0x006699;
			sp.style.backgroundOpacity = 0.5;
			
			
			
			var b1:BButton = new BButton(sp.content, 100, -100, "Button 1 borris is badass");
			var b2:BButton = new BButton(sp.content, 100, 200, "Button 1");
			var b3:BButton = new BButton(sp.content, 100, 300, "Button 3");
			var b4:BButton = new BButton(sp.content, 100, 400, "Button 4");
			var b5:BButton = new BButton(sp.content, 350, 500, "Button 5");
			var b6:BButton = new BButton(sp.content, 200, 0, "Button 6");
			var b7:BButton = new BButton(sp.content, 300, 0, "Button 7");
			var b8:BButton = new BButton(sp.content, 400, 0, "Button 8");
			var b9:BButton = new BButton(sp.content, 500, 0, "Button 9");
			
			new BButton(newWindow.content, 10, 10, "Resize window to random size").addEventListener(MouseEvent.CLICK, 
			function(event:MouseEvent):void
			{
				//newWindow.resize(Math.random() * (Screen.mainScreen.bounds.width - 300) + 300, Math.random() * (Screen.mainScreen.bounds.height - 200) + 200);
			}
			);
			
			var resizeWindowLabel:BLabel = new BLabel(newWindow.content, 250, 10, "Don't worry! it won't get bigger than your screen.");
			resizeWindowLabel.width = 300;
			
			new BLabel(newWindow.content, 20, 50, "Width");
			new BLabel(newWindow.content, 20, 100, "Hieght");
			
			var widthNumericStepper:BNumericStepper = new BNumericStepper(newWindow.content, 100, 50);
			//widthNumericStepper.maximum = Screen.mainScreen.bounds.width;
			widthNumericStepper.minimum = 300;
			widthNumericStepper.stepSize = 10;
			widthNumericStepper.value = 500;
			
			var heightNumericStepper:BNumericStepper = new BNumericStepper(newWindow.content, 100, 100);
			//heightNumericStepper.maximum = Screen.mainScreen.bounds.height;
			heightNumericStepper.minimum = 300;
			heightNumericStepper.stepSize = 10;
			heightNumericStepper.value = 500;
			
			new BLabelButton(newWindow.content, 100, 150, "Resize").addEventListener(MouseEvent.CLICK,
			function(event:MouseEvent):void
			{
				newWindow.resize(widthNumericStepper.value, heightNumericStepper.value);
			}
			);
			
			
			// style testing
			var uic:BUIComponent = new BUIComponent(mainWindow.content, 100, 100);
			uic.name = "uic";
			uic.setSize(100, 100);
			//uic.style.backgroundColor = 0x222222;
			uic.style.backgroundColor = new Gradient([0x777777, 0x444444], [1, 1], [0, 255], "linear", 90);
			//uic.style.backgroundOpacity = 1;
			uic.style.borderColor = 0xFF2222;
			//uic.style.borderColor = new Gradient([0xff0000, 0x0000ff], [1, 1], [0, 255], "linear", 80);
			uic.style.borderWidth = 4;
			uic.style.borderOpacity = 0.5;
			uic.style.borderRadius = 8;
			
			uic.style.shineHeight = 12;
			uic.style.shineOpacity = 0.4;
			//uic.style.highlightColor = 0x00ffff;
			//uic.style.highlightColor = new Gradient([0xff0000, 0x0000ff], [1, 1], [0, 255], "linear", 90);
			//uic.style.highlightHeight = 25;
			//uic.style.highlightOpacity = 0; 
			
			//uic.style.filters = [new DropShadowFilter(2, 45, 0xff0000, 1, 4, 4, 0.5, 1, false)];
			
			//uic.style.backgroundColor = new Gradient([0x777777, 0x444444], [1, 1], [0, 255], "linear", 90);
			uic.style.borderColor = 0xFF2222;
			uic.style.borderWidth = 4;
			
			uic.style.borderTopWidth = 4;
			uic.style.borderBottomWidth = 2;
			uic.style.borderLeftWidth = 10;
			uic.style.borderRightWidth = 1;
			
			uic.style.borderTopLeftRadius = 10;
			uic.style.borderTopRightRadius = 16
			uic.style.borderBottomLeftRadius = 8;
			uic.style.borderBottomRightRadius = 6;
			//uic.style
			
			uic.setSize(50, 38);
			uic.width = 200;
			
			uic.style.highlightHeight = 20;
			uic.style.highlightOpacity = 0.5;
			uic.style.highlightColor = "blue";
			
			
			var s:BStyle = new BStyle();
			s.backgroundColor = 0xffffff;
			uic.style = s;
			s.borderWidth = 2;
			s.borderColor = "blue";
			uic.move(300, 400);
			
			
			// create a canvas
			var canvas:BCanvas = new BCanvas();
			canvas.x = 100;
			canvas.y = 100;
			canvas.width = 800;
			canvas.height = 600;
			
			canvas.backgroundColor = 0xff0000;
			canvas.backgroundTransparency = 0.5;
			canvas.labelColor = 0x00ff00;
			canvas.labelTransparency = 0.5;
			
			canvas.lineSpacing = 30;
			canvas.lineColor = 0x0000ff;
			canvas.lineThickness = 3;
			
			canvas.axisLineColor = 0xffff00;
			canvas.axisLineThickness = 5;
			canvas.axisLineTransparency = 1;
			
			canvas.labelsPosition = "origin";
			canvas.showLabels = true;
			
			canvas.pan(300, 200);
			canvas.panX = 50;
			canvas.panY = 100;
			canvas.zoom = 1;
			
			canvas.showGrid = false;
			canvas.showGrid = true;
			
			//canvas.gridSize = 60;
			
			//newWindow.content.addChild(canvas);
			
			
			// create a tab
			var tab1:BTab = new BTab("");
			var tab2:BTab = new BTab("Tab 2 is longer");
			var tab3:BTab = new BTab("Tab 3 is even longer");
			var tab4:BTab = new BTab("Tab 4");
			var tab5:BTab = new BTab("Tab 5");
			
			var tabGroup:BTabGroup = new BTabGroup("tab group 1");
			tabGroup.addTab(tab1);
			tabGroup.addTab(tab2);
			tabGroup.addTab(tab3);
			tabGroup.addTab(tab4);
			tabGroup.addTab(tab5);
			tabGroup.parent = newWindow.content;
			tabGroup.draggable = true;
			//tabGroup.removeTab(tab4);
			
			tab1.content.addChild(new BButton(null, 100, 100));
			
			tab1.button.icon = new PaletteIcon32x32();
			
			BScrollPane(tab1.content.parent).style.backgroundColor = 0xff0000;
			BScrollPane(tab2.content.parent).style.backgroundColor = 0x00ff00;
			BScrollPane(tab3.content.parent).style.backgroundColor = 0x0000ff;
			BScrollPane(tab4.content.parent).style.backgroundColor = 0xffff00;
			BScrollPane(tab5.content.parent).style.backgroundColor = 0x00ffff;
			
			BScrollPane(tab1.content.parent).style.backgroundOpacity = 1;
			BScrollPane(tab2.content.parent).style.backgroundOpacity = 1;
			BScrollPane(tab3.content.parent).style.backgroundOpacity = 1;
			BScrollPane(tab4.content.parent).style.backgroundOpacity = 1;
			BScrollPane(tab5.content.parent).style.backgroundOpacity = 1;
			
			//tabGroup.selection = tab1;
			
			// make a date picker
			//var dateCell:BDateCell = new BDateCell(mainWindow.content, 0, 0);
			var datePicker:BDatePicker = new BDatePicker(mainWindow.content, 100, 100);
			
			
			// create a flexbox
			var flexBox:BFlexBox = new BFlexBox(BFlexBox.HORIZONTAL, newWindow2.content, 0, 0);
			flexBox.flexParent = newWindow2;
			flexBox.style.backgroundColor = 0x660000;
			
			flexBox.direction = BFlexBox.HORIZONTAL;
			flexBox.justify = BFlexBox.START;
			flexBox.alignItems = BFlexBox.START;
			//flexBox.alignContent = BFlexBox.START;
			flexBox.flex = BFlexBox.WRAP;
			
			flexBox.horizontalSpacing = 20;
			flexBox.verticalSpacing = 20;
			
			
			// populate the flexbox
			new BBaseButton(flexBox, 0, 100).setSize(80, 80);
			new BBaseButton(flexBox, 150, 100).setSize(100, 100);
			new BBaseButton(flexBox, 300, 100).setSize(50, 50);
			new BBaseButton(flexBox, 450, 100).setSize(80, 80);
			
			
			
		} // end function initializeButtons
		
		
		// function initializePanels
		// 
		private function initializePanels():void
		{
			// create a window
			var window1:BPanel = new BPanel("This is a BPanel");
			window1.titleBarMode = BTitleBarMode.COMPACT_TEXT;		// working
			//window1.backgroundDrag = true;						// working
			//window1.maxWidth = 600;								// working
			//window1.minWidth = 200;								// working
			//window1.maxHeight = 400;								// working
			//window1.minHeight = 200;								// working
			//window1.maxSize = new Point(800, 600);				// working
			window1.minSize = new Point(200, 200);					// working
			//window1.closable = false;								// working
			//window1.maximizable = false;							// working
			//window1.minimizable = false;							// working
			//window1.resizable = false;							// working
			window1.colapsable = true;
			window1.x = 500;
			window1.y = 500;
			
			mainWindow.content.addChild(window1);
			var resizePanelButon:BButton = new BButton(window1.content, 100, 100, "Press to resize!");
			resizePanelButon.addEventListener(MouseEvent.CLICK, 
			function(event:MouseEvent):void
			{
				window1.resize(Math.random() * 1000, Math.random() * 800); 
			}
			);
			
			
			// creat a file window panel
			var fileWindow:BFilesAttached = new BFilesAttached();
			mainWindow.content.addChild(fileWindow);
			fileWindow.x = 100;
			fileWindow.y = 100;
			fileWindow.closable = false;
			fileWindow.detachable = false;
			//fileWindow.draggable = false;
			//fileWindow.resizable = false;
			fileWindow.panelWidth = 600;
			fileWindow.panelHeight = 200;
			fileWindow.maxWidth = 800;
			fileWindow.maxHeight = 800;
			var iconTab:BFileTab = fileWindow.tabManager.addTab(new BFileTab("New Tab"));
			fileWindow.tabManager.addTab(new BFileTab("untiltled1.xml"));
			fileWindow.tabManager.addTab(new BFileTab("untiltffled2.xml"));
			fileWindow.tabManager.addTab(new BFileTab("untd3.xml"));
			fileWindow.tabManager.addTab(new BFileTab("untijgjhgltled4dfg.xml"));
			//fileWindow.tabManager.disableAll();
			
			iconTab.content.addChild(new BCheckBox(null, 0, 0, "checkbox 1"));
			
			
			// create a regular panel
			var aPanel1: BPanelAttached = new BPanelAttached();
			aPanel1.x = 800;
			aPanel1.y = 200;
			aPanel1.panelWidth = 300;
			aPanel1.panelHeight = 300;
			aPanel1.maxWidth = 800;
			aPanel1.maxHeight = 800;
			aPanel1.minWidth = 200;
			aPanel1.minHeight = 200;
			aPanel1.closable = false;
			aPanel1.detachable = false;
			aPanel1.draggable = false;
			//aPanel1.resizable = false;
			//mainWindow.content.addChild(aPanel1);
			

			var aPanel2: BPanelAttached = new BPanelAttached();
			aPanel2.x = 800;
			aPanel2.y = 600;
			aPanel2.panelWidth = 400;
			aPanel2.panelHeight = 400;
			//mainWindow.content.addChild(aPanel2);
			aPanel2.tabManager.addTab(new BPanelTab("A Tab")).content.addChild(new BBaseButton(null, 200, 200));
			aPanel2.tabManager.addTab(new BPanelTab("Another Tab"));
			aPanel2.tabManager.addTab(new BPanelTab("Thrid Tab"));
			aPanel2.tabManager.addTab(new BPanelTab("Last Tab"));
			
			aPanel2.tabManager.getTabByLabel("A Tab").content.addChild(new BSlider(BSliderOrientation.HORIZONTAL, null, 300, 300));
			aPanel2.tabManager.getTabByLabel("Another Tab").content.addChild(new BSlider(BSliderOrientation.VERTICAL, null, 300, 300));
			
			/*panel1 = new BPanelWindow(newWindow);
			panel1.x = 500;
			panel1.y = 100;
			panel1.activate();
			//panel1.resizable = false;

			panel1.tabManager.addTab(new BPanelTab("A Tab"));
			panel1.tabManager.addTab(new BPanelTab("Anoter Tab"));
			panel1.tabManager.addTab(new BPanelTab("Thrid Tab"));
			panel1.tabManager.addTab(new BPanelTab("Last Tab"));


			var panel2: BPanelWindow = new BPanelWindow(mainWindow);
			panel2.activate();
			panel2.closable = false;
			panel2.detachable = false;
			panel2.draggable = false;
			panel2.draggable = true;

			var toolTab: BPanelTab = panel2.tabManager.addTab(new BPanelTab("Tools"));
			toolTab.content = new BButton(null, 0, 0, "This is a long button");
			var newTab: BPanelTab = panel2.tabManager.addTab(new BPanelTab("New Tab"));
			newTab.content = new TestPanelContent();

			panel2.tabManager.addTab(new BPanelTab("Properties"));*/

			

			// attached panels
			//var aPanel1:BPanelAttached = new BPanelAttached();
			//mainWindow.content.addChild(aPanel1);


		} // end function initializePanels
		
		
		// function showRightClickMenu
		// 
		private function showRightClickMenu(event: MouseEvent): void
		{
			rightClickMenu2.display(mainWindow.content.stage, event.stageX, event.stageY);
		} // end function showRightClickMenu
		
		
		// function onBrowse
		// 
		private function onBrowse(event:Event): void
		{
			trace("On File Browse.");

			/*file.browse([new FileFilter("All Files", "*.txt;*.htm;*.html;*.hta;*.htc;*.xhtml"),
				new FileFilter("Text Files", "*.txt"),
				new FileFilter("HTML Documents", "*.htm;*.html;*.hta;*.htc;*.xhtml")
			]);
			file.addEventListener(Event.SELECT, onSelected);*/
		} // end function onBrowse


		
		
	}
	
}