package g.objs{
	import framework.Game;
	import g.MyEvent;
	import g.MyObj;
	public class Delayer extends MyObj{
		public static const EXECUTE:String = "execute";
		/**非自动的延时器，需要每次手动调用xx方法, 每次延时完成发出EXECUTE事件*/
		public static function create():Delayer{
			var game:Game=Game.getInstance();
			return game.createGameObj(new Delayer(),{}) as Delayer;
		}
		
		/**创建自动回调的延时器，每次延时完成发出EXECUTE事件*/
		public static function createAutoDelayer(autoScheduleDelay:Number=1):Delayer{
			var game:Game=Game.getInstance();
			var info:*={};
			info.isAuto=true;
			info.autoScheduleDelay=autoScheduleDelay;
			return game.createGameObj(new Delayer(),info) as Delayer;
		}
		
		public function Delayer() {
			super();
		}
		
		private var _autoScheduleDelay:Number;
		private var _isAuto:Boolean;
		private var _isDelaying:Boolean;
		private var _executeEvent:MyEvent = new MyEvent(EXECUTE);
		
		override protected function init(info:*=null):void{
			_isAuto=info.isAuto;
			if(_isAuto){
				_autoScheduleDelay=info.autoScheduleDelay;
				addDelay();
			}
		}
		
		private function addDelay():void {
			scheduleOnce(delayed,_autoScheduleDelay);
		}
		
		private function delayed():void {
			_isDelaying=false;
			dispatchEvent(_executeEvent);
			if(_isAuto)addDelay();
		}
		
		/**手动延时 delayTime<秒>*/
		public function delayHandler(delayTime:Number):void{
			if(_isDelaying)return;
			scheduleOnce(delayed,delayTime);
			_isDelaying=true;
		}
		
		override protected function onDestroy():void {
			unschedule(delayed);
			_executeEvent=null;
			super.onDestroy();
		}
		
		public function get isDelaying():Boolean{return _isDelaying;}
	};

}