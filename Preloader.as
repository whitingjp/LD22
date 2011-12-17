
package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;

	[SWF(width = "816", height = "624", backgroundColor="#30362a")]
	public class Preloader extends Sprite
	{
		public function Preloader ()
		{
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded()) startup();
		}
				
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}		
	}
}	
