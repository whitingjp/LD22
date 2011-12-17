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
		public static const SCREENW:int = 272;
		public static const SCREENH:int = 208;
		
		public static const STATE_GAME:int = 0;
		public static const STATE_EDITOR:int = 1;
		public static const STATE_PRE:int = 2;
		
		public static const FINAL:Boolean = false;
		
		public static const so:SharedObject = SharedObject.getLocal("LD22", "/");
		
		public var dungeon:Dungeon;		
		public static var st:int;
		
		public function Main()
		{
			super(SCREENW*3, SCREENH*3, 60, true);
			FP.screen.scale = 3;
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
			if(!FINAL && so.data.dungeon)
				dungeon.unpack(so.data.dungeon);			
		}
		
		public override function update():void
		{			
			super.update();
			if(st == STATE_PRE) change_state(STATE_GAME);
			trace("count: "+FP.world.count);
			if(!FINAL && Input.pressed(Key.E))
			{
				if(st == STATE_GAME) change_state(STATE_EDITOR);
				else change_state(STATE_GAME);
			}
			
			if(st == STATE_EDITOR)
			{
				if(Input.pressed(Key.S)) save();
				if(Input.pressed(Key.L)) load();
			}
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