package g{
	import framework.Game;
	import framework.GameObjectListProxy;
	import framework.objs.GameObject;	
	import framework.namespaces.frameworkInternal;
	use namespace frameworkInternal;
	public class MyObj extends GameObject{
		
		protected var _myGame:MyGame;
		public function MyObj(){
			super();
		}
		
		override frameworkInternal function init_internal(game:Game,gameObjectListProxy:GameObjectListProxy,info:*):void{
			_myGame=game as MyGame;
			super.init_internal(game,gameObjectListProxy,info);
		}
		
		override protected function onDestroy():void{
			_myGame=null;
			super.onDestroy();
		}
	};

}