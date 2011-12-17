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
		
		public var dungeon:Dungeon;		
		public var state:int;
		
		public function Main()
		{
			super(SCREENW*3, SCREENH*3, 60, true);
			FP.screen.scale = 3;
			FP.screen.color = 0x30362a;
			state = STATE_GAME;
		}
		
		public function change_state(state:int):void
		{
			this.state = state;
			dungeon.reset();
			
			switch(state)
			{
				case STATE_EDITOR: dungeon.add(new RoomEditor(dungeon.current_room));
			}
		}		
		
		public override function init():void
		{
			FP.width /= FP.screen.scale;
			FP.height /= FP.screen.scale;
			
			dungeon = new Dungeon();
			FP.world = dungeon;						
			
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
		}
	}
}