package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UIPanel extends UIObject
	{

		public function UIPanel(layer:UIObject, x:Number = 0, y:Number = 0, fast:Boolean = true, name : String = null)
		{
			super(layer, x, y, fast);
			
			if (name != null) _sprite.name = name;
			_sprite.visible = false;
			_enabled = false;
			_active = false;
		}
		
	}
}
