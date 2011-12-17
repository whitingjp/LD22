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
		public static const PUSHBLOCK:int = 2;
		public static const TRACK:int = 3;
		public static const PLAYER:int = 4;		
		public static const BLOCKER:int = 5;
		
		[Embed(source="gfx/editor_tile.png")]
		public static const EditorTileGfx: Class;		
		
		[Embed(source="gfx/static_tile.png")]
		public static const StaticTileGfx: Class;				

		public var level_data:Tilemap;
		public var include_world_blocks:Boolean=false;		
		
		public var static_rows:Array;
		public var wall_grid:Grid;
		public var floor_grid:Grid;
	
		public function Room(bytes:ByteArray=null)
		{			
			level_data = new Tilemap(EditorTileGfx, WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);			
			if(bytes) unpack(bytes);
			make_live();
		}
		
		public function reprocess(editing:Boolean):void
		{
			trace("editing:"+editing);
			for(var j:int = 0; j<level_data.rows; j++)
			{				
				for(var i:int = 0; i<level_data.columns; i++)
				{					
					var tile:int = level_data.getTile(i, j);
					if(editing)
					{
						static_rows[j].setTile(i, j, tile);						
					}	else
					{
						var e:Entity = null;
						var onTrack:Boolean = false;
						switch(tile)
						{
							case PLAYER:
								e = new Player();
								break;
							case PUSHBLOCK:
								e = new PushBlock();
								onTrack = true;								
								break;
							case BLOCKER:
								e = new Blocker();
								break;
							default:
								static_rows[j].setTile(i, j, tile);
								break;
						}
						if(e)
						{
							e.x = i*TILEW+8;
							e.y = j*TILEH+8;
							FP.world.add(e);
							trace("adding");
							if(onTrack)
								static_rows[j].setTile(i, j, TRACK);
							else
								static_rows[j].setTile(i, j, FLOOR);
						}
					}
				}
			}
			
			if(FP.world is Dungeon)
			{
				var dungeon:Dungeon = Dungeon(FP.world);
				if(!editing && include_world_blocks)
				{				
					add_pushblock_array(dungeon.room_blocks);
				}
			}
		}
		
		public function get_pushblock_array():Array
		{
			var ret:Array = new Array();
			for(var j:int = 0; j<level_data.rows; j++)
			{				
				for(var i:int = 0; i<level_data.columns; i++)
				{
					var tile:int = level_data.getTile(i, j);
					if(tile == PUSHBLOCK)
					{
						var e:Entity = new PushBlock(Dungeon.key(i, j));
						e.x = i*TILEW+8;
						e.y = j*TILEH+8;
						ret.push(e);
					}
				}
			}
			return ret;
		}
		
		public function add_pushblock_array(array:Array):void
		{
			for(var i:int = 0; i<array.length; i++)
				FP.world.add(array[i]);
		}
		
		public function make_live():void
		{
			var editing:Boolean = Main.st == Main.STATE_EDITOR;
			static_rows = new Array();
			for(var j:int = 0; j<level_data.rows; j++)
			{
				static_rows[j] = new Tilemap(editing ? EditorTileGfx : StaticTileGfx, WIDTH*TILEW, 24, TILEW, 24);
				static_rows[j].y = j*16-(editing ? 0 : 8);
				FP.world.addGraphic(static_rows[j], -static_rows[j].y-6);
			}		
			reprocess(editing);			
			wall_grid = new Grid(WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);
			floor_grid = new Grid(WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);
			level_data.createGrid([WALL], wall_grid);
			level_data.createGrid([FLOOR,PLAYER], floor_grid);
			FP.world.addMask(wall_grid, "solid");
			FP.world.addMask(floor_grid, "floor");
		}
		
		public function make_dead():void
		{
			static_rows = null;
		}
		
		public function pack(bytes:ByteArray):void
		{
			var str:String = level_data.saveToString();
			bytes.writeUTF(str);
			bytes.writeBoolean(include_world_blocks);
		}
		
		public function unpack(bytes:ByteArray):void
		{
			var str:String = bytes.readUTF();
			level_data.loadFromString(str);
			include_world_blocks = bytes.readBoolean();
		}
	}	
}