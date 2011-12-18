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
		public static const WIDTH:int = 11;
		public static const HEIGHT:int = 11;
		
		public static const FLOOR:int = 0;
		public static const WALL:int = 1;
		public static const PUSHBLOCK:int = 2;
		public static const TRACK:int = 3;
		public static const PLAYER:int = 4;		
		public static const BLOCKER:int = 5;
		public static const ORB_OFF:int = 6;
		public static const ORB_ON:int = 7;
		public static const ORB_GOAL:int = 8;
		public static const OTHER:int = 9;
		
		[Embed(source="gfx/editor_tile.png")]
		public static const EditorTileGfx: Class;		
		
		[Embed(source="gfx/static_tile.png")]
		public static const StaticTileGfx: Class;				
		
		[Embed(source="gfx/static_tile_overworld.png")]
		public static const StaticTileOverworldGfx: Class;		

		public var level_data:Tilemap;
		public var include_world_blocks:Boolean=false;		
		
		public var static_rows:Array;
		public var wall_grid:Grid;
		public var floor_grid:Grid;
		
		public var valid_exits:int;
	
		public function Room(bytes:ByteArray=null)
		{			
			level_data = new Tilemap(EditorTileGfx, WIDTH*TILEW, HEIGHT*TILEH, TILEW, TILEH);			
			if(bytes) unpack(bytes);
			make_live();
		}
		
		public function calculate_valid_exits():void
		{
			valid_exits = 0;
			var i:int;
			
			for(i=0; i<level_data.columns; i++)
				if(level_data.getTile(i, 0) == FLOOR)
				  valid_exits |= 1;
			for(i=0; i<level_data.rows; i++)
				if(level_data.getTile(WIDTH-1, i) == FLOOR)
				  valid_exits |= 2;
			for(i=0; i<level_data.columns; i++)
				if(level_data.getTile(i, HEIGHT-1) == FLOOR)
				  valid_exits |= 4;
			for(i=0; i<level_data.rows; i++)
				if(level_data.getTile(0, i) == FLOOR)
				  valid_exits |= 8;					
		}
		
		public function reprocess(editing:Boolean):void
		{
			calculate_valid_exits();
			
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
								if(FP.world.typeFirst("player"))
									static_rows[j].setTile(i, j, FLOOR);
								else
									e = new Player();								
								break;
							case PUSHBLOCK:
								e = new PushBlock();
								onTrack = true;								
								break;
							case BLOCKER:
								e = new Blocker();
								break;
							case ORB_OFF:
								e = new Orb(false);
								break;
							case ORB_ON:
								e = new Orb(true);
								break;
							case ORB_GOAL:
								e = new Orb(true, true);
								break;
							case WALL:
								var auto:int = auto_tile(i, j);
								static_rows[j].setTile(i, j, auto);
								break;
							case OTHER:
								e = new Other();
								trace("other");
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
		
		public function auto_tile(i:int, j:int):int
		{
			var flags:int = 0;
			if(level_data.getTile(i,j-1)==WALL || j==0) flags |= 1;
			if(level_data.getTile(i+1,j)==WALL || i==WIDTH-1) flags |= 2;
			if(level_data.getTile(i,j+1)==WALL || j==HEIGHT-1) flags |= 4;
			if(level_data.getTile(i-1,j)==WALL || i==0) flags |= 8;
			return flags_to_frame(flags)+4;
		}
		
		public static function flags_to_frame(flags:int):int
		{
			switch(flags)
			{
				case  0: return 15; break;
				case  1: return 11; break;
				case  2: return 12; break;
				case  3: return  8; break;
				case  4: return  3; break;
				case  5: return  7; break;
				case  6: return  0; break;
				case  7: return  4; break;
				case  8: return 14; break;
				case  9: return 10; break;
				case 10: return 13; break;
				case 11: return  9; break;
				case 12: return  2; break;
				case 13: return  6; break;
				case 14: return  1; break;
				case 15: return  5; break;
			}		
			return 0;
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
		
		public function has_tile(tile:int):Boolean
		{
			for(var j:int = 0; j<level_data.rows; j++)
				for(var i:int = 0; i<level_data.columns; i++)
					if(level_data.getTile(i, j) == tile) return true;
			return false;
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
				var c:Class = StaticTileGfx;
				if(editing) c = EditorTileGfx;
				else if(Main.galaxy.overworld) c = StaticTileOverworldGfx;
				static_rows[j] = new Tilemap(c, WIDTH*TILEW, 24, TILEW, 24);
				static_rows[j].y = j*16-(editing ? 0 : 8);
				FP.world.addGraphic(static_rows[j], -static_rows[j].y-7);
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