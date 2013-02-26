package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcShape 
	{
		public static const SHAPE_AABB:uint = 0;
		public static const SHAPE_CIRCLE:uint = 1;
		
		public var xmin:Number = 0;
		public var ymin:Number = 0;
		public var xmax:Number = 0;
		public var ymax:Number = 0;
		
		public var type:uint;
		
		public var localPosition:Vector2 = new Vector2();
		public var worldPosition:Vector2 = new Vector2();
		
		public function BcShape(type:uint, x:Number = 0, y:Number = 0)
		{
			this.type = type;
			localPosition.assign(x, y);
			worldPosition.assign(x, y);
		}
		
		public function update(position:Vector2):void
		{
			worldPosition.x = localPosition.x + position.x;
			worldPosition.y = localPosition.y + position.y;
		}
		
		public function clone():BcShape
		{
			var shape:BcShape;
			
			switch(type)
			{
				case SHAPE_AABB:
					{
						var aabb:BcAABBShape = BcAABBShape(this);
						shape = new BcAABBShape(localPosition.x, localPosition.y, aabb.width, aabb.height);
					}
					break;
				case SHAPE_CIRCLE:
					{
						var circle:BcCircleShape = BcCircleShape(this);
						shape = new BcCircleShape(localPosition.x, localPosition.y, circle.radius);
					}
					break;
			}
			
			return shape;
		}
		/*
				
		public function testVRay(x:Number, y:Number, direction:int, arbiter:BcArbiter):void
		{
			if ( type == SHAPE_AABB )
			{
				testVRayAABB(x, y, direction, arbiter);
			}
		}
		
		private function testVRayAABB(x:Number, y:Number, direction:int, arbiter:BcArbiter):void
		{
			if ( xmin <= x && x <= xmax )
			{
				var contact:BcContact;
				
				if( direction < 0 && y >= ymin )
				{
					contact = arbiter.inject();
					
					contact.normal.x = 0;
					contact.normal.y = 1;
					
					contact.point.x = x;
					if( y < ymax ) contact.point.y = y;
					else contact.point.y = ymax;
					
					contact.distance = Math.abs(contact.point.y - y);
				}
				else if( direction > 0 && y <= ymax )
				{
					contact = arbiter.inject();
					
					contact.normal.x = 0;
					contact.normal.y = -1;
					
					contact.point.x = x;
					if( y < ymin ) contact.point.y = ymin;
					else contact.point.y = y;
					
					contact.distance = Math.abs(contact.point.y - y);
				}
			}
		}*/
		
		public static function createFromXML(node:XML):BcShape
		{
			var shape:BcShape;
			
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			
			if(node)
			{
				if(node.hasOwnProperty("@x")) x = Number(node.@x);
				if(node.hasOwnProperty("@y")) y = Number(node.@y);
				
				switch(node.@type.toString())
				{
					case "aabb":
						
						if(node.hasOwnProperty("@w")) w = Number(node.@w);
						if(node.hasOwnProperty("@h")) h = Number(node.@h);
					
						shape = new BcAABBShape(x, y, w, h);
						
						break;
						
					case "circle":
					
						if(node.hasOwnProperty("@r")) w = Number(node.@r);
						
						shape = new BcCircleShape(x, y, w);
						
						break;
				}
			}
			
			return shape;
		}
		
	}
}
