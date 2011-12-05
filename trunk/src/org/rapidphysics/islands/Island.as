package org.rapidphysics.islands
{
	import flash.utils.Dictionary;
	
	import org.rapidphysics.Collision;
	import org.rapidphysics.RapidGroup;
	import org.rapidphysics.RapidU;
	import org.rapidphysics.system.RapidHeap;

	/**
	 * Base class for a collection of objects whose collisions should be solved.
	 * Subclasses should define lists of objects with which to compare.
	 * This class contains the core collision solving algorithm common to all Islands.
	 * 
	 * @author greglieberman
	 * 
	 */
	public class Island
	{
		
		/**
		 * A collection of collisions sorted by time (very fast) 
		 */
		protected var collisions:RapidHeap;
		
		/**
		 * used for Collision object recycling (for performance and memory purposes) 
		 */
		private var collisionList:RapidGroup;
		
		/**
		 * Double dictionary of resolved collision times
		 * maps [obj1][obj2] => [time of latest collision resolution]
		 */
		protected var doubleDict:Dictionary;
		
		/**
		 * A mechanism to prevent infinite loops. Don't try to solve collisions more than this number of times per frame 
		 */
		protected var collectCollisionsMax:Number = 15;
		protected var collectCollisionsCount:Number;
		
		/**
		 * How many collisions resolved this frame. Useful for debugging!
		 */
		protected var m_collisionsResolvedThisFrame:Number;
		public function get collisionsResolvedThisFrame():Number { return m_collisionsResolvedThisFrame; }
		

		public function Island()
		{
			super();
			collisions = new RapidHeap(compareByTime);
			doubleDict = new Dictionary(true);
			collisionList = new RapidGroup();
			
		}
		
		/**
		 * Solves all of the collisions in the island. Called by an IslandManager each frame. 
		 * 
		 */
		public function solve():void
		{
			prepare();
			collectCollisions(0);
			collectCollisionsCount++;
			solveCollisions();
		}
		
		/**
		 * Resets collision management variables 
		 */
		private function prepare():void
		{
			m_collisionsResolvedThisFrame = 0;
			collectCollisionsCount = 0;
			collisions.clear();
			doubleDict = new Dictionary(true); // relying on garbage collection to remove older dictionaries
		}
		
		
		/**
		 * A simple compare function for the collisions Heap 
		 * @param c1
		 * @param c2
		 * @return 
		 * 
		 */
		private function compareByTime(c1:Collision, c2:Collision):Number
		{
			return c1.time - c2.time;
		}
		
		/**
		 * Override this method with your collision detection code
		 * @param frameTime
		 * 
		 */
		protected function collectCollisions(frameTime:Number):void
		{
			
		}

		
		/**
		 * Call this function in your implementation of collectCollisions() 
		 * @param c
		 * 
		 */
		protected function addCollision(c:Collision):void
		{
			// add to the heap, the recycle list, and the dictionary
			collisions.insert(c);
			collisionList.add(c);
			
			if( !(c.obj1 in doubleDict))
			{
				doubleDict[c.obj1] = new Dictionary(true);
			}
			if( !(c.obj2 in doubleDict[c.obj1]))
			{
				doubleDict[c.obj1][c.obj2] = -1;
			}
			
		}
		
		protected function recycleCollision():Collision
		{
			var c:Collision = collisionList.recycle() as Collision;
			if(c == null)
				c = new Collision();
			
			return c;
		}
		
		/**
		 * This is the core collision solving algorithm for all of RapidPhysics.
		 * 
		 * Don't override this unless you know what you're doing! 
		 * While there are collisions to resolve, resolve them.
		 * 
		 * This algorithm solves collisions perfectly, but is somewhat slow.
		 * Try to avoid large numbers of objects that frequently collide with each other.
		 * 
		 */
		protected function solveCollisions():void
		{
			var c:Collision;
			var resolvedTime:Number;
			
			// where there are unresolved collisions this frame
			while( !collisions.isEmpty() )
			{
				// get the earliest collision that occured this frame 
				// and compare it to the most recent solved time in the dictionary
				c = collisions.removeMin();
				var latestTime:Number = doubleDict[c.obj1][c.obj2];
				if( shouldIgnoreCollision(c, latestTime) )
				{
					c.destroy();
					continue;
				}
				
				// solve the collision and store this information in the doubleDictionary
				c.resolveCollision();
				resolvedTime = c.time;
				doubleDict[c.obj1][c.obj2] = resolvedTime;
				m_collisionsResolvedThisFrame++;
				// destroy the collision now that I am done with it
				c.destroy();
				// resolving a collision potentially invalidates future collisions
				collisions.clear();
				// collect collisions again (VERY EXPENSIVE, but necessary!)
				collectCollisions(resolvedTime);
				collectCollisionsCount++;
				
				if(collectCollisionsCount >= collectCollisionsMax)
				{
					// I'm stuck in an infinite loop
					break;
				}
				
			}
		}
		
		/**
		 * Should this particular collision condition be ignored?
		 * @param c
		 * @param time
		 * @return 
		 * 
		 */
		private function shouldIgnoreCollision(c:Collision, time:Number):Boolean
		{
			if(time == -1)
			{
				// both objects have not been resolved at all this frame
				return false;
			}
			
			// accounting for floating point error is CRUCIAL
			if(RapidU.sameNumber(c.time, time, 0.000125))
			{
				// this collision at this time has been resolved already
				return true;
			}
			
			if(c.time < time)
			{
				// somehow, we missed solving a collision?
				throw new Error("Investigate how this happened...");
			}
			
			// if time is greater, then we have a new, and different collision to resolve with the same two objects
			return false;
		}
		
		
	}
}