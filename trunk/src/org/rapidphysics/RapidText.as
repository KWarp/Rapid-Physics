package org.rapidphysics
{
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	

	/**
	 * This class is a careful rip and downgrade of FlxText. I just needed an easy way to throw text into this engine. 
	 * @author greglieberman
	 * 
	 */
	public class RapidText extends RapidObject
	{
		/**
		 * Internal reference to a Flash <code>TextField</code> object.
		 */
		protected var _textField:TextField;
		public function get textField():TextField { return _textField; }

		/**
		 * Creates a new <code>FlxText</code> object at the specified position.
		 * 
		 * @param	X				The X position of the text.
		 * @param	Y				The Y position of the text.
		 * @param	Width			The width of the text object (height is determined automatically).
		 * @param	Text			The actual text you would like to display initially.
		 * @param	EmbeddedFont	Whether this text field uses embedded fonts or nto
		 */
		public function RapidText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true)
		{
			super(X,Y);
			
			if(Text == null)
				Text = "";
			_textField = new TextField();
			_textField.x = X;
			_textField.y = Y;
			_textField.width = Width;
			_textField.embedFonts = EmbeddedFont;
			_textField.selectable = false;
			_textField.sharpness = 100;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.text = Text;
			var format:TextFormat = new TextFormat("system",8,0xffffff);
			_textField.defaultTextFormat = format;
			_textField.setTextFormat(format);
			if(Text.length <= 0)
				_textField.height = 1;
			else
				_textField.height = 50;
			
			
		
		}
		
		/**
		 * Clean up memory.
		 */
		override public function destroy():void
		{
			_textField = null;
			super.destroy();
		}
		
		/**
		 * You can use this if you have a lot of text parameters
		 * to set instead of the individual properties.
		 * 
		 * @param	Font		The name of the font face for the text display.
		 * @param	Size		The size of the font (in pixels essentially).
		 * @param	Color		The color of the text in traditional flash 0xRRGGBB format.
		 * @param	Alignment	A string representing the desired alignment ("left,"right" or "center").
		 * @param	ShadowColor	A uint representing the desired text shadow color in flash 0xRRGGBB format.
		 * 
		 * @return	This FlxText instance (nice for chaining stuff together, if you're into that).
		 */
		public function setFormat(Font:String=null,Size:Number=12,Color:uint=0xffffff,Alignment:String=null):RapidText
		{
			if(Font == null)
				Font = "";
			var format:TextFormat = _textField.defaultTextFormat;
			format.font = Font;
			format.size = Size;
			format.color = Color;
			format.align = Alignment;
			_textField.defaultTextFormat = format;
			_textField.setTextFormat(format);

			return this;
		}
		
		/**
		 * The text being displayed.
		 */
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
		}
		
		
		/**
		 * The size of the text being displayed.
		 */
		 public function get size():Number
		{
			return _textField.defaultTextFormat.size as Number;
		}
		
		
		
	
		
		/**
		 * The font used for this text.
		 */
		public function get font():String
		{
			return _textField.defaultTextFormat.font;
		}
		
		
		
		/**
		 * The alignment of the font ("left", "right", or "center").
		 */
		public function get alignment():String
		{
			return _textField.defaultTextFormat.align;
		}
		
		
		
	
		
		
		
		
	}
}
