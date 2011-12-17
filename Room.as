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
	
	public class Room extends Entity
	{
		public static const TILEW:int = 16;
		public static const TILEH:int = 16;
		public static const WIDTH:int = 17;
		public static const HEIGHT:int = 13;
		
		public static const FLOOR:int = 0;
		public static const WALL:int = 1;
		
		[Embed(source="gfx/editor_tile.png")]
		public static const EditorTileGfx: Class;		
		
		[Embed(source="gfx/static_tile.png")]
		public static const StaticTileGfx: Class;				
		
		public var level_data:Tilemap;
		public var static_rows:Array;
		
		public function Room()
		{
			level_data = new Tilemap(EditorTileGfx, WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);
			level_data.setTile(0,0,1);
			level_data.setTile(0,1,1);
			make_live();
		}
		
		public function make_live():void
		{
			static_rows = new Array();			
			for(var j:int = 0; j<level_data.rows; j++)
			{
				static_rows[j] = new Tilemap(StaticTileGfx, WIDTH*TILEW, 24, TILEW, 24);
				static_rows[j].y = j*16-8;
				addGraphic(static_rows[j]);
				for(var i:int = 0; i<level_data.columns; i++)
				{
					var tile:uint = level_data.getTile(i, j);
					switch(tile)
					{
						default:
							static_rows[j].setTile(i, j, tile);
							break;
					}					
				}
			}		
		}
	}	
}