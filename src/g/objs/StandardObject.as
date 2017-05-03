package g.objs{
	import framework.objs.GameObject;
	import framework.Game;
	import Box2D.Dynamics.b2Body;
	import framework.utils.Box2dUtil;
	import framework.objs.Clip;
	import flash.utils.getQualifiedClassName;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import g.MyData;

	public class StandardObject extends GameObject{
		
		public static function create(body:b2Body,view:DisplayObject=null,viewParent:DisplayObjectContainer=null):StandardObject{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=body;
			info.view=view;
			info.viewParent=viewParent;
			return game.createGameObj(new StandardObject(),info) as StandardObject;
		}
		
		protected var _body:b2Body;
		protected var _view:DisplayObject;
		public function StandardObject(){super();}
		
		override protected function init(info:*=null):void{
			_body=info.body;
			if(_body){
				var qclassName:String=flash.utils.getQualifiedClassName(this);
				var type:String=qclassName.substr(qclassName.lastIndexOf(":")+1);
				_body.SetUserData({type:type,thisObj:this});
			}
			_view=info.view;
			if(_view && info.viewParent){
				info.viewParent.addChild(_view);
			}
			syncView();
		}
		
		protected function syncView():void{
			if(_view==null)return;
			_view.x=_body.GetPosition().x*MyData.ptm_ratio;
			_view.y=_body.GetPosition().y*MyData.ptm_ratio;
			_view.rotation=(_body.GetAngle()*57.3)%360;
		}
		
		override protected function onDestroy():void{
			_body&&_body.Destroy();
			if(_view&&_view.parent)_view.parent.removeChild(_view);
			_body=null;
			_view=null;
			super.onDestroy();
		}
	};
}