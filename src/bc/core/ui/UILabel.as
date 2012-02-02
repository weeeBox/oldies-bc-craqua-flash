package bc.core.ui 
{
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	/**
	 * @author Elias Ku
	 */
	public class UILabel extends UIObject 
	{
		public static var DEFAULT_STYLE:UIStyle = new UIStyle();
		DEFAULT_STYLE.setProperty("font", "main");
		DEFAULT_STYLE.setProperty("textSize", 15);
		DEFAULT_STYLE.setProperty("textColor", 0xffffff);
		DEFAULT_STYLE.setProperty("strokeBlur", 0);
		DEFAULT_STYLE.setProperty("strokeColor", 0x0);
		DEFAULT_STYLE.setProperty("strokeAlpha", 1);
		DEFAULT_STYLE.setProperty("strokeStrength", 8);
 		
		protected var _textField:UITextField = new UITextField();
		protected var _textFormat:TextFormat;
		protected var _stroke:DropShadowFilter;
	
		public function UILabel(layer:UIObject, x:Number, y:Number, text:String = "", style:UIStyle = null)
		{
			super(layer, x, y);

//			var strokeBlur:Number;
			
			if(!style)
			{
				style = DEFAULT_STYLE;
			}

//#if CUT_THE_CODE			
//#			_textFormat = new TextFormat(style.getProperty("font"), style.getProperty("textSize"), 0xffffff);
//#			_textField.defaultTextFormat = _textFormat;
//#			_textField.embedFonts = true;
//#			_textField.selectable = false;
//#			_textField.autoSize = UITextFieldAutoSize.LEFT;
//#			_textField.textColor = style.getProperty("textColor");
//#			_textField.text = text;
//#			_textField.cacheAsBitmap = true;
//#			
//#			_sprite.addChild(_textField);
//#			
//#			if(text)
//#			{
//#				_textField.text = text;
//#			}
//#			
//#			strokeBlur = style.getProperty("strokeBlur");
//#			if(strokeBlur && strokeBlur > 0)
//#			{
//#				_stroke = new DropShadowFilter(0, 0, style.getProperty("strokeColor"), style.getProperty("strokeAlpha"), strokeBlur, strokeBlur, style.getProperty("strokeStrength"), 2);
//#				_textField.filters = [_stroke];
//#			}
//#endif
			
		}
		
		public function set html(value:String):void
		{
//#if CUT_THE_CODE
//#			if(value)
//#			{
//#				_textField.htmlText = value;
//#			}
//#			else
//#			{
//#				_textField.htmlText = "";
//#			}
//#endif
		}
		
		public function set multiline(value:Boolean):void
		{
//#if CUT_THE_CODE
//#			_textField.multiline = value;
//#endif
		}
		
		public function set text(value:String):void
		{
//#if CUT_THE_CODE
//#			if(value)
//#			{
//#				_textField.text = value;
//#			}
//#			else
//#			{
//#				_textField.text = "";
//#			}
//#endif
		}
		
		public function get text():String
		{
//#if CUT_THE_CODE
//#			return _textField.text;
//#endif
			return "";
		}
		
		public function set centerX(x:Number):void
		{
			this.x = x + int(-0.5*_sprite.width); 
		}
	}
}
