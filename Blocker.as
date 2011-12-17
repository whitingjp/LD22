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
	
	public class Blocker extends Entity
	{
		[Embed(source="gfx/blocker.png")]
		public static const BlockerGfx:Class;
		
		public var sprite:Spritemap;
		
		public function Blocker():void
		{
			sprite = new Spritemap(BlockerGfx, 16, 24);
			sprite.x -= 8;
			sprite.y -= 16;
			graphic = sprite;
			setHitbox(14,14,7,7);
		}
		
		public override function update():void
		{
			layer = -y;
			
			var side:int = -1;
			if(y<32) side = 0;
			if(x>Main.SCREENW-32) side = 1;
			if(y>Main.SCREENH-32) side = 2;
			if(x<32) side = 3;
			
			var dungeon:Dungeon = Dungeon(FP.world);
			if(dungeon.exits[side])
			{
				sprite.frame = 1;
				type = "";
			} else
			{
				sprite.frame = 0;
				type = "solid";
			}
		}
	}
}