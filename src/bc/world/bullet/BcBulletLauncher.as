package bc.world.bullet 
{
	import bc.core.math.Vector2;
	import bc.game.BcGameGlobal;

	/**
	 * @author Elias Ku
	 */
	public class BcBulletLauncher 
	{
		public static const DIRECTION_NONE:uint = 0;
		public static const DIRECTION_AIM:uint = 1;
		public static const DIRECTION_VELOCITY:uint = 2;
		
		private var n:uint = 1;
		private var min:Number = 0;
		private var max:Number = 0;
		private var a:Number = 0;
		private var w:Number = 0;
		private var f:Number = 0;
		
		private var bullet:BcBulletData;
		public var directionType:uint;
		
		private static var DIRECTION:Vector2 = new Vector2();
		
		public function BcBulletLauncher(xml:XML)
		{
			const toRad:Number = Math.PI/180;
			if(xml.hasOwnProperty("@bullet")) bullet = BcBulletData.getData(xml.@bullet.toString());
			if(xml.hasOwnProperty("@n")) n = uint(xml.@n);
			if(xml.hasOwnProperty("@min")) min = Number(xml.@min)*toRad;
			if(xml.hasOwnProperty("@max")) max = Number(xml.@max)*toRad;
			if(xml.hasOwnProperty("@a")) a = Number(xml.@a)*toRad;
			if(xml.hasOwnProperty("@w")) w = Number(xml.@w)*toRad;
			if(xml.hasOwnProperty("@f")) f = Number(xml.@f)*toRad;
			
			if(xml.hasOwnProperty("@direction"))
			{
				switch(xml.@direction.toString())
				{
					case "none": directionType = DIRECTION_NONE; break;
					case "aim": directionType = DIRECTION_AIM; break;
					case "velocity": directionType = DIRECTION_VELOCITY; break;
				}
			}
		}
		
		public function launch(position:Vector2, direction:Vector2, mask:uint, mod:Number, t:Number = 0):void
		{
			var i:uint;
			var da:Number = (max - min)/n;
			var angle:Number = Math.atan2(direction.y, direction.x) + min + a*Math.sin(w*t + f);
			
			for ( i = 0; i < n; ++i )
			{
				DIRECTION.x = Math.cos(angle);
				DIRECTION.y = Math.sin(angle);
				
				BcGameGlobal.world.bullets.launch(bullet, position, DIRECTION, mask, mod);
				
				angle += da;
			}
		}
	}
}


