/*[IF-FLASH-BEGIN]*/
package g{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	public dynamic class Assets extends EventDispatcher{
		[Embed(source = '../../bin/assets/Hit_mc_1.xml', mimeType='application/octet-stream')]
		private const _XML_1:Class;
		[Embed(source = '../../bin/assets/Hit_mc_2.xml', mimeType='application/octet-stream')]
		private const _XML_2:Class;
		[Embed(source = '../../bin/assets/Hit_mc_3.xml', mimeType='application/octet-stream')]
		private const _XML_3:Class;
		[Embed(source = '../../bin/assets/Hit_mc_4.xml', mimeType='application/octet-stream')]
		private const _XML_4:Class;
		[Embed(source = '../../bin/assets/Hit_mc_5.xml', mimeType='application/octet-stream')]
		private const _XML_5:Class;
		[Embed(source = '../../bin/assets/Hit_mc_6.xml', mimeType='application/octet-stream')]
		private const _XML_6:Class;
		[Embed(source = '../../bin/assets/Hit_mc_7.xml', mimeType='application/octet-stream')]
		private const _XML_7:Class;
		[Embed(source = '../../bin/assets/Hit_mc_8.xml', mimeType='application/octet-stream')]
		private const _XML_8:Class;
		[Embed(source = '../../bin/assets/Hit_mc_9.xml', mimeType='application/octet-stream')]
		private const _XML_9:Class;
		[Embed(source = '../../bin/assets/Hit_mc_10.xml', mimeType='application/octet-stream')]
		private const _XML_10:Class;
		[Embed(source = '../../bin/assets/Hit_mc_11.xml', mimeType='application/octet-stream')]
		private const _XML_11:Class;
		[Embed(source = '../../bin/assets/Hit_mc_12.xml', mimeType='application/octet-stream')]
		private const _XML_12:Class;
		[Embed(source = '../../bin/assets/Hit_mc_13.xml', mimeType='application/octet-stream')]
		private const _XML_13:Class;
		[Embed(source = '../../bin/assets/Hit_mc_14.xml', mimeType='application/octet-stream')]
		private const _XML_14:Class;
		[Embed(source = '../../bin/assets/Hit_mc_15.xml', mimeType='application/octet-stream')]
		private const _XML_15:Class;
		/*[Embed(source = '../../bin/assets/Hit_mc_16.xml', mimeType='application/octet-stream')]
		private const _XML_16:Class;
		[Embed(source = '../../bin/assets/Hit_mc_17.xml', mimeType='application/octet-stream')]
		private const _XML_17:Class;
		[Embed(source = '../../bin/assets/Hit_mc_18.xml', mimeType='application/octet-stream')]
		private const _XML_18:Class;
		[Embed(source = '../../bin/assets/Hit_mc_19.xml', mimeType='application/octet-stream')]
		private const _XML_19:Class;
		[Embed(source = '../../bin/assets/Hit_mc_20.xml', mimeType='application/octet-stream')]
		private const _XML_20:Class;*/
		
		/*[Embed(source="../../bin/assets/1.tmx", mimeType="application/octet-stream")]
		private const _TMX_1:Class;*/
		
		private function init():void{
			trace("init assets");
			new SwcClassConfig();
			setTimeout(loaded,1);
		}
		
		private function loaded(e:Event=null):void{
			e && e.target.removeEventListener(Event.COMPLETE, loaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getMapXML(level:int):XML{
			var __XMLClass:Class = this["_XML_" + level];
			if(__XMLClass) return XML(new __XMLClass());
			
			trace("没有嵌入XML_"+level);
			return null;
		}
		
		public function getMapTmx(level:int):XML{
			var C:Class=this["_TMX_"+level];
			if(C)return XML(new C());
			trace("没有嵌入 "+level+".tmx");
			return null;
		}
		
		public function Assets(single:Single){ if (!single) throw new Error("单例");}
		private static var _instance:Assets;
		public static function getInstance():Assets{
			if (_instance == null){
				_instance = new Assets(new Single());
				_instance.init();
			}
			return _instance ;
		}
		
	};

}
class Single {};
/*[IF-FLASH-END]*/
