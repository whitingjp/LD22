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
		public static const MOVEABLE:int = 2;
		public static const PLAYER:int = 3;
		
		[Embed(source="gfx/editor_tile.png")]
		public static const EditorTileGfx: Class;		
		
		[Embed(source="gfx/static_tile.png")]
		public static const StaticTileGfx: Class;				
		
		public var level_data:Tilemap;
		public var static_rows:Array;
		public var wall_grid:Grid;
		
		public function Room()
		{
			level_data = new Tilemap(EditorTileGfx, WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);
			wall_grid = new Grid(WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);
			make_live();
		}
		
		public function reprocess():void
		{
			var editing:Boolean = Main.state == Main.STATE_EDITOR;
			for(var j:int = 0; j<level_data.rows; j++)
			{				
				for(var i:int = 0; i<level_data.columns; i++)
				{
					var tile:int = level_data.getTile(i, j);
					if(editing)
					{
						static_rows[j].setTile(i, j, tile);
						continue;
					}	
					var e:Entity = null;
					switch(tile)
					{
						case PLAYER:
							e = new Player();
							break;
						default:
							static_rows[j].setTile(i, j, tile);
							break;
					}
					if(e)
					{
						e.x = i*TILEW;
						e.y = i*TILEH;
						FP.world.add(e);
					}
				}
			}
		}
		
		public function make_live():void
		{
			static_rows = new Array();
			for(var j:int = 0; j<level_data.rows; j++)
			{				
				static_rows[j] = new Tilemap(StaticTileGfx, WIDTH*TILEW, 24, TILEW, 24);
				static_rows[j].y = j*16-8;
				addGraphic(static_rows[j]);
			}		
			reprocess();
			level_data.createGrid([WALL], wall_grid);
			FP.world.addMask(wall_grid, "solid");			
		}
		
		public function make_dead():void
		{
			static_rows = null;
		}
		
		public function pack(bytes:ByteArray):void
		{
			var str:String = level_data.saveToString();
			bytes.writeUTF(str);
		}
		
		public function unpack(bytes:ByteArray):void
		{
			var str:String = bytes.readUTF();
			level_data.loadFromString(str);
		}
	}	
}