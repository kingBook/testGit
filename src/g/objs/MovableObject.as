package g.objs{
	import Box2D.Dynamics.b2Body;
	import framework.UpdateType;
	import framework.Game;

	public class MovableObject extends StandardObject{
		
		public static function create(body:b2Body,view:*=null,viewParent:*=null):MovableObject{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=body;
			info.view=view;
			info.viewParent=viewParent;
			return game.createGameObj(new MovableObject(),info) as MovableObject;
		}
		
		public function MovableObject(){
			super();
		}
		
		override protected function update():void{
			syncView();
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
		}
	};
}