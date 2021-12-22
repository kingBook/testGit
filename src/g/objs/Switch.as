package g.objs{
	import Box2D.Dynamics.b2Body;
	/**开关（抽象类）*/
	public class Switch extends MovableObject{
		
		public function Switch(){
			super();
		}
		
		public function control(isAuto:Boolean=false,isDoOn:Boolean=false):void{
			if((_flags&e_isOnce)>0 && (_flags&e_isTriggered)>0)return;
			_flags|=e_isTriggered;//设置为已经触发过
			
			if(isAuto){
				if((_flags&e_isOn)>0)off(); else on();
			}else{
				if(isDoOn)on();else off();
			}
		}
		
		protected function on():void{
			
		}
		
		protected function off():void{
			
		}
		
		protected const e_isOnce:uint		=0x000001;//是否只触发一次
		protected const e_isTriggered:uint	=0x000002;//已经触发过了
		protected const e_isOn:uint	    	=0x000004;//
		protected var _flags:uint;
		
		protected var _myName:String;
		
	};

}