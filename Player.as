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
	
	public class Player extends Entity
	{
		[Embed(source="gfx/player.png")]
		public static const PlayerGfx: Class;	
		
		public static const ORB_TIMEOUT:int = 700;
	
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var sprite:Spritemap;
		public var frame:int = 0;
		public var dir:int = 0;
		public var orb_timer:int = 0;
	
		public function Player():void
		{
			sprite = new Spritemap(PlayerGfx, 16, 24);
			sprite.x = -8;
			sprite.y = -18;
			graphic = sprite;
			setHitbox(4,4,2,2);
			type = "player";
		}
		
		public function check_exiting():void
		{
			var dungeon:Dungeon = Dungeon(FP.world);
			for(var i:int = 0; i<4; i++)
			{
				var check:Boolean = false;
				switch(i)
				{
					case 0: check = y < 0; break;
					case 1: check = x > Main.SCREENW; break;
					case 2: check = y > Main.SCREENH; break;
					case 3: check = x < 0; break;
				}
				if(check && dungeon.exits[i])
				{
					switch(i)
					{
						case 0: this.y += Main.SCREENH; break;
						case 1: this.x -= Main.SCREENW; break;
						case 2: this.y -= Main.SCREENH; break;
						case 3: this.x += Main.SCREENW; break;
					}									
					dungeon.enter_room(dungeon.exits[i]);
					dungeon.room_reset();
					dungeon.add(this);				
				}
			}
		}
		
		public override function update():void
		{
			layer = -y;
			
			if(Main.galaxy.has_won) return;
			
			if(Input.pressed(Key.UP)) dir = 0;
			if(Input.pressed(Key.RIGHT)) dir = 1;
			if(Input.pressed(Key.DOWN)) dir = 2;
			if(Input.pressed(Key.LEFT)) dir = 3;
			vx = int(Input.check(Key.RIGHT))-int(Input.check(Key.LEFT));
			vy = int(Input.check(Key.DOWN))-int(Input.check(Key.UP));
			if(vx && vy)
			{
				vx /= Math.sqrt(2);
				vy /= Math.sqrt(2);
			}
			
			if(Input.pressed(Key.R)) Main.galaxy.enter_dungeon("master");
			
			if(collide("orb_source", x+vx, y+vy))
				orb_timer = ORB_TIMEOUT;				
			if(orb_timer)
			{
				orb_timer--;
				var e:Entity = collide("orb_off", x+vx, y+vy)
				if(e) Orb(e).on = true;
			}
			
			if(collide("orb_goal", x+vx, y+vy))
				Main.galaxy.touched_goal();
				
			if(!Main.FINAL && Input.pressed(Key.ENTER))
				Main.galaxy.touched_goal();
				
			if(collide("other", x+vx, y+vy))
				Main.galaxy.has_won = true;
			
			moveBy(vx, vy, ["solid","push","orb_on","orb_off","orb_source", "orb_goal", "other"]);
			
			if(vx || vy)
				frame=(frame+1)%24;

			var render_frame:int = frame/12;
			render_frame += dir*2;
			if(orb_timer && orb_timer%12 > 7) render_frame += 8;
			sprite.frame = render_frame;			
			
			check_exiting();
		}
	}
}