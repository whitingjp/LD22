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
			add(current_room);
		}		
	}
}