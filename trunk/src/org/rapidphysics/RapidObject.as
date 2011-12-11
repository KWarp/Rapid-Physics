package org.rapidphysics
{
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * This class has LOTS of physics properties. 
	 * @author greglieberman
	 * 
	 */
	public class RapidObject extends RapidBasic
	{
		// x, y position
		public function get x():Number { return position.x; }
		public function get y():Number { return position.y; }
		public function set x(value:Number):void { position.x = value; }
		public function set y(value:Number):void { position.y = value; }
		public var position:Point;
		
		public var prevX:Number;
		public var prevY:Number;
		
		// predicted x,y for next frame
		public function get nextX():Number { return nextPosition.x; }
		public function get nextY():Number { return nextPosition.y; }
		public function set nextX(value:Number):void { nextPosition.x = value; }
		public function set nextY(value:Number):void { nextPosition.y = value; }
		public var nextPosition:Point;
				
		/**
		 * Depending on the shape, width can totally be negative!
		 */
		public var width:Number;
		/**
		 * Depending on the shape, height can totally be negative! 
		 */
		public var height:Number;
		
		/**
		 * Mess with this in your update loop 
		 */
		public var acceleration:Point;
		/**
		 * Mess with this in your update loop 
		 */
		public var velocity:Point;
		/**
		 * @readonly Read-only 
		 */
		public var nextVelocity:Point;
		
		public var maxVelocity:Point;
		
		/**
		 * Relative to (x,y) 
		 */
		public var center:Point;
		public var radians:Number;
		
		public var shape:Shape;
		public var thickness:Number = 1;
		/**
		 * 0xRRGGBB 
		 */
		public var lineColor:uint;
		public var fillColor:uint;

		protected var alpha:Number;
		/**
		 * General usage 
		 */
		protected var _point:Point;
		
		/**
		 * Set to true to prevent this object from moving 
		 */
		public var fixed:Boolean = false;
		
		private var didFirstUpdate:Boolean;
		
		/**
		 * I wrote some code to allow dynamic changes between Euler integration and Verlet integration.
		 * This isn't too practical for actual usage, but good for engine development 
		 */
		public var predictMotionFunction:Function;
		private var integrationMapper:Array;
		
		private var velColor:uint = 0x0000FF; // yellow
		private var accColor:uint = 0xFF0000; // red
		
		public function RapidObject(X:Number=0, Y:Number=0)
		{
			super();
			
			position = new Point(X,Y);
			nextPosition = new Point(X,Y);
			width = 0;
			height = 0;
			_point = new Point();
			acceleration = new Point();
			velocity = new Point();
			nextVelocity = new Point();
			maxVelocity = new Point(25000, 25000);
			center = new Point(X, Y);
			radians = 0;
			
			shape = new Shape();
			lineColor = 0xFFFFFF;
			fillColor = 0xFFFFFF;
			alpha = 1.0;
			
			integrationMapper = new Array();
			integrationMapper[RapidG.INTEGRATION_EULER] = predictMotionEuler;
			integrationMapper[RapidG.INTEGRATION_VERLET] = predictMotionVerlet;
			
			setIntegrationMethod(RapidG.integrationMethod);	
			
			didFirstUpdate = false;
		}
		
		public function reset(X:Number, Y:Number):void
		{
			x = X;
			y = Y;
			didFirstUpdate = false;
		}
		
		public override function destroy():void
		{
			acceleration = null;
			velocity = null;
			maxVelocity = null;
			center = null;
			shape = null;
			integrationMapper = null;
			
			super.destroy();
		}
		
		/**
		 * Occurs right after collision resolution
		 * Set x to nextX, etc etc 
		 * 
		 */
		public override function preUpdate():void
		{
			super.preUpdate();
			
			if(fixed || !didFirstUpdate)
			{
				nextX = x;
				nextY = y;
				nextVelocity.x = velocity.x;
				nextVelocity.y = velocity.y;
			}
			
			updateMotion();
			updateCenter();
			
		}
		
		/**
		 * Add your game's update logic here 
		 * 
		 */
		public override function update():void
		{
			super.update();
		}
	
		
		/**
		 * Predicts where this object will be by the next preUpdate() 
		 * Provides enough information to draw physics information, and resolve collisions
		 */
		public override function postUpdate():void
		{
			super.postUpdate();
			
			if(!fixed)
			{
				predictMotionFunction();
			}

			didFirstUpdate = true;

		}
		
		protected function updateMotion():void
		{				
			prevX = x;
			prevY = y;
			x = nextX;
			y = nextY;
			velocity.x = nextVelocity.x;
			velocity.y = nextVelocity.y;
			
			if(RapidG.visualDebug)
			{
				RapidG.visualDebugLines.push( [prevX, prevY, x, y] );
			}
		}
		
		/**
		 * Override this function if your shape has a different center 
		 * 
		 */
		protected function updateCenter():void
		{
			center.x = width/2;
			center.y = height/2;
		}
		
		public override function preDraw():void
		{
			shape.graphics.clear();
		}
		
		public override function draw():void
		{
			super.draw();
		}
		
		public override function debugDraw():void
		{
			super.debugDraw();
			
			// draw velocity
			shape.graphics.lineStyle(1, velColor, 1);
			shape.graphics.moveTo(x + center.x, y + center.y);
			shape.graphics.lineTo(nextX + center.x, nextY + center.y);
			
		}
		
		/**
		 * takes RapidG.INTEGRATION_EULER, etc.
		 * @param method
		 * 
		 */
		public function setIntegrationMethod(method:Number):void
		{
			if(method < 0 || method > integrationMapper.length)
				return;
			
			predictMotionFunction = integrationMapper[method];
		}
		
		protected function predictMotionEuler():void
		{
			nextVelocity.x = velocity.x + acceleration.x * RapidG.elapsed;
			nextVelocity.y = velocity.y + acceleration.y * RapidG.elapsed;
			nextVelocity.x = RapidU.clamp(nextVelocity.x, -maxVelocity.x, maxVelocity.x);
			nextVelocity.y = RapidU.clamp(nextVelocity.y, -maxVelocity.y, maxVelocity.y);
			
			nextX = x + nextVelocity.x * RapidG.elapsed;
			nextY = y + nextVelocity.y * RapidG.elapsed;
		}
		
		protected function predictMotionVerlet():void
		{
			var velocityDelta:Number;
			var delta:Number;
			
			velocityDelta = (acceleration.x*RapidG.elapsed)/2;
			nextVelocity.x = velocity.x + velocityDelta;
			delta = nextVelocity.x*RapidG.elapsed;
			nextVelocity.x = RapidU.clamp(nextVelocity.x, -maxVelocity.x, maxVelocity.x);
			nextVelocity.x += velocityDelta;
			nextX = x + delta;
			 
			velocityDelta = (acceleration.y*RapidG.elapsed)/2;
			nextVelocity.y = velocity.y + velocityDelta;
			nextVelocity.y = RapidU.clamp(nextVelocity.y, -maxVelocity.y, maxVelocity.y);
			delta = nextVelocity.y*RapidG.elapsed;
			nextVelocity.y += velocityDelta;
			nextY = y + delta;
		}
		
	
		
		
		
	}
}