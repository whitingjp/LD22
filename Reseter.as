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
	
	public class Reseter extends Entity
	{
		[Embed(source="gfx/reseter.png")]
		public static const ReseterGfx: Class;
		
		public var sprite:Spritemap;
		
		public var timer:int;
		
		public function Reseter():void
		{
			sprite = new Spritemap(ReseterGfx,16,16);
			sprite.x -= 8;
			sprite.y -= 8;
			setHitbox(8,8,4,4);
			graphic = sprite;
			type = "reseter";
			timer = 0;
		}
		
		public override function update():void
		{
			layer = -y+5;
			var player_e:Entity = collide("player", x, y);
			if(player_e)
			{
				if(timer == 0) Main.galaxy.play("resetter");
				var player:Player = Player(player_e);
				timer++;
				sprite.frame = timer/8;
				if(timer > 120)
				{
					// do reset
					timer = 0;
					Dungeon(FP.world).reset();
					FP.world.add(player);
					Main.galaxy.play("reset");
				}
			} else
			{
				timer = 0;
			}
		}			
	}
}