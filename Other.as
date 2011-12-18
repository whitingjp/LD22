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
	
	public class Other extends Entity
	{
		[Embed(source="gfx/other.png")]
		public static const OtherGfx: Class;
		
		public var stamp:Stamp;
		
		public function Other():void
		{
			stamp = new Stamp(OtherGfx);
			stamp.x -= 8;
			stamp.y -= 16;
			setHitbox(16,16,8,8);
			graphic = stamp;
			type = "other";
		}
		
		public override function update():void
		{
			layer = -y-2;
		}			
	}
}