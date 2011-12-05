package org.rapidphysics
{
	import flash.geom.Point;
	
	import org.rapidphysics.shapes.RapidLine;
	import org.rapidphysics.shapes.RapidPoint;
	
	
	public class RapidU
	{
		
		/**
		 * Calculates the reflection vector 
		 * @param incoming vector v
		 * @param normal vector n, must be normalized
		 * @param result where the results are stored
		 * 
		 */
		public static function reflect(v:Point, n:Point, result:Point):void
		{
			var d:Number = dot(v, n);
			result.x = v.x - 2*n.x*d;
			result.y = v.y - 2*n.y*d;
		}
		
		/**
		 * 
		 * @param position 	The position that you want modified. The result is stored here too!
		 * @param q			The point of collision
		 * @param n			The normal of the surgace, must be normalized
		 * 
		 */
		public static function reflectPosition(position:Point, q:Point, n:Point):void
		{
			// resolve next position
			// d = (P - Q) dot n
			var d:Number = RapidU.dot(position.subtract(q), n);
			// R = P + (2d)*n
			var twoDN:Point = n.clone();
			twoDN.x *= -2*d;
			twoDN.y *= -2*d;
			position.x += twoDN.x;
			position.y += twoDN.y;
		}
				
		/**
		 * Tells you if two Point objects are the same 
		 * @param p1
		 * @param p2
		 * @param error
		 * @return 
		 * 
		 */
		public static function samePoint(p1:Point, p2:Point, error:Number=0.0):Boolean
		{
			// pointers are the same
			if(p1 == p2)
				return true;
			// values are the same
			if( (Math.abs(p1.x - p2.x) <= error) && (Math.abs(p1.y - p2.y) <= error) )
				return true;
			// not the same
			return false;
		}
		
		/**
		 * Tells you if two numbers are the same 
		 * @param n1
		 * @param n2
		 * @param error
		 * @return 
		 * 
		 */
		public static function sameNumber(n1:Number, n2:Number, error:Number=0.0):Boolean
		{
			return (Math.abs(n1-n2) <= error);
		}
		
		/**
		 * Calculates a number representing the time of collision across 3 points
		 * @param start
		 * @param end
		 * @param posOfCollision
		 * @return the time that the collusion occured, between 0 and 1
		 * 
		 */
		public static function timeOfCollision(start:Point, end:Point, posOfCollision:Point):Number
		{
			var step:Point = end.subtract(start);
			var traveled:Point = posOfCollision.subtract(start);
			return (traveled.length / step.length);
		}
		
		/**
		 * Calculates the dot product for two Point vectors
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
		public static function dot(p1:Point, p2:Point):Number
		{
			return p1.x * p2.x + p1.y * p2.y;
		}
		
		
		
		/*
		public static function reflectPointOffLine(point:RapidPoint, line:RapidLine, pointOfCollision:Point):void
		{
			// subtract the velocity from here to the point of collision from velocity
			
			
			// reflects velocity of the point of the line
			reflect(point.velocity, line.normal, point.velocity);
			
			
		}
		*/

		/**
		 * Given a value passed in, returns a Number between min and max (inclusive)
		 * 
		 * @param value		the Number you want to evaluate
		 * @param min		the minimum number that should be returned
		 * @param max		the maximum number that should be returned
		 * @return 			value clamped between min and max
		 * 
		 */
		static public function clamp(value:Number, min:Number, max:Number) : Number
		{
			if(value < min) return min;
			if(value > max) return max;
			return value;
		}
		
		static public function clampUInt(value:uint, min:uint, max:uint) : uint
		{
			if(value < min) return min;
			if(value > max) return max;
			return value;
		}
		
		
		/**
		 * 
		 * @param value		A Number representing the amount of time passed in seconds
		 * @return 			A String formatted in hours:minutes:seconds:mills
		 * 
		 */
		static public function formatTime(value:Number):String
		{
			var str:String = "";
			if(value <= 0)
			{
				return "0:00";
			}
			var hours:int = Math.floor(value * MINUTES_PER_SECOND * HOURS_PER_MINUTE);
			var minutes:int = Math.floor(value * MINUTES_PER_SECOND) - (hours / HOURS_PER_MINUTE);
			var seconds:int = Math.floor(value) - (minutes / MINUTES_PER_SECOND);
			var mills:int = int( (value - Math.floor(value) ) * MILLS_PER_SECOND);
			
			if(hours > 0)
			{
				if(hours >= 10)
					str += hours + ":";
				else
					str += "0" + hours + ":";					
			}
			if(minutes > 0)
			{
				if(minutes >= 10)
					str += minutes + ":";
				else
					str += "0" + minutes + ":";
			}
			
			if(seconds >= 10)
				str += seconds + ":";
			else
				str += "0" + seconds + ":";
			
			if(mills >= 100)
				str += mills;
			else if(mills >= 10)
				str += "0" + mills;
			else if(mills > 0)
				str += "00" + mills;
			else
				str += "000";
			
			return str;
		}
		
		static public const MINUTES_PER_SECOND:Number = 1/60;
		static public const HOURS_PER_MINUTE:Number = 1/60;		
		static public const MILLS_PER_SECOND:Number = 1000;
		
	}
}
