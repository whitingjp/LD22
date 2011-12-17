package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	import flash.utils.*;
	public class Dungeon extends World
	{
		[Embed(source="levels/level.lvl", mimeType="application/octet-stream")]
		public static const EmbeddedDungeon: Class;		
	
		public var master_room:Room;
		public var sub_rooms:Object;
		public var current_room:Room;
		public var room_blocks:Array;
		public var exits:Array;		
	
		public function init():void
		{			
			master_room = new Room();
			sub_rooms = new Object();			
			current_room = master_room;			
			unpack(new EmbeddedDungeon() as ByteArray);	
			exits = new Array;
			reset();
		}
		
		public function room_reset():void
		{
			removeAll();
			update();
			current_room.make_live();
			add(current_room);			
		}
		
		public function reset():void
		{
			room_blocks = master_room.get_pushblock_array();
			trace("room blocks:"+room_blocks.length);
			room_reset();
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
			if(!sub_rooms[key])
				sub_rooms[key] = new Room();
			current_room = sub_rooms[key]			
		}
		
		public function exit_room():void
		{
			current_room = master_room;
		}
		
		public function find_exits():void
		{
			trace("find_exits()");
			var i:int;
			for(i=0; i<4; i++) exits[i] = null;
		
			// first find this rooms block
			var block:PushBlock;
			for(i=0; i<room_blocks.length; i++)
			{
				var r:Room = null;
				var b:PushBlock = room_blocks[i];
				if(b) trace("test_block:"+b.room_key);
				if(b) r = sub_rooms[b.room_key];
				if(r == current_room)
				{
					block = b;
					trace("found_block:"+b.room_key);
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
							exits[i] = room_blocks[j].room_key;
							trace("found_exit: "+i+":"+exits[i]);
						}
					}
				}
			}
		}		

		public override function update():void
		{
			super.update();
			find_exits();
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