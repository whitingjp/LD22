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
	
	public class PushBlock extends Entity
	{
		[Embed(source="gfx/push_block.png")]
		public static const BlockGfx: Class;	
		
		public var stamp:Stamp;
		
		public function PushBlock():void
		{
			stamp = new Stamp(BlockGfx);
			stamp.x -= 8;
			stamp.y -= 8+8;
			graphic = stamp;
			setHitbox(16,16,8,8);
			layer = -10;
			type = "push";
		}
		
		public override function update():void
		{
			var push:int = -1;
			if(collide("push", x, y+1)) push = 0;
			if(collide("push", x-1, y)) push = 1;
			if(collide("push", x, y-1)) push = 2;
			if(collide("push", x+1, y)) push = 3;
			
			switch(push)
			{
				case 0:
					y -= 1;
					break;
				case 1:
					x += 1;
					break;
				case 2:
					y += 1;
					break;
				case 3:
					x -= 1;
					break;
			}
		}
	}
}