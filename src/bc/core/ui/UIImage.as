package bc.core.ui 
{
	import bc.core.display.BcBitmapData;
	import bc.core.ui.UIObject;

	/**
	 * @author Elias Ku
	 */
	public class UIImage extends UIObject 
	{
		public function UIImage(layer:UIObject, x:Number, y:Number, image:String)
		{
			super(layer, x, y);
			_sprite.addChild(BcBitmapData.create(image));
		}
	}
}
