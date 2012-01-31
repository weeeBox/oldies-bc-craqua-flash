package bc.world.player 
{
	import bc.core.display.BcBitmapData;
	import bc.core.math.Vector2;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Sprite;

	/**
	 * @author Elias Ku
	 */
	public class BcClawSprite extends Sprite
	{
		private var linkSprite:Sprite = new Sprite();
		private var sprite1:Sprite = new Sprite();
		private var sprite2:Sprite = new Sprite();
		
		
		private var opening:Number = 0;
		
		private var weapon:BcPlayerWeapon;
		private var player:BcPlayer;
		
		private var position:Vector2 = new Vector2();
		private var angle:Number = 0;
		private var back:Number = 0;
		
		private var anim:Number = 0;
		
		private var clawInfo:BcPlayerClaw;
		private var index:int;

		public function BcClawSprite(index:int, player:BcPlayer)
		{
			BcSpriteUtil.setupFast(this);
			BcSpriteUtil.setupFast(sprite1);
			BcSpriteUtil.setupFast(sprite2);
			BcSpriteUtil.setupFast(linkSprite);
			
			this.player = player;
			this.index = index;
			
			linkSprite.addChild(BcBitmapData.create("player_claw_link"));
			linkSprite.x = -4;
			sprite1.addChild(BcBitmapData.create("player_claw_back"));
			sprite2.addChild(BcBitmapData.create("player_claw_front"));
			
			addChild(linkSprite);
			addChild(sprite1);
			addChild(sprite2);	
		}
		
		public function initialize():void
		{
			x = 0;
			y = 0;
			angle = 0;
			linkSprite.scaleX = 0.5 + 0.5/16;
			anim = Math.random();
			opening = 0;
			back = 0;
			
			clawInfo = player.claws[index];
		}

		public function update(dt:Number):void
		{
			updateCounters(dt);
			
			if(opening > 0)
			{
				if(!visible)
				{
					visible = true;
				}
				
				updateOpenState(dt);
			}
			else
			{
				if(visible)
					visible = false;
			}
		}
		
		private function updateOpenState(dt:Number):void
		{
			const toDeg:Number = 180/Math.PI;
			var ca:Number;
			var a:Number;
			var b:Number;
			
			anim += dt;
			
			a = Math.PI*2;
			if(anim > a)
			{
				anim -= a;
			}
			
			ca = (opening*back) + 0.1*Math.sin(anim*5);
		
			sprite1.rotation = 90*ca;
			sprite2.rotation = -45*ca;
			
			if(weapon)
			{
				a = Math.sin(opening*Math.PI*0.5);
				b = 6 * (1 - back);
				position.x = clawInfo.position.x * a + clawInfo.direction.x * b;
				position.y = clawInfo.position.y * a + clawInfo.direction.y * b;
				angle = (clawInfo.shootingAngle - 0.1*Math.cos(anim*2))*opening;
			}
			else
			{
				a = 5 * dt;
				position.x -= position.x * a;
				position.y -= position.y * a;
				angle -= angle * dt;
			}
			
			x = position.x;
			y = position.y;
			
			rotation = angle * toDeg;
			
			a = position.x - (-8) - 4*Math.cos(angle);
			b = position.y - (0) - 4*Math.sin(angle);
			
			linkSprite.rotation = (Math.atan2(b, a) - angle) * toDeg;
			linkSprite.scaleX = 0.5+0.5*(a*a + b*b)/(32*32);
		}
		
		private function updateCounters(dt:Number):void
		{
			const shooting:Boolean = (weapon && player.shotTrigger);
			var speed:Number = dt * 6;
			
			if(shooting && opening < 1)
			{
				opening += speed;
				if(opening > 1)
					opening = 1;
			}
			else if(!shooting && opening > 0)
			{
				opening -= speed;
				if(opening < 0)
					opening = 0;
			}
			
			if(back > 0)
			{
				if(weapon)
				{
					if(weapon.sync)
					{
						speed = weapon.rate;
					}
					else
					{
						speed = 0.5 * weapon.rate;
					}
						
					if(speed<2)
					{
						speed = 2;
					}
						
					speed *= dt;
				}
				else
				{
					speed = dt * 4;
				}

				back -= speed;
				if(back < 0)
				{
					back = 0;
				}
			}
		}
		
		public function onLevel():void
		{			
			weapon = player.levelInfo.weapons[index];
		}
		
		public function onShot():void
		{
			back = 1;
		}
		
	}
}


