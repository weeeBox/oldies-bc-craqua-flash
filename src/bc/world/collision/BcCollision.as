package bc.world.collision 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcCollision 
	{
		private static var VEC1:Vector2 = new Vector2();
		private static var VEC2:Vector2 = new Vector2();
		//private static var VEC3:EkV2 = new EkV2();
		
		public static function testVRay(x:Number, y:Number, direction:int, shape:BcShape, arbiter:BcArbiter):void
		{
			 
		}
		
		public static function testShapes(shape1:BcShape, shape2:BcShape, arbiter:BcArbiter):void
		{
			const dx1:Number = shape1.xmin - shape2.xmax;
			const dy1:Number = shape1.ymin - shape2.ymax;
			const dx2:Number = shape2.xmin - shape1.xmax;
			const dy2:Number = shape2.ymin - shape1.ymax;
			
			if(dx1 <= 0 && dy1 <= 0 && dx2 <= 0 && dy2 <= 0)
			{
				switch(shape1.type)
				{
					case BcShape.SHAPE_AABB:
						if(shape2.type == BcShape.SHAPE_AABB)
							testAABBAABB(shape1, shape2, arbiter);
						else if(shape2.type == BcShape.SHAPE_CIRCLE)
							testCircleAABB(BcCircleShape(shape2), shape1, arbiter);
						break;
					case BcShape.SHAPE_CIRCLE:
						if(shape2.type == BcShape.SHAPE_AABB)
							testCircleAABB(BcCircleShape(shape1), shape2, arbiter);
						else if(shape2.type == BcShape.SHAPE_CIRCLE)
							testCircleCircle(BcCircleShape(shape1), BcCircleShape(shape2), arbiter);
						break;
				}
			}
		}
		
		public static function testAABBAABB(aabb1:BcShape, aabb2:BcShape, arbiter:BcArbiter):void
		{
			const dx1:Number = aabb1.xmin - aabb2.xmax;
			const dy1:Number = aabb1.ymin - aabb2.ymax;
			const dx2:Number = aabb2.xmin - aabb1.xmax;
			const dy2:Number = aabb2.ymin - aabb1.ymax;
			
			var contact:BcContact;
			
			if(dx1 <= 0 && dy1 <= 0 && dx2 <= 0 && dy2 <= 0)
			{
				contact = arbiter.inject();
						
				//contact.normal.x = aabb2.worldPosition.x - aabb1.worldPosition.x;
				//contact.normal.y = aabb2.worldPosition.y - aabb1.worldPosition.y;
				//contact.point.x = aabb1.worldPosition.x + contact.normal.x * 0.5;
				//contact.point.y = aabb1.worldPosition.y + contact.normal.y * 0.5;
						
				if(dx2 > dx1)
				{
					contact.point.x = aabb1.xmax - dx2 * 0.5;
				}
				else
				{
					contact.point.x = aabb2.xmax - dx1 * 0.5;
				}
				
				if(dy2 > dy1)
				{
					contact.point.y = aabb1.ymax - dy2 * 0.5;
				}
				else
				{
					contact.point.y = aabb2.ymax - dy1 * 0.5;
				}
				
				contact.normal.x = aabb2.worldPosition.x - contact.point.x;
				contact.normal.y = aabb2.worldPosition.y - contact.point.y;
				
				
				contact.normal.normalize();
			}
		}
		
		public static function testCircleAABB(circle:BcCircleShape, aabb:BcShape, arbiter:BcArbiter):void
		{
			var closest:Vector2 = VEC1;
			var diff:Vector2 = VEC2;
			var center:Vector2 = circle.worldPosition;
			var contact:BcContact;
			
			closest.copy(circle.worldPosition);
    
			if ( center.x < aabb.xmin ) closest.x = aabb.xmin;
			else if( center.x > aabb.xmax ) closest.x = aabb.xmax;
			if( center.y < aabb.ymin ) closest.y = aabb.ymin;
			else if( center.y > aabb.ymax ) closest.y = aabb.ymax;
			
			diff.x = closest.x - center.x;
			diff.y = closest.y - center.y;
			
			if(diff.lengthSqr() <= circle.radius * circle.radius)
			{
				contact = arbiter.inject();

				contact.normal.x = closest.x - aabb.worldPosition.x;
				contact.normal.y = closest.y - aabb.worldPosition.y;
						
				contact.point.x = closest.x;
				contact.point.y = closest.y;
						
				contact.normal.normalize();
			}
		}
		
		public static function testCircleCircle(circle1:BcCircleShape, circle2:BcCircleShape, arbiter:BcArbiter):void
		{
			var diff:Vector2 = VEC1;
			var p1:Vector2 = circle1.worldPosition;
			var p2:Vector2 = circle2.worldPosition;
			var r:Number = circle1.radius + circle2.radius;
			var contact:BcContact;
			
			diff.x = p1.x - p2.x;
			diff.y = p1.y - p2.y;
			
			if(diff.lengthSqr() <= r * r)
			{
				contact = arbiter.inject();

				contact.normal.x = p2.x - p1.x;
				contact.normal.y = p2.y - p1.y;
						
				contact.point.x = p1.x + contact.normal.x * 0.5;
				contact.point.y = p1.y + contact.normal.y * 0.5;
						
				contact.normal.normalize();
			}
		}
		
		public static function testPointShape(point:Vector2, shape:BcShape, arbiter:BcArbiter):void
		{
			var contact:BcContact;
			var r:Number;
			
			if( point.x >= shape.xmin && point.x <= shape.xmax && point.y >= shape.ymin && point.y <= shape.ymax )
			{
				switch(shape.type)
				{
					case BcShape.SHAPE_AABB:
						contact = arbiter.inject();
						break;
					case BcShape.SHAPE_CIRCLE:
						r = BcCircleShape(shape).radius;
						if(point.distanceSqr(shape.worldPosition) <= r*r)
							contact = arbiter.inject();
						break;
				}
				
				if(contact)
				{
					contact.point.x = point.x;
					contact.point.y = point.y;
				
					contact.normal.x = point.x - shape.worldPosition.x;
					contact.normal.y = point.y - shape.worldPosition.y;
					
					contact.normal.normalize();
				}
			}
		}
	}
}
