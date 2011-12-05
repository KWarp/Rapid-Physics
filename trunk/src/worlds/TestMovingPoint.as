package worlds
{
	import flash.geom.Point;
	
	import org.rapidphysics.Collision;
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidText;
	import org.rapidphysics.RapidU;
	import org.rapidphysics.RapidWorld;
	import org.rapidphysics.Rlap;
	import org.rapidphysics.islands.PointLineIsland;
	import org.rapidphysics.shapes.*;
	
	/**
	 * An extremely fast moving point, trapped in a box made up of 4 lines 
	 * @author greglieberman
	 * 
	 */
	public class TestMovingPoint extends RapidWorld
	{
		// line box locations
		private var LEFT:Number = 120;
		private var RIGHT:Number = 520;
		private var TOP:Number = 100;
		private var BOTTOM:Number = 250;
		
		// define the point edges
		private var pt1:Point = new Point(LEFT, TOP);
		private var pt2:Point = new Point(RIGHT, TOP);
		private var pt3:Point = new Point(RIGHT, BOTTOM);
		private var pt4:Point = new Point(LEFT, BOTTOM);	
		
		// this is our fast-moving point
		private var point:RapidPoint;
		
		// some display text
		private var titleText:RapidText;
		private var pointText:RapidText;
		private var controlsText:RapidText;
		
		// this island does all of the heavy lifting in the physics simulation
		// it automatically solves collisions between points and lines
		private var plIsland:PointLineIsland;
		
		
		/**
		 * Constructor. Nothing interesting here. 
		 * 
		 */		
		public function TestMovingPoint()
		{
			super();
		}
		
		/**
		 * The create function is where all of your initialization code should go (like Flixel). 
		 * 
		 */
		public override function create():void
		{
			
			setBackgroundColor(0x000000);

			// create the lines, points, and PointLineIsland to contain them
			plIsland = new PointLineIsland();
			
			// create some lines and add them to the island
			var line1:RapidLine = buildLine(pt1.x, pt1.y, pt2.x, pt2.y); 
			var line2:RapidLine = buildLine(pt2.x, pt2.y, pt3.x, pt3.y);
			var line3:RapidLine = buildLine(pt3.x, pt3.y, pt4.x, pt4.y);
			var line4:RapidLine = buildLine(pt4.x, pt4.y, pt1.x, pt1.y);
			
			// create the point and add it to the island
			point = new RapidPoint();
			point.x = LEFT + 10;
			point.y = TOP + 10;
			point.velocity.x = 100;
			point.velocity.y = 90;
			
			plIsland.points.push(point);
			
			// add the points and lines to the RapidWorld so that they are updated and drawn
			add(line1);
			add(line2);
			add(line3);
			add(line4);
			add(point);
			
			// an islandManager is part of every RapidWorld. Adding your particular island to the manager is essential to have your simulation run correctly
			islandManager.add(plIsland);
			
			
			// display text
			titleText = new RapidText(0, 10, RapidG.width, "Fast Moving Point", false);
			titleText.setFormat(null, 12, 0xFFFFFF, "center");
			flashSprite.addChild(titleText.textField);
			
			pointText = new RapidText(10, RapidG.height - 30, 350, "some text", false);
			pointText.setFormat(null, 10, 0xFFFFFF, "left");
			flashSprite.addChild(pointText.textField);
			
			var controlsMsg:String = "=== Controls === \n" +
									 "P : Pause \n" +
									 "]  : Step through the simulation while paused";
			
			var aWidth:Number = 250;
			controlsText = new RapidText(RapidG.width - aWidth, RapidG.height - 45, aWidth, controlsMsg, false);
			controlsText.setFormat(null, 10, 0xFFFFFF, "left");
			flashSprite.addChild(controlsText.textField);
		}
		
		
		/**
		 * simple function to simplify creating lots of lines
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 * @return 
		 * 
		 */
		private function buildLine(startX:Number=0, startY:Number=0, endX:Number=0, endY:Number=0):RapidLine
		{
			var line:RapidLine = new RapidLine(startX, startY, endX, endY);
			line.fixed = true;
			plIsland.lines.push(line);
			return line;
		}
		
		
		public override function update():void
		{
			super.update();
			
			TitleScreen.handleGlobalInput(host);

			// add velocity to this point every frame
			point.velocity.x += (point.velocity.x > 0) ? 10 : -10;
			point.velocity.y += (point.velocity.y > 0) ? 10 : -10;
			
			// clamp for this demo
			var max:Number = 20000;
			point.velocity.x = RapidU.clamp(point.velocity.x, -max, max);
			point.velocity.y = RapidU.clamp(point.velocity.y, -max, max);
			
			// if the point essapes the box, pause the simulation (this is for debug purposes and should currently be impossible)
			if(point.x < LEFT || point.x > RIGHT ||
				point.y < TOP || point.y > BOTTOM)
			{
				RapidG.paused = true;
			}
			
			// display some cool information
			pointText.text = "velocity: " + point.velocity.length + "\n" +
				"collisions solved per frame: " + plIsland.collisionsResolvedThisFrame;
				
		}
		
	}
}