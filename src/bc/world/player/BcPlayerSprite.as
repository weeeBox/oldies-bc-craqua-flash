package bc.world.player 
{
	import bc.core.display.BcBitmapData;
	import bc.core.math.Vector2;
	import bc.core.util.BcSpriteUtil;
	import bc.world.particles.BcParticleData;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class BcPlayerSprite extends Sprite 
	{
		private var player:BcPlayer;
		
		private var bodySprite:Sprite = new Sprite();
		private var eyesSprite:Sprite = new Sprite();
		private var jawSprite:Sprite = new Sprite();
		private var trunkSprite:Sprite = new Sprite();
		
		private var movingSprite:Sprite = new Sprite();
		
		private var sprLeftClaws:Sprite = new Sprite();
		private var sprRightClaws:Sprite = new Sprite();
		
		private var claws:Vector.<BcClawSprite> = new Vector.<BcClawSprite>(6, true);
		
		private var tailParticle:BcParticleData;
		
		private var jawY:Number = 9;
		private var eyesY:Number = -3;
		
		private var floatAnimation:Number = 0;
		
		private var angle:Number = 0;
		private var movingAngle:Number = 0;
		
		private var jawOffsetX:Number = 0;
		private var jawOffsetY:Number = 0;
		private var movingJaw:Number = 0;
		private var eysOffset:Number = 0;
		
		
		private var damagedEffect:Number = 0;
		
		private var damagedColorTransform:ColorTransform = new ColorTransform();
		
		
		public function BcPlayerSprite(player:BcPlayer)
		{
			BcSpriteUtil.setupFast(this);
			BcSpriteUtil.setupFast(bodySprite);
			BcSpriteUtil.setupFast(eyesSprite);
			BcSpriteUtil.setupFast(jawSprite);
			BcSpriteUtil.setupFast(trunkSprite);
			BcSpriteUtil.setupFast(trunkSprite);
			BcSpriteUtil.setupFast(sprLeftClaws);
			BcSpriteUtil.setupFast(sprRightClaws);
			
			this.player = player;
			
			var i:int;
			
			/*for(i=0; i<5; ++i)
			{
				trails[i] = new Sprite();
				addChild(trails[i]);
			}*/
			
			movingSprite.addChild(BcBitmapData.create("player_marker"));
			bodySprite.addChild(BcBitmapData.create("player_body"));
			eyesSprite.addChild(BcBitmapData.create("player_eyes"));
			eyesSprite.y = eyesY;
			jawSprite.addChild(BcBitmapData.create("player_jaw"));
			jawSprite.y = jawY;
			
			
			
			addChild(movingSprite);
			sprRightClaws.scaleX = -1;
			
			addChild(sprRightClaws);
			addChild(sprLeftClaws);
			
			addChild(trunkSprite);
			trunkSprite.addChild(bodySprite);
			addChild(eyesSprite);
			trunkSprite.addChild(jawSprite);
			
			
			
			for(i=5; i>=0; --i)
			{
				claws[i] = new BcClawSprite(i >> 1, player);
				
				if ( i & 1 )
					sprRightClaws.addChild(claws[i]);
				else 
					sprLeftClaws.addChild(claws[i]);
			}
			
			
			tailParticle = BcParticleData.getData("player_tail");
			
			
		}
		
		public function initialize():void
		{
			for each (var claw:BcClawSprite in claws)
			{
				claw.initialize();
			}
			
			/*for(i=0; i<5; ++i)
				trails[i].addChild(player.trailBitmap.createBitmap());*/
			
		}
		
		public function update(dt:Number):void
		{
			
			if(damagedEffect > 0)
			{
				damagedEffect-=dt*4;
				if(damagedEffect < 0) damagedEffect = 0;
				damagedColorTransform.redOffset = 
				damagedColorTransform.greenOffset = 
				damagedColorTransform.blueOffset = damagedEffect*255;
				transform.colorTransform = damagedColorTransform;
			}
			
			for each (var claw:BcClawSprite in claws)
			{
				claw.update(dt);
			}
			
			var i:uint;
			for (i=0; i < player.tailCount; ++i)
			{
				player.world.particles.launchTrail(tailParticle, player.tailShapes[i].worldPosition, null, 0, 1, this);
			}
			
			if(player.shooting && eysOffset < 1)
			{
				eysOffset += dt*5;
				if(eysOffset > 1)
					eysOffset = 1;
			}
			else if(!player.shooting && eysOffset > 0)
			{
				eysOffset -= dt*5;
				if(eysOffset > 1)
					eysOffset = 1;
			}
			
			eyesSprite.y = eyesY - eysOffset*2;
			
			floatAnimation += dt;
			//var floatX:Number = ;
			
			//bodySprite.y = - 0.5*Math.sin(floatAnimation);
			//jawSprite.y = jawY + 0.5*Math.sin(floatAnimation);
			jawSprite.rotation = 5*Math.sin(floatAnimation*2);
			
			//y += Math.sin(floatAnimation*0.5);
			
			angle = (angle + movingAngle*dt)*Math.exp(-6*dt);
			trunkSprite.rotation = angle*180/Math.PI;
			
			jawOffsetX = (jawOffsetX + movingAngle*dt)*Math.exp(-6*dt);
			jawOffsetY = (jawOffsetY + movingJaw*dt)*Math.exp(-6*dt);
			jawSprite.x = 10*jawOffsetX;
			jawSprite.y = 10*jawOffsetY + jawY - 2*eysOffset;
			
			
			
			
			var dx:Number =  player.world.input.mouseX - player.position.x;
			var dy:Number =  player.world.input.mouseY - player.position.y;
			var scale:Number = Math.sqrt(dx*dx + dy*dy)/32;
			if(scale > 1) scale = 1;
			if(scale < 0.2) scale = 0;
			movingSprite.x = dx;
			movingSprite.y = dy;
			movingSprite.scaleX = scale;
			movingSprite.scaleY = scale;
		}

		public function onMoving(direction:Vector2, length:Number):void
		{
			movingAngle = -direction.x * length * 0.1;
			if(movingAngle > 1)
				movingAngle = 1;
			else if(movingAngle < -1)
				movingAngle = -1;
				
			movingJaw = - direction.y * length * 0.1;
			if(movingJaw > 1)
				movingJaw = 1;
			else if(movingJaw < -1)
				movingJaw = -1;
		}
		
		public function onLevel():void
		{
			for each (var claw:BcClawSprite in claws)
			{
				claw.onLevel();
			}
		}
		
		public function onDamage():void
		{
			damagedEffect = 1;
		}
		
		public function onShot(index:int):void
		{
			var weapon:BcPlayerWeapon = player.levelInfo.weapons[index];
			var clawIndex:int = index<<1;
			
			if(weapon.sync)
			{
				claws[clawIndex].onShot();
				claws[clawIndex + 1].onShot();
			}
			else
			{
				claws[clawIndex + weapon.query].onShot();
			}
		}
		
		
	}
}

