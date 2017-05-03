package g.tiled{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import framework.Game;
	import g.MapModel;
	import g.MapView;
	
	public class MapTiledView extends MapView{
		
		public static function create(mapModel:MapTiledModel,game:Game):MapTiledView{
			var mapView:MapTiledView=new MapTiledView();
			mapView.init(mapModel,game);
			return mapView;
		}
		
		public function MapTiledView(){
			super();
		}
		
		override public function init(mapModel:MapModel, game:Game):void{
			_mapModel=mapModel;
			_game=game;
			//_wallBehindEffList=new Vector.<Clip>();
			//_wallfrontEffList=new Vector.<Clip>();
			
			_bmp_bgBottom=new Bitmap(_mapModel.bmd_bgBottomView);
			_bmp_bgMiddle=new Bitmap(_mapModel.bmd_bgMiddleView);
			//_bmp_wall=new Bitmap(_mapModel.bmd_wallView);
			_bmp_bgBottom.x=_bmp_bgBottom.y=-_mapModel.offset;
			_bmp_bgMiddle.x=_bmp_bgMiddle.y=-_mapModel.offset;
			//_bmp_wall.x=_bmp_wall.y=-_mapModel.offset;
			_bgBottom_container=new Sprite();
			_bgMiddle_container=new Sprite();
			_wall_container=new Sprite();
			_bgBottom_container.addChild(_bmp_bgBottom);
			_bgMiddle_container.addChild(_bmp_bgMiddle);
			createWall(_wall_container);
			//_wall_container.addChild(_bmp_wall);
			_game.global.layerMan.items0Layer.addChild(_bgBottom_container);
			_game.global.layerMan.items1Layer.addChild(_bgMiddle_container);
			//_mapModel.transformChildsToClips(_mapModel.mc_wallBehindEff,_game.global.layerMan.items2Layer,_wallBehindEffList);
			_game.global.layerMan.items3Layer.addChild(_wall_container);
			//_mapModel.transformChildsToClips(_mapModel.mc_wallfrontEff,_game.global.layerMan.items4Layer,_wallfrontEffList);
			
			
		}
		
		private function createWall(container:Sprite):void{
			
		}
		
		
		override public function dispose():void{
			super.dispose();
		}
	};

}