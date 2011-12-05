package org.rapidphysics
{
	/**
	 * Like FlxBasic in Flixel 
	 * @author greglieberman
	 * 
	 */
	public class RapidBasic
	{
		public var active:Boolean;
		public var visible:Boolean;
		public var exists:Boolean;
		
		public function RapidBasic()
		{
			active = true;
			visible = true;
			exists = true;
		}
		
		public function preUpdate():void
		{
		
		}
		
		public function update():void
		{
		
		}
		
		public function postUpdate():void
		{
		
		}
		
		public function preDraw():void
		{
		
		}
		
		public function debugDraw():void
		{
		
		}
		
		public function draw():void
		{
		
		}
		
		public function destroy():void
		{
			exists = false;
		}
		
	}
}