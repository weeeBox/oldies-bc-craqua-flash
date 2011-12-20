package bc.world.player 
{
	import bc.core.math.Vector2;

	/**
	 * @author Elias Ku
	 */
	public class BcPlayerClaw 
	{
		public var position:Vector2 = new Vector2();
		public var direction:Vector2 = new Vector2();
		public var shootingAngle:Number;
		
		public function BcPlayerClaw()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			const toRad:Number = Math.PI/180;
			var angle:Number = (-90 - Number(xml.@angle))*toRad;
			var distance:Number = xml.@distance;
			
			position.assign( Math.cos(angle)*distance, Math.sin(angle)*distance );
			//BcStringUtil.parseVector2(xml.@position, position);
			
			shootingAngle = (-90 - Number(xml.@shooting_angle)) * toRad;
			
			direction.assign( Math.cos(shootingAngle), Math.sin(shootingAngle) );
		}
		
	}
}
