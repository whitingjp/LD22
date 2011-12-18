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
		public var source:Boolean;
		public var anim_timer:int;
		
		public function Orb(source:Boolean, goal:Boolean = false):void
		{
			this.source = source;
			this.on = source;
			if(goal)
				sprite = new Spritemap(GoalGfx, 16, 24);
			else
				sprite = new Spritemap(OrbGfx, 16, 24);
			sprite.x -= 8;
			sprite.y -= 8+8;			
			graphic = sprite;
			setHitbox(12,12,6,6);
			type = source ? "orb_source" : "orb_off";
			if(goal) type = "orb_goal";
		}
		
		public override function update():void
		{
			layer = -y;
			
			anim_timer = (anim_timer+1)%16;
			if(Main.galaxy.overworld)
			{
				var key:String = Dungeon(FP.world).current_room_key;
				if(Main.galaxy.dungeon_completion[key])
					sprite.frame = 2;
				else
					sprite.frame = anim_timer/4;
			}
			else if(source)
				sprite.frame = anim_timer/4;
			else if(on)
				sprite.frame = 2;
			else
				sprite.frame = 0;
			if(on && type == "orb_off") type = "orb_on";
		}
	}
}