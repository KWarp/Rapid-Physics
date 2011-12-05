package org.rapidphysics.shapes
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.rapidphysics.RapidObject;
	import org.rapidphysics.Rlap;
	
	/**
	 * Lines have a start point, and an endpoint 
	 * @author greglieberman
	 * 
	 */
	public class RapidLine extends RapidObject
	{
		
		/**
		 * @readonly
		 * The endpoint of the line 
		 */
		private var m_end:Point;
		public function get end():Point { return m_end; }
		
		private var m_direction:Point
		private var m_normalizedDirection:Point;
		
		/**
		 * The normal for this line 
		 */
		public var normal:Point;
		private var normalM:Matrix; // controls winding order
		private var normalColor:uint = 0x00FF00; // green
		
		public function RapidLine(startX:Number=0, startY:Number=0, endX:Number=0, endY:Number=0)
		{
			super(startX, startY);
			m_end = new Point(endX, endY);
			width = m_end.x - x;
			height = m_end.y - y;
			
			m_direction = new Point();
			m_normalizedDirection = new Point();
			normal = new Point();
			normalM = new Matrix();
			setNormalMatrixDirection(-Math.PI/2);
			
			updateNormal();
		}
		
		public override function destroy():void
		{
			m_end = null;
			
			super.destroy();
		}
		
		/**
		 * A number in radians 
		 * @param Direction
		 * 
		 */
		private function setNormalMatrixDirection(Direction:Number):void
		{
			normalM.a = Math.cos(Direction);
			normalM.b = -Math.sin(Direction);
			normalM.c = Math.sin(Direction);
			normalM.d = Math.cos(Direction);
		}

		
		public override function preUpdate():void
		{
			super.preUpdate();
			
			m_end.x = x + width;
			m_end.y = y + height;
		}

		
		public override function update():void
		{
			super.update();
			
			// not efficient, should check if width/height has changed
			updateNormal();
		}
		
		
		public function setEnd(X:Number, Y:Number):void
		{
			m_end.x = X;
			m_end.y = Y;
			
			width = m_end.x - x;
			height = m_end.y - y;	
		}
		
		public function getDirection():Point
		{
			m_direction.x = end.x - x;
			m_direction.y = end.y - y;
			return m_direction;
		}
		
		public function getNormalizedDirection():Point
		{
			m_normalizedDirection.x = end.x - x;
			m_normalizedDirection.y = end.y - y;
			m_normalizedDirection.normalize(1);
			return m_normalizedDirection;
		}
		
		
		protected function updateNormal():void
		{
			if(width == 0 && height == 0)
			{
				normal.x = 0;
				normal.y = 0;
				return;
			}
			_point.x = width;
			_point.y = height;
			
			_point.normalize(1);
			_point = normalM.transformPoint(_point);
			
			normal.x = _point.x;
			normal.y = _point.y;
			
		}
		
		public override function draw():void
		{
			super.draw();
			
			// the line
			shape.graphics.lineStyle(thickness, lineColor, alpha);
			shape.graphics.moveTo(position.x, position.y);
			shape.graphics.lineTo(m_end.x, m_end.y);
		}
		
		public override function debugDraw():void
		{
			super.debugDraw();
			
			// the line normal
			var drawLonger:Number = 10;
			shape.graphics.lineStyle(1, normalColor, 1);
			shape.graphics.moveTo(x + center.x, y + center.y);
			shape.graphics.lineTo(x + center.x + normal.x*drawLonger, y + center.y + normal.y*drawLonger);
		}
		
		
		/**
		 * Returns the point of intersection, null otherwise 
		 * @param line1
		 * @param line2
		 * @return 
		 * 
		 */
		public static function intersection(line1:RapidLine, line2:RapidLine):Point
		{
			return Rlap.lineSegments(line1.position, line1.m_end, line2.position, line2.m_end);
		}
		
		/**
		 * Returns true if the lines intersect 
		 * @param line1
		 * @param line2
		 * @return 
		 * 
		 */
		public static function intersects(line1:RapidLine, line2:RapidLine):Boolean
		{
			return (RapidLine.intersection(line1, line2) != null);
		}
		
		
	}
}