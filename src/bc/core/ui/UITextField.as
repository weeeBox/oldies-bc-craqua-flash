package bc.core.ui 
{
	/**
	 * @author weee
	 */
	public class UITextField extends UIObject 
	{
		private var _text : String;
		private var _width : uint;
		private var _height : uint;
	
		// TODO: fix me!!!
		public function UITextField(layer:UIObject = null, x:Number = 0, y:Number = 0, fast:Boolean = true)
		{
			super(layer, x, y, fast);
		}
		
		public function get text() : String 
		{ 
			return text; 
		}
		
		public function set text(text : String) : void 
		{
			this._text = text;
		}
		
		public function get width() : uint
		{
			return _width;
		}
		
		public function set width(width : uint) : void 
		{
			_width = width;
		}
		
		public function get height() : uint
		{
			return _height;
		}
		
		public function set height(height : uint) : void 
		{
			_height = height;
		}
	}
}
