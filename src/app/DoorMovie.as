package app{
	import g.objs.SwitchCtrlObj;
	import flash.display.MovieClip;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import g.MyData;

	public class DoorMovie extends SwitchCtrlObj{
		
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			game.createGameObj(new DoorMovie(),info);
		}
		
		override protected function init(info:*=null):void{
			super.init(info);
		}
	}
}