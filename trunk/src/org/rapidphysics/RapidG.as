package org.rapidphysics
{
	import flash.display.Stage;
	
	import org.rapidphysics.input.Keyboard;

	/**
	 * A few useful Globals are stored here
	 * @author Greg Lieberman
	 * 
	 */
	public class RapidG
	{
		
		static public const LIBRARY_NAME:String = "Rapid Physics";
		static public const LIBRARY_MAJOR_VERSION:uint = 0;
		static public const LIBRARY_MINOR_VERSION:uint = 75;
		static public const LIBRARY_COMMENT:String = "Beta";
		
		static public function get libraryDesc():String
		{
			return "Version " + LIBRARY_MAJOR_VERSION + "." + LIBRARY_MINOR_VERSION + " " + LIBRARY_COMMENT;
		}
		
		public static var mouseX:Number = 0;
		public static var mouseY:Number = 0;
		
		/**
		 * Halts the simulation 
		 */
		public static var paused:Boolean = false;
		/**
		 * Draws debug info (velocity each frame, line normals, etc) 
		 */		
		public static var visualDebug:Boolean = true;
		
		public static var width:Number;
		public static var height:Number;
				
		/**
		 * How much time has elapsed this frame 
		 */
		public static var elapsed:Number;
		public static var timeScale:Number = 1.0
		static public var maxElapsed:Number = 0.0333333;
		
		/**
		 * Change this to either INTEGRATION_EULER or INTEGRATION_VERLET depending on what your needs are (verlet is almost always better)
		 */
		static public var integrationMethod:Number = INTEGRATION_VERLET;
		static public const INTEGRATION_EULER:Number = 0;
		static public const INTEGRATION_VERLET:Number = 1;
		
		static public var stage:Stage;
		
		static public var frameRate:Number;
		
		public static var keys:Keyboard = new Keyboard();
		
		/**
		 * Stores all of the lines that visual debug needs for later drawing.
		 * Each entry is an array containing [x1, y1, x2, y2] 
		 */
		public static var visualDebugLines:Array = new Array();
		
		public function RapidG()
		{
		}
		
		
	}
}