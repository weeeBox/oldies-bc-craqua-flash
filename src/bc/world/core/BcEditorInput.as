package bc.world.core 
{
	import bc.world.enemy.BcEnemy;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;

	import flash.ui.Mouse;

	/**
	 * @author weee
	 */
	public class BcEditorInput extends BcInput
	{	
		public var world:BcWorld;
		
		public function BcEditorInput(world:BcWorld)
		{
			this.world = world;
		}
		
		public override function update(dt:Number):void
		{
		}
		
		public override function reset():void
		{				
		}

		public override function keyboard(message:BcKeyboardMessage):void
		{
			
		}
		
		public override function mouse(message:BcMouseMessage):void
		{
			switch(message.event)
			{
				case BcMouseMessage.MOUSE_DOWN:
				{
					mouseX = message.x - bounds.x;
					mouseY = message.y - bounds.y;
					
					var selected : BcEnemy = findEnemyAt(mouseX, mouseY);
					if (selected)
					{
						trace("Find enemy");					
					}
					
					break;	
				}					
				case BcMouseMessage.MOUSE_UP:
					
					break;
			}			
		}
		
		public override function activate(value:Boolean):void
		{
			active = value;
			Mouse.show();
			reset();
		}
		
		private function findEnemyAt(x:Number, y:Number):BcEnemy
		{
			var enemy:BcEnemy = world.enemies.head;
			while (enemy != null)
			{
				var selected:Boolean = enemy.sprite.hitTestPoint(x, y);
				if (selected)
				{
					return enemy;
				}
				
				enemy = enemy.next;
			}	
			
			return null;
		}

	}
}
