package app{
	import flash.display.MovieClip;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import g.MyData;
	import g.objs.StandardObject;
	import framework.objs.Clip;
	import Box2D.Dynamics.b2Body;

	public class Exit extends StandardObject{
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			info.view=Clip.fromDefName("Exit_view",true);
			info.viewParent=game.global.layerMan.items2Layer;
			game.createGameObj(new Exit(),info);
		}
		
		override protected function init(info:* = null):void{
			super.init(info);
			
			_body.SetType(b2Body.b2_staticBody);
			_body.SetSensor(true);
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
		}
		

		
	}
}