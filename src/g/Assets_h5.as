package g{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	public dynamic class Assets_h5 extends EventDispatcher{
		private var _pathList:Array=[
			"assets/Hit_mc_1.xml",
			"assets/Hit_mc_2.xml",
			"assets/Hit_mc_3.xml",
			"assets/Hit_mc_4.xml",
			"assets/Hit_mc_5.xml",
			"assets/Hit_mc_6.xml",
			"assets/Hit_mc_7.xml",
			"assets/Hit_mc_8.xml",
			"assets/Hit_mc_9.xml",
			"assets/Hit_mc_10.xml",
			"assets/Hit_mc_11.xml",
			"assets/Hit_mc_12.xml",
			"assets/Hit_mc_13.xml",
			"assets/Hit_mc_14.xml",
			"assets/Hit_mc_15.xml",
////////////////////////////////////////////////////////
			//"assets/1.tmx",
////////////////////////////////////////////////////////
			"assets/levels.swf",
			"assets/ui.swf",
			"assets/views.swf",
////////////////////////////////////////////////////////
			"assets/Sound_title.mp3",
			"assets/Sound_bg.mp3",
			"assets/Sound_win.mp3",
			"assets/Sound_failure.mp3"
		];
		
		private var _pathId:int=0;
		private var _lc:LoaderContext;
		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _xmlList:Array=[];
		private var _tmxList:Array=[];
		private var _sound:Sound;
		private var _soundList:Object={};
		
		private function init():void{
			_lc = new LoaderContext(true, ApplicationDomain.currentDomain);
			_loader=new Loader();
			_urlLoader=new URLLoader();
			IFlash.preSwfAssets(_pathList);//这里开始调用预加载
			loadHandler();
		}
		
		private function loadHandler():void{
			var path:String=_pathList[_pathId];
			if(path.lastIndexOf(".swf")>-1){
				if(_pathId==_pathList.length-1)_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, allLoaded);
				else _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
				_loader.load(new URLRequest(path),_lc);
			}else if(path.lastIndexOf(".mp3")>-1){
				_sound=new Sound();
				if(_pathId==_pathList.length-1)_sound.addEventListener(Event.COMPLETE, allLoaded);
				else _sound.addEventListener(Event.COMPLETE,loaded);
				_sound.load(new URLRequest(path));
			}else{
				_urlLoader.dataFormat="text";
				if(_pathId==_pathList.length-1)_urlLoader.addEventListener(Event.COMPLETE, allLoaded);
				else _urlLoader.addEventListener(Event.COMPLETE,loaded);
				_urlLoader.load(new URLRequest(path));
			}
		}
		
		private function loaded(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE, loaded);
			saveBytesAssets(e.target,_pathList[_pathId]);
			if(_pathId<_pathList.length-1){
				_pathId++;
				loadHandler();
			}
		}
		
		private function allLoaded(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE, allLoaded);
			saveBytesAssets(e.target,_pathList[_pathId]);
			dispatchEvent(new Event(Event.COMPLETE));
			_lc=null;
			_urlLoader=null;
			_sound=null;
			_pathId=0;
		}
		
		private function saveBytesAssets(eventTarget:*,curPath:String):void{
			if(eventTarget is URLLoader){
				var urlLoader:URLLoader=eventTarget as URLLoader;
				if(curPath.lastIndexOf(".xml")>-1){//保存xml到_xmlList
					var id:int=int(curPath.substring(curPath.lastIndexOf("_")+1,curPath.lastIndexOf(".xml")));
					_xmlList[id]=urlLoader.data;
				}else if(curPath.lastIndexOf(".tmx")>-1){
					id=int(curPath.substring(curPath.lastIndexOf("\/")+1,curPath.lastIndexOf(".tmx")));
					_tmxList[id]=urlLoader.data;
				}
			}else if(eventTarget is Sound){//保存声音到_soundList
				var idStr:String=curPath.substring(curPath.indexOf("\/")+1,curPath.lastIndexOf("."));
				_soundList[idStr]=eventTarget as Sound;
			}
		}
		
		public function getMapXML(level:int):XML{
			if(level>=_xmlList.length)return;
			return _xmlList[level];
		}
		
		public function getMapTmx(level:int):XML{
			if(level>=_tmxList.length)return;
			return _tmxList[level];
		}
		
		public function getSound(idStr:String):Sound{
			return _soundList[idStr] as Sound;
		}
		public function getSoundList():*{return _soundList;}
		
		public function Assets_h5(single:Single){
			if (!single) throw new Error("单例");
		}
		private static var _instance:Assets_h5;
		public static function getInstance():Assets_h5{
			if (_instance == null){
				_instance = new Assets_h5(new Single());
				_instance.init();
			}
			return _instance ;
		}
	};

}
class Single {};


