package org.rapidphysics.islands
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.rapidphysics.Collision;
	import org.rapidphysics.RapidU;
	import org.rapidphysics.Rlap;
	import org.rapidphysics.shapes.RapidLine;
	import org.rapidphysics.shapes.RapidPoint;

	/**
	 * An Island that solves collisions between moving points and fixed lines. 
	 * @author greglieberman
	 * 
	 */
	public class PointLineIsland extends Island
	{
		
		public var points:Vector.<RapidPoint>;
		public var lines:Vector.<RapidLine>;
		
		public function PointLineIsland()
		{
			super();
			points = new Vector.<RapidPoint>();
			lines = new Vector.<RapidLine>();

		}
		
		/**
		 * This is an implementation of collectCollisions for points and lines
		 * NOTE WELL: This implementation collides every point with every line, but it does NOT collide points with each other, or lines with each other 
		 * @param frameTime
		 * 
		 */		
		protected override function collectCollisions(frameTime:Number):void
		{
			var temp:Point = new Point();

			// test for collision between every point and every line
			for each(var rPoint:RapidPoint in points)
			{
				for each(var line:RapidLine in lines)
				{
					var result:Point = (Rlap.lineSegments(rPoint.position, rPoint.nextPosition, line.position, line.end, temp));
					if(result)
					{	
						// grab a collision object, and fill it with data from the intersection
						var c:Collision = recycleCollision();
						c.init(rPoint, line, Rlap.resolveMovingPointAndFixedLine); // obj1, obj2, how to resolve the collision
						c.pointOfCollision.x = result.x;
						c.pointOfCollision.y = result.y;
						c.time = frameTime + RapidU.timeOfCollision(rPoint.position, rPoint.nextPosition, result); // define time for priority in solving collisions
						
						addCollision(c);	
					}
				}
			}
		}
		

	}
}