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
		public static var DEFAULT_STYLE:UIStyle = new UIStyle();
		
		DEFAULT_STYLE.setProperty("font", "main");
		DEFAULT_STYLE.setProperty("textSize", 30);
		DEFAULT_STYLE.setProperty("textColor", 0xffffff);
		DEFAULT_STYLE.setProperty("strokeBlur", 3);
		DEFAULT_STYLE.setProperty("strokeColor", 0x033754);
		DEFAULT_STYLE.setProperty("strokeAlpha", 1);
		DEFAULT_STYLE.setProperty("strokeStrength", 6);
		
		DEFAULT_STYLE.setProperty("back", "ui_btn_back");
		DEFAULT_STYLE.setProperty("body", "ui_btn");
		DEFAULT_STYLE.setProperty("normalBackColor", 0xff000000);
		DEFAULT_STYLE.setProperty("overBackColor", 0xffffffff);
		DEFAULT_STYLE.setProperty("scale", 1);
		
		DEFAULT_STYLE.setProperty("sfxOver", "ui_over");
		DEFAULT_STYLE.setProperty("sfxClick", "ui_click");
		DEFAULT_STYLE.setProperty("sfxPress", "ui_click");
		
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
		
		public function UIButton(layer:UIObject, x:Number = 0, y:Number = 0, text:String = null, style:UIStyle = null, onClick:Function = null, fast:Boolean = true)
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
				style = DEFAULT_STYLE;
			}
			
			_style = style;
			
			image = style.getProperty("back");
			if(image)
			{
				_spriteBack.addChild(BcBitmapData.create(image));
			}
			
			image = style.getProperty("body");
			if(image)
			{
				_spriteBody.addChild(BcBitmapData.create(image));
			}
			
			_spriteButton.addChild(_spriteBack);
			_spriteButton.addChild(_spriteBody);
			_sprite.addChild(_spriteButton);
			
			if(_style.getProperty("scale"))
			{
				_baseScale = _style.getProperty("scale");
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
			
			var sfx:String;
			sfx = _style.getProperty("sfxOver");
			if(sfx) _sfxOver = BcSound.getData(sfx);
			sfx = _style.getProperty("sfxPress");
			if(sfx) _sfxPress = BcSound.getData(sfx);
			sfx = _style.getProperty("sfxClick");
			if(sfx) _sfxClick = BcSound.getData(sfx);
		}
		
		private function createLabel():void
		{
			_label = new UILabel(this, 0, 0, "", _style);
			_label.sprite.scaleX = 
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
			BcColorTransformUtil.setMultipliersARGB(COLOR_BEGIN, _style.getProperty("normalBackColor"));
			BcColorTransformUtil.setMultipliersARGB(COLOR_END, _style.getProperty("overBackColor"));
			_spriteBack.transform.colorTransform = BcColorTransformUtil.lerpMult(COLOR, COLOR_BEGIN, COLOR_END, _tweenOver + (1-_tweenOver)*_tweenLight);
						
			_spriteButton.scaleX = 
			_spriteButton.scaleY = _baseScale*(1 - 0.025 * _tweenPush);
		}
		
		public function set highlight(value:Boolean):void
		{
			_highlight = value;
		}
		
	}
}

