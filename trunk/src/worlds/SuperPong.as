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
	
	public class SuperPong extends RapidWorld
	{
		private var LEFT:Number = 20;
		private var RIGHT:Number = 620;
		private var TOP:Number = 90;
		private var BOTTOM:Number = 400;
		
		private var CENTER_X:Number = LEFT + (RIGHT-LEFT)/2;
		private var CENTER_Y:Number = TOP + (BOTTOM-TOP)/2;
		
		private var plIsland:PointLineIsland;
		
		private var pt1:Point = new Point(LEFT, TOP);
		private var pt2:Point = new Point(RIGHT, TOP);
		private var pt3:Point = new Point(RIGHT, BOTTOM);
		private var pt4:Point = new Point(LEFT, BOTTOM);	
		
		private var point:RapidPoint;
		
		private var titleText:RapidText;
		private var pointText:RapidText;
		private var controlsText:RapidText;
		
		private var paddle1:RapidLine;
		private var paddle2:RapidLine;
		
		private var score:Number;
		
		public function SuperPong()
		{
			super();
		}
		
		public override function create():void
		{
			score = 0;
			setBackgroundColor(0x000000);
			RapidG.visualDebug = false;
			plIsland = new PointLineIsland();

			
			var line1:RapidLine = buildLine(pt1.x, pt1.y, pt2.x, pt2.y);
			var line2:RapidLine = buildLine(pt2.x, pt2.y, pt3.x, pt3.y);
			var line3:RapidLine = buildLine(pt3.x, pt3.y, pt4.x, pt4.y);
			var line4:RapidLine = buildLine(pt4.x, pt4.y, pt1.x, pt1.y);
			
			line2.visible = false;
			line4.visible = false;
			
			var shrink:Number = 125;
			
			paddle1 = new RapidLine(pt4.x, pt4.y - shrink, pt1.x, pt1.y + shrink);
			paddle2 = new RapidLine(pt2.x, pt2.y + shrink, pt3.x, pt3.y - shrink);
			
			point = new RapidPoint();
			//point.x = (LEFT + RIGHT)/2 + 10;
			//point.y = (TOP + BOTTOM)/2;
			point.x = LEFT + 10;
			point.y = TOP + 10;
			point.velocity.x = 100;
			point.velocity.y = 90;
			point.drawSize = 3;
			
			add(line1);
			add(line2);
			add(line3);
			add(line4);
			
			add(paddle1);
			add(paddle2);
			
			plIsland.points.push(point);
			add(point);
			
			
			titleText = new RapidText(0, 10, RapidG.width, "Super Pong", false);
			titleText.setFormat(null, 24, 0xFFFFFF, "center");
			flashSprite.addChild(titleText.textField);
			
			pointText = new RapidText(10, RapidG.height - 30, 350, "some text", false);
			pointText.setFormat(null, 18, 0xFFFFFF, "left");
			flashSprite.addChild(pointText.textField);
			
			var controlsMsg:String = "Q: Reset"; 
			/*"=== Controls === \n" +
									 "P : Pause \n" +
									 "]  : Step through the simulation while paused";
			*/
			var aWidth:Number = 250;
			controlsText = new RapidText(RapidG.width - aWidth, RapidG.height - 45, aWidth, controlsMsg, false);
			controlsText.setFormat(null, 10, 0xFFFFFF, "left");
			flashSprite.addChild(controlsText.textField);
		}
		
		private function buildLine(startX:Number=0, startY:Number=0, endX:Number=0, endY:Number=0):RapidLine
		{
			var line:RapidLine = new RapidLine(startX, startY, endX, endY);
			line.fixed = true;
			plIsland.lines.push(line);
			return line;
		}
		
		public override function preUpdate():void
		{
			plIsland.solve();

			super.preUpdate();
			
		}
		
		
		public override function update():void
		{
			TitleScreen.handleGlobalInput(host);

			
			var speedUp:Number = 5;
			point.velocity.x += (point.velocity.x > 0) ? speedUp : -speedUp;
			point.velocity.y += (point.velocity.y > 0) ? speedUp : -speedUp;
			
			// clamp for this demo
			var max:Number = 20000;
			point.velocity.x = RapidU.clamp(point.velocity.x, -max, max);
			point.velocity.y = RapidU.clamp(point.velocity.y, -max, max);
			
			if(point.x >= CENTER_X)
				paddle2.y =  RapidU.clamp(point.y - paddle2.center.y, TOP, BOTTOM-paddle2.height);
			else
				paddle1.y =  RapidU.clamp(point.y - paddle1.center.y, TOP-paddle1.height, BOTTOM);
			
			score += plIsland.collisionsResolvedThisFrame;
			pointText.text = "Score: " + score; 
			
			if(point.velocity.length > 9000)
			{
				titleText.text = "Super Collider";
			}
			
			super.update();
		}
		
		public override function updatePause():void
		{
			TitleScreen.handleGlobalInput(host);
		}
		
	}
}