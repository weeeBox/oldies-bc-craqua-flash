package bc.world.item 
{
	import bc.world.player.BcPlayer;
	import bc.core.math.Vector2;
	import bc.game.BcGameGlobal;
	import bc.world.core.BcWorld;

	import flash.display.DisplayObject;

	/**
	 * @author Elias Ku
	 */
	public class BcItemList 
	{
		public var count:uint;
		public var head:BcItem;
		
		private var iter:BcItem;
		private var prev:BcItem;
		
		private var moneyAccum:uint;
		private var gemAccum:uint;
		
		public function BcItemList()
		{
		}
		
		public function clear():void
		{
			var node:BcItem = head;
			var next:BcItem;
			
			while(node)
			{
				next = node.next;
				
				node.exit();
				
				node.next = pool;
				pool = node;
				
				node = next;
			}
			
			head = null;
			count = 0;
			
			moneyAccum = gemAccum = 0;
		}
		
		public function update(dt:Number):void
		{
			iter = head;
			prev = null;
			
			while(iter)
			{
				if(iter.dead)
				{
					removeIter();
				}
				else
				{
					iter.update(dt);
					
					prev = iter;
					iter = iter.next;
				}
			}
		}
		
		public function push(node:BcItem):void
		{
			node.next = head;
			head = node;
			
			if(iter && !prev) prev = head;
			
			++count;	
		}
		
		private function removeIter():void
		{
			var node:BcItem = iter;
			
			iter = iter.next;
			if(prev) prev.next = iter;
			else head = iter;
			
			--count;
			
			node.next = pool;
			pool = node;
		}
		
		private var pool:BcItem;
		
		public function initializePool(count:uint):void
		{
			var node:BcItem;
			
			for( var i:uint = count; i > 0; --i )
			{
				node = new BcItem();
				node.next = pool;
				pool = node;
			}
		}
		
		public function launch(properties:BcItemData, position:Vector2, caster:DisplayObject):void
		{
			var node:BcItem = pool;
			
			if(node)
			{
				pool = pool.next;
				node.launch(properties, position, caster);
				if(properties.type == BcItemData.MONEY || properties.type == BcItemData.GEM)
				{
					world.player.medalTotalBonus++;
				}
			}
		}
		
		
		
		public var healingAmount:int;
		public var bombsAmount:int;
		
		private var minGem:uint;
		private var minMoney:uint;
		
		private var world:BcWorld;
		
		public function initializeLogic():void
		{
			BcItemData.moneyList.sort(sorter);
			BcItemData.gemList.sort(sorter);
			
			minGem = BcItemData.gemList[BcItemData.gemList.length-1].amount;
			minMoney = BcItemData.moneyList[BcItemData.moneyList.length-1].amount;
			
			world = BcGameGlobal.world;
		}

		public function launchEnemyBonus(position:Vector2, gems:int, money:int, prob:Number, caster:DisplayObject):void
		{
			
			var count:int;
			
			gemAccum += gems;
			moneyAccum += money;
			
			if(prob >= 1 || Math.random() < prob)
			{
				while(gemAccum > minGem)
				{
					var searchGemItem:BcItemData;
					for each (var gemItem:BcItemData in BcItemData.gemList)
					{	
						searchGemItem = gemItem;					
						if(gemAccum >= gemItem.amount)
						{							
							break;
						}
					}
					launch(searchGemItem, position, caster);
					gemAccum -= searchGemItem.amount;
				}
				
				while(moneyAccum > minMoney)
				{
					var searchMoneyItem:BcItemData;
					for each (var moneyItem:BcItemData in BcItemData.moneyList)
					{
						searchMoneyItem = moneyItem;
						if(moneyAccum >= moneyItem.amount)
						{
							break;
						}
					}
					launch(searchMoneyItem, position, caster);
					moneyAccum -= searchMoneyItem.amount;
				}
			}
			
			count = world.player.getHealthNeed() - healingAmount;
			if(count > 5 && healingAmount < 25 && Math.random()>0.9)
			{
				launch(BcItemData.healingItem, position, caster);
			}
			
			count = world.player.getBombsNeed() - bombsAmount;
			if(count > 0 && bombsAmount < 3 && Math.random()>0.95)
			{
				launch(BcItemData.bombItem, position, caster);
			}
		}
		
		private function sorter(a:BcItemData, b:BcItemData):Number
	    {
			if(a.amount > b.amount)
				return -1;
			if(a.amount < b.amount)
				return 1;
			
			return 0;
	    }
	}
}
