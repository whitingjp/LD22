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
	
	public class Galaxy
	{
		[Embed(source="levels/master.lvl", mimeType="application/octet-stream")]
		public static const MasterDungeon: Class;	
	
		[Embed(source="levels/tutorial.lvl", mimeType="application/octet-stream")]
		public static const TutorialDungeon: Class;
		
		[Embed(source="levels/shuttle.lvl", mimeType="application/octet-stream")]
		public static const ShuttleDungeon: Class;

		[Embed(source="levels/hub.lvl", mimeType="application/octet-stream")]
		public static const HubDungeon: Class;
		
		[Embed(source="levels/orb_tutorial.lvl", mimeType="application/octet-stream")]
		public static const OrbTutorialDungeon: Class;
		
		[Embed(source="levels/timing.lvl", mimeType="application/octet-stream")]
		public static const TimingDungeon: Class;		
	
		public var overworld:Boolean = true;		
		public var dungeon_completion:Object;
		
		public var current_dungeon_key:String="";
		
		public var main:Main;
		
		public var transition:int;
		public var has_won:Boolean=false;
		
		public function Galaxy(main:Main)
		{
			this.main = main;			
		}
		
		public function init():void
		{
			if(Main.so.data.dungeon_completion)
				dungeon_completion = Main.so.data.dungeon_completion;
			else
				dungeon_completion = new Object();
			enter_dungeon("master");
			transition = 0;
		}
		
		public function enter_dungeon(room_key:String):void
		{
			if(transition)
			{
				transition--;
				return;
			}
			transition = 1;
			
			overworld = false;
			var byte_class:Class = null;
			
			if(room_key == "master")
			{
				byte_class = MasterDungeon;
				overworld = true;
			}
			if(room_key == "x:5y:4")
				byte_class = TutorialDungeon;
			if(room_key == "x:7y:5")
				byte_class = ShuttleDungeon;
			if(room_key == "x:3y:4")
				byte_class = HubDungeon;
			if(room_key == "x:6y:6")
				byte_class = OrbTutorialDungeon;
			if(room_key == "x:4y:6")
				byte_class = TimingDungeon;

			if(byte_class != null)
				main.change_dungeon(new byte_class as ByteArray)
		}
		
		public function touched_goal():void
		{
			if(transition)
			{
				transition--;
				return;
			}
			var dungeon:Dungeon = Dungeon(FP.world);
			if(overworld)
			{
				trace("entering sub dungeon: "+dungeon.current_room_key);
				current_dungeon_key = dungeon.current_room_key;
				enter_dungeon(dungeon.current_room_key);
				play("switchworld");
			} else
			{
				trace("returning to overworld: ");
				dungeon_completion[current_dungeon_key] = true;
				Main.so.data.dungeon_completion = dungeon_completion;
				Main.so.flush();
				enter_dungeon("master");
				play("goalorb");
			}
		}
		
		public function play(sound:String):void
		{
			main.audio.play(sound);
		}
	}
}