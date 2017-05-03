package framework.utils {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import framework.system.ObjectPool;
	
	public class LibUtil {
		
		public static function getClass(defName:String,c:Class=null):Class {
			var c:Class;
			var curDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			if (curDomain.hasDefinition(defName))
				c = curDomain.getDefinition(defName) as Class;
			else
				trace("警告：无法获取类：" + defName, "请确认类名正确，检查类所在的fla是否发布swf,swf是否正确嵌入");
			return c;
		}
		
		public static function getDefObj(defName:String, addToPool:Boolean = false):* {
			var pool:ObjectPool = ObjectPool.getInstance();
			var obj:*;
			if(addToPool){
				if (pool.has(defName)) {
					obj = pool.get(defName);
				}
				else {
					obj = getNewClass(defName);
					pool.add(obj,defName);
				}
			}else {
				obj = getNewClass(defName);
			}
			return obj;
		}
		
		private static function getNewClass(defName:String):*{
			var __O:Class = getClass(defName);
			var obj:* = __O ? new __O : null;
			return obj;
		}
		
		public static function getDefMovie(defName:String,addToPool:Boolean=false,isStop:Boolean=true):MovieClip {
			var mc:MovieClip = getDefObj(defName,addToPool) as MovieClip;
			if(mc&&isStop)mc.stop();
			return mc;
		}
		
		public static function getDefDisObj(defName:String,addToPool:Boolean=false):DisplayObject {
			return getDefObj(defName,addToPool) as DisplayObject;
		}
		
		public static function getDefSprite(defName:String,addToPool:Boolean=false):Sprite {
			return getDefObj(defName,addToPool) as Sprite;
		}
		
		public static function getDefBitmapData(defName:String,addToPool:Boolean=false):BitmapData{
			return getDefObj(defName,addToPool) as BitmapData;
		}
		
		public function LibUtil() {
		
		}
		
	};

}