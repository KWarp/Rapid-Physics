package org.rapidphysics.shapes
{
	import flash.geom.Point;
	
	import org.rapidphysics.RapidObject;

	/**
	 * A circle class to enable circle collisions 
	 * x and y are the center of the circle
	 * @author greglieberman
	 * 
	 */
	public class RapidCircle extends RapidObject
	{
		
		public var radius:Number;
		
		public function RapidCircle(X:Number=0, Y:Number=0, Radius:Number=0)
		{
			super(X, Y);
			radius = Radius;
			thickness = 2;
			lineColor = 0xFFFFFF;
			fillColor = 0x999999;
			
		}
		
		public function get diameter():Number
		{
			return radius*2;
		}
		
		
		protected override function updateCenter():void
		{
			center.x = 0;
			center.y = 0;
		}
		
		public override function draw():void
		{
			super.draw();
			
			shape.graphics.lineStyle(thickness, lineColor, alpha);
			shape.graphics.beginFill(fillColor, alpha);
			shape.graphics.drawCircle(x, y, radius);
			shape.graphics.endFill();
		}
		
		public override function debugDraw():void
		{
			super.debugDraw();
			
		}
		
		
		
		
		private static var point:Point = new Point();
		
		public static function overlap(c1:RapidCircle, c2:RapidCircle):Boolean
		{
			var dist:Number;
			
			point.x = c1.x - c2.x;
			point.y = c1.y - c2.y;
			dist = point.length;
			
			if(dist <= c1.radius + c2.radius)
				return true;
			else 
				return false;
		}
		
		/**
		 * If greater than zero, returns the number of pixels that the circles overlap
		 * If less than zero, returns how far away the circles are from touching
		 * If equals zero, the circles are touching
		 * @param c1
		 * @param c2
		 * @return 
		 * 
		 */
		public static function intersection(c1:RapidCircle, c2:RapidCircle):Number
		{
			var dist:Number;
			
			point.x = c1.x - c2.x;
			point.y = c1.y - c2.y;
			dist = point.length;
			
			return (c1.radius + c2.radius) - dist;
				
		}
		
		public static function intersects(c1:RapidCircle, c2:RapidCircle):Boolean
		{
			return (intersection(c1, c2) >= 0);
		}
		
		
	}
}