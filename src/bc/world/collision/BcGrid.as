package bc.world.collision 
{
	import bc.core.math.Vector2;

	import flash.display.Graphics;

	/**
	 * Регулярная сетка для кластеризации игрового пространства.
	 * @author Elias Ku
	 */
	public class BcGrid 
	{
		// Массив ячеек
		private var _cells:Vector.<BcGridCell>;
		
		// Число столбцов и строк в сетке
		private var _cols:uint;
		private var _rows:uint;
		
		// Размеры ячейки
		private var _cellWidth:uint;
		private var _cellHeight:uint;
		
		// Размеры поля
		private var _width:uint;
		private var _height:uint;
		
		// Список для сбора объектов из сетки.
	 	// Таких объектов, которые содержаться в ячейках прошедших какой-либо тест
		private var objectList:BcGridObject;
		
		public function BcGrid(width:uint, height:uint)
		{
			var i:uint;
			var cellCount:uint;
			
			_cellWidth = 64;
			_cellHeight = 64;
			_width = width;
			_height = height;
			_cols = 10;
			_rows = 8;
			
			cellCount = _cols*_rows;
			
			_cells = new Vector.<BcGridCell>(cellCount, true);	
			
			while(i<cellCount)
			{
				_cells[i] = new BcGridCell(_cellWidth, _cellHeight, i % _cols, i / _cols);
				++i;
			}

		}
		
		public function draw(g:Graphics):void
		{
			for each (var cell:BcGridCell in _cells)
			{
				cell.draw(g);
			}
		}
		
		public function clear():void
		{
			for each (var cell:BcGridCell in _cells)
			{
				cell.clear();
			}
		}
		
		private function clearObjectList():void
		{
			var it:BcGridObject = objectList;
			
			while(it)
			{
				it.gridLooking = false;
				it = it.gridLookingNext;
			}
			
			objectList = null;
		}
		
		/*private function pushObject(gridObject:BcGridObject):void
		{
			gridObject.gridLooking = true;
			gridObject.gridLookingNext = objectList;
			objectList = gridObject;
		}*/
		
		private function pushCellObjects(cell:BcGridCell, mask:uint):void
		{
			for each (var object:BcGridObject in cell.objects)
			{
				if( ( object.mask & mask ) && !object.gridLooking )
				{
					object.gridLooking = true;
					object.gridLookingNext = objectList;
					objectList = object;
				}
			}
		}
		
		// Удалить объект из сетки
		public function remove(gridObject:BcGridObject):void
		{
			var objectCells:Vector.<BcGridCell> = gridObject.cells;
			
			for each (var cell:BcGridCell in objectCells)
			{
				cell.remove(gridObject);
			}
			
			objectCells.length = 0;
		}
		
		public function replace(gridObject:BcGridObject):void
		{
			var shape:BcShape = gridObject.shape;

			if(shape)
			{
				var col_beg:int = int(shape.xmin) >> 6;
				var row_beg:int = int(shape.ymin) >> 6;
				var col_end:int = ( int(shape.xmax) >> 6 ) + 1;
				var row_end:int = ( int(shape.ymax) >> 6 ) + 1;
				
				if(col_beg < 0) col_beg = 0;
				if(row_beg < 0) row_beg = 0;
				if(col_end > _cols) col_end = _cols;
				if(row_end > _rows) row_end = _rows;
				
				if(row_beg != gridObject.rowMin ||
				   row_end != gridObject.rowMax ||
				   col_beg != gridObject.colMin ||
				   col_end != gridObject.colMax)
				{
					remove(gridObject);
					placeAABB(col_beg, row_beg, col_end, row_end, gridObject);
				}
			}
			else
			{
				throw new Error("BcGrid: shape info not found");
			}
		}
		
		private function placeAABB(colMin:int, rowMin:int, colMax:int, rowMax:int, gridObject:BcGridObject):void
		{
			const aabb:BcShape = gridObject.shape;
			const dx:Number = aabb.xmin - _width;
			const dy:Number = aabb.ymin - _height;
				
			if(aabb.xmax >= 0 && aabb.ymax >= 0 && dx < 0 && dy < 0)
			{
				var col_it:uint = colMin;
				var row_it:uint = rowMin;
				var cell_it:uint = _cols*rowMin + colMin;
				var cell:BcGridCell;
				
				while(row_it < rowMax)
				{
					while(col_it < colMax)
					{
						cell = _cells[cell_it];
						cell.objects.push(gridObject);
						gridObject.cells.push(cell);
						++col_it;
						++cell_it;
					}
					
					cell_it += _cols + colMin - colMax;
					col_it = colMin;
					++row_it;
				}
				
				gridObject.colMin = colMin;
				gridObject.colMax = colMax;
				gridObject.rowMin = rowMin;
				gridObject.rowMax = rowMax;
			}
			else
			{
				gridObject.colMin = 
				gridObject.colMax = 
				gridObject.rowMin = 
				gridObject.rowMax = -1;
			}
		}
		
		private function lookShape(shape:BcShape, mask:uint):void
		{
			var col_beg:int = int(shape.xmin) >> 6;
			var row_beg:int = int(shape.ymin) >> 6;
			var col_end:int = ( int(shape.xmax) >> 6 ) + 1;
			var row_end:int = ( int(shape.ymax) >> 6 ) + 1;
			
			if(col_beg < 0) col_beg = 0;
			if(row_beg < 0) row_beg = 0;
			if(col_end > _cols) col_end = _cols;
			if(row_end > _rows) row_end = _rows;
			
			var col_it:uint = col_beg;
			var row_it:uint = row_beg;
			var cell_it:uint = _cols*row_beg + col_beg;
			
			while(row_it < row_end)
			{
				while(col_it < col_end)
				{
					pushCellObjects(_cells[cell_it], mask);
					
					++col_it;
					++cell_it;
				}
				
				cell_it += _cols + col_beg - col_end;
				col_it = col_beg;
				++row_it;
			}
		}
		
		/*public function lookVRay(x:Number, y:Number, direction:int, mask:uint):void
		{
			var col:int = x / _cellWidth;
			var row:int = y / _cellHeight;
			var index:int = row * _cols + col;
			var offset:int = _cols;
			var cell:BcGridCell;
			
			if( direction < 0 )
				offset = -offset;
			else if( direction == 0 )
				throw new Error("vertical line dy!=0");
				
			while ( index >= 0 && index < _cells.length )
			{
				cell = _cells[index];
				pushCellObjects(cell, mask);
				index += offset;
			}			
		}*/
		
		/*public function testVRay(x:Number, y:Number, direction:int, mask:uint, arbiter:BcArbiter):void
		{
			var object:BcGridObject;
			
			lookVRay(x, y, direction, mask);
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				object.shape.testVRay(x, y, direction, arbiter);
				object = object.gridLookingNext;
			}
			
			clearObjectList();
		}*/
		
		public function testPoint(point:Vector2, mask:uint, arbiter:BcArbiter):void
		{
			if(point.x < 0 || point.y < 0 || point.x >= _width || point.y >= _height)
			{
				return;
			}
			
			var col:int = int(point.x) >> 6;
			var row:int = int(point.y) >> 6;
			var index:int = row * _cols + col;
			var cell:BcGridCell = _cells[index];
			var object:BcGridObject;
			
			pushCellObjects(cell, mask);
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testPointShape(point, object.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearObjectList();
		}
		
		public function testObject(gridObject:BcGridObject, mask:uint, arbiter:BcArbiter):void
		{
			var cell:BcGridCell;
			var object:BcGridObject;
			
			for each (cell in gridObject.cells)
			{
				pushCellObjects(cell, mask);
			}
			
			arbiter.tester = gridObject;
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testShapes(object.shape, gridObject.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearObjectList();
		}
		
		public function testShape(shape:BcShape, mask:uint, arbiter:BcArbiter):void
		{
			var object:BcGridObject;

			lookShape(shape, mask);
			
			object = objectList;
			while(object)
			{
				arbiter.object = object;
				BcCollision.testShapes(shape, object.shape, arbiter);
				object = object.gridLookingNext;
			}
			
			clearObjectList();
		}
	}
}
