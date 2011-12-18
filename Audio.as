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
		private static var sfxrs:Object = {};
		
		public var fade:Number;
		public static var volTween:VarTween = new VarTween;
		public static var volTween2:VarTween = new VarTween;
		
		public var overworld:Boolean=true;
		public var has_won:Boolean=false;
		public var mute:Boolean=false;
		
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
			
			addSynth("push", "3,,0.08,,0.35,0.2,,-0.5,,,,,,,,,,,0.6,0.3799,,,,0.5");
			addSynth("touchorb", "0,,0.06,,0.3408,0.21,,0.24,,,,,,0.2512,,0.64,,,1,,,,,1.0");
			addSynth("switchworld", "3,,0.28,0.44,0.21,0.18,,-0.3825,,,,,,,,,-0.2638,-0.1954,1,,,,,1");
			addSynth("goalorb", "2,,0.3,,0.2769,0.4363,,0.24,-0.5,,,,,0.4434,,0.5799,,,1,,,,,1");
			addSynth("movedself", "3,,0.5,0.7399,0.3016,0.0484,,-0.3658,,,,-0.6613,0.6463,,,,,,1,,,,,1");
		}
		
		private function addSynth(name:String, settings:String):void
		{
			var synth:SfxrSynth = new SfxrSynth();
			synth.setSettingsString(settings);
			sfxrs[name] = synth;
		}		
		
		public function play(sound:String):void
		{
			if(!mute)
				sfxrs[sound].playCached();
		}
		
		public function update():void
		{
			if(mute) return;
			var target:Boolean = Main.galaxy.overworld;
			if(target != overworld)
			{
				overworld = target;
				volTween.tween(sounds["overworld"], "volume", Number(overworld)/2, 50);
				volTween2.tween(sounds["underworld"], "volume", Number(!overworld)/2, 50);
			}
			target = Main.galaxy.has_won;
			if(target != has_won)
			{
				has_won = target;
				volTween.tween(sounds["overworld"], "volume", 0, 600);
				volTween2.tween(sounds["underworld"], "volume", 0, 600);				
			}
		}
		
		public function toggle_mute():void
		{
			mute = !mute;
			if(mute)
			{
				volTween.tween(sounds["overworld"], "volume", 0, 25);
				volTween2.tween(sounds["underworld"], "volume", 0, 25);
			} else
			{
				volTween.tween(sounds["overworld"], "volume", Number(overworld)/2, 50);
				volTween2.tween(sounds["underworld"], "volume", Number(!overworld)/2, 50);				
			}
		}
	}
}