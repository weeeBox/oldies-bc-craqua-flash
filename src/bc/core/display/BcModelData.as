package bc.core.display 
{
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;

	/**
	 * @author Elias Ku
	 */
	public class BcModelData implements BcIObjectData 
	{
		public var root:BcModelNode;
		
		public var lookup:Object = new Object();
		
		private var index:int;
		
		public function BcModelData()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var newRoot:BcModelNode = new BcModelNode();

			newRoot.id = "root";
			newRoot.parseSprite(xml);
			newRoot.parseChildren(xml);
			
			setupRoot(newRoot);
		}
		
		private function setupRoot(root:BcModelNode):void
		{
			index = 0;
			this.root = root;
			setupNode(root, 0);
		}
		
		private function setupNode(node:BcModelNode, parentIndex:int):void
		{	
			node.index = index;
			node.parent = parentIndex;
			if(node.id)
			{
				lookup[node.id] = node.index;
			}
			
			++index;
			
			if(node.children)
			{
				for each (var iter:BcModelNode in node.children)
				{
					setupNode(iter, node.index);
				}
			}
		}
		
		
		
		private static var data:Object = new Object();
		
		public static function register():void
		{		
			BcData.register("model", new BcModelDataCreator(), data);
		}
		
		public static function getData(id:String):BcModelData
		{
			return BcModelData(data[id]);
		}
	}
}