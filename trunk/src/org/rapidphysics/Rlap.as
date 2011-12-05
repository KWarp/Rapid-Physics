package org.rapidphysics
{
	import flash.geom.Point;
	
	import org.rapidphysics.results.RayCircleResult;
	import org.rapidphysics.shapes.*;

	/**
	 * Rapid Overlap
	 * This class contains a bunch of static functions to do hardcore Intersection Tests and Collision Resolution
	 * @author greglieberman
	 * 
	 */
	public class Rlap
	{
		public function Rlap()
		{
		}
		
		/**
		 * Returns a Point if line segments intersect
		 * null if no intersection
		 * Implemention of: http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
		 * 
		 * @param p1a
		 * @param p1b
		 * @param p2a
		 * @param p2b
		 * @param result if you want to define your own point
		 * @return 
		 * 
		 */
		public static function lineSegments(p1a:Point, p1b:Point, p2a:Point, p2b:Point, result:Point=null):Point 
		{
			// (y2b - y2a)(x1b-x1a) - (x2b-x2a)(y1b-y1a)
			var denom:Number = (p2b.y-p2a.y)*(p1b.x-p1a.x) - (p2b.x-p2a.x)*(p1b.y-p1a.y);
			var ua:Number;
			var ub:Number;
			if(Math.abs(denom) < 0.001) 
			{
				// parallel
				return null;
			}
			ua = ((p2b.x-p2a.x)*(p1a.y-p2a.y) - (p2b.y-p2a.y)*(p1a.x-p2a.x))/denom;
			ub = ((p1b.x-p1a.x)*(p1a.y-p2a.y) - (p1b.y-p1a.y)*(p1a.x-p2a.x))/denom;
			
			if(ua < 0 || ua > 1 || ub < 0 || ub > 1) 
			{
				// intersection occurred outside of line segments
				return null;
			}
			
			var res:Point;
			if(result)
				res = result;
			else
				res = new Point();
			
			// x = x1a + ua(x1b-x1a)
			// y = y1a + ua(y1b-y1a)
			res.x = p1a.x+ua*(p1b.x-p1a.x);
			res.y = p1a.y+ua*(p1b.y-p1a.y)
			return res;
		}
		
		
		/**
		 * Determines the point of intersection between a ray and a sphere
		 * @param start		Start of the ray
		 * @param dir		Normalized direction of the ray
		 * @param center	Center of the circle
		 * @param rad		Radius of the circle
		 * @param result	results are stored in this object, if provided
		 * @return 			null if no collision
		 * 
		 */
		public static function rayCircle(start:Point, dir:Point, center:Point, rad:Number, result:Point=null):Point
		{
			var m:Point = start.subtract(center);
			
			var b:Number = RapidU.dot(m, dir);
			var c:Number = RapidU.dot(m, m) - (rad * rad);
			
			if(c > 0 && b > 0)
			{
				// ray's orgin is outside the circle (c > 0)
				// and ray is pointing away from the circle (b > 0)
				return null;
			}
			
			var disc:Number = b*b - c;
			var t:Number;
			
			if(disc < 0)
				return null; // no intersection
			
			// find earliest time of intersection
			t = -b - Math.sqrt(disc);
			if(t < 0) 
				t = 0;
			
			if(result == null)
				result = new Point();
			
			result.x = start.x + dir.x * t;
			result.y = start.y + dir.y * t;
			
			return result;
		}
		
		/**
		 * Modifies a RayCircleResult object specifying the points of intersection (if they exist) 
		 * @param start
		 * @param end
		 * @param circlePos
		 * @param rad
		 * @param result	Results of the collision are stored here.
		 * 
		 */
		public static function lineSegmentCircle(start:Point, end:Point, circlePos:Point, rad:Number, result:RayCircleResult):void
		{	
			result.reset();
			
			var dir:Point = end.subtract(start);
			var dirLength:Number = dir.length;
			dir.normalize(1);
			var m:Point = start.subtract(circlePos);
			
			var b:Number = RapidU.dot(m, dir);
			var c:Number = RapidU.dot(m, m) - (rad * rad);
			
			if(c > 0 && b > 0)
			{
				// ray's orgin is outside the circle (c > 0)
				// and ray is pointing away from the circle (b > 0)
				result.intersectCount = 0;
				return;
			}
			
			var disc:Number = b*b - c;
			var t:Number;
			
			if(disc < 0)
			{
				// no intersection
				result.intersectCount = 0;
				return; 
			}
			// find earliest time of intersection
			t = -b - Math.sqrt(disc);
			if(t < 0) 
				t = 0;
			
			if(t > dirLength)
			{
				// beyond the end of the line segment
				result.intersectCount = 0;
				return; 
			}
			result.point1.x = start.x + dir.x * t;
			result.point1.y = start.y + dir.y * t;
			
			if(disc == 0)
			{
				// tangent intersection, make both points the same
				result.intersectCount = 1;
				result.point2.x = result.point1.x;
				result.point2.y = result.point1.y;
				return;
			}
			
			// second point
			result.intersectCount = 2;
			t = -b + Math.sqrt(disc);
			
			if(t > dirLength)
			{
				// the line segment partially penetrates the circle
				result.point2.x = end.x; 
				result.point2.y = end.y;
				return; 
			}
			
			// end of the line is outside of the circle
			result.point2.x = start.x + dir.x * t;
			result.point2.y = start.y + dir.y * t;
			
			return;
		}
		
		/**
		 * Returns the distance of the closest pixel on the line segment to the center of the circle 
		 * @param line
		 * @param circle	
		 * @return 			a number between 0 and circle's radius. If there was no intesection, it returns -1
		 * 
		 */
		private function closestPointInLineSegmentCircleIntersect(line:RapidLine, circle:RapidCircle):Number
		{
			var result:RayCircleResult = new RayCircleResult();
			Rlap.lineSegmentCircle(line.position, line.end, circle.position, circle.radius, result)
			if(result.intersectCount == 0)
			{
				// no interesection
				return -1;
			}
			
			// there are exactly 3 points that can potentially be the closest point
			// find out which one
			var avg:Point = Point.interpolate(result.point1, result.point2, 0.5);
			var points:Array = [result.point1, result.point2, avg];
			var shortest:Number = circle.radius;
			for each(var pt:Point in points)
			{
				var length:Number = pt.subtract(circle.position).length;
				if(length < shortest)
					shortest = length;
			}
			
			return circle.radius - shortest;
		}
		
		
		
		
		// ==============================
		// Collision Resolution Functions
		// ==============================
		
		/**
		 * 
		 * @param point
		 * @param line
		 * @param pointOfCollision
		 * 
		 */
		public static function resolveMovingPointAndFixedLine(point:RapidPoint, line:RapidLine, pointOfCollision:Point):void
		{
			// resolve the current point
			RapidU.reflectPosition(point.nextPosition, pointOfCollision, line.normal);
			
			// set current position to point of collision
			point.position.x = pointOfCollision.x;
			point.position.y = pointOfCollision.y;
			
			// reflect velocity
			RapidU.reflect(point.velocity, line.normal, point.nextVelocity);	
			point.velocity.x = point.nextVelocity.x;
			point.velocity.y = point.nextVelocity.y;
			
		}
		
		private static var pt:Point = new Point();
		
		/**
		 * 
		 * @param point
		 * @param circle
		 * @param pointOfCollision
		 * 
		 */
		public static function resolveMovingPointAndFixedCircle(point:RapidPoint, circle:RapidCircle, pointOfCollision:Point):void
		{
			// calculate normal
			pt.x = pointOfCollision.x - circle.position.x;
			pt.y = pointOfCollision.y - circle.position.y;
			pt.normalize(1);
			
			// resolve the current point
			RapidU.reflectPosition(point.nextPosition, pointOfCollision, pt);
			
			// set current position to point of collision
			point.position.x = pointOfCollision.x;
			point.position.y = pointOfCollision.y;
			
			// reflect velocity
			RapidU.reflect(point.velocity, pt, point.nextVelocity);	
			point.velocity.x = point.nextVelocity.x;
			point.velocity.y = point.nextVelocity.y;
			
		}
		
		
	}
}