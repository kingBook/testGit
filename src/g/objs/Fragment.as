package g.objs{
	import Box2D.Dynamics.b2Body;
	import framework.Game;
	import framework.objs.GameObject;
	import g.objs.MovableObject;
	/**碎片*/
	public class Fragment extends MovableObject{
		
		public static function create(body:b2Body,maxY:Number,view:*=null,viewParent:*=null):Fragment{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=body;
			info.view=view;
			info.viewParent=viewParent;
			info.maxY=maxY;
			return game.createGameObj(new Fragment(),info) as Fragment;
		}
		
		public function Fragment(){
			super();
		}
		
		private var _maxY:Number;
		
		override protected function init(info:* = null):void{
			super.init(info);
			_maxY=info.maxY;
		}
		
		override protected function update():void{
			super.update();
			var y:Number=_body.GetAABB().lowerBound.y;
			if(y>_maxY){
				GameObject.destroy(this);
			}
		}
		
	};

}