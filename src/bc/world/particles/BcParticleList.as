package bc.world.particles 
{
	import bc.core.math.Vector2;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class BcParticleList 
	{
		public var count:uint;
		public var head:BcParticle;
		
		private var iter:BcParticle;
		private var prev:BcParticle;
		
		public function BcParticleList()
		{
		}
		
		public function clear():void
		{
			var node:BcParticle = head;
			var next:BcParticle;
			
			while(node)
			{
				next = node.next;
				
				node.sprite.parent.removeChild(node.sprite);
				
				node.next = pool;
				pool = node;
				
				node = next;
			}
			
			head = null;
			count = 0;
		}
		
		public function update(dt:Number):void
		{
			var temp:BcParticle;
			
			iter = head;
			prev = null;
			
			while(iter)
			{
				if(!iter.update(dt))
				{
					temp = iter;
			
					iter = iter.next;
					if(prev) prev.next = iter;
					else head = iter;
					
					--count;
					
					temp.next = pool;
					pool = temp;
				}
				else
				{
					prev = iter;
					iter = iter.next;
				}
			}
		}
		
		public function push(node:BcParticle):void
		{
			node.next = head;
			head = node;
			
			if(iter && !prev) prev = head;
			
			++count;	
		}
		
		private var pool:BcParticle;
		
		public function initializePool(count:uint):void
		{
			var node:BcParticle;
			
			for( var i:uint = count; i > 0; --i )
			{
				node = new BcParticle();
				node.next = pool;
				pool = node;
			}
		}
		
		public function launch(properties:BcParticleData, position:Vector2, direction:Vector2, layer:DisplayObjectContainer, index:int = -1):void
		{
			var node:BcParticle = pool;
			
			if(node)
			{
				pool = pool.next;
				node.launch(properties, position, direction, layer, index);
				push(node);
			}
		}
		
		private var VECTOR:Vector2 = new Vector2();
		private var VECTOR2:Vector2 = new Vector2();
		public function launchFan(properties:BcParticleData, position:Vector2, count:uint, angle:Number, fan:Number, layer:DisplayObjectContainer, index:int = -1):void
		{
			var i:uint;
			var a:Number;
			var dir:Vector2 = VECTOR;
			
			if(count > 1)
			{
				for ( i = 0; i < count; ++i )
				{
					a = angle + i * fan / (count-1);
					dir.x = Math.cos(a);
					dir.y = Math.sin(a);
					launch(properties, position, dir, layer, index);
				}
			}
			else
			{
				a = angle;
				dir.x = Math.cos(a);
				dir.y = Math.sin(a);
				launch(properties, position, dir, layer, index);
			}
		}
		
		public function launchCircleArea(properties:BcParticleData, position:Vector2, radius:Number, count:uint, layer:DisplayObjectContainer, index:int = -1):void
		{
			var i:uint;
			var a:Number;
			var r:Number;
			var dir:Vector2 = VECTOR;
			var pos:Vector2 = VECTOR2;
			
			for ( i = 0; i < count; ++i )
			{
				r = radius * Math.random();
				a = Math.PI * 2 * Math.random();
				dir.x = Math.cos(a);
				dir.y = Math.sin(a);
				pos.x = position.x + dir.x * r;
				pos.y = position.y + dir.y * r;
				launch(properties, pos, dir, layer, index);
			}
		}
		
		public function launchTrail(properties:BcParticleData, position:Vector2, velocity:Vector2, spread:Number, count:uint, sprite:DisplayObject):void
		{
			var d1:Vector2 = VECTOR;
			var d2:Vector2 = VECTOR2;
			var layer:DisplayObjectContainer = sprite.parent;
			var index:uint = layer.getChildIndex(sprite);
			var sp:Number;
			
			if(velocity)
			{
				d1.x = -velocity.x;
				d1.y = -velocity.y;
				d1.normalize();
			}
			else
			{
				d1.x = d1.y = 0;
			}
			
			if(spread <= 0)
			{
				d2.x = d1.x;
				d2.y = d1.y;
			}
			
			for ( var i:uint = count; i > 0; --i )
			{
				if(spread > 0)
				{
					sp = spread*(Math.random()*2 - 1);
					d2.x = d1.x - sp * d1.y;
					d2.y = d1.y + sp * d1.x;
				}
				launch(properties, position, d2, layer, index);
			}
		}
		
		public function launchRect(properties:BcParticleData, rect:Rectangle, angle:Number, spread:Number, count:uint, layer:DisplayObjectContainer):void
		{
			var dir:Vector2 = VECTOR;
			var pos:Vector2 = VECTOR2;
			var a:Number;
					
			for ( var i:uint = count; i > 0; --i )
			{
				a = angle + spread*(Math.random() - 0.5);
				dir.x = Math.cos(a);
				dir.y = Math.sin(a);
				pos.x = rect.x + Math.random() * rect.width;
				pos.y = rect.y + Math.random() * rect.height;
				
				launch(properties, pos, dir, layer);
			}
		}
	}	
}
