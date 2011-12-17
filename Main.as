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
		
		public static const FINAL:Boolean = false;
		
		public static const so:SharedObject = SharedObject.getLocal("LD22", "/");
		
		public var dungeon:Dungeon;		
		public static var state:int;
		
		public function Main()
		{
			super(SCREENW*3, SCREENH*3, 60, true);
			FP.screen.scale = 3;
			FP.screen.color = 0x30362a;
		}
		
		public function change_state(_state:int):void
		{
			state = _state;
			dungeon.reset();
			
			switch(state)
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
			FP.width /= FP.screen.scale;
			FP.height /= FP.screen.scale;
			
			dungeon = new Dungeon();
			if(!FINAL && so.data.dungeon)
				dungeon.unpack(so.data.dungeon);
			FP.world = dungeon;
			
			change_state(STATE_GAME);
			
			super.init();
		}
		
		public override function update():void
		{
			super.update();
			if(!FINAL && Input.pressed(Key.E))
			{
				if(state == STATE_GAME) change_state(STATE_EDITOR);
				else change_state(STATE_GAME);
			}
			
			if(state == STATE_EDITOR)
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
				change_state(state);
			}
		}		
	}
}