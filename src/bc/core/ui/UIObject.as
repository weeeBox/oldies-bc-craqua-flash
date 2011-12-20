package bc.core.ui 
{
	import bc.core.audio.BcSound;
	import bc.core.device.BcDevice;
	import bc.core.util.BcColorTransformUtil;
	import bc.core.util.BcSpriteUtil;

	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author Elias Ku
	 */
	public class UIObject 
	{
		protected var _sprite:Sprite = new Sprite();
		protected var _next:UIObject;
		protected var _parent:UIObject;
		protected var _children:UIObject;
		protected var _active:Boolean = true;
		protected var _enabled:Boolean = true;
		
		protected var _shape:IUIShape;
		protected var _mouseOver:Boolean;
		protected var _mousePressed:Boolean;
		protected var _instantClick:Boolean;
		protected var _onMouseClick:Function;
		protected var _onUpdate:Function;
		
		protected var _sfxOver:BcSound;
		protected var _sfxPress:BcSound;
		protected var _sfxClick:BcSound;
		
		protected var _transition:UITransition;
		protected var _transitionProgress:Number = 0;
		protected var _transitionSpeed:Number = 0;
		protected var _transitionComplete:Function;

		public function UIObject(layer:UIObject, x:Number = 0, y:Number = 0, fast:Boolean = true)
		{
			if(fast)
			{
				BcSpriteUtil.setupFast(_sprite);
			}
			
			this.x = x;
			this.y = y;
			
			if(layer)
			{
				layer.addChild(this);
			}
		}
		
		public function update():void
		{
			var iter:UIObject = _children;
			
			while(iter)
			{
				if(iter._active)
				{
					iter.update();
				}
				iter = iter._next;
			}
			
			if(_transition)
			{
				_transitionProgress += UI.deltaTime * _transitionSpeed;
				if(_transitionProgress >= 1)
				{
					finishTransition();
				}
				else
				{
					updateTransition();
				}
			}
			
			if(_onUpdate!=null)
			{
				_onUpdate(UI.deltaTime);
			}
		}
		
		public function set onUpdate(value:Function):void
		{
			_onUpdate = value;
		}
		
		
		
		public function reset():void
		{
			var iter:UIObject = _children;
			
			while(iter)
			{
				iter.reset();
				iter = iter._next;
			}
			
			_mouseOver = 
			_mousePressed = false;
		}
		
		public function addChild(object:UIObject):void
		{
			if(!object._parent)
			{
				object._parent = this;
				object._next = _children;
				_children = object;
				_sprite.addChild(object._sprite);
			}
			else
			{
				throw new Error();
			}
		}
		
		public function removeChild(object:UIObject):void
		{
			var prev:UIObject;
			var iter:UIObject;
			
			if(object._parent == this)
			{
				object._parent = null;
				
				iter = _children;
				while(iter)
				{
					if(iter == object)
					{
						break;
					}
					prev = iter;
					iter = _next;
				}
				
				if(prev)
				{
					prev._next = object._next;
				}
				else
				{
					_children = object._next;
				}
				
				object._next = null;
				
				_sprite.removeChild(object._sprite);
			}
			else
			{
				throw new Error();
			}
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			_sprite.x = x;
			_sprite.y = y;
		}
		
		public function set x(value:Number):void { _sprite.x = value; }
		public function get x():Number { return _sprite.x; }
		public function set y(value:Number):void { _sprite.y = value; }
		public function get y():Number { return _sprite.y; }
		
		public function get sprite():Sprite { return _sprite; }
		public function get parent():UIObject { return _parent; }
		public function get children():UIObject { return _children; }
		public function get next():UIObject { return _next; }
		
		protected function mouseMove(x:Number, y:Number):void
		{
			var iter:UIObject = _children;

			while(iter)
			{
				if(iter._enabled)
				{
					iter.mouseMove(x - iter._sprite.x, y - iter._sprite.y);
				}
				iter = iter._next;
			}
			
			if(_shape)
			{
				if(_shape.testMouse(x, y))
				{
					if(!_mouseOver)
					{
						if(_sfxOver)
						{
							_sfxOver.play();
						}
					}
					_mouseOver = true;
				}
				else
				{
					_mouseOver = false;
				} 
			}
		}
		
		protected function mouseDown(x:Number, y:Number):void
		{
			var iter:UIObject = _children;

			while(iter)
			{
				if(iter._enabled)
				{
					iter.mouseDown(x - iter._sprite.x, y - iter._sprite.y);
				}
				iter = iter._next;
			}
			
			if(_mouseOver)
			{
				if(!_mousePressed)
				{
					_mousePressed = true;
					if(_sfxPress && !_instantClick)
					{
						_sfxPress.play();
					}
				}
				
				if(_instantClick)
				{
					mouseClick();
				}
			}
		}
		
		protected function mouseUp(x:Number, y:Number):void
		{
			var iter:UIObject = _children;

			while(iter)
			{
				if(iter._enabled)
				{
					iter.mouseUp(x - iter._sprite.x, y - iter._sprite.y);
				}
				iter = iter._next;
			}
			
			if(_mousePressed)
			{				
				if(_mouseOver && !_instantClick)
				{
					mouseClick();
				}

				_mousePressed = false;
			}
		}

		protected function mouseClick():void
		{
			if(_onMouseClick!=null)
			{
				_onMouseClick(this);
			}
			
			if(_sfxClick)
			{
				//_sfxClick.play();
			}
		}
		
		public function play(transition:UITransition = null, time:Number = 0, onComplete:Function = null):void
		{
			if(_transition)
			{
				finishTransition();
			}
			
			if(transition)
			{
				_transition = transition;
				_transitionComplete = onComplete;
				startTransition();
				if(time <= 0)
				{
					finishTransition();
				}
				else
				{
					_transitionSpeed = 1/time;
				}
			}
		}
		
		public function set enabled(value:Boolean):void {_enabled = value;}
		public function set visible(value:Boolean):void {_sprite.visible = value;}
		public function set active(value:Boolean):void {_active = value;}
		
		private static var COLOR:ColorTransform = new ColorTransform();
		protected function updateTransition():void
		{
			var t:Number;
			
			if(_transition.ease == null)
			{
				t = _transitionProgress;
			}
			else
			{
				t = _transition.ease(_transitionProgress);
			}
			
			if(_transition.x)
			{
				_sprite.x = _transition.x[0] + (_transition.x[1] - _transition.x[0])*t;
			}

			if(_transition.y)
			{
				_sprite.y = _transition.y[0] + (_transition.y[1] - _transition.y[0])*t;
			}
			
			if(_transition.sx)
			{
				_sprite.scaleX = _transition.sx[0] + (_transition.sx[1] - _transition.sx[0])*t;
			}

			if(_transition.sy)
			{
				_sprite.scaleY = _transition.sy[0] + (_transition.sy[1] - _transition.sy[0])*t;
			}
			
			if(_transition.a)
			{
				_sprite.alpha = _transition.a[0] + (_transition.a[1] - _transition.a[0])*t;
			}
			
			else if(_transition.color)
			{
				_sprite.transform.colorTransform = BcColorTransformUtil.lerpColor(COLOR, _transition.color[0], _transition.color[1], t);
			}
		}
		
		protected function startTransition():void
		{
			if(_transition.flags && _transition.flags[0])
			{
				setTransitionFlags(_transition.flags[0]);
			}
			
			_transitionProgress = 0;
			updateTransition();
		}
		
		protected function finishTransition():void
		{
			var onComplete:Function = _transitionComplete;
			
			if(_transition.flags && _transition.flags[1])
			{
				setTransitionFlags(_transition.flags[1]);
			}
			
			_transitionProgress = 1;
			updateTransition();
			
			_transition = null;
			_transitionProgress = 0;
			_transitionSpeed = 1;
			_transitionComplete = null;
			
			if(onComplete != null)
			{
				onComplete(this);
			}
		}
		
		protected function setTransitionFlags(flags:uint):void
		{
			if(flags & UITransition.FLAG_ACTIVATE)
			{
				_active = true;
			}
			
			if(flags & UITransition.FLAG_DEACTIVATE)
			{
				_active = false;
			}
			
			if(flags & UITransition.FLAG_SHOW)
			{
				_sprite.visible = true;
			}
			
			if(flags & UITransition.FLAG_HIDE)
			{
				_sprite.visible = false;
			}
			
			if(flags & UITransition.FLAG_RESET)
			{
				reset();
			}
			
			if(flags & UITransition.FLAG_ENABLE)
			{
				_enabled = true;
				mouseMove(BcDevice.mouseX, BcDevice.mouseY);
				if(BcDevice.mousePushed)
				{
					mouseDown(BcDevice.mouseX, BcDevice.mouseY);
				}
			}
			
			if(flags & UITransition.FLAG_DISABLE)
			{
				_enabled = false;
			}
		}
	}
}
