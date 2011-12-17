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
	
		public function init():void
		{			
			master_room = new Room();
			sub_rooms = new Object();			
			current_room = master_room;			
			unpack(new EmbeddedDungeon() as ByteArray);			
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
		
		public function find_exits():Array
		{
			var i:int;
			var ret:Array = new Array;
			for(i=0; i<4; i++) ret[i] = null;
		
			// first find this rooms block
			var block:PushBlock;
			for(i=0; i<room_blocks.length; i++)
			{
				var r:Room = null;
				var b:PushBlock = room_blocks[i];
				if(b) r = sub_rooms[b.room_key];
				if(r == current_room)
					block = b;
			}
			
			if(block)
			{
				// now find possible exits
				
				for(i=0; i<4; i++)
				{
					var offx:int = 0;
					var offy:int = 0;
					switch(i)
					{
						case 0: offy = -16; break;
						case 1: offx =  16; break;
						case 2: offy =  16; break;
						case 3: offx = -16; break;
					}
					var col:Entity = collidePoint("push", block.x+offx, block.y+offy);
					if(col && col is PushBlock)
						ret[i] = PushBlock(col).room_key;
				}
			}
			return ret;
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
					bytes.writeUTF("key");
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