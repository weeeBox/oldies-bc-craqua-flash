package bc.world.core 
{
	import bc.game.BcGame;
	import bc.core.audio.BcAudio;
	import bc.core.audio.BcMusic;
	import bc.core.data.BcData;
	import bc.core.device.BcAsset;
	import bc.core.device.BcDevice;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.core.util.BcColorTransformUtil;
	import bc.core.util.BcSpriteUtil;
	import bc.game.BcGameGlobal;
	import bc.ui.BcGameUI;
	import bc.world.bullet.BcBulletData;
	import bc.world.bullet.BcBulletList;
	import bc.world.bullet.BcExplosion;
	import bc.world.collision.BcArbiter;
	import bc.world.collision.BcGrid;
	import bc.world.enemy.BcEnemyData;
	import bc.world.enemy.BcEnemyList;
	import bc.world.enemy.path.BcEnemyPathData;
	import bc.world.hud.BcHud;
	import bc.world.item.BcItemData;
	import bc.world.item.BcItemList;
	import bc.world.particles.BcParticleData;
	import bc.world.particles.BcParticleList;
	import bc.world.player.BcPlayer;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class BcWorld 
	{	
		public var dt:Number = 0;
		
		public var width:uint = 640-16;
		public var height:uint = 480-8;

		public var grid:BcGrid;
		public var arbiter:BcArbiter;
		
		public var input:BcInput;
		
		public var particles:BcParticleList = new BcParticleList();
		public var player:BcPlayer;
		public var enemies:BcEnemyList = new BcEnemyList();
		public var items:BcItemList = new BcItemList();
		public var bullets:BcBulletList = new BcBulletList();

		public var level:BcLevel;
		
	
		public var sprite:Sprite = new Sprite();

		public var mainLayer:Sprite = new Sprite();
		//private var debugLayer:Sprite = new Sprite();
		
		public var hud:BcHud;
				
		private var _pause:Boolean;
		
		public var checkPoint:BcCheckPoint;
		
		private var halfDeltaTime:Boolean;
		
		public function BcWorld()
		{
			if(!BcGameGlobal.world)
			{
				BcGameGlobal.world = this;
				BcAudio.centreListener( width, height );
				
				initializeProperties();
				
				hud = new BcHud();
				hud.initialize();

				level = new BcLevel();
				
				particles.initializePool(300);
				bullets.initializePool(200);
				items.initializePool(100);
				items.initializeLogic();
				
				arbiter = new BcArbiter();
				
				grid = new BcGrid(width, height);
				
				player = new BcPlayer("data_player_init");
				
				input = new BcInput(player);
				input.bounds.x = input.bounds.y = 8;
				input.bounds.width = width;
				input.bounds.height = height;
				
				BcSpriteUtil.setupFast(sprite);
				//BcSpriteUtil.setupFast(debugLayer);
				BcSpriteUtil.setupFast(mainLayer);
				
				sprite.scrollRect = new Rectangle(0, 0, 640, 480);
				sprite.opaqueBackground = 0x000000;
				//sprite.cacheAsBitmap = true;
				
				sprite.addChild(hud.background);
				sprite.addChild(hud.middle);
				//sprite.addChild(debugLayer);
				sprite.addChild(mainLayer);
				//sprite.addChild(hud.overlay);
				
				//debugLayer.visible = false;
				
				level.parse(BcAsset.getXML("level_level"));
				
				initializeCheckPoint();
				
				sprite.visible = false;
				BcDevice.display.addChildAt(sprite, 0);
			}
		}
		
		private function initializeProperties():void
		{
			BcParticleData.register();
			BcExplosion.register();
			BcBulletData.register();
			BcItemData.register();
			BcEnemyData.register();
			BcEnemyPathData.register();
			
			var xmls:Vector.<String> = Vector.<String>(
			[
				"level_data",
				"data_player",
				
				"mob_enemies",
				"mob_nuke",
				"mob_pig",
				"mob_fish",
				"mob_fly",
				"mob_jelly",
				"mob_pinkhead",
				"mob_thorn",
				"mob_tooth",
				"mob_vision",
				
				"mob_goo",
				"mob_h1n1",
				"mob_bank",
				
				"prop_particles", 
				"data_items"
			]);
			
			BcData.load(xmls);
		}
		
		private function initializeCheckPoint():void
		{
			if(BcGameGlobal.localStore.check == null)
			{
				checkPoint = 
				BcGameGlobal.localStore.check = new BcCheckPoint();
			}
			else
			{
				checkPoint = new BcCheckPoint();
				checkPoint.copyObject(BcGameGlobal.localStore.check);
				BcGameGlobal.localStore.check = checkPoint;
			}
		}
		
		/**
		 * Загрузить, инициализировать и запустить уровень
		 */
		public function start(startNewGame:Boolean):void
		{		
			BcMusic.stopAll(0);
			
	    	if(startNewGame)
	    	{
	    		checkPoint.copy(level.defaultCheckPoint);
	    	}

			//level.parse(BcAsset.getXML("level_level"));
			
			player.start();
			//monsters.start();
			level.start();
			
			initFlashTween();
			initShakeTween();
				
			sprite.visible = true;
			_pause = false;
			input.activate(true);
			
			gameOverTimer = 0;
		}

		public function saveCheckPoint():void
		{
			level.fillCheckPoint(checkPoint);
			player.fillCheckPoint(checkPoint);
		}

		public function exit():void
		{
			arbiter.release();
			player.exit();
			bullets.clear();
			items.clear();
			enemies.clear();
			particles.clear();
			level.clear();
	
			//debugLayer.graphics.clear();

			if(hud.middle.numChildren > hud.debugChildrenLeaksMiddle ||
				mainLayer.numChildren > 0)
			{
				throw new Error("BcWorld: layer leaks");
			}
			
			sprite.visible = false;
		}
		
		public function update(dt:Number):void
		{
			if(!_pause)
			{
				if(halfDeltaTime) dt*=0.5;
				this.dt = dt;
				
				if(flashProgress > 0)
				{
					flashProgress-=dt;
					updateFlashTween();
				}
				
				if(shakeProgress > 0)
				{
					shakeProgress-=dt;
					updateShakeTween();
				}
				
				input.update(dt);
				
				player.update(dt);
				enemies.update(dt);
				items.update(dt);
				bullets.update(dt);
				particles.update(dt);
				level.update(dt);
				hud.update(dt);
				
				//sprDebug.graphics.clear();
				//grid.draw(sprDebug.graphics);
				
				//checkGameOver();
				
				if(gameOverTimer > 0)
				{
					gameOverTimer -= dt;
					if(gameOverTimer <= 0)
					{
						BcGameUI.instance.goEnd();
					}
				}
			}
		}
		
		
		public function get playing():Boolean
		{
			return sprite.visible;
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
		
		public function set pause(value:Boolean):void
		{
			_pause = value;
			input.activate(!value);
		}
			
		public function keyboardMessage(message:BcKeyboardMessage):void
		{
			if(!_pause)
			{
				/*if(message.event == BcKeyboardMessage.KEY_DOWN && !message.repeated)
				{
					if(message.key==Keyboard.ENTER)
					{
						particles.launch(BcParticleData.getData("test_particle"), new Vector2(320, 240), null, mainLayer);
						tweenFlash(1);
						tweenShake(1);
					}
					else if(message.key==Keyboard.F1)
					{
						halfDeltaTime = !halfDeltaTime;
					}
				}*/
			}
			input.keyboard(message);
		}
		
		public function mouseMessage(message:BcMouseMessage):void
		{
			if(!_pause)
			{
				
			}
			input.mouse(message);
		}
		
		
		
		private var flashProgress:Number = 0;
		private var flashBackgroundColor:ColorTransform = new ColorTransform();
		private var flashStencilColor:ColorTransform = new ColorTransform();
		private var flashTweenColor:ColorTransform = new ColorTransform();
		private var flashNormalColor:ColorTransform = new ColorTransform();
		
		private function initFlashTween():void
		{
			BcColorTransformUtil.setColorARGB(flashBackgroundColor, 0xff000000, 0x00fff8d6);
			BcColorTransformUtil.setColorARGB(flashStencilColor, 0xff000000, 0x00303030);
			
			flashProgress = 0;
			updateFlashTween();
		}

		private function updateFlashTween():void
		{
			if(flashProgress > 0)
			{
				var t:Number = 1-flashProgress;
				t = 1-t*t;
				
				BcColorTransformUtil.lerpColor(flashTweenColor, flashNormalColor, flashBackgroundColor, t);
				hud.background.transform.colorTransform = flashTweenColor;
				
				BcColorTransformUtil.lerpColor(flashTweenColor, flashNormalColor, flashStencilColor, t);
				hud.middle.transform.colorTransform = flashTweenColor;
				mainLayer.transform.colorTransform = flashTweenColor;
			}
			else
			{
				hud.background.transform.colorTransform = flashNormalColor;
			
				hud.middle.transform.colorTransform = flashNormalColor;
				mainLayer.transform.colorTransform = flashNormalColor;
			}
		}
		
		public function tweenFlash(amount:Number):void
		{
			flashProgress += amount;
			if(flashProgress > 1)
			{
				flashProgress = 1;
			}
			updateFlashTween();
		}
		
		
		private var shakeProgress:Number = 0;
		
		private function initShakeTween():void
		{
			shakeProgress = 0;
			updateShakeTween();
		}
		
		private function updateShakeTween():void
		{
			if(shakeProgress < 0)
			{
				shakeProgress = 0; 
			}

			var ox:Number = shakeProgress*8*(0.5-Math.random());
			var oy:Number = shakeProgress*8*(0.5-Math.random());
				
			mainLayer.x = 8 + ox;
			mainLayer.y = oy;
			
			hud.background.x = ox*0.4;
			hud.background.y = oy*0.4;
			
			hud.middle.x = ox*0.5;
			hud.middle.y = oy*0.5;
		}

		public function tweenShake(amount:Number):void
		{
			shakeProgress += amount;
			if(shakeProgress > 1)
			{
				shakeProgress = 1;
			}
			updateShakeTween();
		}
		
		public var uiVictory:Boolean;
		public var uiDeath:Boolean;
		public var uiClear:Boolean;
		public var uiBoss:Boolean;
		public var uiMessage:String;
		public var uiRank:String;
		public var gameOverTimer:Number = 0;
		
		public var uiBest:Boolean;
		
		
		private function calcResult():void
		{
			// просчитать медальки
			player.calcMedals();
			if(player.getMoney() > 0 && player.getMoney() > BcGameGlobal.localStore.best)
			{
				BcGameGlobal.localStore.best = player.getMoney();
				uiBest = true;
			}
			else
			{
				uiBest = false;
			}
			
		}
		
		public function endVictory():void
		{
			uiVictory = true;
			uiClear = uiBoss = uiDeath = false;
			uiMessage = "VICTORY!!!";
			
			calcResult();
			gameOverTimer = 5;
			
			BcMusic.getMusic("victory").play();
			
		}
		
		public function endDeath():void
		{
			uiClear = uiBoss = uiVictory = false;
			uiDeath = true;
			uiMessage = "GAME OVER";
			
			calcResult();
			gameOverTimer = 5;
			
			BcMusic.stopAll(0);
	    	BcMusic.getMusic("gameover").play();
		}
		
		public function endStage():void
		{
			uiBoss = uiDeath = uiVictory = false;
			uiClear = true;
			uiMessage = "STAGE CLEAR";
			
			calcResult();

			BcMusic.stopAll(1);
			BcMusic.getMusic("victory").play(1);
			
			BcGameUI.instance.goEnd();
		}

		public function endBoss():void
		{
			uiClear = uiDeath = uiVictory = false;
			uiBoss = true;
			uiMessage = "BOSS DEFEATED";
			
			calcResult();
			
			BcMusic.stopAll(1);
			BcMusic.getMusic("victory").play(1);
			
			BcGameUI.instance.goEnd();
		}
	}
}