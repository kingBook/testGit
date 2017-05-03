package framework.system {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	import framework.UpdateType;
	import framework.system.SystemKeyboard;
	import framework.events.FrameworkEvent;
	import framework.Game;
	import framework.namespaces.frameworkInternal;
	use namespace frameworkInternal;

	public class KeyboardManager{
		private var _stage:Stage;
		private var _keys:SystemKeyboard;
		private var _lastTime:int;
		private var _release:Boolean;
		private var _game:Game;
		public function KeyboardManager(game:Game){
			_game=game;
			_stage=_game.global.stage;
			
			_keys = new SystemKeyboard();
			_keys.bind(_stage);
			_stage.focus = _stage;
			_stage.addEventListener(Event.DEACTIVATE, deActivateHandler);
			_game.addUpdate(UpdateType.FOREVER,update);
		}
		
		private function deActivateHandler(e:Event):void { _keys.reset(); }
		private function update():void { _keys.update(); }
		public function p(key:String):Boolean { return _keys.pressed(key); }
		public function jP(key:String):Boolean { return _keys.justPressed(key); }
		public function jR(key:String):Boolean { return _keys.justReleased(key); }
		
		public function p_keys(keys:Vector.<String>):Boolean{
			var i:int=keys.length;
			while (--i>=0){
				if(_keys.pressed(keys[i]))return true;
			}
			return false;
		}
		public function jp_keys(keys:Vector.<String>):Boolean{
			var i:int=keys.length;
			while (--i>=0){
				if(_keys.justPressed(keys[i]))return true;
			}
			return false;
		}
		
		public function double(key:String):Boolean {
			var doubleKey:Boolean;
			if (jR(key)) {
				_release = true;
			} else if (jP(key)) {
				if (_lastTime - (_lastTime=getTimer()) + 300 > 0 && _release) {
					doubleKey = true;
				}
				_release = false;
			}
			return doubleKey;
		}
		
		private var _longPressTimes:*;
		/**
		 * 是否长按下某一个键
		 * @param	key 键名
		 * @param	maxTime 判断长按的时间<ms>
		 * @return
		 */
		public function longPress(key:String,maxTime:int=300):Boolean{
			_longPressTimes||={};
			if(!_longPressTimes[key]){
				if(p(key)) _longPressTimes[key]=getTimer();
			}else{
				if(p(key)){
					if(getTimer()-_longPressTimes[key]>=maxTime){
						delete _longPressTimes[key];
						return true;
					}
				}else{
					delete _longPressTimes[key];
				}
			}
			return false;
		}
		
		public function destroy():void {
			_stage.removeEventListener(Event.DEACTIVATE, deActivateHandler);
			_game.removeUpdate(UpdateType.FOREVER, update);
			if (_keys) {
				_keys.unbind(_stage);
				_keys.destroy();
				_keys = null;
			}
			_longPressTimes = null;
			_stage = null;
			_game = null;
		}
	}
}