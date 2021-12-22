package framework{
	import framework.namespaces.frameworkInternal;
	use namespace frameworkInternal;
	
	public class UpdateProxy{
		
		private var _game:Game;
		private var _list:Vector.<Vector.<Function>>;
		
		public function UpdateProxy(game:Game){
			_game=game;
			_list=new Vector.<Vector.<Function>>(4,true);
			_list[UpdateType.FOREVER]=new Vector.<Function>();
			_list[UpdateType.FIXED]=new Vector.<Function>();
			_list[UpdateType.UPDATE]=new Vector.<Function>();
			_list[UpdateType.LATE]=new Vector.<Function>();
		}
		
		frameworkInternal function add(updateType:int,func:Function):void{
			var id:int=_list[updateType].indexOf(func);
			if(id<0)_list[updateType].unshift(func);
		}
		
		frameworkInternal function remove(updateType:int,func:Function):void{
			var id:int=_list[updateType].indexOf(func);
			if(id>-1)_list[updateType][id]=null;
		}
		
		frameworkInternal function update():void{
			foreach(UpdateType.FOREVER);
			if(_game.pause)return;
			foreach(UpdateType.FIXED);
			foreach(UpdateType.UPDATE);
			foreach(UpdateType.LATE);
		}
		
		private function foreach(updateType:int):void{
			var vec:Vector.<Function>=_list[updateType];
			var i:int=vec.length;
			while(--i>=0){
				if(vec[i]==null) vec.splice(i,1);
				else vec[i]();
			}
		}
	};

}