package bc.ui
{
	import bc.core.boxing.BcNumber;
	import bc.core.util.BcUtil;
	import bc.core.ui.UIUpdateCallback;
	import bc.core.ui.UIMouseClickCallback;
	import bc.core.ui.UITransitionCallback;
	import bc.core.motion.easing.BcEaseFunction;
	import bc.core.audio.BcAudio;
	import bc.core.audio.BcMusic;
	import bc.core.device.BcAsset;
	import bc.core.display.BcBitmapData;
	import bc.core.ui.UI;
	import bc.core.ui.UIButton;
	import bc.core.ui.UICheckBox;
	import bc.core.ui.UIImage;
	import bc.core.ui.UILabel;
	import bc.core.ui.UILayer;
	import bc.core.ui.UIObject;
	import bc.core.ui.UIPanel;
	import bc.core.ui.UIStyle;
	import bc.core.ui.UITransition;
	import bc.game.BcGameGlobal;
	import bc.game.BcStrings;
	import bc.world.player.BcPlayer;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Elias Ku
	 */
	public class BcGameUI implements UIMouseClickCallback, UITransitionCallback, UIUpdateCallback
	{
		public var oMochiAd:Boolean = false;
		public var oMochiHS:Boolean = true;
		public var oSponsorLogo:Boolean = true;
		public var oSponsorSplash:Boolean = true;
		public var oSponsorCredits:Boolean = true;
		public var oShowScoresButton:Boolean = false;
		public var oBestScore:Boolean = false;
		
		// UITransition finish codes
		private static const TRC_LOADING_HIDED:int = 1;
		private static const TRC_EXIT_PAUSE:int = 2;
		private static const TRC_GO_GAME:int = 3;
		private static const TRC_QUIT_WORLD:int = 4;
		private static const TRC_RESTART:int = 5;
		private static const TRC_OPEN_MAIN:int = 6;
		
		public static var instance:BcGameUI;
		
		private var layerBack:UILayer = new UILayer();
		private var layerMain:UILayer = new UILayer();
		private var layerOverlay:UILayer = new UILayer();
		
		private var backPanel:UIPanel = new UIPanel(layerBack, 0, 0, false);
		private var backFader:UIObject;
		private var backTitle:UIGameTitle;
		private var backBubbles:UIBubbles;
		
		private var loadingPanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var loadingSponsor:UIObject;
		private var loadingPlay:UIButton;
		private var loadingLabel:UILabel;
		private var loadingProgress:UIObject = new UIObject(loadingPanel);


		//private var g5Splash:Splash;
//#if CUT_THE_CODE		
//#		private var mcAd:MovieClip;
//#		private var mcSp:MovieClip;
//#		private var mcSpFrame:Shape = new Shape();
//#endif

		private static var easeOpen:BcEaseFunction = new BcEaseOpen();
		private static var easeClose:BcEaseFunction = new BcEaseClose();		

		public function BcGameUI()
		{
			if(instance) throw new Error();
			
			instance = this;
			
			UI.addLayer(layerBack);
			UI.addLayer(layerMain);
			UI.addLayer(layerOverlay);
			
			new UIImage(backPanel, 0, 0, "ui_bg");
			backFader = new UIObject(backPanel);
			initBackFader();
			
			loadingLabel = new UILabel(loadingPanel, 320, 420, "0" + BcStrings.UI_LOADING, stTitle);
			loadingSponsor = UIObject(loadingPanel);
		
			if(oSponsorSplash)
			{
				/*g5Splash = new Splash();
				g5Splash.x = int(0.5*(640 - g5Splash.width));
				g5Splash.y = 32;*/
				
				/*mcSp = new MovieClip();
				mcSp.addChild(new (BcPreloaderAsset.swf_preloader)());
				mcSp.x = 320;
				mcSp.y = 240;*/
				
				//mcSpFrame.graphics.beginFill(0xffffff);
				//mcSpFrame.graphics.drawRoundRect(0, 48, mcSp.width, mcSp.height-48*2, 36, 36);
				//mcSp.mask = mcSpFrame;
				//mcSpFrame.x = mcSp.x = (640-mcSp.width)*0.5;
				//loadingSponsor.sprite.addChild(mcSp);
			}
			
			/*if(!oSponsorSplash && oMochiAd)
			{
				mcAd = new MovieClip();
				loadingPanel.sprite.addChild(mcAd);
			}*/
			
			backPanel.play(transBackStart, 1);
			loadingPanel.play(transWindowOpen, 0.25);
		}
		
		public function loading(progress:Number):void
		{
			progress+=0.01;
			if(progress>1) progress = 1;
			
			loadingLabel.text = "" + int(progress*100) + BcStrings.UI_LOADING;
			loadingLabel.centerX = 320;
			
			var g:Graphics = loadingProgress.sprite.graphics;
			g.clear();
			g.lineStyle(1, 0x060F26);
			g.beginFill(0xDDEEEC, 0.5);
			g.drawRect(10, 480-10, 620, 5);
			g.endFill();
			g.lineStyle();
			g.beginFill(0x2F68AA);
			g.drawRect(10+2, 480-10+2, (620-3)*progress, 2);
			g.endFill();
		}
		
		private var mainPanel:UIPanel = new UIPanel(layerMain);
		private var mainButtons:UIObject = new UIObject(mainPanel);
		private var mainNewGame:UIButton;
		private var mainContinue:UIButton;
		private var mainHighScores:UIButton;
		private var mainHelp:UIButton;
		private var mainFader:UIObject;
		private var mainFaderBitmap:Bitmap;
		private var mainSponsor:UIObject;
		private var mainInstruction:UIButton;
		private var instructionsPanel:UIObject;
		private var showInstructions:Boolean;
		private var showInstructionsTime:Number = 0.0;
		
		private var mainBest:UILabel;
		
		private var creditsPanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var creditsClose:UIButton;
		private var creditsSponsor:UIButton;
		
		private var hsPanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var hsBack:UIButton;
		private var HSMC:MovieClip = new MovieClip();
		//private var g5Hiscores:ZattikkaHiScores;
		
		private var gamePanel:UIPanel = new UIPanel(layerMain, 0, 0, false);
		private var gameLink:UIButton;
		
		private var gameFader:UIGameEffect = new UIGameEffect(layerBack);
		
		private var pausePanel:UIPanel = new UIPanel(layerMain);
		private var pauseEnd:UIButton;
		private var pauseResume:UIButton;
		
		private var endPanel:UIPanel = new UIPanel(layerMain);
		private var endLabel:UILabel;
		private var endRank:UILabel;
		private var endResult:UILabel;
		private var endContinue:UIButton;
		private var endSubmit:UIButton;
		private var endGame:UIButton;
		private var endReplay:UIButton;
		
		
		
		private var stQuality : UIStyle = new UIStyle(UICheckBox.getDefaultStyle(), BcUtil.createDictionary([
														"text1", BcStrings.UI_QUALITY_HIGH, 
														"text2", BcStrings.UI_QUALITY_LOW, 
														"back1", "ui_qb", 
														"back2", "ui_qb", 
														"body1", "ui_q", 
														"body2", "ui_q"]));
		private var stMusic : UIStyle = new UIStyle(UICheckBox.getDefaultStyle(), BcUtil.createDictionary(
														["text1", BcStrings.UI_MUSIC_ON, 
														"text2", BcStrings.UI_MUSIC_OFF, 
														"back1", "ui_m1b", 
														"back2", "ui_m2b", 
														"body1", "ui_m1", 
														"body2", "ui_m2"]));
		private var stSound : UIStyle = new UIStyle(UICheckBox.getDefaultStyle(), BcUtil.createDictionary(
														["text1", BcStrings.UI_SFX_ON, 
														"text2", BcStrings.UI_SFX_OFF, 
														"back1", "ui_s1b", 
														"back2", "ui_s2b", 
														"body1", "ui_s1", 
														"body2", "ui_s2"]));
		private var stButtonMedium : UIStyle = new UIStyle(UIButton.getDefaultStyle(), BcUtil.createDictionary(["scale", new BcNumber(0.75)]));
		private var stButtonOther : UIStyle = new UIStyle(UIButton.getDefaultStyle(), BcUtil.createDictionary(["scale", new BcNumber(0.85)]));
		private var stButtonSmall : UIStyle = new UIStyle(UIButton.getDefaultStyle(), BcUtil.createDictionary(["scale", new BcNumber(0.5)]));
		private var stTitle : UIStyle = new UIStyle(UILabel.getDefaultStyle(), BcUtil.createDictionary(
														["font", "main", 
														"textSize", new BcNumber(30), 
														"textColor", new BcNumber(0xffffff), 
														"strokeBlur", new BcNumber(3), 
														"strokeColor", new BcNumber(0x033754), 
														"strokeAlpha", new BcNumber(1), 
														"strokeStrength", new BcNumber(6)]));
		private var stInfo : UIStyle = new UIStyle(stTitle, BcUtil.createDictionary(["textSize", new BcNumber(25)]));
		private var stInfoSmall : UIStyle = new UIStyle(stTitle, BcUtil.createDictionary(["textSize", new BcNumber(15)]));
		
		private var settingsPanel:UIPanel = new UIPanel(layerOverlay);
		private var settingsQ:UICheckBox;
		private var settingsM:UICheckBox;
		private var settingsS:UICheckBox;

		public function loadingComplete():void
		{
			loadingLabel.text = BcStrings.UI_LOADING_COMPLETED;
			loadingLabel.centerX = 320;
			loadingLabel.play(transLabelHide, 0.5);
			loadingProgress.play(transObjectHide, 0.5);
			loadingPlay = new UIButton(loadingPanel, 320, 435, BcStrings.UI_LOADING_PLAY, null, this);
			loadingPlay.highlight = true;
			loadingPlay.play(transButtonShow, 0.5);
			
			
			backBubbles = new UIBubbles(backPanel);
			backTitle = new UIGameTitle(backPanel, 320, -165);
			
			// MAIN
			mainNewGame = new UIButton(mainButtons, 510, 182, BcStrings.UI_NEW_GAME, null, this);
			mainNewGame.highlight = true;
			mainNewGame.multiline = true;
			mainNewGame.html = "<p align=\"center\"><font size=\"25\">" + BcStrings.UI_NEW_GAME + "</font></p>";
			mainContinue = new UIButton(mainButtons, 510, 260, BcStrings.UI_CONTINUE, null, this);
			mainContinue.multiline = true;
			
			mainInstruction = new UIButton(mainButtons, 250+8, 440, "", stButtonOther, this);
			mainInstruction.html = "<font size=\"25\">" + BcStrings.UI_INSTRUCTIONS + "</font>";
			instructionsPanel = new UIObject(mainPanel, 16-320, 165);
			instructionsPanel.onUpdate = this;
			
			var instructionsLabel:UILabel = new UILabel(instructionsPanel, 0, 0, "", stInfoSmall);
			instructionsLabel.multiline = true;
			instructionsLabel.html = BcStrings.UI_INSTRUCTIONS_TEXT;
			
			var g:Graphics = instructionsPanel.sprite.graphics;
			g.beginFill(0x000000, 0.5);
			g.drawRoundRect(-10, -10, 20+instructionsLabel.sprite.width, 20+instructionsLabel.sprite.height, 8, 8);
			g.endFill();
			
			if(oShowScoresButton)
			{
				mainHighScores = new UIButton(mainButtons, 510, 360-16-8-2, BcStrings.UI_HIGHSCORES, stButtonOther, this);
			}
			else
			{
				if(oBestScore)
				{
					mainBest = new UILabel(mainButtons, 510, 360-8-2-48, "", stTitle);
					mainBest.multiline = true;
				}
			}
			
			if(!oBestScore && !oShowScoresButton)
			{
				mainHelp = new UIButton(mainButtons, 510, 360-24, BcStrings.UI_CREDITS, stButtonOther, this);
			}
			else
			{
				mainHelp = new UIButton(mainButtons, 510, 400+2, BcStrings.UI_CREDITS, stButtonOther, this);
			}
			initMainFader();
			
			creditsClose = new UIButton(creditsPanel, 320, 420, BcStrings.UI_BACK, null, this);
			var label:UILabel;
			var image:UIImage;
			
			var bd:BcBitmapData = new BcBitmapData();
			bd.bitmapData = BcAsset.getImage("sponsor_logo");
			bd.x = -bd.bitmapData.width*0.5;
			bd.y = -bd.bitmapData.height*0.5;
			BcBitmapData.addData("sponsor_logo", bd);
		
			image = new UIImage(mainButtons, 511, 423+4, "sponsor_logo");
			image.sprite.scaleX = 0.47;
			image.sprite.scaleY = 0.47;
			
			if(oSponsorCredits)
			{
				image = new UIImage(creditsPanel, 160, 160, "ui_ddg");
				image.sprite.scaleX = 0.6;
				image.sprite.scaleY = 0.6;
				(new UILabel(creditsPanel, 320, 100-20, "DIGIDUCK GAMES", stInfoSmall)).centerX = 160;
				label = new UILabel(creditsPanel, 320, 100-20, BcStrings.UI_SPONSORED_BY, stInfoSmall);
				label.multiline = true;
				label.html = "<p align=\"center\">" + BcStrings.UI_SPONSORED_BY + "</p>";
				label.centerX = 320+160;
				
				//creditsSponsor = ;
				image = new UIImage(creditsPanel, 320+160, 160, "sponsor_logo");
				image.sprite.scaleX = 0.4;
				image.sprite.scaleY = 0.4;
				
				if(oSponsorLogo)
				{
					//mainSponsor = new g5Button(backPanel, -(218-68), 511-63, new (BcPreloaderAsset.swf_main)(), 10, sponsorLink);
				}
			}
			else
			{
				new UIImage(creditsPanel, 320, 180, "ui_ddg");
				(new UILabel(creditsPanel, 320, 30, "DIGIDUCK GAMES", stTitle)).centerX = 320;
			}
			
			//gameLink = new g5Game(gamePanel, 16, 4, sponsorLink);
			
			label = new UILabel(creditsPanel, 200, 285, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">" + BcStrings.UI_DEVELOPED_BY + "</font><br>Kuzmichev Ilya<br>aka<br>Elias Ku</p>";
			label.centerX = 110;
			label = new UILabel(creditsPanel, 200, 285, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">" + BcStrings.UI_MUSIC_SFX_BY + "</font><br>Korobeynik Alexey<br>aka<br>Alexis Scorpio</p>";
			label.centerX = 530;
			
			label = new UILabel(creditsPanel, 200, 305, "", stInfoSmall);
			label.multiline = true;
			label.html = "<p align=\"center\"><font color=\"#33ff33\">" + BcStrings.UI_THANKS_TO + "</font><br>StormEx, grouzdev, Myxa</p>";
			label.centerX = 320;
			
			//hsBack = new UIButton(hsPanel, 320, 435, BcStrings.UI_CONTINUE, null, onButtonClick);
			
			/** PAUSE **/
			(new UILabel(pausePanel, 320, 200, BcStrings.UI_PAUSED, stTitle)).centerX = 320;
			pauseResume = new UIButton(pausePanel, 320, 300, BcStrings.UI_RESUME, null, this);
			pauseResume.highlight = true;
			pauseEnd = new UIButton(pausePanel, 320, 400, BcStrings.UI_END_GAME, stButtonSmall, this);
			
			// END
			endLabel = new UILabel(endPanel, 320, 50-32, "", stTitle);
			
			endRank = new UILabel(endPanel, 320, 400-64-24, "", stInfo);
			endResult = new UILabel(endPanel, 320, 400-32-16, "", stInfo);
			
			initStats();

			endContinue = new UIButton(endPanel, 320, 100+16, BcStrings.UI_CONTINUE, null, this);
			endContinue.highlight = true;
			endSubmit = new UIButton(endPanel, 320, 400+32, "SUBMIT", null, this);
			endSubmit.multiline = true;
			endSubmit.html = "<p align=\"center\"><font size=\"25\">" + BcStrings.UI_SUBMIT_SCORES + "</font></p>";
			
			endGame = new UIButton(endPanel, 320-232, 100-32, BcStrings.UI_END_GAME, stButtonSmall, this);
			endReplay = new UIButton(endPanel, 320+232, 100-32, BcStrings.UI_REPLAY, stButtonSmall, this);
			
			// SETTINGS
			settingsQ = new UICheckBox(settingsPanel, 620-527+16, 466-8, stQuality, this);
			settingsS = new UICheckBox(settingsPanel, 584-527+16, 466-8, stSound, this);
			settingsM = new UICheckBox(settingsPanel, 547-527+16, 466-8, stMusic, this);
		}
		
		private function clickInstructions():void
		{
			if(showInstructions)
			{
				showInstructions = false;
			}
			else
			{
				showInstructions = true;
				instructionsPanel.sprite.visible = true;
			}
		}
				
		public function onUpdate(dt:Number):void
		{
			var update:Boolean;
			var t:Number;
			if(showInstructions && showInstructionsTime < 1)
			{
				showInstructionsTime+=dt*4;
				if(showInstructionsTime > 1)
				{
					showInstructionsTime = 1;
				}
				update = true;
			}
			else if(!showInstructions && showInstructionsTime > 0)
			{
				showInstructionsTime-=dt*4;
				if(showInstructionsTime <= 0)
				{
					showInstructionsTime = 0;
					instructionsPanel.sprite.visible = false;
				}
				update = true;
			}
			
			if(update)
			{
				t = easeOpen.easing(showInstructionsTime);
				instructionsPanel.x = 16-320 + 320*t;
			}
		}
		private function selectMainButtonsLight():void
		{
//#if CUT_THE_CODE			
//			const cont:Boolean = BcGameGlobal.world.checkPoint.wave > 0;
//#endif
			const cont:Boolean = false;			
			
			mainNewGame.highlight = !cont;
			mainContinue.highlight = cont;
			
			mainContinue.html = "<p align=\"center\">" + BcStrings.UI_CONTINUE + "<br><font size=\"12\">" + BcStrings.INFO_STAGE_N + 
				(BcGameGlobal.world.checkPoint.wave+1) +
				"</font></p>";
			
			if(!oShowScoresButton && oBestScore)
			{
				mainBest.html = "<p align=\"center\">" + BcStrings.INFO_YOUR_BEST_SCORE + "<br><font size=\"20\">" + 
					uint(BcGameGlobal.localStore.best) +
					"</font></p>";
				mainBest.centerX = 510;
			}
		}
		
		public function onMouseClicked(object:UIObject):void
		{
			if (object == mainNewGame)
			{
					continueGame = false;
					closeMain();
			}
			else if (object == mainContinue)
			{
					continueGame = true;
					closeMain();
			}
			else if (object == mainHelp)
			{
					showCredits();
			}
			else if (object == mainHighScores)
			{
					showHighscores();
			}
			else if (object == loadingSponsor)
			{
					//navigate("http://www.gimme5games.com/?ref=CRAQUA_SPLASH");
			}
			else if (object == loadingPlay)
			{
					//loadingSponsor.play(transObjectHide, 1);
				loadingPanel.play(transWindowClose, 0.25, this, TRC_LOADING_HIDED);
					selectMainButtonsLight();
					mainPanel.play(transWindowOpen, 1);
					mainButtons.play(transMainButtonsOpen, 1);
				if (mainSponsor != null) mainSponsor.play(transMainSponsorOpen, 1);
					backTitle.play(transTitleShow, 1);
					backFader.play(transObjectHide, 1);
					settingsPanel.play(transWindowOpen, 1);
					BcMusic.getMusic("menu").play(1);
			}
			else if (object == pauseResume)
			{
					resumeGame = true;
					closePause();
			}
			else if (object == pauseEnd)
			{
					resumeGame = false;
					closePause();
			}
			else if (object == endGame)
			{
					endClickEnd();
			}
			else if (object == endReplay)
			{
					endClickReplay();
			}
			else if (object == endContinue)
			{
					endClickContinue();
			}
			else if (object == endSubmit)
			{
					endClickSubmit();
			}
			else if (object == creditsClose)
			{
					enableMain();
					creditsPanel.play(transWindowClose, 1);
			}
			else if (object == hsBack)
			{
					//BcDevice.stage.removeChild(g5Hiscores);
					endPanel.play(transWindowOpen, 0.5);
					hsPanel.play(transWindowClose, 0);
			}
			else if (object == mainInstruction)
			{
				clickInstructions();
		        }
			else if (object == settingsQ || object == settingsM || object == settingsS)
		        {
				onSettingClick(UICheckBox(object));
			}
		}
		
		private function loadingHided():void
		{
			if(oMochiAd)
			{
				/*MochiAd.unload(mcAd);
				loadingPanel.sprite.removeChild(mcAd);
				mcAd = null;*/
			}
		}
		
		private function showCredits():void
		{
			disableMain();
			creditsPanel.play(transWindowOpen, 1);
		}
		
		private function showHighscores():void
		{
			//
		}
		
		private function showSubmit():void
		{
			/*if(oShockHS)
			{
				//endPanel.play(transWindowClose, 1);
				hsPanel.play(transWindowOpen, 1);
				//BcDevice.stage.addChild(g5Hiscores);
				
				var score:int = BcGameGlobal.world.player.getMoney();
				//g5Hiscores.setDetails(246, 0, "craqua", "jZxUzqho7FjO9Gf", false, score, score, "points!");
			}*/
			
			/*hsPanel.play(transWindowOpen, 1);
			
			var o:Object = { n: [1, 7, 6, 1, 6, 12, 14, 6, 9, 12, 10, 12, 1, 6, 7, 7], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
			MochiScores.showLeaderboard({boardID: boardID, score: BcGameGlobal.world.player.getMoney(), res:"640x480",
				clip:HSMC,
				
					onClose:function():void {
						endPanel.play(transWindowOpen, 0.5);
						hsPanel.play(transWindowClose, 0);
						},
					onDisplay:function():void {
						endSubmit.play(transDisable, 0);
						endSubmit.sprite.alpha = 0.5;
						}
						
					});
			*/
			
			
			
		}
		
		private function onSettingClick(check:UICheckBox):void
		{
			if (check == settingsQ)
			{
//					if(settingsQ.checked) BcDevice.quality = 0;
//					else BcDevice.quality = 2;
			}
			if (check == settingsM)
			{
					if(settingsM.checked) BcMusic.setVolume(0);
					else BcMusic.setVolume(1);
			}
			if (check == settingsS)
			{
					if(settingsS.checked) BcAudio.setSFXVolume(0);
					else BcAudio.setSFXVolume(1);
			}
		}

		private function openMain(openSettings:Boolean = true):void
		{
			selectMainButtonsLight();
			mainPanel.play(transWindowOpen, 1);
			mainButtons.play(transMainButtonsOpen, 1);
			if(mainSponsor) mainSponsor.play(transMainSponsorOpen, 1);
			backTitle.play(transTitleShow, 1);
			backPanel.play(transBackOpen, 1);
			if(openSettings) settingsPanel.play(transWindowOpen, 1);
			BcMusic.getMusic("menu").play(2);
		}
		
		private function closeMain():void
		{
			mainPanel.play(transWindowClose, 1);
			mainButtons.play(transMainButtonsClose, 1);
			if(mainSponsor) mainSponsor.play(transMainSponsorClose, 1);
			backTitle.play(transTitleHide, 1);
			backPanel.play(transBackClose, 1, this, TRC_GO_GAME);
			settingsPanel.play(transWindowClose, 1);
			BcMusic.getMusic("menu").stop(2);
		}
		
		private var continueGame:Boolean;
		
		private function goGame():void
		{
			if(continueGame)
			{
				BcGameGlobal.game.startLastCheckPoint();
			}
			else
			{
				BcGameGlobal.game.startNewGame();
			}
			
			gameFader.initBack();
			gameFader.play(transFaderStart, 1);
			
			gamePanel.play(transWindowOpen, 1);
		}
		
		private var resumeGame:Boolean;
		
		public function goPause():void
		{
			gameFader.initBack();
			gameFader.play(transFaderOpen, 1);
			pausePanel.play(transWindowOpen, 1);
			settingsPanel.play(transWindowOpen, 1);
			
			gamePanel.play(transWindowClose, 0.25);
		}
		
		private function closePause():void
		{
			if(resumeGame)
			{
				gameFader.play(transFaderClose, 0.5);
				BcGameGlobal.game.resumePlaying();
				gamePanel.play(transWindowOpen, 0.25);
			}
			else
			{
				BcMusic.stopAll(1);
				gameFader.play(transFaderExit, 1, this, TRC_EXIT_PAUSE);
			}
			pausePanel.play(transWindowClose, 0.25);
			settingsPanel.play(transWindowClose, 0.25);			
		}
		
		private function exitPause():void
		{
			if(!resumeGame)
			{
				BcGameGlobal.game.quitWorld();
				openMain();
			}
		}
		
		public function goEnd():void
		{
			var pausing:Boolean = BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss;

			endLabel.text = BcGameGlobal.world.uiMessage;
			endRank.text = BcStrings.INFO_RANK + BcGameGlobal.world.uiRank;
			endResult.text = BcStrings.INFO_RESULT + BcGameGlobal.world.player.getMoney();
			
			endLabel.centerX = 320;
			endRank.centerX = 320; 
			endResult.centerX = 320;
			
			gameFader.initBack();
			
			if(pausing)
			{
				BcGameGlobal.world.pause = true;
				gameFader.play(transFaderOpen, 1);
			}
			else
			{
				gameFader.play(transFaderOpen, 1, this, TRC_QUIT_WORLD);
			}
			
			if(BcGameGlobal.world.uiBoss || BcGameGlobal.world.uiVictory)
			{
				endReplay.play(transDisable, 0);
				endReplay.sprite.alpha = 0.5;
			}
			else
			{
				endReplay.play(transEnable, 0);
				endReplay.sprite.alpha = 1;
			}
			
			if(BcGameGlobal.world.player.getMoney() == 0 || BcGameGlobal.world.uiDeath)
			{
				endSubmit.play(transDisable, 0);
				endSubmit.sprite.alpha = 0.5;
			}
			else
			{
				endSubmit.play(transEnable, 0);
				endSubmit.sprite.alpha = 1;
			}
			
			/*if(BcGameGlobal.world.uiDeath && BcGameGlobal.world.player.getMoney() > 0)
			{
				showSubmit();
			}
			else
			{*/
			
			endPanel.play(transWindowOpen, 1);
			
			//}
			
			//if((BcGameGlobal.world.uiVictory || BcGameGlobal.world.uiDeath) && BcGameGlobal.world.uiBest)
			/*if(BcGameGlobal.world.player.getMoney() > 0)
			{
				showSubmit();
				//endPanel.play(transWindowOpen, 1, function (o:UIObject):void {showSubmit();});
			}
			else
			{
				endPanel.play(transWindowOpen, 1);
			}*/
			
			settingsPanel.play(transWindowOpen, 1);
			
			goStats();
			
			gamePanel.play(transWindowClose, 1);
		}
		
		private function endClickContinue():void
		{

			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				gameFader.play(transFaderClose, 0.5);
				endPanel.play(transWindowClose, 0.5);
				settingsPanel.play(transWindowClose, 0.5);
				BcGameGlobal.world.pause = false;
				BcMusic.getMusic("victory").stop(1);
				BcMusic.getMusic("stage").play(1);
				
				gamePanel.play(transWindowOpen, 0.5);
			}
			else if(BcGameGlobal.world.uiVictory)
			{
				BcMusic.getMusic("victory").stop(1);
				gameFader.play(transFaderExit, 0.5);
				endPanel.play(transWindowClose, 0.5, this, TRC_OPEN_MAIN);
			}
			else if(BcGameGlobal.world.uiDeath)
			{
				gameFader.play(transFaderExit, 0.5);
				endPanel.play(transWindowClose, 0.5);
				settingsPanel.play(transWindowClose, 0.5, this, TRC_RESTART);
				
				gamePanel.play(transWindowOpen, 0.5);
			}
		}
		
		private function endClickSubmit():void
		{
			endPanel.play(transWindowClose, 0.5);
			showSubmit();
		}
		
		private function endClickEnd():void
		{
			BcMusic.stopAll(1);
			
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				BcGameGlobal.game.quitWorld();
			}
			
			gameFader.play(transFaderExit, 0.5);
			endPanel.play(transWindowClose, 0.5, this, TRC_OPEN_MAIN);
		}
		
		private function endClickReplay():void
		{
			if(BcGameGlobal.world.uiClear || BcGameGlobal.world.uiBoss)
			{
				BcGameGlobal.game.quitWorld();
			}
			
			BcMusic.stopAll(0.5);
			
			gameFader.play(transFaderExit, 0.5);
			endPanel.play(transWindowClose, 0.5);
			settingsPanel.play(transWindowClose, 0.5, this, TRC_RESTART);
		}
		
		public function onTransitionComplete(object:UIObject, finishCode:int) : void
		{
			switch (finishCode)
			{
				case TRC_LOADING_HIDED:
					loadingHided();
					break;
				case TRC_EXIT_PAUSE:
					exitPause();
					break;
				case TRC_GO_GAME:
					goGame();
					break;
				case TRC_QUIT_WORLD:
					BcGameGlobal.game.quitWorld();			
					break;
				case TRC_RESTART:
					BcGameGlobal.game.startLastCheckPoint();
					gameFader.initBack();
					gameFader.play(transFaderStart, 1);
					break;
				case TRC_OPEN_MAIN:
					openMain(false);
					break;
			}
		}

		private var transBackStart : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			Vector.<uint>([0xff000000, 0, 0xffffffff, 0]), // color
			Vector.<uint>(UITransition.OPEN), // flags
			easeOpen // ease
		);
		private var transObjectShow : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([0, 1]), // a
			null, // color
			Vector.<uint>([UITransition.FLAG_SHOW, 0]), // flags
			easeOpen // ease
		);
		private var transObjectHide : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0]), // a
			null, // color
			Vector.<uint>([0, UITransition.FLAG_HIDE]), // flags
			easeOpen // ease
		);
		private var transBackOpen : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			Vector.<uint>([0xff000000, 0, 0xffffffff, 0]), // color
			Vector.<uint>(UITransition.OPEN), // flags
			easeOpen // ease
		);
		private var transBackClose : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			Vector.<uint>([0xffffffff, 0, 0xff000000, 0]), // color
			Vector.<uint>(UITransition.CLOSE), // flags
			easeOpen // ease
		);
		private var transWindowOpen : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([0, 1]), // a
			null, // color
			Vector.<uint>(UITransition.OPEN), // flags
			easeOpen // ease
		);
		private var transWindowClose : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0]), // a
			null, // color
			Vector.<uint>(UITransition.CLOSE), // flags
			easeOpen // ease
		);
		private var transMainButtonsOpen : UITransition = new UITransition(
			Vector.<Number>([320, 0]), // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transMainButtonsClose : UITransition = new UITransition(
			Vector.<Number>([0, 320]), // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transMainSponsorOpen : UITransition = new UITransition(
			Vector.<Number>([-150, 150]), // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transMainSponsorClose : UITransition = new UITransition(
			Vector.<Number>([150, -150]), // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transDisable : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			Vector.<uint>([UITransition.FLAG_DISABLE, 0]), // flags
			null // ease
		);
		private var transEnable : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			Vector.<uint>([0, UITransition.FLAG_ENABLE]), // flags
			null // ease
		);
		private var transButtonShow : UITransition = new UITransition(
			null, // x
			null, // y
			Vector.<Number>([0, 1]), // sx
			Vector.<Number>([0, 1]), // sy
			Vector.<Number>([0, 1]), // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transTitleShow : UITransition = new UITransition(
			null, // x
			Vector.<Number>([-165, 0]), // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transTitleHide : UITransition = new UITransition(
			null, // x
			Vector.<Number>([0, -165]), // y
			null, // sx
			null, // sy
			null, // a
			null, // color
			null, // flags
			easeOpen // ease
		);
		private var transFaderStart : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0]), // a
			Vector.<uint>([0xff000000, 0, 0xffffffff, 0]), // color
			Vector.<uint>([UITransition.FLAG_ACTIVATE | UITransition.FLAG_SHOW, UITransition.FLAG_DEACTIVATE | UITransition.FLAG_HIDE]), // flags
			easeOpen // ease
		);
		private var transFaderOpen : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([0, 1]), // a
			null, // color
			Vector.<uint>(UITransition.OPEN), // flags
			easeOpen // ease
		);
		private var transFaderClose : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0]), // a
			null, // color
			Vector.<uint>(UITransition.CLOSE), // flags
			easeOpen // ease
		);
		private var transFaderExit : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			null, // a
			Vector.<uint>([0xffffffff, 0, 0xff000000, 0]), // color
			Vector.<uint>(UITransition.CLOSE), // flags
			easeOpen // ease
		);
		private var transLabelHide : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0]), // a
			null, // color
			Vector.<uint>([0, UITransition.FLAG_HIDE]), // flags
			easeOpen // ease
		);
		private var transStatEnable : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([0.2, 1]), // a
			Vector.<uint>([0xffffffff, 0xff00ff00, 0, 0]), // color
			null, // flags
			easeOpen // ease
		);
		private var transStatDisable : UITransition = new UITransition(
			null, // x
			null, // y
			null, // sx
			null, // sy
			Vector.<Number>([1, 0.2]), // a
			Vector.<uint>([0xff00ff00, 0xffffffff, 0, 0]), // color
			null, // flags
			easeOpen // ease
		);
		
		private function initBackFader():void
		{
			var nbd:BitmapData = new BitmapData(640, 480, false, 0x0);
//#if CUT_THE_CODE
//#			nbd.applyFilter(BcAsset.getImage("ui_bg"), new Rectangle(0, 0, 640, 480), new Point(), new BlurFilter(8, 8));
//#endif
			var bm:Bitmap = new Bitmap(nbd);
			bm.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
			backFader.sprite.addChild(bm);
		}
		
		private function initMainFader():void
		{
			mainFader = new UIObject(mainPanel);
			mainFaderBitmap = new Bitmap(new BitmapData(640, 480, false, 0x0));
			mainFader.sprite.addChild(mainFaderBitmap);
			mainFader.sprite.visible = false;
		}
		
		private function disableMain():void
		{
			mainFaderBitmap.bitmapData.draw(layerBack.sprite);
			mainFaderBitmap.bitmapData.draw(layerMain.sprite);
//#if CUT_THE_CODE			
//#			mainFaderBitmap.bitmapData.applyFilter(mainFaderBitmap.bitmapData, new Rectangle(0, 0, 640, 480), new Point(), new BlurFilter(8, 8));
//#endif
			mainFaderBitmap.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
			mainFader.play(transObjectShow, 1);
			mainPanel.play(transDisable, 1);
		}
		
		private function enableMain():void
		{
			mainFader.play(transObjectHide, 0.5);
			mainPanel.play(transEnable, 0.5);
		}
		
		private var descRockets:UILabel;
		private var descDamage:UILabel;
		private var descBottom:UILabel;
		private var descBonus:UILabel;
		private var descComplete:UILabel;

		private function initStats():void
		{
			var y:Number = 166+10;
			var labelSpace:Number = 24;
			
			descRockets = new UILabel(endPanel, 135, y, BcStrings.DESC_ROCKETS + int(BcPlayer.M_ROCKETS*100) + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descDamage = new UILabel(endPanel, 135, y, BcStrings.DESC_DAMAGE + int(BcPlayer.M_DAMAGE*100) + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descBottom = new UILabel(endPanel, 135, y, BcStrings.DESC_BOTTOM + int(BcPlayer.M_BOTTOM*100) + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descBonus = new UILabel(endPanel, 135, y, BcStrings.DESC_BONUS + int(BcPlayer.M_BONUS*100) + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
			descComplete = new UILabel(endPanel, 135, y, BcStrings.DESC_COMPLETE + int(BcPlayer.M_COMPLETE*100) + BcStrings.DESC_POINTS, stInfoSmall);
			y+=labelSpace;
		}
		
		private function goStats():void
		{
			var player:BcPlayer = BcGameGlobal.world.player;
			
			if(player.uiRockets)
				descRockets.play(transStatEnable, 3);
			else
				descRockets.play(transStatDisable, 3);
			
			if(player.uiDamage)
				descDamage.play(transStatEnable, 3);
			else
				descDamage.play(transStatDisable, 3);
				
			if(player.uiBottom)
				descBottom.play(transStatEnable, 3);
			else
				descBottom.play(transStatDisable, 3);
				
			if(player.uiBonus)
				descBonus.play(transStatEnable, 3);
			else
				descBonus.play(transStatDisable, 3);
				
			if(player.uiComplete)
				descComplete.play(transStatEnable, 3);
			else
				descComplete.play(transStatDisable, 3);
		}
	}
}
