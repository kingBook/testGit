package framework.system{
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import framework.Game;
	import framework.events.FrameworkEvent;
	import g.Main;
	public class Global extends EventDispatcher{
		protected var _game:Game;
		protected var _stage:Stage;
		protected var _main:Main;
		protected var _layerMan:LayerManager;
		protected var _objectPool:ObjectPool;
		protected var _curWorld:b2World;
		protected var _localMan:LocalManager;
		protected var _soundMan:SoundManager;
		protected var _box2dManList:Vector.<Box2dManager>;
		//protected var _shakeMan:ShakeManager;
		protected var _gameWidth:Number;
		protected var _gameHeight:Number;
		protected var _ptm_ratio:Number;
		protected var _box2dDebug:Box2dDebug;

		public function Global(main:Sprite,game:Game,gameWidth:Number,gameHeight:Number,box2dDebugVisible:Boolean=false,ptm_ratio:Number=30){
			super();
			_stage = main.stage;
			_game = game;
			_gameWidth = gameWidth;
			_gameHeight = gameHeight;
			_ptm_ratio = ptm_ratio;
			_main=main as Main;
			_layerMan = new LayerManager(_main);
			_objectPool = ObjectPool.getInstance();
			if(box2dDebugVisible) _box2dDebug = new Box2dDebug(_game,_layerMan,this,ptm_ratio);
		}
		
		public function setCurWorld(value:b2World):void{
			if(value==_curWorld)return;
			_curWorld=value;
			_curWorld.SetContactListener(new MyContactListener());
			dispatchEvent(new FrameworkEvent(FrameworkEvent.CHANGE_CURRENT_WORLD));
		}
		
		/** 返回Box2dManager id从0开始*/
		public function getBox2dMan(id:int):Box2dManager{
			if(!_box2dManList || _box2dManList.length<=id)return null;
			return _box2dManList[id];
		}
		public function addBox2dMan(id:int,box2dMan:Box2dManager):void{
			_box2dManList||=new Vector.<Box2dManager>();
			_box2dManList[id]=box2dMan;
		}
		
		/**开始关卡前调用此方法*/
		protected function reset():void{
			_layerMan.reset();
			if(_box2dDebug)_box2dDebug.reset();
			
			if(_box2dManList.length>0){
				var i:int = _box2dManList.length, box2dMan:Box2dManager;
				while (--i >= 0){
					box2dMan = _box2dManList[i];
					if(box2dMan) box2dMan.reset();
				}
			}
		}
		
		public function get curWorld():b2World{return _curWorld;}
		public function get stage():Stage{return _stage;}
		public function get main():Sprite{return _main;}
		public function get layerMan():LayerManager{return _layerMan;}
		public function get objectPool():ObjectPool{return _objectPool;}
		public function get localManager():LocalManager{ return _localMan||=new LocalManager();}
		public function get soundMan():SoundManager{ return _soundMan||=new SoundManager(); }
		//public function get shakeMan():ShakeManager{ return _shakeMan ||= new ShakeManager(_game, _layerMan.shakeLayer); }
		
		public function get gameWidth():Number{return _gameWidth;}
		public function get gameHeight():Number{return _gameHeight;}
		public function get ptm_ratio():Number{return _ptm_ratio;}
		public function get box2dDebug():Box2dDebug{return _box2dDebug;}

	};
}