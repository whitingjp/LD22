package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.utils.*;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Orb extends Entity
	{
		[Embed(source="gfx/orbs.png")]
		public static const OrbGfx: Class;
		
		public var sprite:Spritemap;
		
		public var on:Boolean;
		public var anim_timer:int;
		
		public function Orb(on:Boolean):void
		{
			this.on = on;
			sprite = new Spritemap(OrbGfx, 16, 24);
			sprite.x -= 8;
			sprite.y -= 8+8;			
			graphic = sprite;
			setHitbox(12,12,6,6);
			type = "orb_off";
		}
		
		public override function update():void
		{
			layer = -y;
			
			anim_timer = (anim_timer+1)%32;
			if(on && anim_timer < 24)
				sprite.frame = 1;
			else
				sprite.frame = 0;
			type = on ? "orb_on" : "orb_off";
		}
	}
}