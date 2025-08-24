/* Author: Rohaan Allport
 * Date Created: 13/10/2014 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription:
 * 
 * 
*/


package Borris.controls 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	//import mx.effects.*;
	//import mx.effects.easing.*;
	//import spark.effects.*;
	//import spark.effects.animation.*;
	//import spark.effects.easing.*;
	
	
	public class BAccordion extends BUIComponent 
	{
		// constants
		private static const DETAILS_TOP_MARGIN:int = 0;
		private static const DETAILS_BOTTOM_MARGIN:int = 0;
		
		
		// set and get
		protected var _multipleOpens:Boolean = true;		// Determines whether this BAccordion Object supports multiple BDetails Objects to be open at the same time.
		protected var _details:Array;						// [read-only] An array containing the BDetails Objects
		protected var _minWidth:Number = 32;				// 
		
		
		// other
		protected var targetDetails:BDetails;
		protected var _detailsWidth:Number = 200;			// 
		protected var _detailsHeight:Number = 200;			// I really have no clue why this is here. I just have it here just cuz i can.
		protected var buttonHeight:int = 30;
		
		
		//--------------------------------------
        //  Constructor
        //--------------------------------------
		/**
         * Creates a new BAccordian component instance.
         *
         * @param parent The parent DisplayObjectContainer of this component. If the value is null the component will have no initail parent.
         * @param x The x coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the left.
         * @param y The y coordinate value that specifies the position of the component within its parent, in pixels. This value is calculated from the top.
         */
		public function BAccordion(parent:DisplayObjectContainer = null, x:Number = 0, y:Number =  0) 
		{
			_details = new Array();
			_width = 200;
			//_height = 300;
			super(parent, x, y);
			
			// event handling
			this.addEventListener(Event.SELECT, onDetailSelect);
			
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		/**
		 * 
		 * 
		 */  
		protected function onDetailSelect(event:Event):void
		{
			parent.setChildIndex(this, parent.numChildren - 1);
			targetDetails = event.target as BDetails;
			
			// has no use, but somehow prevents the last details from glitching
			if (targetDetails)
			{
				var difference:int = targetDetails.height - buttonHeight;
			}
			
			var details:BDetails;
			var prevDetails:BDetails;
			var nextDetails:BDetails;
			var detailsY:int;
			var tween:Tween;
			
			for(var i:int = 0; i < _details.length; i++)
			{
				details = _details[i]; 
				
				if (i < _details.length)
				{
					nextDetails = _details[i + 1];
				}
				if (i > 0)
				{
					prevDetails = _details[i - 1];
					details.y = prevDetails.y + prevDetails.height; // working (no animations)
				}
				
				// for animation
				if (nextDetails)
				{
					// working up animation
					if (targetDetails)
					{
						if (!targetDetails.opened)
						{
							detailsY = details.y + buttonHeight;
							
							if (details.opened && details != targetDetails)
							{
								detailsY = details.y + details.height;
							}
							else
							{
								detailsY = details.y + buttonHeight;
							}
							tween = new Tween(nextDetails, "y", Regular.easeInOut, nextDetails.y, detailsY, 0.3, true);
							//animation = new Resize(nextDetails);
							//animation.heightTo = detailsY;
							//animation.play();
							
						}// working up animation end
						
					}
				}
				
			} // end for
			
			
			// for animation
			if (targetDetails)
			{
				for (i = _details.indexOf(targetDetails); i < _details.length; i++ )
				{
					details = _details[i]; 
					
					if (i > 0)
					{
						prevDetails = _details[i - 1];
					}
					if (i < _details.length)
					{
						nextDetails = _details[i + 1];
					}
					
					if (nextDetails)
					{
						// working down animation
						
						
						if (targetDetails.opened)
						{
							detailsY = details.y + buttonHeight;
							
							if (details.opened && details != targetDetails)
							{
								detailsY = details.y + details.height;
							}
							else
							{
								detailsY = details.y + buttonHeight;
							}
							tween = new Tween(nextDetails, "y", Regular.easeInOut, detailsY, nextDetails.y, 0.3, true);
							
						}// working down animation end
						
					}
					
				} // end for
			}
			
		} // end function onDetailswSelect
		
		
		//**************************************** FUNCTIONS ********************************************
		
		/**
		 * @inheritDoc
		 * 
		 */ 
		override protected function draw():void
		{
			// Note: 
			// In this draw function we only adjust the width, and the Y position of the details Objects.
			// The X position is always 0.
			// The width is the width of the details Objects is the width Accordion
			
			
			
			
			var details:BDetails;
			var prevDetails:BDetails;
			
			for(var i:int = 0; i < _details.length; i++)
			{
				details = _details[i]; 
				details.x = 0;
				details.y = 0;
				
				if (i > 0)
				{
					prevDetails = _details[i - 1];
					details.y = prevDetails.y + prevDetails.height; // working (no animations)
				}
				
				details.width = _width;
				
			} // end for
			
		} // end function draw
		
		
		/**
		 * Sets the component to the specified width and height.
		 * 
		 * <p><strong>Note:</strong> Only the width is changed. The height of the cccordian is determined my the details that it contains.</p>
		 * 
		 * @inheritDoc
		 */ 
		override public function setSize(width:Number, height:Number):void
		{
			// the height of all the detail together when they are closed
			height = Math.max(height, _details.length * 20);
			super.setSize(width, height);
			
		}  // end function setSize
		
		
		/**
		 * Reports whether this accordion contains the specified details.
		 * 
		 * @param details The BDetails to look up
		 * 
		 * @return true if details is in this accordian.
		 */ 
		public function containsDetails(details:BDetails):Boolean
		{
			return contains(details);
		} // end function containsDetails
		
		
		/**
		 * Adds a details at the bottom of the accordian.
		 * 
		 * @param details The BDetails object to add at the bottom of the accordian.
		 * 
		 * @return 
		 */ 
		public function addDetails(details:BDetails):BDetails
		{
			addDetailsAt(details, _details.length);
			draw();
			return details;
		} // end function addDetails
		
		
		/**
		 * Inserts a details at the specified position.
		 * The position is indexed from the top. Set the index parameter to zero to insert the item at the top of the menu.
		 * 
		 * @param details The details object to insert.
		 * @param index The (zero-based) position in the accordian at which to insert the details.
		 * 
		 * @return 
		 */ 
		public function addDetailsAt(details:BDetails, index:int):BDetails
		{
			// makes the Accordion width the width of the datails Object of the details Object is wider.
			_width = Math.max(_width, details.width);
			
			this.addChildAt(details, index);
			details.width = _width;
			//details.height = _detailsHeight;
			//details.rowHeight = idk;
			//details.columnWidth = idk;
			_details.splice(index, 0, details);
			//setSize(_winWidth, _winHeight);
			
			draw();
			return details;
		} // end function addDetailsAt
		
		
		/**
		 * Removes the specified details.
		 * 
		 * @param details The BDetails object to remove from this accordian.
		 * 
		 * @return The BDetails object removed.
		 */ 
		public function removeDetails(details:BDetails):BDetails
		{
			removeChild(details);
			_details.splice(_details.indexOf(details), 1);
			draw();
			return details;
		} // end function removeDetails
		
		
		/**
		 * Removes and returns the details at the specified index.
		 * 
		 * @param index The (zero-based) position of the details to remove.
		 * 
		 * @return The BDetails object removed.
		 */ 
		public function removeDetailsAt(index:int):BDetails
		{
			var details:BDetails = _details[index];
			removeChild(details);
			_details.splice(index, 1);
			draw();
			return details;
		} // end function removeDetailsAt
		
		
		/**
		 * Gets the details at the specified index.
		 * 
		 * @param index The (zero-based) position of the details to return.
		 * 
		 * @return The BDetails object at the specified position in the menu.
		 */ 
		public function getDetailsAt(index:int):BDetails
		{
			return _details[index];
		} // end function getDetailsAt
		
		
		/**
		 * Gets the details with the specified name.
		 * 
		 * <p><strong>Note:</strong> The name property of details is not assigned by default.</p>
		 * 
		 * @param name The string to look up.
		 * 
		 * @return The BDetails object with the specified name or null, if no such item exists in the accordian.
		 */ 
		public function getDetailsByName(name:String):BDetails
		{
			var details:BDetails;
			
			for(var i:int = 0; i < _details.length; i++)
			{
				details = _details[i];
				if(details.name == name)
				{
					return details;
				} // end if
				
			} //  end for
			
			return null;
		} // end function getDetailsByName
		
		
		/**
		 * Gets the details with the specified label.
		 * 
		 * <p><strong>Note:</strong> The label property of details is not assigned by default.</p>
		 * 
		 * @param label The string to look up.
		 * 
		 * @return The BDetails object with the specified label or null, if no such item exists in the accordian.
		 */ 
		public function getDetailsByLabel(label:String):BDetails
		{
			var details:BDetails;
			
			for(var i:int = 0; i < _details.length; i++)
			{
				details = _details[i];
				if(details.label == label)
				{
					trace("found details");
					return details;
				} // end if
				
			} //  end for
			
			return null;
		} // end function getDetailsByLabel
		
		
		/**
		 * Gets the position of the specified details.
		 * 
		 * @param details The BDetails object to look up.
		 * 
		 * @return The (zero-based) position of the specified details in this accordian or -1, if the item is not in this accordian.
		 */ 
		public function getDetailsIndex(details:BDetails):int
		{
			if (containsDetails(details))
				return _details.indexOf(details);
			else
				return -1;
		} // end function getDetailsIndex
		
		
		/**
		 * Moves a details to the specified position.
		 * If the details is not already in the accordian, calling this method adds the details to the accordian.
		 * 
		 * @param details The BDetails object to move.
		 * @param index The (zero-based) position in the accordian to which to move the details.
		 */ 
		public function setDetailsIndex(details:BDetails, index:int):void
		{
			if (!containsDetails(details))
			{
				addDetailsAt(details, index);
				draw();
				return;
			}
			_details.splice(index, 0, details);
			draw();
		} // end function setDetailsIndex
		
		
		//******************************************** SET AND GET ******************************************
		
		/**
		 * Gets or sets a Boolean value that indicates whether more than one details can be open at a time. 
		 * A value of <code>true</code> indicates that multiple details can be open at one time; 
		 * a value of <code>false</code> indicates that only one details can be open at one time.
		 */
		public function get multipleOpens():Boolean
		{
			return _multipleOpens;
		}
		public function set multipleOpens(value:Boolean):void
		{
			_multipleOpens = value;
		}
		
		
		/**
		 * The array of BDetails objects in this accordian.
		 * 
		 * <p>The array is sorted in display order.</p>
		 */
		public function get details():Array
		{
			return _details;
		}
		
		
		/**
		 * [read-only] The number of BDetails Objects this BAccordion contains
		 */
		public function get numDetails():int
		{
			return _details.length;
		}
		
		
		/**
		 * The minimum width for this accordian.
		 * 
		 * <p>Setting minWidth, will change the accordian width if the current width is smaller than the new minimum width.</p>
		 */
		public function get minWidth():Number
		{
			return _minWidth;
		}
		public function set minWidth(value:Number):void
		{
			_minWidth = Math.ceil(value);
		}
		
		
		//*************************************** SET AND GET OVERRIDES **************************************
		
		/**
		 * @inheritDoc
		 */
		public override function set width(value:Number):void
		{
			// check to see if value, or minWidth is larger, and set it to value.
			value = Math.max(value, minWidth);
			super.width = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			for(var i:int = 0; i < _details.length; i++)
			{
				_height += _details[i].height;
			}
			
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			// the height of all the detail together when they are closed
			value = Math.max(value, _details.length * buttonHeight);
			super.height = value;
		}
		
		
		
	}

}