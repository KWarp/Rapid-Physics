package org.rapidphysics.islands
{
	import flash.geom.Point;
	
	import org.rapidphysics.Collision;
	import org.rapidphysics.RapidU;
	import org.rapidphysics.Rlap;
	import org.rapidphysics.results.RayCircleResult;
	import org.rapidphysics.shapes.RapidCircle;
	import org.rapidphysics.shapes.RapidPoint;

	/**
	 * An island that solves collisions between points and circles 
	 * @author greglieberman
	 * 
	 */
	public class PointCircleIsland extends Island
	{
		
		public var points:Vector.<RapidPoint>;
		public var circles:Vector.<RapidCircle>;
		private var result:RayCircleResult;
		
		public function PointCircleIsland()
		{
			super();
			points = new Vector.<RapidPoint>();
			circles = new Vector.<RapidCircle>();
			result = new RayCircleResult();
		}
		
		protected override function collectCollisions(frameTime:Number):void
		{

			for each(var point:RapidPoint in points)
			{
				for each(var circle:RapidCircle in circles)
				{
					Rlap.lineSegmentCircle(point.position, point.nextPosition, circle.position, circle.radius, result);
					if(result.intersectCount > 0)
					{
						
						var c:Collision = recycleCollision();
						c.init(point, circle, Rlap.resolveMovingPointAndFixedCircle);
						c.pointOfCollision.x = result.point1.x;
						c.pointOfCollision.y = result.point1.y;
						c.time = frameTime + RapidU.timeOfCollision(point.position, point.nextPosition, result.point1);
						
						addCollision(c);
						
					}
				}
			}
		}
		
		
	}
}