package bc.world.enemy.actions 
{
	import bc.core.display.BcBitmapData;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.actions.BcIEnemyAction;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcEnemyBitmapAction implements BcIEnemyAction 
	{
		public var node:String;
		public var bitmapData:BcBitmapData;
		
		public function BcEnemyBitmapAction(xml:XML)
		{
			if(xml.hasOwnProperty("@data"))
			{
				bitmapData = BcBitmapData.getData(xml.@data);
			}
			
			node = xml.@node.toString();
		}
		
		public function action(enemy:BcEnemy):void
		{
			var bm:DisplayObject = enemy.sprite.lookup[node];
			if(bm is Bitmap)
			{
				if(bitmapData)
				{
					bitmapData.setupBitmap(Bitmap(bm));
				}
				else
				{
					Bitmap(bm).bitmapData = null;
				}
			}
		}
	}
}
