package org.rapidphysics
{
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * RapidWorld is like FlxState. All physics, gameplay, and/or menu screens should be classes that extend RapidWorld
	 * @author greglieberman
	 * 
	 */
	public class RapidWorld extends RapidGroup
	{
		/**
		 * Convenient access point to the Flash Display List 
		 */
		public var flashSprite:Sprite;
		protected var visualDebugShape:Shape;
		protected var host:RapidSim;
		
		/**
		 * Add your Islands to this manager! 
		 */
		protected var islandManager:IslandManager;
		
		public function RapidWorld()
		{
			super();
			flashSprite = new Sprite();
			visualDebugShape = new Shape();
			islandManager = new IslandManager();
			flashSprite.addChild(visualDebugShape);
		}
		
		public function setBackgroundColor(color:uint, alpha:Number=1.0):void
		{
			flashSprite.graphics.clear();
			flashSprite.graphics.beginFill(color, alpha);
			flashSprite.graphics.drawRect(flashSprite.x, flashSprite.y, RapidG.width, RapidG.height);
			flashSprite.graphics.endFill();
		}
		
		public function setHost(host:RapidSim):void
		{
			this.host = host;
		}
		
		/**
		 * Override this function with your initilization code 
		 * 
		 */
		public function create():void
		{
		
		}
		
		/**
		 * Add objects to the world (very important!) 
		 * @param basic
		 * 
		 */
		public override function add(basic:RapidBasic):void
		{
			super.add(basic);
			
			// if this is a RapidObject, add it's shape to the Flash Display List (very hacky)
			var object:RapidObject = basic as RapidObject;
			if(object)
				flashSprite.addChild(object.shape);
		}
		
		public override function preUpdate():void
		{
			// gather possible collisions, and sort by time, then solve
			islandManager.solve();

			super.preUpdate();
			
			// all RapidObjects have moved to their next position
			
		}
		
		public override function postUpdate():void
		{
			super.postUpdate();
			
			// all RapidObjects have predicted their next positions (useful for drawing)
		}
		
		/**
		 * Called when the simulation is paused 
		 * 
		 */
		public function updatePause():void
		{
		
		}
		
		public override function preDraw():void
		{
			super.preDraw();
			visualDebugShape.graphics.clear();
		}
		
		public override function debugDraw():void
		{
			super.debugDraw();
			
			visualDebugShape.graphics.lineStyle(1, 0xFFFF00, 1);
			for each(var array:Array in RapidG.visualDebugLines)
			{
				visualDebugShape.graphics.moveTo(array[0], array[1]);
				visualDebugShape.graphics.lineTo(array[2], array[3]);
			}
			
		}
		
		
		
		
		
	}
}