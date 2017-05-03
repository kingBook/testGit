package g.tiled{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import framework.Game;
	import framework.UpdateType;
	import g.Map;
	import g.MapCamera;
	import g.MyData;

	public class MapTiled extends Map{
		
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new MapTiled());
		}
		
		public function MapTiled(){ super(); }
		
		override protected function init(info:* = null):void{
			_model=MapTiledModel.create(_myGame,OFFSET);
			_view=MapTiledView.create(_model as MapTiledModel,_game);
			createMapBodies();
			createObjs();
			
			var cameraSize:Point=new Point(MyData.stageW,MyData.stageH);
			var cameraTarget:DisplayObject=_game.global.layerMan.gameLayer;
			_camera=MapCamera.create(cameraSize,_model.width,_model.height,cameraTarget);
			_camera.addEventListener(MapCamera.MOVE,cameraMove);
		}
		
		override protected function createMapBodies():void{
			//_model.createXmlBodies();
			_model.createWorldEdgeBodies(0,-100,0,100);
		}
		
		override protected function createObjs():void{
			
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
		}
		
		
	};

}