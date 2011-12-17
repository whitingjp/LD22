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
		
		[Embed(source="gfx/highlight.png")]
		public static const HighlightGfx: Class;

		public var highlight:BitmapData;
			
		public function RoomEditor(room:Room)
		{
			this.room = room;
			editTile = 0;
			layer = -1000;
			highlight = FP.getBitmap(HighlightGfx); 
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
				room.reprocess(true);
			}
		}
		
		public override function render():void
		{			
			var dungeon:Dungeon = Dungeon(FP.world);
			if(dungeon.current_room != dungeon.master_room) return;
			for(var i:int=0; i<Room.WIDTH; i++)
			{
				for(var j:int=0; j<Room.HEIGHT; j++)
				{
					if(dungeon.get_sub_room(i, j))
						FP.buffer.copyPixels(highlight, highlight.rect, new Point(i*16, j*16));
				}
			}
		}
	}
}