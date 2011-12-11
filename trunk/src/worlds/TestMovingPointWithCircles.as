package worlds
{
	import flash.geom.Point;
	
	import org.rapidphysics.Collision;
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidText;
	import org.rapidphysics.RapidU;
	import org.rapidphysics.RapidWorld;
	import org.rapidphysics.Rlap;
	import org.rapidphysics.islands.PointCircleIsland;
	import org.rapidphysics.shapes.*;
	
	public class TestMovingPointWithCircles extends RapidWorld
	{
		private var LEFT:Number = 120;
		private var TOP:Number = 100;
			
		
		private var point:RapidPoint;
		
		private var titleText:RapidText;
		private var pointText:RapidText;
		private var controlsText:RapidText;
		
		private var island:PointCircleIsland;
		
		public function TestMovingPointWithCircles()
		{
			super();
		}
		
		public override function create():void
		{
			
			setBackgroundColor(0x000000);

			island = new PointCircleIsland();
			
			var MAXI:int = 4;
			var MAXJ:int = 3;
			var circle:RapidCircle;
			for(var i:int=0; i<MAXI; i++)
			{
				for(var j:int=0; j<MAXJ; j++)
				{
					if(i == 0 || i == MAXI-1 || j==0 || j == MAXJ-1)
					{
						circle = new RapidCircle(LEFT+ 125*i, TOP + 125*j, 70);
						island.circles.push(circle);
						add(circle);
					}
				}				
			}
			
			
			point = new RapidPoint(LEFT + 100, TOP + 100);
			//point.x = (LEFT + RIGHT)/2 + 10;
			//point.y = (TOP + BOTTOM)/2;
			point.velocity.x = 100;
			point.velocity.y = 30;
			point.thickness = 3;
			
			island.points.push(point);
			
			add(point);
			
			islandManager.add(island);
			
			
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
			
			//RapidG.paused = true;
		}
		
		
		public override function update():void
		{
			super.update();
			
			TitleScreen.handleGlobalInput(host);

			
			//point.velocity.x += (point.velocity.x > 0) ? 10 : -10;
			//point.velocity.y += (point.velocity.y > 0) ? 10 : -10;
			
			point.velocity.x *= 1.0125;
			point.velocity.y *= 1.0125;
			
			// clamp for this demo
			var max:Number = 20000;
			point.velocity.x = RapidU.clamp(point.velocity.x, -max, max);
			point.velocity.y = RapidU.clamp(point.velocity.y, -max, max);
			
			/*
			pointText.text = "velocity.x: " + point.velocity.x + "\n" +
							 "velocity.y: " + point.velocity.y;
			*/
			pointText.text = "velocity: " + point.velocity.length + "\n" +
				"collisions solved per frame: " + island.collisionsResolvedThisFrame;
				
		}
		
		public override function updatePause():void
		{
			TitleScreen.handleGlobalInput(host);
		}
		
	}
}