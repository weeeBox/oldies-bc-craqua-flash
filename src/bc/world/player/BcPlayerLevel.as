package bc.world.player 
{

	/**
	 * @author Elias Ku
	 */
	internal class BcPlayerLevel 
	{
		// Модификатор скорости стрельбы
		public var modRate:Number = 1;
		
		// Модификатор урона
		public var modDamage:Number = 1;
		
		// Время на восстановление одной жизни
		public var regenHealth:Number = 1;
		
		// Время на восстановление бомбы
		public var regenBomb:Number = 1;
		
		// уровень опыта до след уровня
		public var exp:uint;
		
		public var weapons:Vector.<BcPlayerWeapon> = new Vector.<BcPlayerWeapon>(3, true);
		public var bombs:Vector.<BcPlayerWeapon> = new Vector.<BcPlayerWeapon>();
		
		public function BcPlayerLevel()
		{
			
		}
		
		public function parse(xml:XML):void
		{
			var i:int;
			var weapon:BcPlayerWeapon;
			
			exp = xml.@exp;
			
			var node:XML = xml.mod[0];
			if(node)
			{
				modRate = node.@rate;
				modDamage = node.@damage;
			}
			
			node = xml.regen[0];
			if(node)
			{
				regenHealth = node.@health;
				regenBomb = node.@bomb;
			}
			
			for each (var weaponNode:XML in xml.weapon)
			{
				weapon = new BcPlayerWeapon();
				weapon.parse(weaponNode);
				weapons[i] = weapon;
				i++;
			}
			
			for each (var bombNode:XML in xml.bomb)
			{
				weapon = new BcPlayerWeapon();
				weapon.parse(bombNode);
				bombs.push(weapon);
			}
		}
	}
}
