package bc.world.common 
{
	import bc.core.math.Vector2;
	import bc.game.BcGameGlobal;
	import bc.world.collision.BcGridObject;
	import bc.world.core.BcWorld;

	import flash.display.DisplayObject;

	/**
	 * Объект, который присутствует на карте
	 * @author Elias Ku
	 */
	public class BcObject extends BcGridObject 
	{
		// Константы масок коллизий
		public const MASK_PLAYER:uint = 1;
		public const MASK_ENEMY:uint = 2;
		public const MASK_ITEM:uint = 4;
		public const MASK_ALL:uint = 0xffffffff;
		
		// Ссылка на мир
		public var world:BcWorld;
		
		public var impulse:Vector2 = new Vector2();
		public var impulseFriction:Number = 10;
		public var movement:Vector2 = new Vector2();
		
		public var objectSprite:DisplayObject;
		
		public function BcObject()
		{
			super();
			
			world = BcGameGlobal.world;
		}
		
		/*public function update(dt:Number):void
		{
			velocity.addVector(forceAccum);
			forceAccum.setZero();
			
		}*/
		
		protected function move(dt:Number):void
		{
			var impulsed:Boolean;
		
			if(impulse.lengthSqr() > 0.01)
			{
				impulse.multScalar(Math.exp(-dt*impulseFriction));
				impulsed = true;
			}
			else
			{
				impulse.setZero();
			}
						
			if(movement.lengthSqr() > 0.01 || impulsed)
			{
				position.x += movement.x + impulse.x * dt;
				position.y += movement.y + impulse.y * dt;
				
				shape.update(position);
				checkBounds();
				world.grid.replace(this);
				
				if(objectSprite)
				{
					objectSprite.x = position.x;
					objectSprite.y = position.y;
				}
			}
			
			movement.setZero();
		}
		
		protected virtual function checkBounds():void
		{
			var positionChanged:Boolean;
				
			if(shape.xmin < 0)
			{
				position.x -= shape.xmin;
				positionChanged = true;
			}
			else if(shape.xmax > world.width)
			{
				position.x -= shape.xmax - world.width;
				positionChanged = true;
			}
			
			if(shape.ymin < 0)
			{
				position.y -= shape.ymin;
				positionChanged = true;
			}
			else if(shape.ymax > world.height)
			{
				position.y -= shape.ymax - world.height;
				positionChanged = true;
			}
				
			if(positionChanged)
			{
				shape.update(position);
			}
		}
	}
}
