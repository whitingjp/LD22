
package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;

	[SWF(width = "528", height = "528", backgroundColor="#30362a")]
	public class Preloader extends Sprite
	{
	
		private var progressBar: Shape;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;		
	
		public function Preloader ()
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.7;
			h = 32;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;		
					
			graphics.beginFill(0x30362a);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			progressBar = new Shape();
			addChild(progressBar);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded()) startup();
			
			var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
				
			progressBar.graphics.clear();
			progressBar.graphics.beginFill(0xc1f6bb);
			progressBar.graphics.drawRect(px, py, p * w, h);
			progressBar.graphics.endFill();			
		}
				
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}		
	}
}	
