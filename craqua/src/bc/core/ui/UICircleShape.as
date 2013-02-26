package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UICircleShape 
	{
		private var _x:Number;
		private var _y:Number;
		private var _r:Number;
		
		public function UICircleShape(radius:Number, x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
			_r = radius;
		}
		
		public function testMouse(x:Number, y:Number):Boolean
		{
			const dx:Number = x - _x;
			const dy:Number = y - _y;
			
			return (dx*dx + dy*dy) <= _r*_r;
		}
	}
}
