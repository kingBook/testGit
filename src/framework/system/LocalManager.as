package framework.system {
	import flash.net.SharedObject;

	public class LocalManager{
		private const _FILE_NAME:String="kingBookGameLocalFile"; //文件名 
		private var _so:SharedObject;
		public function LocalManager(){
			_so = SharedObject.getLocal(_FILE_NAME);
		}
		
		/**清除*/
		public function clear():void{
			_so.clear();
		}
		
		/**保存数据*/
		public function save(key:String, data:*):void{
			_so.data[key] = data;
			_so.flush();
		}
		
		/**提取数据*/
		public function get(key:String):*{
			return _so.data[key];
		}
		
		public function getInt(key:String,defaultValue:int):int{
			var i:int=int(_so.data[key])||defaultValue;
			return i;
		}
	}
}