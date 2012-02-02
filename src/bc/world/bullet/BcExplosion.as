package bc.world.bullet 
{
	import bc.core.audio.BcSound;
	import bc.core.data.BcData;
	import bc.core.data.BcIObjectData;
	import bc.core.math.Vector2;
	import bc.core.util.BcStringUtil;
	import bc.game.BcGameGlobal;
	import bc.world.collision.BcArbiter;
	import bc.world.collision.BcCircleShape;
	import bc.world.collision.BcContact;
	import bc.world.common.BcObject;
	import bc.world.common.BcObjectDamage;
	import bc.world.core.BcWorld;
	import bc.world.enemy.BcEnemy;
	import bc.world.particles.BcParticleData;
	import bc.world.player.BcPlayer;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcExplosion implements BcIObjectData
	{
		private static var OBJECT_DAMAGE:BcObjectDamage = new BcObjectDamage();
		
		private var damage:Number = 0;
		
		private var shape:BcCircleShape = new BcCircleShape();
		
		private var impulse:Number = 0;

		private var shakeAmount:Number = 0;
		private var flashAmount:Number = 0;
		private var waveParticle:BcParticleData;
		private var bubbleParticle:BcParticleData;
		private var bubbleCount:uint;
		private var bubbleRadius:Number = 0;
		
		private var sfx:BcSound;
		
		private var world:BcWorld;
		
		public function BcExplosion()
		{
			world = BcGameGlobal.world;
		}
		
		public function parse(xml:XML):void
		{
			var node:XML;
			
			if(xml.hasOwnProperty("@damage")) damage = xml.@damage;
			if(xml.hasOwnProperty("@radius")) shape.radius = xml.@radius;

			if(xml.hasOwnProperty("@shake")) shakeAmount = xml.@shake;
			if(xml.hasOwnProperty("@flash")) flashAmount = xml.@flash;
			
			if(xml.hasOwnProperty("@sfx")) sfx = BcSound.getData(xml.@sfx);
			
			if(xml.hasOwnProperty("@impulse")) impulse = xml.@impulse;
			
			node = xml.particles[0];
			if(node)
			{
				node = xml.particles[0].wave[0];
				if(node)
				{
					if(node.hasOwnProperty("@particle")) waveParticle = BcParticleData.getData(node.@particle);
				}
				
				node = xml.particles[0].bubbles[0];
				if(node)
				{
					if(node.hasOwnProperty("@particle")) bubbleParticle = BcParticleData.getData(node.@particle);
					if(node.hasOwnProperty("@count")) bubbleCount = node.@count;
					if(node.hasOwnProperty("@radius")) bubbleRadius = node.@radius;
				}
			}
		}
		
		public function explode(position:Vector2, mask:uint = 0, mod:Number = 1):void
		{
			processObjects(position, mask, mod);
			
			if(shakeAmount > 0)
				world.tweenShake(shakeAmount);
				
			if(flashAmount > 0)
				world.tweenFlash(flashAmount);
				
			if(waveParticle)
				world.particles.launch(waveParticle, position, null, world.mainLayer);
				
			if(bubbleParticle && bubbleCount > 0)
				world.particles.launchCircleArea(bubbleParticle, position, bubbleRadius, bubbleCount, world.mainLayer);
				
			if(sfx)
				sfx.playObject(position.x, position.y);
		}
		
		private function processObjects(position:Vector2, mask:uint, mod:Number):void
		{
			var arbiter:BcArbiter = world.arbiter;
			var contact:BcContact;
			var i:uint;
			var dx:Number;
			var dy:Number;
			var len:Number;
			var aCount:uint = arbiter.contactCount;
			
			shape.update(position);
			
					
			world.grid.testShape(shape, mask, arbiter);
						
			for ( i = aCount; i < arbiter.contactCount; ++i )
			{
				contact = BcContact(arbiter.contacts[i]);
		
				// игнорируем по х
				OBJECT_DAMAGE.velocity.x = 
				OBJECT_DAMAGE.velocity.y = 0;
				
				if(impulse > 0)
				{
					dx = contact.object.position.x - position.x;
					dy = contact.object.position.y - position.y;
					len = dx*dx + dy*dy;
					
					if( len > 0.001 && dy < 0 )
					{
						OBJECT_DAMAGE.velocity.y = dy * impulse / Math.sqrt(len);
					}
				}	
				
				OBJECT_DAMAGE.amount = mod * damage;
				OBJECT_DAMAGE.position.copy(contact.point);
				
				if ( mask & BcObject.MASK_ENEMY )
					BcEnemy(contact.object).damage(OBJECT_DAMAGE);
				else
					BcPlayer(contact.object).damage(OBJECT_DAMAGE);
			}
			
			arbiter.contactCount = aCount;
		}
				
		//////////////
		private static var data:Dictionary = new Dictionary();
		
		public static function register():void
		{		
			BcData.register("explosion", new BcExplosionDataCreator(), data);
		}
		
		public static function getData(id:String):BcExplosion
		{
			return BcExplosion(data[id]);
		}
	}
}
