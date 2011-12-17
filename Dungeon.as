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
	
		public var current_room:Room;
		public function Dungeon()
		{			
			current_room = new Room();
			unpack(new EmbeddedDungeon() as ByteArray);			
			reset();
		}
		
		public function reset():void
		{
			removeAll();
			current_room.make_live();
			add(current_room);
		}

		public function pack():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			current_room.pack(bytes);
			return bytes;
		}
		
		public function unpack(bytes:ByteArray):void
		{
			current_room.unpack(bytes);
		}
	}
}