package worlds
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import org.rapidphysics.RapidG;
	import org.rapidphysics.RapidSim;
	import org.rapidphysics.RapidText;
	import org.rapidphysics.RapidWorld;
	
	public class TitleScreen extends RapidWorld
	{
		private var title:RapidText;
		private var subtitle:RapidText;
		private var description:RapidText;
		
		
		private var field:TextField;
		
		public function TitleScreen()
		{
			super();
		}
		
		public override function create():void
		{
			setBackgroundColor(0xFFFFFF);

			var subtitleText:String = RapidG.libraryDesc;
			
			title = new RapidText(0, 10, RapidG.width, RapidG.LIBRARY_NAME, false);
			title.setFormat(null, 36, 0x000000, "center");
			flashSprite.addChild(title.textField);
			
			subtitle = new RapidText(0, 60, RapidG.width, subtitleText, false);
			subtitle.setFormat(null, 14, 0x000000, "center");
			flashSprite.addChild(subtitle.textField);
			
			var descText:String = 
				"Click on the screen to begin\n\n\n" +
				"=== Controls === \n" +
				"P: Pause \n" +
				"] : Step through the simulation while paused \n" +
				"Q: Reset the demo \n" +
				"O: Toggle Visual Debug \n" +
				"\n\n" +
				"--- Press keys 2-6 to browse different demos. ---\n" +
				"--- Press 1 to return to Title Screen ---";
				
			
			description = new RapidText(120, 150, RapidG.width, descText, false);
			description.setFormat(null, 18, 0x000000, "left");
			description.textField.height = 300;
			flashSprite.addChild(description.textField);
			
		}
		
		public override function update():void
		{
			super.update();
			
			TitleScreen.handleGlobalInput(host);
			
			//if(RapidG.keys.any())
			{
				//host.switchWorld(TestMovingPoint);
				//host.switchWorld(TestMovingPointWithCircles);
				//host.switchWorld(TestLineCircle);
				//host.switchWorld(SuperPong);
				//host.switchWorld(TestWorld);
				//host.switchWorld(TestCircles);
			
			}
		}
		
		public override function updatePause():void
		{
			TitleScreen.handleGlobalInput(host);
		}
		
		
		
		
		public static function handleGlobalInput(host:RapidSim):void
		{
			if(RapidG.keys.justPressed("ONE"))
			{
				RapidG.paused = false;
				host.switchWorld(TitleScreen);
			}
			if(RapidG.keys.justPressed("TWO"))
			{
				RapidG.paused = false;
				host.switchWorld(TestMovingPoint);				
			}
			if(RapidG.keys.justPressed("THREE"))
			{
				RapidG.paused = false;
				host.switchWorld(TestMovingPointWithCircles);
			}
			if(RapidG.keys.justPressed("FOUR"))
			{
				RapidG.paused = false;
				host.switchWorld(TestCircles);
			}
			if(RapidG.keys.justPressed("FIVE"))
			{
				RapidG.paused = false;
				host.switchWorld(TestLineCircle);
			}
			if(RapidG.keys.justPressed("SIX"))
			{
				RapidG.paused = false;
				host.switchWorld(SuperPong);
			}
			if(RapidG.keys.justPressed("SEVEN"))
			{
				
			}
		}
		
	}
}