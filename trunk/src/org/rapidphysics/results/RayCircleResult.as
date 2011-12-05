package org.rapidphysics.results
{
	import flash.geom.Point;

	/**
	 * RayCircle Intersections are complicated enough for us to need an Object with multiple properties 
	 * @author greglieberman
	 * 
	 */
	public class RayCircleResult
	{

		
		/**
		 * How many intersections were encountered: 0, 1, or 2 
		 */
		public var intersectCount:uint;
		/**
		 * The point of entry 
		 * Or, the beginning of the ray, inside the circle 
		 */
		public var point1:Point;
		/**
		 * The point of exit (if it is not a tangent collision) 
		 * Or, the end point of the line inside the circle
		 */
		public var point2:Point;
		
		public function RayCircleResult()
		{
			intersectCount = 0;
			point1 = new Point();
			point2 = new Point();
		}
		
		public function reset():void
		{
			intersectCount = 0;
			point1.x = 0;
			point1.y = 0;
			point2.x = 0;
			point2.y = 0;
			
		}
		
		
	}
}