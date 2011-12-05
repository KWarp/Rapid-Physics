package org.rapidphysics
{
	import flash.geom.Point;

	/**
	 * Stores information about collisions that occur in the simulation. 
	 * Collisions deal with two objects at a time.
	 * @author Greg Lieberman
	 * 
	 */
	public class Collision extends RapidBasic
	{
		
		/**
		 * 0 = this frame
		 * 1 = next frame 
		 */		
		public var time:Number;
		
		public var obj1:RapidObject;
		public var obj2:RapidObject;
		public var pointOfCollision:Point;
		
		/**
		 * Function pointer to resolve the collision
		 * resolve(obj1:RapidObject, obj2:RapidObject, pointOfCollision:Point)
		 */
		private var resolve:Function;
		
		
		public function Collision()
		{			
			pointOfCollision = new Point();
		}
		
		public function init(obj1:RapidObject, obj2:RapidObject, resolveFunction:Function):void
		{
			time = 0;
			this.obj1 = obj1;
			this.obj2 = obj2;
			resolve = resolveFunction;
			
		}
		
		public function resolveCollision():void
		{
			resolve(obj1, obj2, pointOfCollision);
		}
		
	}
}