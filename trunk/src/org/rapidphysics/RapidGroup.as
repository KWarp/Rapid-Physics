package org.rapidphysics
{
	import flash.utils.Dictionary;

	/**
	 * Group objects together, like FlxGroup
	 * @author greglieberman
	 * 
	 */
	public class RapidGroup extends RapidBasic
	{
		protected var members:Vector.<RapidBasic>;
		protected var membersDict:Dictionary;
		
		public function RapidGroup()
		{
			super();
			
			members = new Vector.<RapidBasic>();
			membersDict = new Dictionary(true);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			for each(var basic:RapidBasic in members)
			{
				basic.destroy();
			}
			members = null;
			membersDict = null;
		}
		
		public function add(basic:RapidBasic):void
		{
			// don't add the same object twice
			if(basic in membersDict)
				return;
			
			membersDict[basic] = true;
			members.push(basic);
		}
		
		/**
		 *  
		 * @return the first RapidBasic that does not exist, otherwise null
		 * 
		 */
		public function recycle():RapidBasic
		{
			for each(var basic:RapidBasic in members)
			{
				if(!basic.exists)
				{
					basic.exists = true;
					return basic;
				}
			}	
			return null;
		}
		
		public override function preUpdate():void
		{
			super.preUpdate();
			
			for each(var basic:RapidBasic in members)
			{
				if(basic.active)
					basic.preUpdate();
			}
		}
		
		public override function update():void
		{
			super.update();
			
			for each(var basic:RapidBasic in members)
			{
				if(basic.active)
					basic.update();
			}
		}
		
		public override function postUpdate():void
		{
			super.postUpdate();
			
			for each(var basic:RapidBasic in members)
			{
				if(basic.active)
					basic.postUpdate();
			}
		}
		
		public override function preDraw():void
		{
			super.preDraw();
			
			for each(var basic:RapidBasic in members)
			{
				basic.preDraw();
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			for each(var basic:RapidBasic in members)
			{
				if(basic.visible)
					basic.draw();
			}
		}
		
		public override function debugDraw():void
		{
			super.debugDraw();
			
			for each(var basic:RapidBasic in members)
			{
				basic.debugDraw();
			}
		}
		
		
	}
}