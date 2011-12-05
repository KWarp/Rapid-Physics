package org.rapidphysics.system
{
	import org.rapidphysics.Collision;
	
	/**
	 * A Binary Heap
	 * min heap with vector implementation
	 * 
	 * 
	 * */
	public class RapidHeap
	{
		private var data:Vector.<Collision>;
		/**
		 * points to the next empty location in the array
		 */
		private var heapLength:int;
		public function get length():int { return heapLength; }
		
		//the function for which to compare arguments
		private var compare:Function;
		
		public function RapidHeap(pCompare:Function)
		{
			data = new Vector.<Collision>();
			heapLength = 0;
			compare = pCompare;
		}
		
		public function clear():void
		{
			// I would like to put this code somewhere else
			for each(var c:Collision in data)
			{
				if(c != null)
					c.destroy();
			}	
			data.length = 0;
			heapLength = 0;
		}
		
		public function isEmpty() :Boolean 
		{
			return heapLength == 0;
		}
		
		/**
		 * Add the element on the bottom level of the heap.
		 * Compare the added element with its parent; if they are in the correct order, stop.
		 * If not, swap the element with its parent and return to the previous step.
		 * @param obj
		 * 
		 */
		public function insert(obj:Collision) : void 
		{
			var temp:Collision;
			var i:int = heapLength;
			var parent:int = Math.floor( (i-1)/2 );
			data[i] = obj;
			heapLength++;
			
			// while the heap is not in the correct state
			while(i != 0 && compare(data[i], data[parent]) < 0) 
			{
				// swap parent and child
				temp = data[i];
				data[i] = data[parent];
				data[parent] = temp;
				//move up
				i = parent;
				parent = Math.floor( (i-1)/2 );
			}	
		}
		

		/**
		 * remove the root
		 * put the bottom element in its place
		 * heapify
		 * @return 
		 * 
		 */
		public function removeMin():Collision 
		{
			if(heapLength == 0) 
			{
				trace("Warning: Heap is empty");
				return null;
			}
			heapLength--;
			var returnItem:Collision = data[0];
			data[0] = data[heapLength];
			data[heapLength] = null;
			heapify(0);
			return returnItem;
		}
		
		private function heapify(index:int) : void 
		{
			// child indicies
			var left:int = 2*index+1;
			var right:int = 2*index+2;
			var smallest:int;
			var temp:Collision;
			if(left < heapLength && compare(data[index], data[left]) >= 0) 
			{
				smallest = left;	
			} 
			else 
			{
				smallest = index;
			}
			if(right < heapLength && compare(data[smallest], data[right]) >= 0) 
			{
				smallest = right;
			}
			
			if(smallest != index) 
			{
				//swap
				temp = data[index];
				data[index] = data[smallest];
				data[smallest] = temp;
				heapify(smallest);
			}
		}
		
	}
}