package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	import flash.utils.*;
	public class Dungeon extends World
	{
		public var master_room:Room;
		public var sub_rooms:Object;
		public var current_room:Room;
		public var current_room_key:String;
		public var room_blocks:Array;
		public var exits:Array;
		public var room_timer:int;
		public var overworld:Boolean=false;
	
		public function init(bytes:ByteArray=null):void
		{			
			master_room = new Room();
			sub_rooms = new Object();			
			current_room = master_room;
			if(bytes) unpack(bytes);
			exits = new Array;
			reset();
		}
		
		public function room_reset():void
		{
			room_timer = 0;
			removeAll();
			update();
			current_room.make_live();
			add(current_room);			
		}
		
		public function reset():void
		{
			room_blocks = master_room.get_pushblock_array();
			if(current_room == master_room && Main.st == Main.STATE_GAME)
				enter_room(find_start_room());
			room_reset();
		}
		
		public function find_start_room():String
		{
			for(var key:String in sub_rooms)
			{
				var room:Room = sub_rooms[key];
				for(var j:int = 0; j<room.level_data.rows; j++)
				{				
					for(var i:int = 0; i<room.level_data.columns; i++)
					{
						if(room.level_data.getTile(i,j) == Room.PLAYER)
							return key;
					}
				}
			}
			return "";
		}
		
		public static function key(x:int, y:int):String
		{
			return "x:"+x+"y:"+y;
		}
		
		public function cut_sub_room(key:String):Room
		{
			var room:Room = sub_rooms[key];
			sub_rooms[key] = null;
			return room;
		}
		
		public function set_sub_room(key:String, room:Room):void
		{
			sub_rooms[key] = room;
		}		
		
		public function enter_room(key:String):void
		{
			trace("key:"+key);
			if(!sub_rooms[key])
				sub_rooms[key] = new Room();
			current_room = sub_rooms[key]	
			current_room_key = key;
		}
		
		public function exit_room():void
		{
			current_room = master_room;
		}
		
		public function find_exits():void
		{
			var i:int;
			for(i=0; i<4; i++) exits[i] = null;
		
			// first find this rooms block
			var block:PushBlock;
			for(i=0; i<room_blocks.length; i++)
			{
				var r:Room = null;
				var b:PushBlock = room_blocks[i];
				if(b) r = sub_rooms[b.room_key];
				if(r == current_room)
				{
					block = b;
				}
			}
			
			if(block)
			{
				// now find possible exits
				
				for(i=0; i<4; i++)
				{
					var ax:int = block.x/16;
					var ay:int = block.y/16;
					switch(i)
					{
						case 0: ay -= 1; break;
						case 1: ax += 1; break;
						case 2: ay += 1; break;
						case 3: ax -= 1; break;
					}
					for(var j:int=0; j<room_blocks.length; j++)
					{
						var bx:int = room_blocks[j].x/16;
						var by:int = room_blocks[j].y/16;
						if(ax == bx && ay == by)
						{
							var check_key:String = room_blocks[j].room_key;
							var check_flag:int = 1<<(i+2)%4;
							var check_room:Room = sub_rooms[check_key];
							if(check_room && check_room.valid_exits & check_flag)
							{
								exits[i] = check_key;
							}
						}
					}
				}
			}
		}		

		public override function update():void
		{
			room_timer++;
			super.update();
			find_exits();
			
			if(Main.st == Main.STATE_GAME && !current_room.include_world_blocks)
			{
				for(var i:int=0; i<room_blocks.length; i++)
					if(room_blocks[i].room_key == current_room_key)
						room_blocks[i].update_canmove();
			}
		}		
		
		public function pack():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			master_room.pack(bytes);
			var num_sub_rooms:int = 0;
			var key:String
			for(key in sub_rooms)
				if(sub_rooms[key])
					num_sub_rooms++;
			bytes.writeInt(num_sub_rooms);
			for(key in sub_rooms)
			{
				if(sub_rooms[key])
				{
					bytes.writeUTF(key);
					sub_rooms[key].pack(bytes);
				}
			}
			return bytes;
		}
		
		public function unpack(bytes:ByteArray):void
		{
			master_room.unpack(bytes);
			sub_rooms = new Object();
			var num_sub_rooms:int = bytes.readInt();
			for(var i:int=0; i<num_sub_rooms; i++)
			{
				var key:String = bytes.readUTF();
				sub_rooms[key] = new Room(bytes);
			}
		}
	}
}