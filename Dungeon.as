package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	public class Dungeon extends World
	{
		public var current_room:Room;
		public function Dungeon()
		{
			current_room = new Room();			
			reset();
		}
		
		public function reset():void
		{
			removeAll();
			current_room.make_live();
			add(current_room);
		}
	}
}