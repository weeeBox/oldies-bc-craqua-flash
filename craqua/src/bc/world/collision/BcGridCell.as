package bc.world.collision 
{
	
	import flash.display.Graphics;

	/**
	 * @author Elias Ku
	 */
	public class BcGridCell 
	{
		private var _col:uint;
		private var _row:uint;
		private var _x:uint;
		private var _y:uint;
		private var _width:uint;
		private var _height:uint;
		
		internal var objects:Vector.<BcGridObject> = new Vector.<BcGridObject>();
		
		public function BcGridCell(width:uint, height:uint, col:uint, row:uint)
		{
			_x = col*width;
			_y = row*height;
			_col = col;
			_row = row;
			_width = width;
			_height = height;
		}
		
		// Удаляем объект из ячейки
		internal function remove(gridObject:BcGridObject):void
		{
			var index:uint;
			
			// Находим индекс объекта в массиве
			for each (var obj:BcGridObject in objects)
			{
				if(obj==gridObject)
					break;
					
				++index;
			}
			
			if(index < objects.length)
				objects.splice(index, 1);
			else
				throw new Error("GridCell: nothing to remove!");
		}
		
		// Удаляем все объекты из ячейки
		internal function clear():void
		{
			objects.length = 0;
		}
		
		public function draw(g:Graphics):void
		{
			var alpha:Number = objects.length / 16;
			if(alpha>0)
			{
				g.lineStyle(1, 0x0000ff);
				g.beginFill(0xff0000, alpha);
				g.drawRect(_x + 1, _y + 1, _width - 2, _height - 2);
				g.endFill();
			}
			else
			{
				g.lineStyle(1, 0x000000);
				g.drawRect(_x + 1, _y + 1, _width - 2, _height - 2);
			}
		}
		
		
	}
}
