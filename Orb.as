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
		
		[Embed(source="gfx/goal.png")]
		public static const GoalGfx: Class;		
		
		public var sprite:Spritemap;
		
		public var on:Boolean;
		public var anim_timer:int;
		
		public function Orb(on:Boolean, goal:Boolean = false):void
		{
			this.on = on;
			if(goal)
				sprite = new Spritemap(GoalGfx, 16, 24);
			else
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
			
			anim_timer = (anim_timer+1)%16;
			if(on)
				sprite.frame = anim_timer/4;
			else
				sprite.frame = 0;
			type = on ? "orb_on" : "orb_off";
		}
	}
}