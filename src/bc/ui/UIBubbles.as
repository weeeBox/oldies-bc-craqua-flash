package bc.ui 
{
	import bc.core.ui.UI;
	import bc.core.ui.UIObject;

	/**
	 * @author Elias Ku
	 */
	public class UIBubbles extends UIObject 
	{
		public var bubbles:Bubble;
		public var pool:Bubble;
		private var iter:Bubble;
		private var prev:Bubble;
		
		private var gen:Number = 0;
		
		public function UIBubbles(layer:UIObject)
		{
			super(layer, 0, 0, true);
			
			var node:Bubble;
			
			for( var i:uint = 40; i > 0; --i )
			{
				node = new Bubble();
				node.next = pool;
				pool = node;
			}
		}
		
		public override function update():void
		{
			super.update();
			
			const dt:Number = UI.deltaTime;
			var temp:Bubble;
			
			iter = bubbles;
			prev = null;
			
			while(iter)
			{
				if(!iter.update(dt))
				{
					temp = iter;
			
					iter = iter.next;
					if(prev) prev.next = iter;
					else bubbles = iter;
					
					temp.next = pool;
					pool = temp;
				}
				else
				{
					prev = iter;
					iter = iter.next;
				}
			}
			
			gen -= dt;
			if(gen <= 0)
			{
				var node:Bubble = pool;
			
				if(node)
				{
					pool = pool.next;
					node.launch(_sprite);
					node.next = bubbles;
					bubbles = node;
				}
				
				gen = 0.1+0.3*Math.random();
			}
		}
	}
}

import bc.core.display.BcBitmapData;
import bc.core.util.BcSpriteUtil;

import flash.display.Bitmap;
import flash.display.Sprite;

internal class Bubble extends Sprite
{
	public var t:Number = 0;
	public var next:Bubble;
	public var bitmap:Bitmap;
	public var vy:Number = 0;
	public var s:Number = 0;
	public var g:Number = 0;
	public var f:Number = 0;
	public var ox:Number = 0;
	public var mod:Number = 0;
	public var mod_ph:Number = 0;
	
	public function Bubble()
	{
		BcSpriteUtil.setupFast(this);
		visible = false;
		
		bitmap = BcBitmapData.create("fx_air_32");
		addChild(bitmap);
		
		alpha = 0.7;
	}
	
	public function update(dt:Number):Boolean
	{
		vy -= g*dt;
		vy *= Math.exp( -dt * f );
		y += vy*dt;
		
		if(t<1)
		{
			t+=dt*g/1400;
			if(t>1) t = 1;
			
			
		}
		
		mod += dt*mod_ph;
		if(mod > Math.PI*2) mod -= Math.PI*2;
		
		var sc:Number = s*t*t*t;
		var ph:Number = mod;
		scaleX = sc + sc*0.1*Math.sin(ph);
		scaleY = sc + sc*0.1*Math.cos(ph);
		
		x = ox+sc*32*Math.sin(ph);
		
				
		if(y < -32 && visible)
		{
			visible = false;
			parent.removeChild(this);
		}
		
		return visible;
	}
	
	public function launch(layer:Sprite):void
	{
		t = 0;
		vy = 0;
		
		ox = x = 20+Math.random()*600;
		y = 320+Math.random()*160;
		s = 0.2 + Math.random()*0.3;
		g = 400 + 300*Math.random();
		f = 5 + 2*Math.random();
		mod_ph = 0.5+2*Math.random();
		
		scaleX = 
		scaleY = 0;
		
		layer.addChild(this);	
		visible = true;
	}
}