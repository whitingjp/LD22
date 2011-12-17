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
	
	public class RoomEditor extends Entity
	{
		public var room:Room;
		public var editTile:int;
			
		public function RoomEditor(room:Room)
		{
			this.room = room;
			editTile = 0;
		}
		
		public override function update():void
		{
			var i:int;
			for(i=0; i<10; i++)
				if(Input.pressed(Key.DIGIT_1 + i))
					editTile = i;
					
			var mx:int = Input.mouseX / Room.TILEW;
			var my:int = Input.mouseY / Room.TILEW;
			if(Input.mouseDown)
			{
				room.level_data.setTile(mx, my, editTile);
				room.reprocess();
			}
		}
	}
}