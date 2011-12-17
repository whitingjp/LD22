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
	
	public class Player extends Entity
	{
		[Embed(source="gfx/player.png")]
		public static const PlayerGfx: Class;	
	
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var sprite:Spritemap;
	
		public function Player():void
		{
			sprite = new Spritemap(PlayerGfx, 16, 24);
			sprite.x = -8;
			sprite.y = -20;
			graphic = sprite;
			setHitbox(4,4,-2,-2);
			layer = -10;
		}
		
		public override function update():void
		{
			vx = int(Input.check(Key.RIGHT))-int(Input.check(Key.LEFT));
			vy = int(Input.check(Key.DOWN))-int(Input.check(Key.UP));
			if(vx && vy)
			{
				vx /= Math.sqrt(2);
				vy /= Math.sqrt(2);
			}
			moveBy(vx, vy, ["solid"]);
		}
	}
}