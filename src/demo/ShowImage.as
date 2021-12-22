package demo {
	import framework.Game;
	import framework.objs.GameObject;
	import framework.utils.LibUtil;
	import framework.events.FrameworkEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	

	public class ShowImage extends GameObject{
		public function ShowImage(){
			super();
		}
		
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new ShowImage());
		}
		
		override protected function init(info:*=null):void{
			var sp:Sprite = new Sprite();
			_game.global.main.addChild(sp);
			var mc:MovieClip = LibUtil.getDefMovie("Mc");
			sp.addChild(mc);
			super.init(info);
		}
	};
}