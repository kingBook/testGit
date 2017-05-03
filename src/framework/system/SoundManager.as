package framework.system{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.ApplicationDomain;
	import framework.events.FrameworkEvent;
	import flash.events.EventDispatcher;

	public class SoundManager extends EventDispatcher{
		
		public static function create():SoundManager{
			return new SoundManager();
		}
		
		private var _instances:Object;
		private var _soundList:*;
		private var _mute:Boolean;
		private var _muteEvent:FrameworkEvent;
		
		public function SoundManager(){
			_soundList={};
			_instances={};
		}
		
		/**一次性播放*/
		public function play(name:String,volume:Number=1,startTime:Number=0,allowMultiple:Boolean=false):SoundInstance{
			var si:SoundInstance=getSoundInstance(name);
			si.play(startTime,volume,allowMultiple,1);
			si.mute=_mute;
			return si;
		}
		
		/**不允许重复且循环的播放一个声音*/
		public function playLoop(name:String,volume:Number=1,startTime:Number=0):SoundInstance{
			var si:SoundInstance=getSoundInstance(name);
			si.play(startTime,volume,false,int.MAX_VALUE);
			si.mute=_mute;
			return si;
		}
		
		/**停止一个声音*/
		public function stop(name:String,onlyCurPlaying:Boolean=false):SoundInstance{
			var si:SoundInstance=getSoundInstance(name);
			si.stop(onlyCurPlaying);
			return si;
		}
		
		/**停止所有声音*/
		public function stopAll():void{
			var si:SoundInstance;
			for(var name:String in _instances){
				si=_instances[name] as SoundInstance;
				si.stop(true);
			}
		}
		
		/**暂停一个声音*/
		public function pause(name:String):SoundInstance{
			var si:SoundInstance=getSoundInstance(name);
			si.pause();
			return si;
		}
		
		/**暂停所有声音*/
		public function pauseAll():void{
			var si:SoundInstance;
			for(var name:String in _instances){
				si=_instances[name] as SoundInstance;
				si.pause();
			}
		}
		
		/**恢复播放一个暂停的声音*/
		public function resume(name:String):SoundInstance{
			var si:SoundInstance=getSoundInstance(name);
			si.resume();
			return si;
		}
		
		/**恢复播放所有暂停的声音*/
		public function resumeAll():void{
			var si:SoundInstance;
			for(var name:String in _instances){
				si=_instances[name] as SoundInstance;
				si.resume();
			}
		}
		
		public function addSoundInstance(name:String,sound:Sound):SoundInstance{
			if(_instances[name]){
				trace("警告：已经存在声音实例"+name+",此次添加失败");
				return null;
			}
			var si:SoundInstance=new SoundInstance(sound);
			_instances[name]=si;
			return si;
		}
		
		public function getSoundInstance(name:String):SoundInstance{
			var si:SoundInstance=_instances[name];
			if(si==null){
				var sound:Sound;
				var domain:ApplicationDomain=ApplicationDomain.currentDomain;
				if(domain.hasDefinition(name))sound=new (domain.getDefinition(name)) as Sound;
				if(sound){ 
					si=addSoundInstance(name,sound);
				}else{
					if(_soundList)sound=_soundList[name] as Sound;
					if(sound==null)throw new Error("找不到声音:"+name);
				}
			}
			return si;
		}
		
		public function set mute(value:Boolean):void{
			_mute=value;
			var si:SoundInstance;
			for(var name:String in _instances){
				si=_instances[name] as SoundInstance;
				si.mute=_mute;
			}
			_muteEvent||=new FrameworkEvent(FrameworkEvent.MUTE,{});
			_muteEvent.info.mute=_mute;
			dispatchEvent(_muteEvent);
		}
		
		public function get mute():Boolean{return _mute;}
		
	};

}