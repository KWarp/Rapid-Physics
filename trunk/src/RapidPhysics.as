package
{
	import flash.display.Sprite;
	
	import org.rapidphysics.RapidSim;
	
	import worlds.*;
	
	[SWF(width="640", height="480", backgroundColor="#333333")] //Set the size and color of the Flash file
	
	
	/**
	 * This class uses the rapid physics library 
	 * @author Greg Lieberman
	 * 
	 */
	public class RapidPhysics extends RapidSim
	{
		public static const FRAME_RATE:Number = 60;
		public static const WIDTH:Number = 640;
		public static const HEIGHT:Number = 480;

		public function RapidPhysics()
		{
			super(TitleScreen, FRAME_RATE, WIDTH, HEIGHT);
		}
		
		
	}
}