package bc.world.enemy 
{

	
	/**
	 * @author Elias Ku
	 */
	public class BcEnemyList 
	{
		public var count:uint;
		public var head:BcEnemy;
		
		private var iter:BcEnemy;
		private var prev:BcEnemy;
		
		public function BcEnemyList()
		{
			
		}
		
		public function clear():void
		{
			var node:BcEnemy = head;
			var next:BcEnemy;
			
			while(node)
			{
				next = node.next;
				
				node.exit();
				node.next = null;
				
				node = next;
			}
			
			head = null;
			count = 0;
		}
		
		public function update(dt:Number):void
		{
			iter = head;
			prev = null;
			
			while(iter)
			{
				if(iter.dead)
				{
					removeIter();
				}
				else
				{
					iter.update(dt);
					
					prev = iter;
					iter = iter.next;
				}
			}
		}
		
		public function push(monster:BcEnemy):void
		{
			monster.next = head;
			head = monster;
			
			if(iter && !prev) prev = head;
			
			++count;	
		}
		
		private function removeIter():void
		{
			var node:BcEnemy = iter;
			
			iter = iter.next;
			node.next = null;
			
			if(prev) prev.next = iter;
			else head = iter;
			
			--count;
		}
	}
}
