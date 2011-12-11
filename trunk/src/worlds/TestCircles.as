package worlds
{
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidText;
	import org.rapidphysics.RapidWorld;
	import org.rapidphysics.shapes.*;
	
	/**
	 * Simple test of how close circles are to each other 
	 * @author greglieberman
	 * 
	 */
	public class TestCircles extends RapidWorld
	{
		private var c1:RapidCircle;
		private var c2:RapidCircle;
		private var c3:RapidCircle;
		
		private var titleText:RapidText;
		private var pointText:RapidText;
		
		public function TestCircles()
		{
			super();
		}
		
		public override function create():void
		{
			setBackgroundColor(0x000000);
			
			// title text
			titleText = new RapidText(0, 10, RapidG.width, "TestCircles\nMove the mouse around to guide the circle", false);
			titleText.setFormat(null, 12, 0xFFFFFF, "center");
			flashSprite.addChild(titleText.textField);
			
			// make circles
			c1 = new RapidCircle();
			c1.x = 100;
			c1.y = 100;
			c1.radius = 50;
			
			c2 = new RapidCircle();
			c2.x = 300;
			c2.y = 300;
			c2.radius = 50;
			
			c3 = new RapidCircle();
			c3.x = 400;
			c3.y = 200;
			c3.radius = 25;
			
			// add them to the simulation
			add(c3);
			add(c2);
			add(c1);
			
			// display text
			pointText = new RapidText(10, RapidG.height - 30, 350, "some text", false);
			pointText.setFormat(null, 10, 0xFFFFFF, "left");
			flashSprite.addChild(pointText.textField);
			
		}
		
		public override function update():void
		{
			TitleScreen.handleGlobalInput(host);

			// one of the circles follows the mouse
			c1.x = RapidG.mouseX;
			c1.y = RapidG.mouseY;
			
			// do an intersect text with the other two circles
			var result1:Number = RapidCircle.intersection(c1, c2);
			var result2:Number = RapidCircle.intersection(c1, c3);
			
			// display results
			pointText.text = "distance1: " + result1 + "\n" +
							 "distance2: " + result2;
		}
		
		public override function updatePause():void
		{
			TitleScreen.handleGlobalInput(host);
		}
		
	}
}