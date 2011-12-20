package bc.ui 
{
	import bc.core.ui.UI;
	import bc.core.ui.UIImage;
	import bc.core.ui.UIObject;

	/**
	 * @author Elias Ku
	 */
	public class UIGameTitle extends UIObject 
	{
		protected var _imgTitle:UIImage;
		protected var _flow:Number = 0;
		
		public function UIGameTitle(layer:UIObject, x:Number, y:Number)
		{
			super(layer, x, y);
			
			_imgTitle = new UIImage(this, 0, 0, "ui_title");
		}
		
		public override function update():void
		{
			super.update();
			
			const dt:Number = UI.deltaTime;
			
			_flow += dt*0.2;
			while(_flow > 1) _flow -= 1;
			
			_imgTitle.y = 4*Math.sin(Math.PI*2*_flow);
		}
	}
}
