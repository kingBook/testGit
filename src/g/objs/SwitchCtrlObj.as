package g.objs{
	import g.MyEvent;
	/**开关控制的对象*/
	public class SwitchCtrlObj extends MovableObject{
		
		public function SwitchCtrlObj(){
			super();
		}
		
		override protected function init(info:* = null):void{
			super.init(info);
			_game.addEventListener(MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
		}
		
		private function createMapComplete(e:MyEvent):void{
			_game.removeEventListener(MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
			if((_flags&e_isOn)>0) _flags|=e_initIsOn;
		}
		
		/**控制接口*/
		public function control(isAuto:Boolean=false,isDoOn:Boolean=false):void{
			if(isAuto){
				if((_flags&e_isOn)>0)off();else on();
			}else{
				if(isDoOn)on();else off();
			}
		}
		
		protected function on():void{}
		
		protected function off():void{}
		
		override protected function onDestroy():void{
			_game.removeEventListener(MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
			super.onDestroy();
		}
		
		public function get ctrlMyName():String { return _ctrlMyName; }
		public function get initIsOn():Boolean{ return (_flags&e_initIsOn)>0; }
		
		private const e_initIsOn:uint=0x000001;
		protected const e_isOn:uint    =0x000002;
		protected var _flags:uint;
		protected var _ctrlMyName:String;
		
	};

}