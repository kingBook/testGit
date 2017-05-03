package g{
	import flash.display.Bitmap;
	import framework.Game;
	import framework.utils.FuncUtil;
	import framework.objs.Clip;
	import g.MapModel;
	import flash.display.Sprite;

	public class MapView{
		public static function create(mapModel:MapModel,game:Game):MapView{
			var mapView:MapView=new MapView();
			mapView.init(mapModel,game);
			return mapView;
		}
		
		protected var _mapModel:MapModel;
		protected var _game:Game;
		protected var _bmp_bgBottom:Bitmap;
		protected var _bmp_bgMiddle:Bitmap;
		protected var _bmp_wall:Bitmap;
		protected var _bgBottom_container:Sprite;
		protected var _bgMiddle_container:Sprite;
		protected var _wall_container:Sprite;
		protected var _wallBehindEffList:Vector.<Clip>;
		protected var _wallfrontEffList:Vector.<Clip>;
		public function dispose():void{
			if(_wallBehindEffList)clearClips(_wallBehindEffList);
			if(_wallfrontEffList)clearClips(_wallfrontEffList);
			if(_bgBottom_container){
				if(_bgBottom_container.parent)_bgBottom_container.parent.removeChild(_bgBottom_container);
			}
			if(_bgMiddle_container){
				if(_bgMiddle_container.parent)_bgMiddle_container.parent.removeChild(_bgMiddle_container);
			}
			if(_wall_container){
				if(_wall_container.parent)_wall_container.parent.removeChild(_wall_container);
			}
			_mapModel=null;
			_game=null;
			_bmp_bgBottom=null;
			_bmp_bgMiddle=null;
			_bmp_wall=null;
			_bgBottom_container=null;
			_bgMiddle_container=null;
			_wall_container=null;
			_wallBehindEffList=null;
			_wallfrontEffList=null;
		}
		public function MapView(){ super(); }
		
		public function init(mapModel:MapModel,game:Game):void{
			_mapModel=mapModel;
			_game=game;
			_wallBehindEffList=new Vector.<Clip>();
			_wallfrontEffList=new Vector.<Clip>();
			
			_bmp_bgBottom=new Bitmap(_mapModel.bmd_bgBottomView);
			_bmp_bgMiddle=new Bitmap(_mapModel.bmd_bgMiddleView);
			_bmp_wall=new Bitmap(_mapModel.bmd_wallView);
			_bmp_bgBottom.x=_bmp_bgBottom.y=-_mapModel.offset;
			_bmp_bgMiddle.x=_bmp_bgMiddle.y=-_mapModel.offset;
			_bmp_wall.x=_bmp_wall.y=-_mapModel.offset;
			_bgBottom_container=new Sprite();
			_bgMiddle_container=new Sprite();
			_wall_container=new Sprite();
			_bgBottom_container.addChild(_bmp_bgBottom);
			_bgMiddle_container.addChild(_bmp_bgMiddle);
			_wall_container.addChild(_bmp_wall);
			_game.global.layerMan.items0Layer.addChild(_bgBottom_container);
			_game.global.layerMan.items1Layer.addChild(_bgMiddle_container);
			_mapModel.transformChildsToClips(_mapModel.mc_wallBehindEff,_game.global.layerMan.items2Layer,_wallBehindEffList);
			_game.global.layerMan.items3Layer.addChild(_wall_container);
			_mapModel.transformChildsToClips(_mapModel.mc_wallfrontEff,_game.global.layerMan.items4Layer,_wallfrontEffList);
		}
		
		public function scorll(vx:int,vy:int):void{
/*[IF-FLASH-BEGIN]*/
			_bgBottom_container.x+=vx;
			_bgBottom_container.y+=vy;
			_bgMiddle_container.x+=vx;
			_bgMiddle_container.y+=vy;
			_wall_container.x+=vx;
			_wall_container.y+=vy;
/*[IF-FLASH-END]*/
/*[IF-SCRIPT-BEGIN] 
			var vxx:Number=vx*0.5;
			var vyy:Number=vy*0.5;
			vxx=vxx>0?int(vxx-0.9):int(vxx+0.9);
			vyy=vyy>0?int(vyy-0.9):int(vyy+0.9);
			_bgBottom_container.x+=vx*0.5;
			_bgBottom_container.y+=vy*0.5;
			vxx=vx*0.2;
			vyy=vy*0.2;
			vxx=vxx>0?int(vxx-0.9):int(vxx+0.9);
			vyy=vyy>0?int(vyy-0.9):int(vyy+0.9);
			_bgMiddle_container.x+=vxx;
			_bgMiddle_container.y+=vyy;
[IF-SCRIPT-END]*/
		}
		
		protected function clearClips(list:Vector.<Clip>):void{
			var i:int=list.length;
			while(--i>=0){
				if(list[i].parent)list[i].parent.removeChild(list[i]);
			}
		}
		
	};

}