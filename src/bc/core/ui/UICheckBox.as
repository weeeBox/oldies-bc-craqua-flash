package bc.core.ui 
{
	import bc.core.audio.BcSound;
	import bc.core.display.BcBitmapData;
	import bc.core.ui.UIObject;
	import bc.core.util.BcColorTransformUtil;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class UICheckBox extends UIObject 
	{
		public static var DEFAULT_STYLE:UIStyle = new UIStyle();
		
		DEFAULT_STYLE.setProperty("font", "main");
		DEFAULT_STYLE.setProperty("textSize", 12);
		DEFAULT_STYLE.setProperty("textColor", 0xffffff);
		DEFAULT_STYLE.setProperty("strokeBlur", 3);
		DEFAULT_STYLE.setProperty("strokeColor", 0x033754);
		DEFAULT_STYLE.setProperty("strokeAlpha", 1);
		DEFAULT_STYLE.setProperty("strokeStrength", 6);
		
		DEFAULT_STYLE.setProperty("text1", "unchecked");
		DEFAULT_STYLE.setProperty("text2", "checked");
		DEFAULT_STYLE.setProperty("back1", "ui_btn_back");
		DEFAULT_STYLE.setProperty("body1", "ui_btn");
		DEFAULT_STYLE.setProperty("back2", "ui_btn_back");
		DEFAULT_STYLE.setProperty("body2", "ui_btn");
		DEFAULT_STYLE.setProperty("normalBackColor", 0xff000000);
		DEFAULT_STYLE.setProperty("overBackColor", 0xffffffff);
		
		DEFAULT_STYLE.setProperty("sfxOver", "ui_over");
		DEFAULT_STYLE.setProperty("sfxClick", "ui_click");
		
		protected var _style:UIStyle;
		
		protected var _label:UILabel;
		
		protected var _spriteButton:Sprite = new Sprite();
		protected var _spriteBody:Sprite = new Sprite();
		protected var _spriteBack:Sprite = new Sprite();
		
		protected var _bmBack1:Bitmap;
		protected var _bmBody1:Bitmap;
		protected var _bmBack2:Bitmap;
		protected var _bmBody2:Bitmap;
		
		protected var _checked:Boolean;
		
		protected var _tweenOver:Number = 0;
		protected var _tweenPush:Number = 0;
		
		public function UICheckBox(layer:UIObject, x:Number = 0, y:Number = 0, style:UIStyle = null, onCheck:Function = null)
		{
			super(layer, x, y);
			
			var image:String;
			var w:Number = 0;
			var h:Number = 0;
			
			BcSpriteUtil.setupFast(_spriteButton);
			BcSpriteUtil.setupFast(_spriteBack);
			BcSpriteUtil.setupFast(_spriteBody);
			
			if(!style)
			{
				style = DEFAULT_STYLE;
			}
			
			_style = style;
			
			image = style.getProperty("back1");
			if(image)
			{
				_bmBack1 = BcBitmapData.create(image);
				_spriteBack.addChild(_bmBack1);
			}
			
			image = style.getProperty("back2");
			if(image)
			{
				_bmBack2 = BcBitmapData.create(image);
				_spriteBack.addChild(_bmBack2);
			}
			
			image = style.getProperty("body1");
			if(image)
			{
				_bmBody1 = BcBitmapData.create(image);
				_spriteBody.addChild(_bmBody1);
				w = _bmBody1.width;
				h = _bmBody1.height;
			}
			
			image = style.getProperty("body2");
			if(image)
			{
				_bmBody2 = BcBitmapData.create(image);
				_spriteBody.addChild(_bmBody2);
			}
			
			_spriteButton.addChild(_spriteBack);
			_spriteButton.addChild(_spriteBody);
			_sprite.addChild(_spriteButton);
			
			_shape = new UIRectangleShape(w, h, int(-0.5*w), int(-0.5*h));
			
			_onMouseClick = onCheck;
			_instantClick = true;
			
			_label = new UILabel(this, 0, 0, "", _style);
			
			checked = false;
			
			redraw();
			
			var sfx:String;
			sfx = _style.getProperty("sfxOver");
			if(sfx) _sfxOver = BcSound.getData(sfx);
			sfx = _style.getProperty("sfxPress");
			if(sfx) _sfxPress = BcSound.getData(sfx);
			sfx = _style.getProperty("sfxClick");
			if(sfx) _sfxClick = BcSound.getData(sfx);
		}
		
		public function set text(value:String):void
		{
			if(!_label)
			{
				_label = new UILabel(this, 0, 0, value, _style);
			}
			else
			{
				_label.text = value;
			}
		
			_label.x = int(-0.5*_label.sprite.width); 
			_label.y = int(-0.5*_label.sprite.height);
		}
		
		public override function reset():void
		{
			super.reset();
			
			_tweenOver = 
			_tweenPush = 0;
			
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
				_tweenOver += dt*speed;
				if(_tweenOver > 1)
				{
					_tweenOver = 1;
				}
				updated = true;
			}
			else if(!_mouseOver && _tweenOver > 0)
			{
				_tweenOver -= dt*speed*0.3;
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
			
			if(updated)
			{
				redraw();
			}
		}
		
		private static var COLOR_BEGIN:ColorTransform = new ColorTransform();
		private static var COLOR_END:ColorTransform = new ColorTransform();
		private static var COLOR:ColorTransform = new ColorTransform();
		
		private function redraw():void
		{
			BcColorTransformUtil.setMultipliersARGB(COLOR_BEGIN, _style.getProperty("normalBackColor"));
			BcColorTransformUtil.setMultipliersARGB(COLOR_END, _style.getProperty("overBackColor"));
			_spriteBack.transform.colorTransform = BcColorTransformUtil.lerpMult(COLOR, COLOR_BEGIN, COLOR_END, _tweenOver);
						
			_spriteButton.scaleX = 
			_spriteButton.scaleY = 1 - 0.1 * _tweenPush;
			
			_label.sprite.alpha = _tweenOver;
			_label.y = -20-20*_tweenOver;
		}
		
		public function set checked(value:Boolean):void
		{	
			_checked = value;
			
			_bmBody1.visible = 
			_bmBack1.visible = !value;
			_bmBody2.visible = 
			_bmBack2.visible = value;
			
			if(value)
			{
				_label.text = _style.getProperty("text2");
			}
			else
			{
				_label.text = _style.getProperty("text1");
			}
			
			_label.x = int(-0.5*_label.sprite.width); 
		}
		
		public function get checked():Boolean
		{
			return _checked;
		}
		
		protected override function mouseClick():void
		{
			checked = !_checked;
					
			super.mouseClick();
		}
	}
}
