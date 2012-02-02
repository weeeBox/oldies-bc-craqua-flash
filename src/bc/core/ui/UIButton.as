package bc.core.ui 
{
	import bc.core.audio.BcSound;
	import bc.core.display.BcBitmapData;
	import bc.core.ui.UIObject;
	import bc.core.util.BcColorTransformUtil;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class UIButton extends UIObject 
	{
		private static var defaultStyle:UIStyle;
		
		protected var _style:UIStyle;
		
		protected var _label:UILabel;
		
		protected var _spriteButton:Sprite = new Sprite();
		protected var _spriteBody:Sprite = new Sprite();
		protected var _spriteBack:Sprite = new Sprite();
		
		protected var _tweenOver:Number = 0;
		protected var _tweenPush:Number = 0;
		
		protected var _highlight:Boolean;
		protected var _tweenLight:Number = 0;
		
		protected var _baseScale:Number = 1;
		
		protected var _overSpeed:Number = 6;
		protected var _overBackSpeed:Number = 2;
		
		public function UIButton(layer:UIObject, x:Number = 0, y:Number = 0, text:String = null, style:UIStyle = null, onClick:UIMouseClickCallback = null, fast:Boolean = true)
		{
			super(layer, x, y, fast);
			
			var image:String;
			var w:Number = 0;
			var h:Number = 0;
			
			if(fast)
				BcSpriteUtil.setupFast(_spriteButton);
				
			BcSpriteUtil.setupFast(_spriteBack);
			BcSpriteUtil.setupFast(_spriteBody);
			
			if(!style)
			{
				style = getDefaultStyle();
			}
			
			_style = style;

			image = style.getString("back");
			if(image != null)
			{
				_spriteBack.addChild(BcBitmapData.create(image));
			}

			image = style.getString("body");
			if(image != null)
			{
				_spriteBody.addChild(BcBitmapData.create(image));
			}
			
			_spriteButton.addChild(_spriteBack);
			_spriteButton.addChild(_spriteBody);
			_sprite.addChild(_spriteButton);
			
			if(_style.hasProperty("scale"))
			{
				_baseScale = _style.getNumber("scale");
			}
			
			w = _baseScale*(_spriteButton.width-12);
			h = _baseScale*(_spriteButton.height-12);
			
			_shape = new UIRectangleShape(w, h, int(-0.5*w), int(-0.5*h));
			
			if(text)
			{
				this.text = text;
			}
			
			_onMouseClick = onClick;
			
			redraw();
			
			var sfx : String;
			sfx = _style.getString("sfxOver");
			if(sfx != null) _sfxOver = BcSound.getData(sfx);
			sfx = _style.getString("sfxPress");
			if(sfx != null) _sfxPress = BcSound.getData(sfx);
			sfx = _style.getString("sfxClick");
			if(sfx != null) _sfxClick = BcSound.getData(sfx);
		}
		
		private function createLabel():void
		{
			_label = new UILabel(this, 0, 0, "", _style);
			_label.sprite.scaleX = _baseScale;
			_label.sprite.scaleY = _baseScale;
		}
		
		private function alignLabel():void
		{
			_label.x = int(-0.5*_label.sprite.width); 
			_label.y = int(-0.5*_label.sprite.height);
		}
		
		public function set text(value:String):void
		{
			if(!_label) createLabel();
			_label.text = value;
			alignLabel();
		}
		
		public function set html(value:String):void
		{
			if(!_label) createLabel();
			_label.html = value;
			alignLabel();
		}
		
		public function set multiline(value:Boolean):void
		{
			if(!_label) createLabel();
			_label.multiline = value;
			alignLabel();
		}
		
		
		public override function reset():void
		{
			super.reset();
			
			_tweenOver = 
			_tweenPush = 
			_tweenLight = 0;
			
			redraw();
		}
		
		public override function update():void
		{
			super.update();
			
			var dt:Number = UI.deltaTime;
			var speed:Number;
			var updated:Boolean;
			
			speed = 6;
			if(_mouseOver && _tweenOver < 1)
			{
				_tweenOver += dt*_overSpeed;
				if(_tweenOver > 1)
				{
					_tweenOver = 1;
				}
				updated = true;
			}
			else if(!_mouseOver && _tweenOver > 0)
			{
				_tweenOver -= dt*_overBackSpeed;
				if(_tweenOver < 0)
				{
					_tweenOver = 0;
				}
				updated = true;
			}
			
			speed = 12;
			if(_mouseOver && _mousePressed && _tweenPush < 1)
			{
				_tweenPush += dt*speed;
				if(_tweenPush > 1)
				{
					_tweenPush = 1;
				}
				updated = true;
			}
			else if((!_mouseOver || !_mousePressed) && _tweenPush > 0)
			{
				_tweenPush -= dt*speed;
				if(_tweenPush < 0)
				{
					_tweenPush = 0;
				}
				updated = true;
			}
			
			if(_highlight)
			{
				_tweenLight -= dt;
				while(_tweenLight < 0)
					_tweenLight += 1;
					
				updated = true;
			}
			else if(_tweenLight > 0)
			{
				_tweenLight -= dt;
				if(_tweenLight < 0)
					_tweenLight = 0;
				
				updated = true;
			}
			
			if(updated)
			{
				redraw();
			}
		}
		
		protected static var COLOR_BEGIN:ColorTransform = new ColorTransform();
		protected static var COLOR_END:ColorTransform = new ColorTransform();
		protected static var COLOR:ColorTransform = new ColorTransform();
		
		protected function redraw():void
		{
			BcColorTransformUtil.setMultipliersARGB(COLOR_BEGIN, _style.getUint("normalBackColor"));
			BcColorTransformUtil.setMultipliersARGB(COLOR_END, _style.getUint("overBackColor"));
			_spriteBack.transform.colorTransform = BcColorTransformUtil.lerpMult(COLOR, COLOR_BEGIN, COLOR_END, _tweenOver + (1-_tweenOver)*_tweenLight);
						
			_spriteButton.scaleX = 
			_spriteButton.scaleY = _baseScale*(1 - 0.025 * _tweenPush);
		}
		
		public function set highlight(value:Boolean):void
		{
			_highlight = value;
		}
		
		public static function getDefaultStyle() : UIStyle
		{
			if (defaultStyle == null)
			{
				defaultStyle = new UIStyle();
		
				defaultStyle.setString("font", "main");
				defaultStyle.setNumber("textSize", 30);
				defaultStyle.setNumber("textColor", 0xffffff);
				defaultStyle.setNumber("strokeBlur", 3);
				defaultStyle.setNumber("strokeColor", 0x033754);
				defaultStyle.setNumber("strokeAlpha", 1);
				defaultStyle.setNumber("strokeStrength", 6);
				
				defaultStyle.setString("back", "ui_btn_back");
				defaultStyle.setString("body", "ui_btn");
				defaultStyle.setNumber("normalBackColor", 0xff000000);
				defaultStyle.setNumber("overBackColor", 0xffffffff);
				defaultStyle.setNumber("scale", 1);
				
				defaultStyle.setString("sfxOver", "ui_over");
				defaultStyle.setString("sfxClick", "ui_click");
				defaultStyle.setString("sfxPress", "ui_click");				
			}
			return defaultStyle;
		}
	}
}

