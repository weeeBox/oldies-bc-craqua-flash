package bc.core.ui 
{
	import bc.core.boxing.BcNumber;
	import bc.core.boxing.BcBoolean;
	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class UIStyle 
	{
		private var properties:Dictionary;
		private var baseStyle:UIStyle;
		
		public function UIStyle(baseStyle:UIStyle = null, moreProperties:Dictionary = null)
		{
			this.baseStyle = baseStyle;
			
			if(moreProperties != null)
			{
				this.properties = moreProperties;
			}
			else
			{
				this.properties = new Dictionary;
			}
		}
		
		public function setObject(name:String, value:Object):void
		{
			properties[name] = value;
		}
		
		public function setString(name:String, value:String):void
		{
			properties[name] = value;
		}
		
		public function setNumber(name:String, value:Number):void
		{
			properties[name] = new BcNumber(value);
		}		
			
		public function getObject(name:String):Object
		{
			var style:UIStyle = this;
			while(style != null)
			{
				var propValue : Object = style.properties[name];
				if (propValue != null)
				{
					return style.properties[name];
				}
								
				style = style.baseStyle;
			}
			
			return null;
		}
		
		public function hasProperty(name : String) : Boolean
		{
			return getObject(name) != null;
		}
		
		public function getString(name:String):String
		{
			var style:UIStyle = this;
			while(style != null)
			{
				var propValue : String = style.properties[name];
				if (propValue != null)
				{
					return propValue;
				}
								
				style = style.baseStyle;
			}
			
			return null;
		}
		
		public function getBoolean(name:String):Boolean
		{
			var value : Object = getObject(name);
			return value == null ? false : (BcBoolean(value)).value;
		}
		
		public function getUint(name:String):uint
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).uintValue();
		}
		
		public function getInt(name:String):int
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).intValue();
		}
		
		public function getNumber(name:String):Number
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).value;
		}
	}
}
