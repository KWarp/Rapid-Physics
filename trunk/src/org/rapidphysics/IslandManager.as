package org.rapidphysics
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.rapidphysics.islands.Island;
	import org.rapidphysics.shapes.RapidLine;
	import org.rapidphysics.shapes.RapidPoint;
	import org.rapidphysics.system.RapidHeap;

	/**
	 * Tracks a list of islands. A RapidWorld tells it's IslandManager to solve all of the islands every frame.
	 * @author greglieberman
	 * 
	 */
	public class IslandManager
	{
		private var islands:Vector.<Island>;

		
		public function IslandManager()
		{
			super();
			islands = new Vector.<Island>();
		}
		
		public function add(island:Island):void
		{
			islands.push(island);
		}
		
		internal function solve():void
		{
			for each(var island:Island in islands)
			{
				island.solve();
			}
		}
		
		
	}
}