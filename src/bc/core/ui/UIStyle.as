package bc.core.ui 
{

	/**
	 * @author Elias Ku
	 */
	public class UIStyle 
	{
		private var _properties:Object;
		private var baseStyle:UIStyle;
		
		public function UIStyle(baseStyle:UIStyle = null, properties:Object = null)
		{
			this.baseStyle = baseStyle;
			
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
			var value:Object = null;
			
			while(value==null && style!=null)
			{
				value = style._properties[name];
				style = style.baseStyle;
			}
			
			return value;
		}
	}
}
