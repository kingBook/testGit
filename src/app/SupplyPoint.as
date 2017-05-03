package app{
	import Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import framework.utils.LibUtil;
	import g.MyData;
	import g.objs.MovableObject;
	
	
	public class SupplyPoint extends MovableObject{
		public static const ADD_BULLET_NUM:int=25;
		
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			info.view=LibUtil.getDefMovie("SupplyPoint_view");
			info.viewParent=game.global.layerMan.items2Layer;
			game.createGameObj(new SupplyPoint(),info);
		}
		
		public function SupplyPoint(){
			super();
		}
		
		override protected function init(info:* = null):void{
			super.init(info);
			_body.SetType(b2Body.b2_staticBody);
			_body.SetSensor(true);
			
			_mc=_view as MovieClip;
			_mc.stop();
			
			_isOpen=false;
		}
		
		public function open():void{
			if(_mc.currentFrame>1)return;
			_mc.gotoAndPlay(2);
			_mc.addFrameScript(_mc.totalFrames-1,opened);
			_isOpen=true;
		}
		
		private function opened():void{
			_mc.stop();
		}
		
		override protected function onDestroy():void{
			_mc.addFrameScript(_mc.totalFrames-1,null);
			super.onDestroy();
		}
		
		private var _mc:MovieClip;
		private var _isOpen:Boolean;
		
		public function get isOpen():Boolean{ return _isOpen; }
		
	};

}