package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import net.flashpunk.utils.*;
	import net.flashpunk.tweens.misc.*;
	import net.flashpunk.*;
	
	public class Audio
	{
		[Embed(source="audio/overworld.mp3")]
		public static var OverworldSfx:Class;
		
		[Embed(source="audio/underworld.mp3")]
		public static var UnderworldSfx:Class;
		
		private static var sounds:Object = {};
		
		public var fade:Number;
		public static var volTween:VarTween = new VarTween;
		public static var volTween2:VarTween = new VarTween;
		
		public var overworld:Boolean=true;
		public var has_won:Boolean=false;

		public function init():void
		{
			sounds["overworld"] = new Sfx(OverworldSfx);
			sounds["underworld"] = new Sfx(UnderworldSfx);
			sounds["overworld"].loop(0);
			sounds["underworld"].loop(0);
			FP.tweener.addTween(volTween);
			FP.tweener.addTween(volTween2);
			volTween.tween(sounds["overworld"], "volume", 1, 600);
			fade = 0;
		}
		
		public function update():void
		{
			var target:Boolean = Main.galaxy.overworld;
			if(target != overworld)
			{
				overworld = target;
				volTween.tween(sounds["overworld"], "volume", Number(overworld), 50);
				volTween2.tween(sounds["underworld"], "volume", Number(!overworld), 50);
			}
			target = Main.galaxy.has_won;
			if(target != has_won)
			{
				has_won = target;
				volTween.tween(sounds["overworld"], "volume", 0, 600);
				volTween2.tween(sounds["underworld"], "volume", 0, 600);				
			}
		}
	}
}