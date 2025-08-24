/* Author: Rohaan Allport
 * Date Created: 01/30/2016 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: The base Borris user interface component.
 * 
 * Todos:
	 * 
 * 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.desktop.*;
	import flash.text.*;
	import flash.geom.Point;
	import flash.filters.*;
	import flash.utils.Timer;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.controls.datePickerClasses.*;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	public class BDatePicker extends BUIComponent
	{
		// constants
		private static const WEEK_DAYS:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		private static const MONTHS:Array = [
                                {label: "January", data: 0},
                                {label: "February", data: 1},
                                {label: "March", data: 2},
                                {label: "April", data: 3},
                                {label: "May", data: 4},
                                {label: "June", data: 5},
                                {label: "July", data: 6},
                                {label: "August", data: 7},
                                {label: "September", data: 8},
                                {label: "October", data: 9},
                                {label: "November", data: 10},
                                {label: "December", data: 11},
                            ];
		private static var DAYS_OF_MONTHS:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		
		
		// assets
		protected var monthPickerCB:BComboBox; 						// Combobox to pick a month.
		protected var yearPickerNS:BNumericStepper;					// Numeric stepper to pick a year.
		
		protected var cellDaysContainer:Sprite;
		protected var cellMonthsContainer:Sprite;
		protected var cellYearsContainer:Sprite;
		
		protected var currentTimeLabel:BLabel;
		protected var currentDateLabel:BLabel;
		
		
		// style
		public var cellWidth:int = 40;
		public var cellHeight:int = 40;
		public var cellPadding:int = 2;
		
		private var currentTimeTF:TextFormat;
		private var currentDateTF:TextFormat;
		
		
		// other
		private var dateCells:Array = new Array();
		private var currentDateTime:Date = new Date();
		private var firstDay:Date = new Date(currentDateTime.fullYear, currentDateTime.month);
		private var firstDayColumn:uint = firstDay.day;
		private var maxDays:uint;
		
		
		// set and get
		protected var _currentDay:String;						// [read-only]
		protected var _currentDate:String;
		protected var _currentMonth:String;						// [read-only]
		protected var _currentYear:int;							// [read-only]
		
		protected var _selectedDay:String;
		protected var _selectedMonth:String;
		protected var _selectedYear:int;
		
		protected var _showCurrentTime:Boolean = false;
		protected var _showCurrentDate:Boolean = false;
		
		
		
		public function BDatePicker(parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) 
		{
			super(parent, x, y);
			initialize();
			setSize((cellWidth + cellPadding) * 7 + 20 - cellPadding, 470);
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		/**
		 * 
		 * @param event
		 */
		protected function pickMonth(event:Event):void
		{
			firstDay.month = BComboBox(event.target).selectedItem.data;
    		monthsSetup();
		} // end function pickMonth
		
		
		/**
		 * 
		 * 
		 * @param event
		 */
		protected function pickYear(event:Event):void
		{
			firstDay.fullYear = event.target.value;
    		monthsSetup();
		} // end function pickYear
		
		
		/**
		 * 
		 */
		private function onTick(event:TimerEvent):void
		{
			var currentTime:Date = new Date();
	
			var hours:int = currentTime.getHours();
			var minutes:int = currentTime.getMinutes();
			var seconds:int = currentTime.getSeconds();
			
			var day:int = currentTime.getDay();
			var month:int = currentTime.getMonth();
			var date:int = currentTime.getDate();
			var year:int = currentTime.getFullYear();
			
			// set P.M/A.M
			var pm_amString:String;
			hours >= 12 ? pm_amString = "P.M" : pm_amString = "A.M";
			
			// Set hour to 12 if the current time is in the hour or 12:00a.m 
			// and set hpur to hour-12 if it is passed 12:00p.m (12 hr clock conversion)
			if(hours == 0)
			{
				hours = 12;
			}
			else if(hours > 12)
			{
				hours -= 12;
			}
			
			// Set the text objects to the date values
			hours < 10 ? currentTimeLabel.text = "0" + hours.toString() : currentTimeLabel.text = hours.toString();
			minutes < 10 ? currentTimeLabel.text += ":0" + minutes.toString() : currentTimeLabel.text += ":" + minutes.toString();
			seconds < 10 ? currentTimeLabel.text += ":0" + seconds.toString() : currentTimeLabel.text += ":" + seconds.toString();
			currentTimeLabel.text += "   " + pm_amString
			
			currentDateLabel.text = WEEK_DAYS[day] + ", " + MONTHS[month].label + " " + date.toString() + ", " + year.toString();
			
		} // end function onTick

		
		
		//**************************************** FUNCTIONS ********************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			super.initialize();
			
			style.backgroundColor = 0x333333;
			style.backgroundOpacity = 0.7;
			style.filters = [new DropShadowFilter(2, 90, 0x000000, 1, 8, 8, 1, 1, false)];
			
			// initialize assets
			// containers
			cellDaysContainer = new Sprite();
			cellMonthsContainer = new Sprite();
			cellYearsContainer = new Sprite();
			
			cellDaysContainer.y = 
			cellMonthsContainer.y = 
			cellYearsContainer.y = 140;
			
			currentTimeLabel = new BLabel(this, 10, 10, "Current Time");
			currentTimeLabel.textField.setTextFormat(new TextFormat("Calibri", 28, 0xFFFFFF, false));
			currentTimeLabel.textField.defaultTextFormat = new TextFormat("Calibri", 28, 0xFFFFFF, false);
			currentTimeLabel.width = 400;
			currentTimeLabel.height = 50;
			
			currentDateLabel = new BLabel(this, 10, 50, "Current Date");
			currentDateLabel.textField.setTextFormat(new TextFormat("Calibri", 18, 0x3399CC, false));
			currentDateLabel.textField.defaultTextFormat = new TextFormat("Calibri", 18, 0x3399CC, false);
			currentDateLabel.width = 400;
			currentDateLabel.height = 30;
			
			
			monthPickerCB = new BComboBox(this, 10, 90);
			monthPickerCB.listPosition = BComboBoxDropdownPosition.BOTTOM;
			monthPickerCB.setSize((cellWidth + cellPadding) * 7 - cellPadding, 40);
			for (var i:int = 0; i < MONTHS.length; i++ )
			{
				monthPickerCB.dropdown.addItem(MONTHS[i]);
			} // end for
			
			yearPickerNS = new BNumericStepper(this, 10, 430);
			yearPickerNS.buttonPlacement = BNumericStepperButtonPlacement.HORIZONTAL;
			yearPickerNS.editable = false;
			yearPickerNS.setSize((cellWidth + cellPadding) * 7 - cellPadding, 40);
			yearPickerNS.maximum = currentDateTime.fullYear + 100;
			yearPickerNS.minimum = currentDateTime.fullYear - 100;
			yearPickerNS.maxChars = 4;
			yearPickerNS.value = currentDateTime.fullYear;
			
			
			makeDateCellGrid(10, 30);
			makeDaysLabels(10, 0);
			monthsSetup();
			monthPickerCB.selectedIndex = currentDateTime.month;
			
			
			// add assets to respective containers
			addChild(cellDaysContainer);
			addChild(cellMonthsContainer);
			addChild(cellYearsContainer);
			
			
			// other
			var ticker:Timer = new Timer(1000);
			ticker.addEventListener(TimerEvent.TIMER, onTick);
			ticker.start();
			
			
			// event handling
			monthPickerCB.addEventListener(Event.CHANGE, pickMonth);
			yearPickerNS.addEventListener(Event.CHANGE, pickYear);
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
		} // end function draw
		
		
		/**
		 * Cgreats the cells for the date picker (42 cells, 6 rows, 7 columns), positions them
		 * and adds then to the date picker.
		 * 
		 * @param x The x position to start the gird within the cells' parent container.
		 * @param y The y position to start the gird within the cell's parent container.
		 */
		protected function makeDateCellGrid(x:int, y:int):void
		{
			var dateCell:BDateCell;
			
			
			for(var i:int = 0; i < 6; i++)
			{
				for(var j:int = 0; j < 7; j++)
				{
					dateCell = new BDateCell(cellDaysContainer, (x + (cellWidth + cellPadding) * j), (y + (cellHeight + cellPadding) * i));
					dateCell.setSize(cellWidth, cellHeight);
					
					// put all date cells into and array for refrence
					dateCells.push(dateCell);
				}
			} // end for
			
			
		} // end function makeDateCellGrid
		
		
		/**
		 * Creates the 7 "day labels" to be placed above the date cells.
		 * 
		 * @param x The x position to start the labels within their parent container.
		 * @param y The y position to start the labels within their parent container.
		 */
		protected function makeDaysLabels(x:Number, y:Number):void 
		{
			//Add week day names
			for (var i:int = 0; i < 7; i++)  
			{
				var label:BLabel = new BLabel(cellDaysContainer, (x + (cellWidth + cellPadding) * i), y, String(WEEK_DAYS[i]).substring(0, 3));
			}
		} // end function makeDaysLabels
		
		
		/**
		 * Calls the arrangeDates(), prevMonthDates(), and nextMonthDates() functions.
		 */
		protected function monthsSetup():void
		{
			arrangeDates();
			prevMonthDates();
			nextMonthDates();
		} // ends function monthsSetup
		
		
		/**
		 * 
		 */
		protected function arrangeDates():void
		{
			var dateCell:BDateCell;
			
			 //get column number for first day of the month
			if (firstDay.day == 0)
			{
				//when last date of previous month is on saturday then move to second row
				firstDayColumn = firstDay.day + 7;
			}
			else
			{
				firstDayColumn = firstDay.day;
			}
			
			//get max days for current month w.r.t leap year if any
    		maxDays = (firstDay.getFullYear() % 4 == 0 && firstDay.getMonth() == 1 ? 29 : DAYS_OF_MONTHS[firstDay.getMonth()]);
			
			//put dates for current month
			for (var i:int = 0; i < maxDays; i++)
			{
				dateCell = dateCells[firstDayColumn + i];
				dateCell.label = (i + 1).toString();
				dateCell.state = "currentMonth";
				
				// Highlight today
				if(firstDay.fullYear == currentDateTime.fullYear && firstDay.month == currentDateTime.month)
				{
					if(dateCell.label == (currentDateTime.date).toString())
					{
						dateCell.state = "currentDay";
					}
				}
				
			} // end for 
			
			
		} // end function arrangeDates
		
		
		/**
		 * Formats the cells that belong to the previous month by changing their state.
		 */
		protected function prevMonthDates():void 
		{
			var dateCell:BDateCell;
 
			var prevMonthFirstDay:Date = new Date(firstDay.fullYear, firstDay.month, firstDay.date - 1);
				 
			for (var i:int = firstDayColumn - 1; i >= 0; i--) 
			{
				dateCell = dateCells[i];
				
				dateCell.label = (prevMonthFirstDay.date - ((firstDayColumn - 1) - i)).toString();
				dateCell.state = "normal";
			} // end for
			
		} // end function prevMonthDates
		
		
		/**
		 * Formats the cells that belong to the next month by changing their state.
		 */
		protected function nextMonthDates():void 
		{
			var dateCell:BDateCell;
     
			for (var i:int = 1; i < (42 - maxDays - (firstDayColumn - 1)); i++)
			{
				dateCell = dateCells[(firstDayColumn - 1) + i + maxDays];
				
				dateCell.label = i.toString();
				dateCell.state = "normal";
			} // end for
			
		} // end function nextMonthDates
		
		
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		/**
		 * Gets the current day.
		 */
		public function get currentDay():String
		{
			return WEEK_DAYS[currentDateTime.day];
		}
		
		
		/**
		 * Gets the current date.
		 */
		public function get currentDate():int
		{
			return currentDateTime.date;
		}
		
		
		/**
		 * Gets the current month.
		 */
		public function get currentMonth():String
		{
			/*var currentMonth:String;
			
			switch(currentDateTime.month)
			{
				case 0:
					break;
			} // end switch
			*/
			return MONTHS[currentDateTime.month].label;
		}
		
		
		/**
		 * Gets the current year.
		 */
		public function get currentYear():int
		{
			return currentDateTime.fullYear;
		}
		
		
		/**
		 * Gets or sets whether to display the durrent date.
		 */
		/*public function get showCurrentDate():Boolean
		{
			return _showCurrentDate;
		}
		
		public function set showCurrentDate(value:Boolean):void
		{
			_showCurrentDate = value;
		}
		*/
		
		/**
		 * Gets or sets whether to display the durrent time.
		 */
		/*public function get showCurrentTime():Boolean
		{
			return _showCurrentTime;
		}
		
		public function set showCurrentTime(value:Boolean):void
		{
			_showCurrentTime = value;
		}
		*/
	}

}