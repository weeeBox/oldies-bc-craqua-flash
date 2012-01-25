package bc.game 
{

	/**
	 * @author Elias Ku
	 */
	public class BcStrings 
	{
		public static const UI_LOADING:String = "% loaded";
		public static const UI_LOADING_COMPLETED:String = "COMPLETED";
		public static const UI_LOADING_PLAY:String = "PLAY!";
		
		public static const UI_SPONSORED_BY:String = "SPONSORED BY:";
		public static const UI_DEVELOPED_BY:String = "DEVELOPED BY:";
		public static const UI_MUSIC_SFX_BY:String = "MUSIC/SFX BY:";
		public static const UI_THANKS_TO:String = "THANKS TO:";
		
		public static const UI_QUALITY_HIGH:String = "HIGH";
		public static const UI_QUALITY_LOW:String = "LOW";
		public static const UI_MUSIC_ON:String = "MUSIC ON";
		public static const UI_MUSIC_OFF:String = "MUSIC OFF";
		public static const UI_SFX_ON:String = "SFX ON";
		public static const UI_SFX_OFF:String = "SFX OFF";
			
		public static const UI_NEW_GAME:String = "NEW GAME";
		public static const UI_CONTINUE:String = "CONTINUE";
		public static const UI_HIGHSCORES:String = "HIGHSCORES";
		public static const UI_CREDITS:String = "CREDITS";
		public static const UI_BACK:String = "BACK";
		public static const UI_PAUSED:String = "PAUSED";
		public static const UI_RESUME:String = "RESUME";
		public static const UI_END_GAME:String = "END GAME";
		public static const UI_REPLAY:String = "REPLAY";
		public static const UI_SUBMIT_SCORES:String = "SUBMIT<br>SCORES";
		
		public static const INFO_STAGE_N:String = "Stage ";
		public static const INFO_YOUR_BEST_SCORE:String = "Your Best Score:";
		public static const INFO_RANK:String = "RANK: ";
		public static const INFO_RESULT:String = "RESULT: ";
		
		public static const DESC_ROCKETS:String = "Complete stage without rockets: +";
		public static const DESC_DAMAGE:String = "No bullets/enemies damage: +";
		public static const DESC_BOTTOM:String = "Enemies didn't reach the bottom: +";
		public static const DESC_BONUS:String = "At least 95% gems harvested: +";
		public static const DESC_COMPLETE:String = "You're alive: +";
		public static const DESC_POINTS:String = "% points";
		
		public static const GAME_VICTORY:String = "VICTORY!!!";
		public static const GAME_GAME_OVER:String = "GAME OVER";
		public static const GAME_STAGE_CLEAR:String = "STAGE CLEAR";
		public static const GAME_BOSS_DEFEATED:String = "BOSS DEFEATED";
		public static const GAME_STAGE_N:String = "Stage ";
		public static const GAME_BOSS_N:String = "Boss ";
		
		public static const BOSS_NAMES:Object = null; // FIXME!!! {boss1:"Gasoiler", boss2:"A(H1N1)", boss3:"MR. NOTHING"};
		
		public static const RANKS:Array = ["EASY", "NOT BAD", "GOOD", "EXCELLENT", "AWESOME", "HARDCORE"];
		
		public static var UI_INSTRUCTIONS:String = "INSTRUCTIONS";
		public static var UI_INSTRUCTIONS_TEXT:String = "<font color=\"#33ff33\">ContrГґles.</font><br> - Souris pour bouger.<br> - Clic gauche pour tirer.<br> - Touche Espace pour<br>   envoyer des missiles.<br><br><font color=\"#33ff33\">Instructions.</font><br> - Tuer les ennemis.<br> - Collecter les Г©toiles pour<br>   amГ©liorer les armes du crabe.<br> - Ne pas laisser vos coeurs<br>   passer Г  zГ©ro.";
		
		public static function initialize():void
		{
			/*if(Translations.instance.exists("UI_QUALITY_HIGH"))
				UI_QUALITY_HIGH = Translations.instance.getString("UI_QUALITY_HIGH");
			if(Translations.instance.exists("UI_QUALITY_LOW"))
				UI_QUALITY_LOW = Translations.instance.getString("UI_QUALITY_LOW");
			if(Translations.instance.exists("UI_MUSIC_ON"))
				UI_MUSIC_ON = Translations.instance.getString("UI_MUSIC_ON");
			if(Translations.instance.exists("UI_MUSIC_OFF"))
				UI_MUSIC_OFF = Translations.instance.getString("UI_MUSIC_OFF");
			if(Translations.instance.exists("UI_SFX_ON"))
				UI_SFX_ON = Translations.instance.getString("UI_SFX_ON");
			if(Translations.instance.exists("UI_SFX_OFF"))
				UI_SFX_OFF = Translations.instance.getString("UI_SFX_OFF");
		
			if(Translations.instance.exists("UI_NEW_GAME"))
				UI_NEW_GAME = Translations.instance.getString("UI_NEW_GAME");
			if(Translations.instance.exists("UI_CONTINUE"))
				UI_CONTINUE = Translations.instance.getString("UI_CONTINUE");
			if(Translations.instance.exists("UI_HIGHSCORES"))
				UI_HIGHSCORES = Translations.instance.getString("UI_HIGHSCORES");
			if(Translations.instance.exists("UI_CREDITS"))
				UI_CREDITS = Translations.instance.getString("UI_CREDITS");
			if(Translations.instance.exists("UI_BACK"))
				UI_BACK = Translations.instance.getString("UI_BACK");
			if(Translations.instance.exists("UI_PAUSED"))
				UI_PAUSED = Translations.instance.getString("UI_PAUSED");
			if(Translations.instance.exists("UI_RESUME"))
				UI_RESUME = Translations.instance.getString("UI_RESUME");
			if(Translations.instance.exists("UI_END_GAME"))
				UI_END_GAME = Translations.instance.getString("UI_END_GAME");
			if(Translations.instance.exists("UI_REPLAY"))
				UI_REPLAY = Translations.instance.getString("UI_REPLAY");
			if(Translations.instance.exists("UI_SUBMIT_SCORES"))
				UI_SUBMIT_SCORES = Translations.instance.getString("UI_SUBMIT_SCORES");
				
				
			if(Translations.instance.exists("INFO_STAGE_N"))
				INFO_STAGE_N = Translations.instance.getString("INFO_STAGE_N");
			if(Translations.instance.exists("INFO_YOUR_BEST_SCORE"))
				INFO_YOUR_BEST_SCORE = Translations.instance.getString("INFO_YOUR_BEST_SCORE");
			if(Translations.instance.exists("INFO_RANK"))
				INFO_RANK = Translations.instance.getString("INFO_RANK");
			if(Translations.instance.exists("INFO_RESULT"))
				INFO_RESULT = Translations.instance.getString("INFO_RESULT");
		
			if(Translations.instance.exists("DESC_ROCKETS"))
				DESC_ROCKETS = Translations.instance.getString("DESC_ROCKETS");
			if(Translations.instance.exists("DESC_DAMAGE"))
				DESC_DAMAGE = Translations.instance.getString("DESC_DAMAGE");
			if(Translations.instance.exists("DESC_BOTTOM"))
				DESC_BOTTOM = Translations.instance.getString("DESC_BOTTOM");
			if(Translations.instance.exists("DESC_BONUS"))
				DESC_BONUS = Translations.instance.getString("DESC_BONUS");
			if(Translations.instance.exists("DESC_COMPLETE"))
				DESC_COMPLETE = Translations.instance.getString("DESC_COMPLETE");
			if(Translations.instance.exists("DESC_POINTS"))
				DESC_POINTS = Translations.instance.getString("DESC_POINTS");

			if(Translations.instance.exists("GAME_BOSS_1"))
				POOL.boss1 = Translations.instance.getString("GAME_BOSS_1");			
			if(Translations.instance.exists("GAME_BOSS_2"))
				POOL.boss2 = Translations.instance.getString("GAME_BOSS_2");
			if(Translations.instance.exists("GAME_BOSS_3"))
				POOL.boss3 = Translations.instance.getString("GAME_BOSS_3");
				
			if(Translations.instance.exists("GAME_VICTORY"))
				GAME_VICTORY = Translations.instance.getString("GAME_VICTORY");
			if(Translations.instance.exists("GAME_GAME_OVER"))
				GAME_GAME_OVER = Translations.instance.getString("GAME_GAME_OVER");
			if(Translations.instance.exists("GAME_STAGE_N"))
				GAME_STAGE_N = Translations.instance.getString("GAME_STAGE_N");
			if(Translations.instance.exists("GAME_BOSS_N"))
				GAME_BOSS_N = Translations.instance.getString("GAME_BOSS_N");*/
		}
	}
}
