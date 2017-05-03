package framework.system {
	import iflash.utils.LayaDictionary;

	public class ObjectPool{
		private var _dict:LayaDictionary;
		private static var _instance:ObjectPool;
		public function ObjectPool(single:Single) {
			if (!single) throw new Error("只能通过ObjectPool.getInstance()方法返回实例");
			_dict=new LayaDictionary();
		}
		public static function getInstance():ObjectPool {
			return _instance ||= new ObjectPool(new Single());
		}
		public function add(obj:Object, key:*=null):void{
			if (key) {
				if(!has(key))_dict.set(key,obj);
				else error(key);
			}else {
				if(!has(obj))_dict.set(key,obj);
				else error(obj);
			}
		}
		private function error(key:*):void {
			throw new Error(key+"已经存在对象池中!");
		}
		
		public function remove(key:*):void{
			if(has(key))_dict.remove(key);
		}
		
		public function get(key:*):*{
			if (has(key)) return _dict.get(key);
			else return null;
		}
		
		public function has(key:*):Boolean{
			return _dict.keys.indexOf(key)>-1;
		}
		
		public function clear():void{
			for (var k:* in _dict) delete _dict[k];
		}
	};
}
class Single { };