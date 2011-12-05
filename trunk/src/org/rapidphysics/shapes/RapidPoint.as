package org.rapidphysics.shapes
{
	import org.rapidphysics.RapidObject;
	
	/**
	 * Pretty much a RapidObject that draws at point at it's current (x,y) 
	 * @author greglieberman
	 * 
	 */
	public class RapidPoint extends RapidObject
	{
		
		public var drawSize:Number;
		
		public function RapidPoint(X:Number=0, Y:Number=0, DrawSize:Number=1.0)
		{
			super(X,Y);
			lineColor = 0xFF00FF; // purple
			drawSize = DrawSize;
		}
		
		public override function draw():void
		{
			super.draw();
			
			shape.graphics.lineStyle(thickness, lineColor, alpha);
			shape.graphics.beginFill(lineColor, alpha);
			shape.graphics.drawCircle(x, y, drawSize);
			shape.graphics.endFill();
		}
		
		
	}
}