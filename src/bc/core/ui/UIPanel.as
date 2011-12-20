package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UIPanel extends UIObject
	{

		public function UIPanel(layer:UIObject, x:Number = 0, y:Number = 0, fast:Boolean = true)
		{
			super(layer, x, y, fast);
			
			_sprite.visible = false;
			_enabled = false;
			_active = false;
		}
		
	}
}
