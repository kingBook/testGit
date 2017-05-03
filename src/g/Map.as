package g{
	import app.FireBird;
	import app.Player;
	import app.SupplyPoint;
	import app.Exit;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import framework.Game;
	import framework.UpdateType;
	import g.fixtures.SwitcherButton;
	import g.fixtures.SwitcherRocker;
	import g.fixtures.Platform;
	import g.fixtures.SwitcherMovieOneClip;
	import g.fixtures.SwitcherMovieTwoClip;
	import Box2D.Dynamics.b2Body;
	import g.objs.DisplayObj;
	import g.objs.SpriteBoxBody;
	import app.BulletTouchSwitch;

	public class Map extends MyObj{
		public static const OFFSET:int=10;
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new Map());
		}
		
		protected var _model:MapModel;
		protected var _view:MapView;
		protected var _camera:MapCamera;
		
		public function Map(){super();}
		
		override protected function init(info:* = null):void{
			_model=MapModel.create(_myGame,OFFSET);
			_view=MapView.create(_model,_game);
			
			var cameraSize:Point=new Point(MyData.stageW,MyData.stageH);
			var cameraTarget:DisplayObject=_game.global.layerMan.gameLayer;
			_camera=MapCamera.create(cameraSize,_model.width,_model.height,cameraTarget);
			_camera.addEventListener(MapCamera.MOVE,cameraMove);
			
			createMapBgFire();
			createMapBodies();
			createObjs();
			
			
			
		}
		
		private function createMapBgFire():void{
			var defName:String="Fire_view";
			var parent:Sprite=_game.global.layerMan.items0Layer;
			DisplayObj.createDefClip(-126,326,defName,parent);
			DisplayObj.createDefClip(438,334,defName,parent);
			DisplayObj.createDefClip(1098,380,defName,parent);
		}
		
		override protected function lateUpdate():void{
			_camera.update();
		}
		
		protected function cameraMove(e:MyEvent):void{
			var vx:int=e.info.vx;
			var vy:int=e.info.vy;
/*[IF-FLASH]*/_model.scroll(vx,vy);
			_view.scorll(vx,vy);
		}
		
		protected function createMapBodies():void{
			_model.createXmlBodies();
			_model.createWorldEdgeBodies(0,-100,0,100);
		}
		
		protected function createObjs():void{
			var objsMc:MovieClip=_model.mc_objs;
			var len:int=objsMc.numChildren;
			var childMc:MovieClip;
			for(var i:int;i<len;i++){
				childMc=objsMc.getChildAt(i) as MovieClip;
				if(childMc==null)continue;
				if(childMc.name.indexOf("switcher_button")>-1){
					SwitcherButton.create(childMc);
				}else if(childMc.name.indexOf("switcher_rocker")>-1){
					SwitcherRocker.create(childMc);
				}else if(childMc.name.indexOf("platform_controlled")>-1){
					Platform.create(childMc);
				}else if(childMc.name.indexOf("platform_auto")>-1){
					Platform.create(childMc);
				}else if(childMc.name.indexOf("platform_fixed")>-1){
					Platform.create(childMc);
				}else if(childMc.name.indexOf("switcherMovieOneClip")>-1){
					SwitcherMovieOneClip.create(childMc);
				}else if(childMc.name.indexOf("switcherMovieTwoClip")>-1){
					SwitcherMovieTwoClip.create(childMc);
				}else if(childMc.name.indexOf("danger")>-1){
					SpriteBoxBody.create(childMc,"Danger",true,b2Body.b2_staticBody);
				}else if(childMc.name.indexOf("player")>-1){
					Player.create(childMc);
				}else if(childMc.name.indexOf("supplyPoint")>-1){
					SupplyPoint.create(childMc);
				}else if(childMc.name.indexOf("fireBird")>-1){
					FireBird.create(childMc);
				}else if(childMc.name.indexOf("exit")>-1){
					Exit.create(childMc);
				}else if(childMc.name.indexOf("bulletTouchSwitch")>-1){
					BulletTouchSwitch.create(childMc);
				}
			}
		}
		
		override protected function onDestroy():void{
			if(_camera){
				_camera.removeEventListener(MapCamera.MOVE,cameraMove);
				_camera.dispose();
				_camera=null;
			}
			if(_model){
				_model.dispose();
				_model=null;
			}
			if(_view){
				_view.dispose();
				_view=null;
			}
			super.onDestroy();
		}
		
		public function get width():int{return _model.width;}
		public function get height():int{return _model.height;}
		public function get camera():MapCamera{ return _camera; }
	};

}