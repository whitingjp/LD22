package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class Main extends Engine
	{
		public static const SCREENW:int = 176;
		public static const SCREENH:int = 176;
		
		public static const STATE_GAME:int = 0;
		public static const STATE_EDITOR:int = 1;
		public static const STATE_PRE:int = 2;
		
		public static const FINAL:Boolean = false;
		
		public static const so:SharedObject = SharedObject.getLocal("LD22", "/");
		
		public var dungeon:Dungeon;
		public static var st:int;
		
		public var cut_room:Room=null;
		
		public function Main()
		{
			super(SCREENW*4, SCREENH*4, 60, true);
			FP.screen.scale = 4;
			FP.screen.color = 0x30362a;
			st = STATE_PRE;
		}
		
		public function change_state(_state:int):void
		{			
			st = _state;		
			trace("change_state:"+st);
			dungeon.reset();
			
			switch(st)
			{
				case STATE_EDITOR: dungeon.add(new RoomEditor(dungeon.current_room));
				case STATE_GAME:
					if(!FINAL)
					{
						so.data.dungeon = dungeon.pack();
						so.flush();
					}
					break;
			}			
		}		
		
		public override function init():void
		{
			super.init();
			
			FP.width /= FP.screen.scale;
			FP.height /= FP.screen.scale;
			
			dungeon = new Dungeon();
			FP.world = dungeon;
			dungeon.init();			
			if(!FINAL)
			{
				//if(so.data.dungeon) dungeon.unpack(so.data.dungeon);
				FP.console.enable();
				FP.console.toggleKey = Key.Q;
			}			
		}
		
		public override function update():void
		{			
			super.update();
			if(st == STATE_PRE) change_state(STATE_GAME);
			if(!FINAL && Input.pressed(Key.E))
			{
				if(st == STATE_GAME) change_state(STATE_EDITOR);
				else change_state(STATE_GAME);
			}
			
			if(st == STATE_EDITOR)
			{
				if(Input.pressed(Key.S)) save();
				if(Input.pressed(Key.L)) load();
				if(Input.pressed(Key.SPACE)) toggle_master();
				if(Input.check(Key.SHIFT) && Input.pressed(Key.X)) cut_sub_room();
				if(Input.check(Key.SHIFT) && Input.pressed(Key.V)) paste_sub_room();
				if(Input.check(Key.SHIFT) && Input.pressed(Key.ESCAPE))
				{
					dungeon = new Dungeon();
					FP.world = dungeon;					
					dungeon.init(true);
				}
			}
		}
		
		public function cut_sub_room():void
		{
			var mx:int = Input.mouseX / Room.TILEW;
			var my:int = Input.mouseY / Room.TILEW;
			cut_room = dungeon.cut_sub_room(Dungeon.key(mx, my));
		}
		
		public function paste_sub_room():void
		{
			var mx:int = Input.mouseX / Room.TILEW;
			var my:int = Input.mouseY / Room.TILEW;
			dungeon.set_sub_room(Dungeon.key(mx, my), cut_room);
		}		
		
		public function toggle_master():void
		{
			if(dungeon.current_room == dungeon.master_room)
			{
				var mx:int = Input.mouseX / Room.TILEW;
				var my:int = Input.mouseY / Room.TILEW;
				dungeon.enter_room(Dungeon.key(mx, my));
			} else
			{
				dungeon.exit_room();
			}
			change_state(STATE_EDITOR);
		}
		
		public function save():void
		{
			new FileReference().save(dungeon.pack());			
		}
		
		public function load():void
		{
			var file:FileReference = new FileReference();
			file.addEventListener(Event.SELECT, fileSelect);
			file.browse();
			
			function fileSelect(event:Event):void
			{
				file.addEventListener(Event.COMPLETE, loadComplete);
				file.load();
			}
			
			function loadComplete(event:Event):void
			{
				dungeon.unpack(file.data);
				change_state(st);
			}
		}		
	}
}