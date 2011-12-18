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
		public var anim_timer:int;
		
		public var decided_can_move:Boolean;
		public var can_move:Boolean = false;
		
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
			
			decided_can_move = false;
		}
		
		public function update_wait():void
		{
			if(!can_move) return;
			
			var push:int = -1;			
			if(collide("player", x, y+1)) push = 0;
			if(collide("player", x-1, y)) push = 1;
			if(collide("player", x, y-1)) push = 2;
			if(collide("player", x+1, y)) push = 3;
			
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
		
		public function update_overlay():void
		{
			var dungeon:Dungeon = Dungeon(FP.world);
			var exits:int = dungeon.sub_rooms[room_key].valid_exits;
			var frame:int = Room.flags_to_frame(exits);
			if(!can_move) frame += 16;
			overlay.frame = frame;
			
			anim_timer = (anim_timer+1)%128;
			if(dungeon.sub_rooms[room_key] == dungeon.current_room && anim_timer < 40)
				overlay.alpha = anim_timer/40.0;
			else 
				overlay.alpha = 1;
		}
		
		public function update_canmove():void
		{
			if(!decided_can_move)
			{
				if(!room_key) can_move = true;
				else
				{
					var room:Room = Dungeon(FP.world).sub_rooms[room_key];
					can_move = !room.has_tile(Room.ORB_OFF);
				}
				decided_can_move = true;
			}
		
			var dungeon:Dungeon = Dungeon(FP.world);
			if(dungeon.current_room == dungeon.sub_rooms[room_key])
			{
				var off_orb:Orb = Orb(dungeon.typeFirst("orb_off"));
				var on_orb:Orb = Orb(dungeon.typeFirst("orb_on"));
				var source_orb:Orb = Orb(dungeon.typeFirst("orb_source"));
				if(can_move && off_orb)
					off_orb.on = true;
				else if(!off_orb && (on_orb || source_orb))
					can_move = true;
			}
		}
		
		public override function update():void
		{
			layer = -y;
			if(push_timer) update_push();
			else update_wait();
			
			if(room_key) update_overlay();
			else overlay.alpha = 0;
			
			update_canmove();
		}
	}
}