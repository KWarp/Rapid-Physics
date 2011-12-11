package org.rapidphysics
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	/**
	 * This is a top-level class that runs a rapid physics simulation.  
	 * @author greglieberman
	 * 
	 */
	public class RapidSim extends Sprite
	{
		
		private var currentWorld:Class;
		private var currentWorldInstance:RapidWorld;
		private var requestedWorld:Class;
		
		/**
		 * Total number of milliseconds elapsed since game start.
		 */
		protected var _total:uint;
		
		/**
		 * 
		 * 
		 */
		public function RapidSim(initState:Class, frameRate:Number, width:Number, height:Number)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			requestedWorld = initState;
			RapidG.frameRate = frameRate;
			RapidG.width = width;
			RapidG.height = height;
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			RapidG.stage = stage;
			stage.frameRate = RapidG.frameRate;
			_total = getTimer();
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Switch physics worlds here 
		 * @param world
		 * 
		 */
		public function switchWorld(world:Class):void
		{
			requestedWorld = world;
		}
		
		private function doSwitch():void
		{
			// destroy old world
			if(currentWorldInstance)
			{
				removeChild(currentWorldInstance.flashSprite);
				currentWorldInstance.destroy();
			}
			// set new world
			currentWorld = requestedWorld;
			requestedWorld = null;
			
			// create new world
			currentWorldInstance = new currentWorld();
			currentWorldInstance.setHost(this);
			stage.focus = currentWorldInstance.flashSprite;
			currentWorldInstance.create();
			addChild(currentWorldInstance.flashSprite);
		}
		
		/**
		 * Heavy lifting of the simulation run 
		 * @param e
		 * 
		 */
		protected function onEnterFrame(e:Event):void
		{
			var mark:uint = getTimer();
			var elapsedMS:uint = mark-_total;
			
			//Frame timing
			var elapsed:Number = elapsedMS/1000;
			_total = mark;
			RapidG.elapsed = elapsed;
			if(RapidG.elapsed > RapidG.maxElapsed)
				RapidG.elapsed = RapidG.maxElapsed;
			RapidG.elapsed *= RapidG.timeScale;
			
			// switch worlds
			if(requestedWorld != null)
				doSwitch();
			
			updateInput();
			
			if(RapidG.paused)
			{
				currentWorldInstance.updatePause();
				// update pause
				if(RapidG.keys.justReleased("RBRACKET"))
					step();
			}
			else
			{
				step();
			}
			
			currentWorldInstance.preDraw();
			currentWorldInstance.draw();
			if(RapidG.visualDebug)
			{
				currentWorldInstance.debugDraw();
			}
			
		}
		
		protected function updateInput():void
		{
			RapidG.keys.update();
			
			// pause game
			if(RapidG.keys.justPressed("P"))
				RapidG.paused = !RapidG.paused;
			
			if(RapidG.keys.justPressed("O"))
				RapidG.visualDebug = !RapidG.visualDebug;
			
			// reset state
			if(RapidG.keys.justPressed("Q"))
			{
				RapidG.paused = false;
				switchWorld(currentWorld);
			}
		}
		
		protected function step():void
		{
			RapidG.visualDebugLines.length = 0; // clear 
			
			RapidG.mouseX = this.mouseX;
			RapidG.mouseY = this.mouseY;
			
			currentWorldInstance.preUpdate();
			currentWorldInstance.update();
			currentWorldInstance.postUpdate();
		}
		
		
		/**
		 * Internal event handler for input and focus.
		 * 
		 * @param	FlashEvent	Flash keyboard event.
		 */
		protected function onKeyDown(FlashEvent:KeyboardEvent):void
		{
			RapidG.keys.handleKeyDown(FlashEvent);
		}
		
		protected function onKeyUp(FlashEvent:KeyboardEvent):void
		{
			RapidG.keys.handleKeyUp(FlashEvent);
		}
		
		
	}
}