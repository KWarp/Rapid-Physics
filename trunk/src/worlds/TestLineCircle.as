package worlds
{
	import flash.geom.Point;
	
	import org.rapidphysics.RapidBasic;
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidText;
	import org.rapidphysics.RapidWorld;
	import org.rapidphysics.Rlap;
	import org.rapidphysics.results.RayCircleResult;
	import org.rapidphysics.shapes.RapidCircle;
	import org.rapidphysics.shapes.RapidLine;
	import org.rapidphysics.shapes.RapidPoint;
	
	/**
	 * Shows all the useful information I can get when a (directed) line overlaps a circle 
	 * @author greglieberman
	 * 
	 */
	public class TestLineCircle extends RapidWorld
	{
		private var titleText:RapidText;

		private var line:RapidLine;
		private var circle1:RapidCircle;
		private var circle2:RapidCircle;
		
		private var circle3:RapidCircle;
		private var resultLine:RapidLine;
		private var result:RayCircleResult;
		
		private var resultPoint:RapidPoint;
		
		private var circles:Vector.<RapidCircle>;
		
		public function TestLineCircle()
		{
			super();
		}
		
		public override function create():void
		{
			super.create();
			setBackgroundColor(0x000000);
			
			titleText = new RapidText(0, 10, RapidG.width, "TestLineCircle", false);
			titleText.setFormat(null, 12, 0xFFFFFF, "center");
			flashSprite.addChild(titleText.textField);
						
			line = new RapidLine(0, 0, 100, 100);
			circle1 = new RapidCircle(200, 200, 60);
			circle2 = new RapidCircle(400, 100, 25);
			resultPoint = new RapidPoint(0, 0, 3);
			
			circle3 = new RapidCircle(400, 400, 60);
			resultLine = new RapidLine();
			resultLine.lineColor = 0xFFFF00;
			resultLine.thickness = 2;
			result = new RayCircleResult();
			
			circles = new Vector.<RapidCircle>();
			
			circles.push(circle1);
			circles.push(circle2);
			circles.push(circle3);
			
			add(line);
			add(circle1);
			add(circle2);
			add(circle3);
			add(resultPoint);
			add(resultLine);
		}
		
		public override function update():void
		{
			super.update();
			
			TitleScreen.handleGlobalInput(host);

			
			// line follows mouse
			line.x = RapidG.mouseX - line.center.x;
			line.y = RapidG.mouseY - line.center.y;
			
			// this code would normally be contained in an island if part of this physics simulation, 
			// but I want to display the collision information
			resultPoint.visible = false;
			resultLine.visible = false;
			for each(var circle:RapidCircle in circles)
			{
				
				// multiple intersection line
				Rlap.lineSegmentCircle(line.position, line.end, circle.position, circle.radius, result);
				if(result.intersectCount > 0)
				{
					
					resultPoint.visible = true;
					resultPoint.x = result.point1.x;
					resultPoint.y = result.point1.y;

					resultLine.visible = true;
					resultLine.x = result.point1.x;
					resultLine.y = result.point1.y;
					if(result.intersectCount == 2)
					{
						resultLine.setEnd(result.point2.x, result.point2.y);
					}
				}
			}
			
			
		}
		
		
	}
}