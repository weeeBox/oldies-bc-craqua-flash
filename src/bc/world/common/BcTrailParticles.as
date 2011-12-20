package bc.world.common 
{
	import bc.world.particles.BcParticleList;
	import bc.world.core.BcWorld;
	import bc.game.BcGameGlobal;
	import bc.core.math.Vector2;
	import bc.world.particles.BcParticleData;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcTrailParticles 
	{
		
		public var particle:BcParticleData;
		public var speed:Number = 1;
		public var velocityEffect:Boolean = true;
		public var casterDisplayObject:DisplayObject;
		
		private var counter:Number = 0;
		
		private static var VECTOR:Vector2 = new Vector2();
		
		public function BcTrailParticles(casterDisplayObject:DisplayObject, particle:BcParticleData, speed:Number = 1, velocityEffect:Boolean = true)
		{
			this.casterDisplayObject = casterDisplayObject;
			this.particle = particle;
			this.speed = speed;
			this.velocityEffect = velocityEffect;
		}
		
		public function update(dt:Number, velocity:Vector2):void
		{
			if(particle && casterDisplayObject && speed > 0)
			{
				if(!velocityEffect)
				{
					counter += dt * speed;
				}
				else if(velocity)
				{
					counter += dt * speed * velocity.length();
				}
				
				if(counter >= 1)
				{
					VECTOR.x = casterDisplayObject.x;
					VECTOR.y = casterDisplayObject.y;
					BcGameGlobal.world.particles.launchTrail(particle, VECTOR, null, 0, 1, casterDisplayObject);
					counter -= int(counter);
				}
			}
			
		}
	}
}
