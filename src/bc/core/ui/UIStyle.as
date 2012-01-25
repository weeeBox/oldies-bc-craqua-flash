package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UIStyle 
	{
		private var _properties:Object;
		private var _base:UIStyle;
		
		public function UIStyle(base:UIStyle = null, properties:Object = null)
		{
			_base = base;
			
			if(properties)
			{
				_properties = properties;
			}
			else
			{
				_properties = new Object();
			}
		}
		
		public function setProperty(name:String, value:Object):void
		{
			_properties[name] = value;
		}
		
		public function getProperty(name:String):Object
		{
			var style:UIStyle = this;
			var value:* = null;
			
			while(value==null && style!=null)
			{
				value = style._properties[name];
				style = style._base;
			}
			
			return value;
		}
	}
}
