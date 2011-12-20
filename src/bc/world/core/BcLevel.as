package bc.world.core 
{
	import bc.core.audio.BcMusic;
	import bc.core.math.Vector2;
	import bc.core.util.BcStringUtil;
	import bc.game.BcGameGlobal;
	import bc.game.BcStrings;
	import bc.world.common.BcBossBar;
	import bc.world.common.BcLevelMarker;
	import bc.world.enemy.BcEnemy;
	import bc.world.enemy.BcEnemyData;
	import bc.world.enemy.path.BcEnemyPathData;

	/**
	 * @author Elias Ku
	 */
	public class BcLevel 
	{
		private var waveIndex:uint;
		private var waves:Vector.<XML> = new Vector.<XML>();
		private var enemies:Vector.<BcEnemy> = new Vector.<BcEnemy>();
		private var enemyIndex:int;
		private var waveTime:Number;
		public var boss:BcEnemy;
		private var bossName:String;
	
		private var FLOW_COUNTDOWN:Number = 3;
		
		private var flowPause:Number = 0;
		private var nextBoss:Boolean;
			
		private var FLOW_WAVE:uint = 0;
		private var FLOW_BOSS:uint = 1;
		private var FLOW_NEXT:uint = 2;
		
		private var flow:uint = 0;
		
		private var world:BcWorld;
		
		private var marker:BcLevelMarker = new BcLevelMarker();
		public var bar:BcBossBar = new BcBossBar();
		
		
		private var end:Boolean;
		private var saved:Boolean;
		
		public var defaultCheckPoint:BcCheckPoint = new BcCheckPoint();
		
		public function BcLevel()
		{
			world = BcGameGlobal.world;
		}

		public function clear():void
		{
			enemies.length = 0;
			boss = null;
			if(marker.parent)
				marker.parent.removeChild(marker);
			bar.exit();
			
			nextBoss = false;
		}
		
		public function start():void
	    {
	    	end = false;
			waveIndex = world.checkPoint.wave;
			beginWave(waveIndex, true);
			BcMusic.getMusic("stage").play();
	    }
	    
	    public function update(dt:Number):void
		{
			if(!end)
			{
				switch(flow)
				{
					case FLOW_WAVE:
						updateWave(dt);
						break;
					case FLOW_BOSS:
						updateBoss(dt);
						break;
					case FLOW_NEXT:
						updateNext(dt);
						break;
				}
				
				checkPlayerDeath();
			}
			
			marker.update(dt);
			bar.update(dt);
		}
		
		private function updateWave(dt:Number):void
	    {	    	
	    	if(flowPause >= FLOW_COUNTDOWN)
	    	{
	    		waveTime+=dt;
	    		if(enemyIndex < enemies.length)
	    		{
					joinNextEnemy();
	    		}
	    		else if(world.enemies.count==0)
	    		{
	    			if(boss)
	    			{
	    				nextBoss = true;
	    			}
	    			goNext();
	    		}
	    	}
	    	else
	    	{
	    		flowPause+=dt;
	    		if(flowPause >= FLOW_COUNTDOWN && !saved)
	    		{
	    			world.saveCheckPoint();
	    			saved = true;
	    		}
	    	}
	    }

		private function joinNextEnemy():void
	    {
	    	var enemy:BcEnemy;
	    	
	    	while (enemyIndex < enemies.length)
	    	{
	    		enemy = enemies[enemyIndex];
	    		
	    		if(enemy.startTime <= waveTime)
	    		{
		    		enemy.join();
		    		++enemyIndex;
	    		}
	    		else
	    		{
	    			break;
	    		}
	    	}
	    }
	    
		private function updateBoss(dt:Number):void
	    {	    	
	    	if(flowPause < FLOW_COUNTDOWN)
	    	{
	    		flowPause+=dt;
	    		if(flowPause >= FLOW_COUNTDOWN)
	    		{
	    			boss.join();
	    			bar.launch(bossName);
	    			BcMusic.stopAll(0);
	    			BcMusic.getMusic("boss").play();
	    		}
	    	}
	    	else
	    	{
	    		if(boss.dead)
	    		{
	    			goNext();
					bar.hide();
					BcMusic.getMusic("boss").stop(1);
				}
	    	}
	    }
	    
	    private function goNext():void
	    {
	    	flow = FLOW_NEXT;
	    	flowPause = 0;
	    }
	    
	    private function updateNext(dt:Number):void
	    {
	    	if(flowPause < FLOW_COUNTDOWN)
	    	{
	    		flowPause+=dt;
	    		if(flowPause >= FLOW_COUNTDOWN)
	    		{
	    			if(nextBoss)
	    			{
	    				world.endStage();
	    				
	    				flow = FLOW_BOSS;
		    			flowPause = 0;
		    			marker.launch(bossName);
		    			
		    			nextBoss = false;
	    			}
	    			else if(waveIndex + 1 < waves.length)
	    			{
	    				if(boss)
	    				{
	    					world.endBoss();
	    				}
	    				else
	    				{
	    					world.endStage();
	    				}
	    				
		    			beginWave(waveIndex+1);
		    			saved = false;
	    			}
	    			else
	    			{
	    				marker.launch(BcStrings.GAME_VICTORY);
						world.hud.tweenNight(false);
	    				end = true;
	    				    				
	    				world.endVictory();
	    			}
	    		}
	    	}
	    }
	    
	    public function fillCheckPoint(checkPoint:BcCheckPoint):void
	    {
	    	checkPoint.wave = waveIndex;
		}

		public function parse(xml:XML):void
		{
			for each (var node:XML in xml.wave)
			{
				waves.push(node);
			}
			
			defaultCheckPoint.exp = xml.@exp;
			defaultCheckPoint.wave = xml.@wave;
		}

		public function checkPlayerDeath():void
		{
			if(world.player.isDead())
			{
				marker.launch(BcStrings.GAME_GAME_OVER);
	    		end = true;
	    	
	    		world.endDeath();
			}
		}
		
		
		private function beginWave(index:uint, starting:Boolean = false):void
		{
			var waveXML:XML;
			var waveList:XMLList;
			var enemiesNode:XML;
			var enemyData:BcEnemyData;
			var enemy:BcEnemy;
			var i:int;
			var count:int;
			var maxTime:Number = 0;
			var timeOffset:Number = 0;
			var timeBegin:Number = 0;
			var timeEnd:Number = 0;
			var timeDelta:Number = 0;
			var normalEnemyPath:BcEnemyPathData = BcEnemyPathData.getData("normal");
			var enemyPath:BcEnemyPathData;
			var night:Boolean;
			
			var nodeX:XML;
			var beginX:Number;
			var spreadX:Number;
			var deltaX:Number;
			var startX:Number;
			var startGeneration:int;
			var fallingType:int;
			var horiSideFlip:Boolean;
			var horiSideFlipping:Boolean;
			var nodeName:String;
			var bombTarget:Vector2 = new Vector2();
			var bombPosition:Vector2 = new Vector2();
			
			waveTime = 0;
			enemies.length = 0;
			enemyIndex = 0;
			boss = null;
			bossName = null;
			flow = FLOW_WAVE;			
			flowPause = 0;
			nextBoss = false;
			
			
			
			if(index < waves.length)
			{
				waveXML = waves[index];
				waveIndex = index;
				marker.launch(BcStrings.GAME_STAGE_N + (waveIndex+1).toString());
			}
			
			if(waveXML)
			{
				night = BcStringUtil.parseBoolean(waveXML.@night);
				if(starting)
				{
					world.hud.initEnv(night);
				}
				else
				{
					world.hud.tweenNight(night);
				}
				
				if(waveXML.hasOwnProperty("@boss"))
				{
					enemyData = BcEnemyData.getData(waveXML.@boss);
					if(enemyData)
					{
						boss = new BcEnemy();
						boss.setup(enemyData, normalEnemyPath)
						boss.fallDown(320);
					}
				
					if(waveXML.hasOwnProperty("@boss_name"))
					{
						bossName = BcStrings.BOSS_NAMES[waveXML.@boss_name.toString()];
					}
					else
					{
						bossName = BcStrings.GAME_BOSS_N + (waveIndex+1).toString();
					}
				}				
				
				waveList = waveXML.children();
				for each (enemiesNode in waveList)
				{
					nodeName = enemiesNode.name();
					if(nodeName=="offset")
					{
						timeOffset = enemiesNode.@time;
					}
					else
					{
						count = uint(enemiesNode.@count);
						
						timeBegin = timeOffset + Number(enemiesNode.@begin);
						timeEnd = timeBegin + Number(enemiesNode.@time);
						if(timeEnd > maxTime)
						{
							maxTime = timeEnd;
						}
						
						if(enemiesNode.hasOwnProperty("@id"))
						{
							enemyData = BcEnemyData.getData(enemiesNode.@id);
							if(enemyData)
							{
								if(enemiesNode.hasOwnProperty("@path"))
								{
									enemyPath = BcEnemyPathData.getData(enemiesNode.@path);
								}
								else
								{
									enemyPath = normalEnemyPath;
								}
								
								fallingType = 0;
								startGeneration = 
								beginX = 
								deltaX = 0;
								horiSideFlipping = 
								horiSideFlip = false;
								
								if(enemiesNode.hasOwnProperty("@fall"))	fallingType = enemiesNode.@fall;
								
								switch(fallingType)
								{
									case 0: spreadX = world.width; break;
									case 1: spreadX = world.height; break;
								}
														
								nodeX = enemiesNode.x[0];
								if(nodeX)
								{
									beginX = 0;
									if(nodeX.hasOwnProperty("@begin")) beginX = nodeX.@begin;								
									if(nodeX.hasOwnProperty("@spread")) spreadX = nodeX.@spread;
									
									deltaX = spreadX/count;
									
									if(nodeX.hasOwnProperty("@random"))
									{
										startGeneration = 0;
									}
									else
									{
										startGeneration = 1;
									}
									
									if(fallingType==1)
									{
										if(nodeX.hasOwnProperty("@side")) horiSideFlip = nodeX.@side;
										if(nodeX.hasOwnProperty("@flipping")) horiSideFlipping = nodeX.@flipping;
									}
								}							
								
								timeDelta = (timeEnd - timeBegin)/count;
								for ( i = 0; i < count; ++i )
								{
									switch(startGeneration)
									{
										case 0:
											startX = beginX + Math.random() * spreadX;
											break;
										case 1:
											startX = beginX;
											beginX += deltaX;
											break;
									}
									
									enemy = new BcEnemy();
									enemy.setup(enemyData, enemyPath);
									if(enemyData.launchSpeed > 0)
									{
										enemy.fallBomb(0, 0, 0, 0, enemiesNode.bomb[0]);
									}
									else
									{
										switch(fallingType)
										{
											case 0: enemy.fallDown(startX); break;
											case 1:
												enemy.path.flipped = horiSideFlip;
												enemy.fallHorizont(startX);
												if(horiSideFlipping) horiSideFlip = !horiSideFlip;
												break;
										}
									}
									
									enemy.startTime = timeBegin + timeDelta*i;
									enemies.push(enemy);
								}
							}
						}
					}
	
				}
						
				enemies.sort(sorter);
			}
			
		}

		
	    private function sorter(a:BcEnemy, b:BcEnemy):Number
	    {
			if(a.startTime < b.startTime)
				return -1;
			if(a.startTime > b.startTime)
				return 1;
			
			return 0;
	    }
	}
}
