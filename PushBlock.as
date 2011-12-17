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
		
		[Embed(source="gfx/push_block_overlay.png")]
		public static const BlockOverlayGfx: Class;

		public static const PUSH_TIME:int = 8;
		
		public var vx:int;
		public var vy:int;
		public var stamp:Stamp;
		public var overlay:Spritemap;
		public var push_timer:int;
		public var room_key:String;
		
		public function PushBlock(room_key:String=null):void
		{
			stamp = new Stamp(BlockGfx);
			stamp.x -= 8;
			stamp.y -= 8+8;
			addGraphic(stamp);
			
			overlay = new Spritemap(BlockOverlayGfx, 16, 16);
			overlay.frame = 1;
			overlay.x -= 8;
			overlay.y -= 8+5;
			addGraphic(overlay);
			
			setHitbox(14,14,7,7);
			layer = -10;
			type = "push";
			push_timer = 0;
			this.room_key = room_key;
		}
		
		public function update_wait():void
		{
			var push:int = -1;			
			if(collide("player", x, y+1)) push = 0;
			if(collide("player", x-1, y)) push = 1;
			if(collide("player", x, y-1)) push = 2;
			if(collide("player", x+1, y)) push = 3;
			trace("push:"+push);
			
			if(push != -1)
			{
				push_timer = PUSH_TIME;
				vx = 0;
				vy = 0;
				switch(push)
				{
					case 0:
						vy = -2;
						break;
					case 1:
						vx = 2;
						break;
					case 2:
						vy = 2;
						break;
					case 3:
						vx = -2;
						break;
				}
				var e:Entity = collide("push", x+vx*2, y+vy*2);
				if(e && e != this) push_timer = 0;
				if(collide("solid", x+vx*2, y+vy*2)) push_timer = 0;
				if(collide("floor", x+vx*2, y+vy*2)) push_timer = 0;
			}			
		}
		
		public function update_push():void
		{
			push_timer--;
			moveBy(vx, vy, ["solid", "floor"]);
		}
		
		public override function update():void
		{
			layer = -y;
			if(push_timer) update_push();
			else update_wait();
		}
	}
}