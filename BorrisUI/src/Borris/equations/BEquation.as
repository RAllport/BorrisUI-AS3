/* Author: Rohaan Allport
 * Date Created: 08/11/2015 (dd/mm/yyyy)
 * Date Completed: (dd/mm/yyyy)
 *
 * Decription: 
 * 
 * Todos:
	 * 
 * 
*/


package Borris.equations 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import Borris.BMath;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Rohaan Allport
	 */
	
	
	
	public class BEquation extends EventDispatcher
	{
		// constants
		// angular measure
		public static const ANGULAR_MEASURE_DEGREES:String = "degrees";
		public static const ANGULAR_MEASURE_RADIANS:String = "radians";
		
		
		// other
		private var finalResult:Number = 0;										// the final result/answer
		private var arrayToCalculate:Array = []; 								// 
		
		
		//  set and get
		protected var _angularMeasureMode:String = ANGULAR_MEASURE_DEGREES;
		protected var _equation:Array = [];										// 
		protected var _stringRepresentation:String = "";						// [read-only]
		
		protected var _result:Number = 0;										// [read-only]
		
		protected var _standardNotationPower:uint = 0;							// [read-only]
		protected var _standardNotationResult:Number = 0;						// [read-only]
		
		protected var _x:Number = 0;											// 
		protected var _y:Number = 0;											// The output of X (same as result)
		
		
		public function BEquation(equation:Array) 
		{
			_equation = equation;
			setArrayToCalc();
		}
		
		
		//**************************************** HANDLERS *********************************************
		
		
		
		
		//**************************************** FUNCTIONS ********************************************
		
		// funtion separateBrackets
		// 
		protected function separateBrackets(bracketArray:Array):Number
		{
			//trace("BEquation | Separating brackets...");
			var tempNum:Number = 0;
			var tempArray:Array;
			var spliced:Array;
			var bracketsFlag:Boolean = false;
			
			// search for brackets
			for(var i:int = 0; i < bracketArray.length; i++)
			{
				if(bracketArray[i] == ")")
				{
					
					//trace("\nBEquation | Brackets found!");
					
					for(var j:int = i; j >= 0; j--)
					{
						if(bracketArray[j] == "(")
						{
							tempArray = bracketArray.splice(j + 1, i - (j + 1) );
							//trace("BEquation | Equation in brackets: " + tempArray);
							var _result:Number = operate(tempArray);
							//trace("BEquation | Result (in brackets): " + _result + "\n");
							spliced = bracketArray.splice(j, 2, _result);
							i = 0;
							
						} // end of if
						
					} // end of for loop j
					
					bracketsFlag = true;
					
				} // end of if
				
			} // end of for loop i
			
			/* The loops have now found the brackets, obtained the result inside them.
			 * And has taken out the brackets and placed the result in the array.
			 * Now it will check How big the new equation is.
			 * if it is 2 or greater (eg. root(4) an operation and number) then operate again.
			 * if its less than 2 (eg. a single digit), then the final result has been obtained.
			 */
			
			if (!bracketsFlag)
			{
				//trace("BEquation | No brackets found!");	
			}
			
			// test length of array, if 2 or more, opperate again
			if(bracketArray.length >= 2)
			{
				tempNum = operate(bracketArray);
			}
			else
			{
				tempNum = _result;
			}
			
			return tempNum;
		} // end of function separateBrackets
		
		
		/* function operate. 
		 * loops though an array multiple times. looks for a
		 * mathematical operation and performs that operation on the numbers
		 * adjacent to it, cuts out the operation and its adjacent number(s)
		 * and replaces them with the new value.
		 */
		protected function operate(array:Array):Number
		{
			var tempNum:Number;
			var answer:Number = 0;
			var loopTimes:int = array.length;
			var spliced:Array;
			
			
			// convert all numbers with minus signs to minus numbers
			for(var i:int = 0; i < loopTimes; i++)
			{
				if(array[i] == "minus")
				{
					tempNum = array[i+1] * -1;
					spliced = array.splice(i, 2, tempNum);
					if(!isNaN(array[i-1]))
					{
						array.splice(i, 0, "add");
					}
					i = 0;
				}
			}
			
			for(var b:int = 0; b < loopTimes; b++) // brackets loop
			{
				if(array[b] == "(")
				{
					//trace("found open bracket"); // does not trace
					tempNum = separateBrackets(array);
					spliced = array.splice(b, 2, tempNum);
				}
				
			}
			
			for(var pow:int = 0; pow < loopTimes; pow++)
			{
				if(array[pow] == "power")
				{
					tempNum = Math.pow(array[pow-1], array[pow+1]);
					spliced = array.splice(pow-1, 3, tempNum);
					pow = 0;
				}
				if(array[pow] == "square")
				{
					tempNum = Math.pow(array[pow-1], 2);
					spliced = array.splice(pow-1, 2, tempNum);
					pow = 0;
				}
				if(array[pow] == "cube")
				{
					tempNum = Math.pow(array[pow-1], 3);
					spliced = array.splice(pow-1, 2, tempNum);
					pow = 0;
				}
				if(array[pow] == "squareRoot")
				{
					tempNum = Math.sqrt(array[pow+1]);
					spliced = array.splice(pow, 2, tempNum);
					pow = 0;
				}
				if(array[pow] == "cubeRoot")
				{
					tempNum = Math.pow(array[pow+1], 1/3);
					spliced = array.splice(pow, 2, tempNum);
					pow = 0;
				}
				if(array[pow] == "EXP")
				{
					tempNum = array[pow-1] * Math.pow(10, array[pow+1]);
					spliced = array.splice(pow, 2, tempNum);
					pow = 0;
				}
				if(array[pow] == "xRoot")
				{
					tempNum = Math.pow(array[pow+1], 1/array[pow-1]);
					spliced = array.splice(pow-1, 3, tempNum);
					pow = 0;
				}
			}
			
			for(var fac:int = 0; fac < loopTimes; fac++)
			{
				if(array[fac] == "factorial")
				{
					tempNum = BMath.factorial(array[fac-1]);
					array.splice(fac-1, 2, tempNum);
					fac = 0;
				}
				if (array[fac] == "nCr")
				{
					tempNum = BMath.nCr(array[fac - 1], array[fac + 1]);
					array.splice(fac - 1, 3, tempNum);
					fac = 0;
				}
				if (array[fac] == "nPr")
				{
					tempNum = BMath.nPr(array[fac - 1], array[fac + 1]);
					array.splice(fac - 1, 3, tempNum);
					fac = 0;
				}
			}
			
			for(var log:int = 0; log < loopTimes; log++)
			{
				if(array[log] == "log")
				{
					tempNum = BMath.log(array[log + 1], array[log - 1]);
					spliced = array.splice(log - 1, 3, tempNum);
					log = 0;
				}
				if(array[log] == "ln")
				{
					tempNum = Math.log(array[log+1]);
					spliced = array.splice(log, 2, tempNum);
					log = 0;
				}
				
			}
			
			for(var trig:int = 0; trig < loopTimes; trig++) // trigonometry
			{
				if(array[trig] == "sin")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.sin(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{
						tempNum = Math.sin(array[trig+1] * Math.PI/180);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
				if(array[trig] == "cos")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.cos(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{ 
						tempNum = Math.cos(array[trig+1] * Math.PI/180);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
				if(array[trig] == "tan")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.tan(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{ 
						tempNum = Math.tan(array[trig+1] * Math.PI/180);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
				// inverse functions
				if(array[trig] == "arcsin")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.asin(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{ 
						tempNum = Math.asin(array[trig+1]) * 180/Math.PI;
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
				if(array[trig] == "arccos")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.acos(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{ 
						tempNum = Math.acos(array[trig+1]) * 180/Math.PI;
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
				if(array[trig] == "arctan")
				{
					if(_angularMeasureMode == ANGULAR_MEASURE_RADIANS)
					{
						tempNum = Math.atan(array[trig+1]);
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
					else if(_angularMeasureMode == ANGULAR_MEASURE_DEGREES)
					{ 
						tempNum = Math.atan(array[trig+1]) * 180/Math.PI;
						spliced = array.splice(trig, 2, tempNum);
						trig = 0;
					}
				}
			}
			
			for(var md:int = 0; md < loopTimes; md++) // multiplication and divition loop
			{
				if(array[md] == "multiply")
				{
					tempNum = array[md-1] * array[md+1];
					spliced = array.splice(md-1, 3, tempNum);
					md = 0;
				}
				if(array[md] == "divide")
				{
					tempNum = array[md-1] / array[md+1];
					spliced = array.splice(md-1, 3, tempNum);
					md = 0;
				}
			}
			
			for(var am:int = 0; am < loopTimes; am++) // addition and subtraction loop
			{
				if(array[am] == "add")
				{
					tempNum = array[am-1] + array[am+1];
					spliced = array.splice(am-1, 3, tempNum);
					am = 0;
				}
			}
			
			
			return tempNum;
			
		} // end function parseEquation
		
		
		// function calulateAnswer
		// 
		public function calculateAnswer():Number
		{
			setArrayToCalc();
			
			//trace("BEquation | Equation: " + _equation);
			
			//trace("BEquation | Calculating answer...");
			
			if(_equation.length <= 1)
			{
				finalResult = arrayToCalculate[0];
			}
			else
			{
				//trace("BEquation | Obtaining result...");
				finalResult = separateBrackets(arrayToCalculate);
			}
			
			var decimal:String = finalResult.toString();
			if(decimal.length > 15 && decimal.indexOf(".", 0) >= 0)
			{
				finalResult = Math.round(finalResult*10000000000000)/10000000000000;
			}
			
			
			// standard notation
			var tempResult:Number = finalResult;
			var decimalCount:uint = 0;
			
			// keep dividing result by 10 till it's less than 10
			while (tempResult > 10)
			{
				tempResult /= 10;
				decimalCount++; // increament the decimal count/power
			}
			
			_result = finalResult;
			_standardNotationResult = tempResult;
			_standardNotationPower = decimalCount;
			
			// empty the equation array so that recalculating is not glitched
			//_equation = [];
			
			//trace("BEquation | Final result: " + finalResult);
			//trace("BEquation | Standard notation result: " + _standardNotationResult);
			//trace("BEquation | Standard notation power: " + _standardNotationPower);
			
			return finalResult;
			
		} // end 
		
		
		// function setArrayToCalc
		// Copies the values of _equation to arrayToCalculate
		private function setArrayToCalc():void
		{
			arrayToCalculate = [];
			for (var i:int = 0; i < _equation.length; i++ )
			{
				arrayToCalculate.push(_equation[i]);
			}
		} // end function setArrayToCalc
		
		
		//**************************************** SET AND GET ******************************************
		
		
		// 
		public function set angularMeasureMode(value:String):void
		{
			_angularMeasureMode = value;
		}
		
		public function get angularMeasureMode():String 
		{
			return _angularMeasureMode;
		}
		
		
		//
		public function set equation(value:Array):void
		{
			_equation = value;
			//setArrayToCalc();
		}
		
		public function get equation():Array
		{
			return _equation;
		}
		
		
		// 
		public function get result():Number
		{
			return _result;
		}
		
		
		// 
		public function get standardNotationPower():uint
		{
			return _standardNotationPower;
		}
		
		
		// 
		public function get standardNotationResult():Number
		{
			return _standardNotationResult;
		}
		
		
		// 
		public function get stringRepresentation():String
		{
			var string:String = "";
			
			for (var i:int = 0; i < _equation.length; i++ )
			{
				// if i is a number
				if (_equation[i] is Number )
				{
					if (_equation[i] == Math.PI)
					{
						string += "π";
					}
					else if (_equation[i] == Math.E)
					{
						string += "e";
					}
					else
					{
						string += _equation[i].toString();
					}
					
				}
				
				
				if (_equation[i] == "(") 		{ string += "("; }
				if (_equation[i] == ")") 		{ string += ")"; }
				/*if (_equation[i] == "[")		{ string += "["; }
				if (_equation[i] == "]")		{ string += "]"; }
				if (_equation[i] == "{")		{ string += "{"; }
				if (_equation[i] == "}")		{ string += "}"; }*/
				
				if (_equation[i] == "power") 	{ string += "^"; }
				if (_equation[i] == "square") 	{ string += "²"; }
				if (_equation[i] == "cube") 	{ string += "³"; }
				if (_equation[i] == "squareRoot"){ string += "√"; }
				if (_equation[i] == "cubeRoot") { string += "³√"; }
				if (_equation[i] == "EXP") 		{ string += "EXP"; }
				if (_equation[i] == "xRoot") 	{ string += ""; }
				
				if (_equation[i] == "factorial"){ string += "!"; }
				if (_equation[i] == "nCr") 		{ string += "nCr"; }
				if (_equation[i] == "nPr")		{ string += "nPr"; }
				if (_equation[i] == "log")		{ string += "log"; }
				if (_equation[i] == "ln")		{ string += "ln"; }
				
				if (_equation[i] == "sin")		{ string += "sin"; }
				if (_equation[i] == "cos")		{ string += "cos"; }
				if (_equation[i] == "tan")		{ string += "tan"; }
				if (_equation[i] == "arcsin")	{ string += "sin-¹"; }
				if (_equation[i] == "arccos")	{ string += "cos-¹"; }
				if (_equation[i] == "arctan")	{ string += "tan-¹"; }
				
				if (_equation[i] == "multiply")	{ string += "×"; }
				if (_equation[i] == "divide")	{ string += "÷"; }
				if (_equation[i] == "add")		{ string += "+"; }
				if (_equation[i] == "minus")	{ string += "-"; }
				
				if (_equation[i] == "X")		{ string += "X"; }
				/*if (_equation[i] == "Y")		{ string += "Y"; }
				if (_equation[i] == "k")		{ string += "k"; }
				if (_equation[i] == "m")		{ string += "m"; }
				if (_equation[i] == "c")		{ string += "c"; }*/
				
			} // end for 
			
			return string;
		}
		
		
		// 
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		
		// 
		/*public function set y(value:Number):void
		{
			_y = value;
		}*/
		
		public function get y():Number
		{
			setArrayToCalc();
			
			// where ever there is "X", insert value of _X
			for(var i:int = 0; i < arrayToCalculate.length; i++)
			{
				if(arrayToCalculate[i] == "X")
				{
					arrayToCalculate.splice(i, 1, _x)
				}
			}
			
			// 
			_y = separateBrackets(arrayToCalculate);
			
			// reset array to calculate
			setArrayToCalc();
			
			return _y;
		}
		
		
		//**************************************** SET AND GET OVERRIDES ********************************
		
		//
		override public function toString():String
		{
			return _equation.toString();
		}
		
		
	}

}