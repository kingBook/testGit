package demo{
	import Box2D.Dynamics.b2Body;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import g.Map;
	import g.MyData;
	import g.MyObj;
	import g.fixtures.Switcher;

	/**
	 * ...
	 * @author kingBook
	 * 2016/4/19 14:05
	 */
	public class MapScorllTest extends MyObj{
		
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new MapScorllTest());
		}
		
		private var _body:b2Body;
		public function MapScorllTest(){
			super();
		}
		
		override protected function init(info:* = null):void{
			_body=Box2dUtil.createRoundBox(40,60,400,450,_game.global.curWorld,MyData.ptm_ratio,5,10);
			
			var map:Map=_game.getGameObjList(Map)[0] as Map;
			map.camera.bindTargets([_body],true);
			
			_body.SetUserData({type:"mapScorllTest",thisObj:this});
			Switcher.AddActiveObj(this);
		}
		
		override protected function onDestroy():void{
			Switcher.RemoveActiveObj(this);
			_game.global.curWorld.DestroyBody(_body);
			_body=null;
			super.onDestroy();
		}
		
	};

}