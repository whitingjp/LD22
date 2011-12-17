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
		public const SCREENW:int = 272;
		public const SCREENH:int = 208;
		public function Main()
		{
			super(SCREENW*3, SCREENH*3, 60, true);
			FP.screen.scale = 3;
			FP.screen.color = 0x30362a;
		}
		
		public override function init():void
		{
			FP.width /= FP.screen.scale;
			FP.height /= FP.screen.scale;
			
			FP.world = new Dungeon();
			
			super.init();
		}
	}
}