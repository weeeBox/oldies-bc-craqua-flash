package bc.world.bullet 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcBulletList 
	{
		public var count:uint;
		public var head:BcBullet;
		
		private var iter:BcBullet;
		private var prev:BcBullet;
		
		public function BcBulletList()
		{
			
		}
		
		public function clear():void
		{
			var node:BcBullet = head;
			var next:BcBullet;
			
			while(node)
			{
				next = node.next;
				
				node.exit();
				
				node.next = pool;
				pool = node;
				
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
		
		public function push(bullet:BcBullet):void
		{
			bullet.next = head;
			head = bullet;
			
			if(iter && !prev) prev = head;
			
			++count;	
		}
		
		private function removeIter():void
		{
			var node:BcBullet = iter;
			
			iter = iter.next;
			if(prev) prev.next = iter;
			else head = iter;
			
			--count;
			
			node.next = pool;
			pool = node;
		}
		
		private var pool:BcBullet;
		
		public function initializePool(count:uint):void
		{
			var node:BcBullet;
			
			for( var i:uint = count; i > 0; --i )
			{
				node = new BcBullet();
				node.next = pool;
				pool = node;
			}
		}
		
		public function launch(properties:BcBulletData, position:Vector2, direction:Vector2, mask:uint, mod:Number = 1):BcBullet
		{
			var node:BcBullet = pool;
			
			if(node)
			{
				pool = pool.next;
				node.launch(properties, position, direction, mask, mod);
			}
			
			return node;
		}
	}
}
