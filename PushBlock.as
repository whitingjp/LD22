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
	}
}