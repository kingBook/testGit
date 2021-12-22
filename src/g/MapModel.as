package g{
	import Box2D.Dynamics.b2Body;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import framework.objs.Clip;
	import framework.system.ObjectPool;
	import framework.utils.Box2dUtil;
	import framework.utils.FuncUtil;
	import framework.utils.LibUtil;
	import g.MapData;
	import g.MyData;
	import g.MyGame;

	public class MapModel{
		
		public static function create(myGame:MyGame,offset:Number):MapModel{
			var model:MapModel=new MapModel();
			model.init(myGame,offset);
			return model;
		}
		
		public var width:int;
		public var height:int;
		public var bodiesXml:XML;
		public var mc_objs:MovieClip;
		public var mc_hit:MovieClip;
		public var mc_wallfrontEff:MovieClip;
		public var mc_wall:MovieClip;
		public var mc_wallBehindEff:MovieClip;
		public var mc_bgMiddle:MovieClip;
		public var mc_bgBottom:MovieClip;
		
		public var bmd_wallSource:BitmapData;
		public var bmd_bgMiddleSource:BitmapData;
		public var bmd_bgBottomSource:BitmapData;
		public var bmd_wallView:BitmapData;
		public var bmd_bgMiddleView:BitmapData;
		public var bmd_bgBottomView:BitmapData;
		
		protected var _pos_wall:Point;
		protected var _pos_bgMiddle:Point;
		protected var _pos_bgBottom:Point;
		
		protected var _myGame:MyGame;
		protected var _offset:int;
		protected var _pt:Point;
		protected var _viewRect:Rectangle;
		protected var _scrollRect:Rectangle;
		protected var _viewWidth:int;
		protected var _viewHeight:int;
		public function dispose():void{
			bodiesXml=null;
			mc_objs=null;
			mc_hit=null;
			mc_wallfrontEff=null;
			mc_wall=null;
			mc_wallBehindEff=null;
			mc_bgMiddle=null;
			mc_bgBottom=null;
			
			bmd_wallSource=null;
			bmd_bgMiddleSource=null;
			bmd_bgBottomSource=null;
/*[IF-FLASH-BEGIN]*/
			if(bmd_wallView)bmd_wallView.dispose();
			if(bmd_bgMiddleView)bmd_bgMiddleView.dispose();
			if(bmd_bgBottomView)bmd_bgBottomView.dispose();
/*[IF-FLASH-END]*/
			bmd_wallView=null;
			bmd_bgMiddleView=null;
			bmd_bgBottomView=null;
			
			_pos_wall=null;
			_pos_bgMiddle=null;
			_pos_bgBottom=null;
			
			_myGame=null;
			_pt=null;
			_viewRect=null;
			_scrollRect=null;
			
		}
		
		public function MapModel(){ super(); }
		
		public function init(myGame:MyGame,offset:int):void{
			_myGame=myGame;
			_offset=offset;
			_viewWidth=MyData.stageW+(_offset<<1);
			_viewHeight=MyData.stageH+(_offset<<1);
			var gameLevel:int=myGame.myGlobal.gameLevel;
			bodiesXml=MapData.getBodiesXml(gameLevel);
			
			var data:*=MapData.getDataObj(gameLevel);
			width=data.size.width;
			height=data.size.height;
			
			mc_objs=LibUtil.getDefMovie(data.objs.name);
			mc_objs.gotoAndStop(data.objs.frame);
			mc_hit=LibUtil.getDefMovie(data.hit.name);
			mc_hit.gotoAndStop(data.hit.frame);
			mc_wallfrontEff=LibUtil.getDefMovie(data.wallFrontEff.name);
			mc_wallfrontEff.gotoAndStop(data.wallFrontEff.frame);
			mc_wall=LibUtil.getDefMovie(data.wall.name);
			mc_wall.gotoAndStop(data.wall.frame);
			mc_wallBehindEff=LibUtil.getDefMovie(data.wallBehindEff.name);
			mc_wallBehindEff.gotoAndStop(data.wallBehindEff.frame);
			mc_bgMiddle=LibUtil.getDefMovie(data.bgMiddle.name);
			mc_bgMiddle.gotoAndStop(data.bgMiddle.frame);
			mc_bgBottom=LibUtil.getDefMovie(data.bgBottom.name);
			mc_bgBottom.gotoAndStop(data.bgBottom.frame);
			
			var pool:ObjectPool=ObjectPool.getInstance();
			bmd_wallSource=getSourceBitmapData("bmd_wallSource"+gameLevel,mc_wall,pool);
			bmd_bgMiddleSource=getSourceBitmapData("bmd_bgMiddleSource"+gameLevel,mc_bgMiddle,pool);
			bmd_bgBottomSource=getSourceBitmapData("bmd_bgBottomSource"+gameLevel,mc_bgBottom,pool);
/*[IF-FLASH-BEGIN]*/
			bmd_wallView=getViewBitmapData(bmd_wallSource);
			bmd_bgMiddleView=getViewBitmapData(bmd_bgMiddleSource);
			bmd_bgBottomView=getViewBitmapData(bmd_bgBottomSource);
/*[IF-FLASH-END]*/
/*[IF-SCRIPT-BEGIN]
			bmd_wallView=bmd_wallSource;
			bmd_bgMiddleView=bmd_bgMiddleSource;
			bmd_bgBottomView=bmd_bgBottomSource;
[IF-SCRIPT-END]*/
			_pos_wall=new Point(0,0);
			_pos_bgMiddle=new Point(0,0);
			_pos_bgBottom=new Point(0,0);
		}
		
		public function scroll(vx:int,vy:int):void{
			var vxx:Number=vx*0.2;
			var vyy:Number=vy*0.2;
			vxx=vxx>0?int(vxx+0.9):int(vxx-0.9);
			vyy=vyy>0?int(vyy+0.9):int(vyy-0.9);
			scrollBmd(bmd_bgBottomView,bmd_bgBottomSource,_pos_bgBottom,vxx,vyy);
			vxx=vx*0.5;
			vyy=vy*0.5;
			vxx=vxx>0?int(vxx+0.9):int(vxx-0.9);
			vyy=vyy>0?int(vyy+0.9):int(vyy-0.9);
			scrollBmd(bmd_bgMiddleView,bmd_bgMiddleSource,_pos_bgMiddle,vxx,vyy);
			scrollBmd(bmd_wallView,bmd_wallSource,_pos_wall,vx,vy);
		}
		
		public function createXmlBodies(friction:Number=NaN,restitution:Number=NaN):void{
			var bodies:Vector.<b2Body>=Box2dUtil.createXmlBodies(bodiesXml,_myGame.global.curWorld,MyData.ptm_ratio);
			var userData:*={type:"Ground"};
			var i:int=bodies.length;
			while(--i>=0){
				bodies[i].SetUserData(userData);
				Box2dUtil.setBodyFixture(bodies[i],NaN,friction,restitution);
			}
		}
		
		public function createWorldEdgeBodies(offsetL:Number=0,offsetT:Number=0,offsetR:Number=0,offsetD:Number=0):Vector.<b2Body>{
			var x:Number=offsetL;
			var y:Number=offsetT;
			var w:Number=width-offsetL+offsetR;
			var h:Number=height-offsetT+offsetD;
			var bodies:Vector.<b2Body>=Box2dUtil.createWrapWallBodies(x,y,w,h,_myGame.global.curWorld,MyData.ptm_ratio);
			var i:int=bodies.length;
			while (--i>=0){
				bodies[i].SetType(b2Body.b2_staticBody);
				bodies[i].GetFixtureList().SetFriction(0);
				bodies[i].SetUserData({type:"EdgeGround"});
			}
			return bodies;
		}
		
		/**返回地图对象要显示的BitmapData，上下左右都放大了2*_offset像素，避免震动地图时产生空白边缘*/
		protected function getViewBitmapData(sourceBitmapData:BitmapData):BitmapData{
			var bmd:BitmapData=new BitmapData(_viewWidth,_viewHeight,true,0);
			_viewRect||=new Rectangle(0,0,_viewWidth,_viewHeight);
			_pt||=new Point();
			_pt.x=0; _pt.y=0;
			bmd.copyPixels(sourceBitmapData,_viewRect,_pt);
			return bmd;
		}
		
		/**返回地图对象的BitmapData，上下左右都放大了2*_offset像素，避免震动地图时产生空白边缘*/
		protected function getSourceBitmapData(poolKey:String,mc:MovieClip,pool:ObjectPool):BitmapData{
			var bmd:BitmapData;
			if(pool.has(poolKey)){
				bmd=pool.get(poolKey) as BitmapData;
			}else{
				var w:int=int((width+(_offset<<1))+0.9);
				var h:int=int((height+(_offset<<1))+0.9);
				var tx:Number=_offset;
				var ty:Number=_offset;
				bmd=FuncUtil.getBmdFromDisObj(mc,w,h,tx,ty);
				pool.add(bmd,poolKey);
			}
			return bmd;
		}
		
		protected function scrollBmd(bmd_view:BitmapData,bmd_source:BitmapData,pos:Point,vx:int,vy:int):void{
			bmd_view.scroll(-vx,-vy);
			
			_scrollRect||=new Rectangle();
			_pt||=new Point();
			var xLen:int=Math.abs(vx);
			var yLen:int=Math.abs(vy);
			pos.x+=vx;
			pos.y+=vy;
			if(vx!=0){
				_scrollRect.width=xLen;
				_scrollRect.height=_viewHeight;
				_scrollRect.x=vx>0 ? pos.x+_viewWidth-xLen : pos.x;
				_scrollRect.y=pos.y;
				_pt.x=vx>0 ? _viewWidth-xLen : 0;
				_pt.y=0;
				bmd_view.copyPixels(bmd_source,_scrollRect,_pt);
			}
			if(vy!=0){
				_scrollRect.width=_viewWidth;
				_scrollRect.height=yLen;
				_scrollRect.x=pos.x;
				_scrollRect.y=vy>0 ? pos.y+_viewHeight-yLen : pos.y;
				_pt.x=0;
				_pt.y=vy>0 ? _viewHeight-yLen : 0;
				bmd_view.copyPixels(bmd_source,_scrollRect,_pt);
			}
		}
		
		public function transformChildsToClips(container:MovieClip,parent:*,outputList:Vector.<Clip>=null):Vector.<Clip>{
			var list:Vector.<Clip>=outputList?outputList:new Vector.<Clip>();
			var clip:Clip;
			var len:int=container.numChildren;
			var child:*;
			for(var i:int=0;i<len;i++){
				child=container.getChildAt(i);
				if(child is MovieClip){
					var qName:String=flash.utils.getQualifiedClassName(child);
					var isCustomLinkClass:Boolean=qName.indexOf("::MovieClip")<0;
					if(isCustomLinkClass){
						clip=Clip.fromDefName(qName,true);
						clip.transform=child.transform;
						clip.smoothing=true;
					}else{
						clip=Clip.fromDisplayObject(child);
					}
				}else{
					clip=Clip.fromDisplayObject(child);
				}
				list.push(clip);
				parent.addChild(clip);
			}
			return list;
		}
		
		public function get offset():int{ return _offset; }
		
	};

}