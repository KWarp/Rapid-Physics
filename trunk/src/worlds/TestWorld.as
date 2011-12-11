package worlds
{
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidWorld;
	import org.rapidphysics.shapes.RapidLine;
	import org.rapidphysics.shapes.RapidPoint;
	
	public class TestWorld extends RapidWorld
	{
		public function TestWorld()
		{
			super();
		}
		
		public override function create():void
		{
			setBackgroundColor(0x000000);
			
			var line:RapidLine = new RapidLine();
			line.x = 10;
			line.y = 10;
			line.width = 0;
			line.height = 50;
			line.acceleration.x = 50;
			
			var line2:RapidLine = new RapidLine();
			line2.x = 10;
			line2.y = 70;
			line2.width = 0;
			line2.height = 50;
			line2.acceleration.x = 50;
			
			var point:RapidPoint = new RapidPoint();
			point.x = 50;
			point.y = 150;
			point.velocity.x = 5;
			point.velocity.y = 25;
			
			
			add(line);
			add(line2);
			add(point);
		}
		
		public override function updatePause():void
		{
			TitleScreen.handleGlobalInput(host);
		}
		
		
	}
}