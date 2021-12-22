package g {
	import Box2D.Dynamics.b2World;
	import flash.geom.Rectangle;
	import framework.events.FrameworkEvent;
	import framework.Game;
	//import framework.flintparticles.twoD.renderers.BitmapRenderer;
	import framework.system.Global;
	//import framework.utils.FuncUtil;
	//import g.objs.Item;
	//import kingBook.Player;
	import flash.display.Sprite;
	
	public class MyGlobal extends Global {
		public static const GAMEING:String="gameing";
		public static const GAME_END:String="gameEnd";
		private var _gameLevel:int;
		private var _gameStatus:String;
		private var _disableKeyboard:Boolean;
		//private var _renderer:BitmapRenderer;
		private var _resetPointList:Array;
		
		public var playerHp:int;
		
		public function MyGlobal(main:Sprite,game:Game,gameWidth:Number,gameHeight:Number,box2dDebugVisible:Boolean=false,ptm_ratio:Number=30) {
			super(main,game,gameWidth,gameHeight,box2dDebugVisible,ptm_ratio);
			_game.addEventListener(FrameworkEvent.PAUSE, pauseResumeHandler);
			_game.addEventListener(FrameworkEvent.RESUME, pauseResumeHandler);
		}
		
		public function gotoLevel(level:int):void {
			reset();
			_gameLevel = level;
			_gameStatus = GAMEING;
			_disableKeyboard = false;
			_main["gameLevel"] = _gameLevel;
			
			_resetPointList = [];
			//playerHp = Player.HP;
			
			//Item.itemTotal=0;
			//Item.itemCount=0;
			
		}
		
		public function gameWin():void {
			_gameStatus = GAME_END;
			_disableKeyboard = true;
		}
		
		public function gameFailure():void {
			_gameStatus = GAME_END;
			_disableKeyboard = true;
		}
		
		private function pauseResumeHandler(e:FrameworkEvent):void {
			_disableKeyboard = _game.pause;
		}
		
		public function resetLevel():void { disposeVars(); }
		public function nextLevel():void { disposeVars(); }
		public function disposeVars():void {
			//FuncUtil.removeChild(_renderer);
			//_renderer = null;
			_resetPointList.length = 0;
		}
		
		public function get resetPointList():Array { return _resetPointList; }
		public function get gameLevel():int { return _gameLevel; }
		public function get gameStatus():String { return _gameStatus; }
		public function get disableKeyboard():Boolean { return _disableKeyboard; }
		/*public function get renderer():BitmapRenderer {
			var mapModel:MapModel = _game.getModel(MapModel.ID)as MapModel;
			_renderer ||= new BitmapRenderer(new Rectangle(0, 0, mapModel.width, mapModel.height));
			_game.global.layerMan.effLayer.addChild(_renderer);
			return _renderer;
		}*/
	}

}