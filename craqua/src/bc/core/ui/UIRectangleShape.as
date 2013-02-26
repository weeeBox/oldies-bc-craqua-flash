package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UIRectangleShape implements IUIShape 
	{
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function UIRectangleShape(width:Number, height:Number, x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		public function testMouse(x:Number, y:Number):Boolean
		{
			return (x >= _x && y >= _y && x <= _x + _width && y <= _y + _height);
		}
		
		
	}
}
