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

		public static const PUSH_TIME:int = 8;
		
		public var vx:int;
		public var vy:int;
		public var stamp:Stamp;
		public var push_timer:int;
		public var room_key:String;
		
		public function PushBlock(room_key:String=null):void
		{
			stamp = new Stamp(BlockGfx);
			stamp.x -= 8;
			stamp.y -= 8+8;
			graphic = stamp;
			setHitbox(14,14,7,7);
			layer = -10;
			type = "push";
			push_timer = 0;
			this.room_key = room_key;
		}
		
		public function update_wait():void
		{
			var push:int = -1;
			if(collide("push", x, y+1)) push = 0;
			if(collide("push", x-1, y)) push = 1;
			if(collide("push", x, y-1)) push = 2;
			if(collide("push", x+1, y)) push = 3;
			
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
				if(collide("push", x+vx*2, y+vy*2)) push_timer = 0;
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