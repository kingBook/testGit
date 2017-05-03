package g.objs{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import framework.Game;
	import framework.objs.Clip;
	import framework.objs.GameObject;
	import framework.utils.LibUtil;
	
	public class DisplayObj extends GameObject{
		
		public static function create(x:Number,y:Number,view:DisplayObject,viewParent:DisplayObjectContainer):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.x=x;
			info.y=y;
			info.view=view;
			info.viewParent=viewParent;
			game.createGameObj(new DisplayObj(),info);
		}
		
		public static function createDefClip(x:Number,y:Number,defName:String,viewParent:DisplayObjectContainer):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.x=x;
			info.y=y;
			info.view=Clip.fromDefName(defName,true);
			info.viewParent=viewParent;
			game.createGameObj(new DisplayObj(),info);
		}
		
		public static function createDefMovieClip(x:Number,y:Number,defName:String,viewParent:DisplayObjectContainer):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.x=x;
			info.y=y;
			info.view=LibUtil.getDefMovie(defName,false,false);
			info.viewParent=viewParent;
			game.createGameObj(new DisplayObj(),info);
		}
		
		public function DisplayObj(){
			super();
		}
		
		override protected function init(info:* = null):void{
			info.view.x=info.x;
			info.view.y=info.y;
			if(info.viewParent){
				info.viewParent.addChild(info.view);
			}
			
			_view=info.view;
		}
		
		override protected function onDestroy():void{
			if(_view){
				if(_view.parent)_view.parent.removeChild(_view);
				_view=null;
			}
			super.onDestroy();
		}
		
		private var _view:DisplayObject;
		
	};

}