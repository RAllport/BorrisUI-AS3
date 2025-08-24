



package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import Borris.containers.BBaseScrollPane;
	
	/**
	 * 
	 * @author Rohaan Allport
	 */
	public class BList extends BBaseScrollPane
	{
		// assets
		public var itemClass:Class = BListItem;
		
		
		// style
		protected var _rowHeight:int = 30;
		
		
		// other
		protected var items:Array = [];							// 
		public var currentValue:Object;							// 
		protected var tempHeight:Number = 0;					// A temporary value to hold the height of the list while it is in autoSize state
		
		
		// set and get
		protected var _allowMultipleSelection:Boolean;			// Gets a Boolean value that indicates whether more than one list item can be selected at a time.
		//protected var _dataProvider:DataProvider;				// Gets or sets the data model of the list of items to be viewed.
		protected var _length:uint;								// [read-only] Gets the number of items in the data provider.
		//protected var _maxHorizontalScrollPosition:Number;		// 
		protected var _rowCount:uint = 0;						// [read-only] Gets the number of rows that are at least partially visible in the list.
		protected var _selectable:Boolean;						// Gets or sets a Boolean value that indicates whether the items in the list can be selected.
		protected var _selectedIndex:int = -1;					// Gets or sets the index of the item that is selected in a single-selection list.
		protected var _selectedIndices:Array;					// Gets or sets an array that contains the items that were selected from a multiple-selection list.
		protected var _selectedItem:Object;						// Gets or sets the item that was selected from a single-selection list.
		protected var _selectedItems:Array;						// Gets or sets an array that contains the objects for the items that were selected from the multiple-selection list.
		
		protected var _autoSize:Boolean = true;					// Automatically adjust the height of the list depending on the 'number of rows to show' and the 
		protected var _numRowsToShow:uint = 5;					// if auto size, automatically adjust the height of the list to fit the number of rows to show
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BList component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x position to place this component.
         * @param y The y position to place this component.
         */
		public function BList(parent:DisplayObjectContainer=null, x:Number=0, y:Number=0) 
		{
			super(parent, x, y);
			setSize(200, 200);
		}
		
		
		/**
		 * Called when the user clicks a list item
		 * Sets the clicked item to selected
		 */
		protected function mouseClickHandler(event:MouseEvent):void
		{
			var listItem:BListItem
			
			for (var i:int = 0; i < items.length; i++ )
			{
				listItem = container.getChildAt(i) as BListItem;
				listItem.selected = false;
			}
			
			listItem = BListItem(event.currentTarget);
			listItem.selected = true;
			currentValue = listItem.data;
			_selectedItem = listItem;
			_selectedIndex = container.getChildIndex(listItem);
			
			//trace(listItem.label);
			trace(listItem.data);
			//trace(listItem.parent);
			//trace(listItem.parent.numChildren);
			trace(listItem.parent.getChildIndex(listItem));
			//trace(_selectedIndex);
			//trace(_selectedItem.label);
				
			dispatchEvent(new Event(Event.CHANGE));
		} // end function houseClickGandler
		
		
		/**
		 * 
		 * @param event
		 */
		override protected function scrollBarChangeHandler(event:Event):void
		{
			// need to fix this shit
			
			// a methout for round to a multiply of a number
			var pow:Number = Math.pow(10, 6);
			var snap:Number = _numRowsToShow * pow;
			var rounded:Number = Math.round((vScrollBar.scrollPosition * (containerMask.height - container.height)) * pow);
			var snapped:Number = Math.round(rounded / snap) * snap;
			var val:Number = snapped / pow;
			//var moveToValue:int = Math.min(  _rowHeight, val);
			//trace(moveToValue);
			
			//container.y = vScrollBar.scrollPosition * (containerMask.height - container.height);
			//var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, (vScrollBar.scrollPosition * (containerMask.height - container.height)), 0.3, true);
			var tween:Tween = new Tween(container, "y", Regular.easeInOut, container.y, val, 0.3, true);
			
			// set the scroll position to a more accurate position
			vScrollBar.scrollPosition = val / (containerMask.height - container.height);
			
		} // end function scrollBarChangeHandler
		
		
		
		//************************************* FUNCTIONS ******************************************
		
		
		/**
		 * Initailizes the component by creating assets, setting properties and adding listeners.
		 */ 
		override protected function initialize():void
		{
			_contendPadding = 0;
			super.initialize();
			
			// initialize assets
			hScrollBar.visible = false;
			
			tempHeight = _height;
			
			// event handling
			
		} // end function initialize
		
		
		/**
		 * @inheritDoc
		 */ 
		override protected function draw():void
		{
			super.draw();
			
			
			var listItem:BListItem;
			
			// 
			if (_autoSize)
			{
				// set the height of the list to. If the height of all the items is less than 
				_height = _numRowsToShow * _rowHeight;
				if (items.length * _rowHeight < _height)
				{
					_height = items.length * _rowHeight;
				}
				
				// 
				vScrollBar.height = _numRowsToShow * _rowHeight;
				vScrollBar.visible = (items.length > _numRowsToShow);
				hScrollBar.visible = false;
				
				// 
				vScrollBar.lineScrollSize = 1 / (items.length - _numRowsToShow);
				
				// 
				containerMask.height = _numRowsToShow * _rowHeight;
				
			} // end if auto size
			else
			{
				if (tempHeight != 0)
				{
					_height = tempHeight;
				}
				
				// set row count to the number of rows that are at least partially visible in the list.
				_rowCount = Math.ceil(_height / _rowHeight);
				// 
				////vScrollBar.height = _rowCount * _rowHeight;
				vScrollBar.visible = (items.length > _rowCount);
				hScrollBar.visible = false;
				
				// 
				vScrollBar.lineScrollSize = 1 / (items.length - _rowCount);
				
				// 
				////containerMask.height = _rowCount * _rowHeight;
			}
			
			// st the item positions and sizes
			for (var i:int = 0; i < items.length; i++ )
			{
				listItem = container.getChildAt(i) as BListItem;
				listItem.x = 0;
				listItem.y = i * _rowHeight;
				listItem.width = _width;
				listItem.height = _rowHeight;
			}
			
		} // end function draw
		
		
		/**
		 * Appends an item to the end of the list of items.
		 * 
		 * <p>An item should contain label and data properties; however, items that contain 
		 * other properties can also be added to the list. By default, the label property 
		 * of an item is used to display the label of the row; the data property is used to 
		 * store the data of the row.</p>
		 * 
		 * @param item The item to be added to the list.
		 */
		public function addItem(item:Object):void
		{
			items.push(item);
			
			var listItem:BListItem = new itemClass();
			listItem.y = container.numChildren * _rowHeight;
			container.addChild(listItem);
			listItem.label = item.label == "" ? "Item " + items.length : item.label;
			listItem.data = item.data;
			
			listItem.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			draw();
			
		} // end function addItem
		
		
		/**
		 * Inserts an item into the list at the specified index location. 
		 * The indices of items at or after the specified index location are incremented by 1.
		 * 
		 * @param item The item to be added to the list.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			items.splice(index, 0, item);
			
			var listItem:BListItem = new itemClass();
			listItem.y = index * _rowHeight;
			container.addChildAt(listItem, index);
			listItem.label = item.label == "" ? "Item " + items.length : item.label;
			listItem.data = item.data;
			
			listItem.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			
			draw();
		} // end function addItemAt
		
		
		/**
		 * Retrieves the item at the specified index.
		 * 
		 * @param index The index of the item to be retrieved.
		 * 
		 * @return The object at the specified index location.
		 */
		public function getItemAt(index:uint):Object
		{
			return items[index];
		} // end function getItemAt
		
		
		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			items = [];
			container.removeChildren(0);
		} // end function removeAll
		
		
		/**
		 * Removes the specified item from the list.
		 * 
		 * @param item The item to be removed.
		 * 
		 * @return The item that was removed.
		 */
		public function removeItem(item:Object):Object
		{
			container.removeChildAt(items.indexOf(item));
			items.splice(items.indexOf(item), 1);
			draw();
			
			return item;
		} // end function removeItem
		
		
		/**
		 * Removes the item at the specified index position. 
		 * The indices of items after the specified index location are decremented by 1.
		 * 
		 * @param index The index of the item in the data provider to be removed.
		 * 
		 * @return The item that was removed.
		 */
		public function removeItemAt(index:uint):Object
		{
			var item:Object = items[index];
			container.removeChildAt(index);
			items.splice(index, 1);
			draw();
			
			return item;
		} // end function removeItemAt
		
		
		/**
		 * Replaces the item at the specified index location with another item. 
		 * This method modifies the data provider of the List component. 
		 * If the data provider is shared with other components, 
		 * the data that is provided to those components is also updated.
		 * 
		 * @param item The item to replace the item at the specified index location.
		 * @param index The index position of the item to be replaced.
		 * 
		 * @return The item that was replaced.
		 */
		public function replaceItemAt(item:Object, index:uint):Object
		{
			var item:Object = removeItemAt(index);
			addItemAt(item, index);
			
			return item;
		} // end function replaceItemAt
		
		
		// function scrollToIndex
		// 
		/*public function scrollToIndex(index:int):void
		{
			
		} // end function scrollToIndex
		
		
		// function scrollToSelected
		// 
		public function scrollToSelected():void
		{
			
		} // end function scrollToSelected
		
		
		// function sortItems
		// 
		public function sortItems(... sortArgs):*
		{
			
		} // end function sortItems
		
		
		// function clearSelcetion
		// 
		public function clearSelcetion():void
		{
			
		} // end function clearSelcetion
		
		
		// function isItemSelected
		// 
		public function isItemSelected(item:Object):Boolean
		{
			
		} // end function isItemSelected*/
		
		
		
		//***************************************** SET AND GET *****************************************
		
		/**
		 * Gets a Boolean value that indicates whether more than one list item can be selected at a time. 
		 * A value of true indicates that multiple selections can be made at one time; 
		 * a value of false indicates that only one item can be selected at one time.
		 * 
		 * @default false
		 */
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}
		
		
		/**
		 * Gets the number of items in the list.
		 */
		public function get length():uint
		{
			return items.length;
		}
		
		
		/**
		 * Gets the number of rows that are at least partially visible in the list.
		 * 
		 * <p><strong>Note:</strong> This property must be overridden in any class that extends SelectableList.</p>
		 * 
		 * @default 0
		 */
		public function get rowCount():uint
		{
			//return Math.ceil(_height / _rowHeight);
			return _rowCount;
		}
		
		
		/**
		 * 
		 */
		public function get rowHeight():int
		{
			return _rowHeight;
		}
		public function set rowHeight(value:int):void
		{
			_rowHeight = value;
			draw();
		}
		
		
		/**
		 * Gets or sets a Boolean value that indicates whether the items in the list can be selected. 
		 * A value of true indicates that the list items can be selected; 
		 * a value of false indicates that they cannot be.
		 * 
		 * @default true
		 */
		public function get selectable():Boolean
		{
			return _selectable
		}
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			
			for (var i:int = 0; i < container.numChildren; i++ )
			{
				BUIComponent(container.getChildAt(i)).enabled = value;
			}
		}
		
		
		/**
		 * Gets or sets the index of the item that is selected in a single-selection list. 
		 * A single-selection list is a list in which only one item can be selected at a time.
		 * 
		 * <p>A value of -1 indicates that no item is selected; if multiple selections are made, 
		 * this value is equal to the index of the item that was selected last in the group of selected items.</p>
		 * 
		 * <p>When ActionScript is used to set this property, the item at the specified index replaces the current selection. 
		 * When the selection is changed programmatically, a change event object is not dispatched.</p>
		 */
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			_selectedIndices = [];
			_selectedIndices.push(value);
			
			for (var i:int = 0; i < container.numChildren; i++ )
			{
				BListItem(container.getChildAt(value)).selected = false;
			}
			BListItem(container.getChildAt(value)).selected = true;
		}
		
		
		/**
		 * Gets or sets an array that contains the items that were selected from a multiple-selection list.
		 * 
		 * <p>To replace the current selection programmatically, you can make an explicit assignment to this property. 
		 * You can clear the current selection by setting this property to an empty array or to a value of undefined. 
		 * If no items are selected from the list of items, this property is undefined.</p>
		 * 
		 * <p>The sequence of values in the array reflects the order in which the items were selected from the multiple-selection list. 
		 * For example, if you click the second item from the list, then the third item, and finally the first item, 
		 * this property contains an array of values in the following sequence: [1,2,0].</p>
		 */
		public function get selectedIndices():Array
		{
			return _selectedIndices;
		}
		public function set selectedIndices(value:Array):void
		{
			if (_allowMultipleSelection)
			{
				_selectedIndices = value;
				
				for (var i:int = 0; i < container.numChildren; i++ )
				{
					BListItem(container.getChildAt(i)).selected = false;
					
					for (var j:int = 0; j < value.length; j++ )
					{
						if (i == j)
						{
							BListItem(container.getChildAt(i)).selected = true;
						}
					} // end for
					
				} // end for
			}
			else
			{
				throw new Error("Multiple selection is not allowed. Set the allowMultipleSelection property to true.");
			}
			
		}
		
		
		/**
		 * Gets or sets the item that was selected from a single-selection list. 
		 * For a multiple-selection list in which multiple items are selected, 
		 * this property contains the item that was selected last.
		 * 
		 * <p>If no selection is made, the value of this property is null.</p>
		 */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;
			
			var listItem:BListItem;
			for (var j:int = 0; j < container.numChildren; j++ )
			{
				
				if (value.label == BListItem(container.getChildAt(j)).label && value.data == BListItem(container.getChildAt(j)).data)
				{
					listItem = container.getChildAt(j) as BListItem;
				}
			}
			//listItem = value as BListItem;
			
			_selectedIndex = container.getChildIndex(listItem);
			_selectedIndices = [];
			_selectedIndices.push(_selectedIndex);
			
			for (var i:int = 0; i < container.numChildren; i++ )
			{
				BListItem(container.getChildAt(i)).selected = false;
			}
			
			BListItem(value).selected = true;
			
		}
		
		
		/**
		 * Gets or sets an array that contains the objects for the items that were selected from the multiple-selection list.
		 * 
		 * <p>For a single-selection list, the value of this property is an array containing the one selected item. 
		 * In a single-selection list, the allowMultipleSelection property is set to false.</p>
		 */
		public function get selectedItems():Array
		{
			return _selectedItems;
		}
		public function set selectedItems(value:Array):void
		{
			_selectedItems = value;
		}
		
		
		/**
		 * Gets or sets whether to automatically adjust the height of the list depending on the 'number of rows to show' and the 
		 */
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			if (value)
			{
				tempHeight = _height;
			}
			draw();
		}
		
		
		/**
		 * 
		 */
		public function get numRowsToShow():uint
		{
			return _numRowsToShow;
		}
		public function set numRowsToShow(value:uint):void
		{
			_numRowsToShow = value;
			if (_autoSize)
			{
				draw();
			}
		}
		
		
		// OVRRIDES
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			tempHeight = value;
		}
		
	}

}