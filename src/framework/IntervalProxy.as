package framework{
	import flash.utils.clearInterval;
	import framework.events.FrameworkEvent;
	import framework.namespaces.frameworkInternal;
	import iflash.utils.LayaDictionary;
	use namespace frameworkInternal;
	/**延时调度代理*/
	public class IntervalProxy{
		
		private var _game:Game;
		private var _scheduleDict:LayaDictionary;
		
		public function IntervalProxy(game:Game){
			_game=game;
			_game.addEventListener(FrameworkEvent.PAUSE,pauseRoResumeHandler);
			_game.addEventListener(FrameworkEvent.RESUME,pauseRoResumeHandler);
			_scheduleDict=new LayaDictionary();
		}
		
		/**指定的间隔(interval 秒)，重复调度(repeat+1)次函数*/
		frameworkInternal function schedule(func:Function,interval:Number,repeat:int,params:Array=null):void{
			if(isHasSchdule(func))return;
			if(repeat<0)throw new Error("参数repeat不能小于0");
			var schduleObj:ScheduleObject=new ScheduleObject(removeScheduleObject,func,interval,repeat,params);
			schduleObj.schedule();
			_scheduleDict.set(func,schduleObj);
		}
		private function removeScheduleObject(func:Function):void{
			_scheduleDict.remove(func);
		}
		
		/**指定的间隔(delay 秒)，调度一次函数*/
		frameworkInternal function scheduleOnce(func:Function,delay:Number=0,params:Array=null):void{
			schedule(func,delay,0,params);
		}
		
		/**移除函数调度*/
		frameworkInternal function unschedule(func:Function):void{
			if(!isHasSchdule(func))return;
			var schduleObj:ScheduleObject=_scheduleDict.get(func) as ScheduleObject;
			schduleObj.unschedule();
		}
		
		/**判断指定函数是否正在调度中*/
		frameworkInternal function isHasSchdule(func:Function):Boolean{
			return _scheduleDict.contains(func);
		}
		
		private function pauseRoResumeHandler(e:FrameworkEvent):void{
			var isPause:Boolean=e.type==FrameworkEvent.PAUSE;
			var scheduleObjs:Array=_scheduleDict.elements;
			var i:int=scheduleObjs.length;
			while (--i>=0){
				if(isPause)ScheduleObject(scheduleObjs[i]).pauseSchedule();
				else ScheduleObject(scheduleObjs[i]).resumeSchedule();
			}
		}
		
	};

}
import flash.utils.clearInterval;
import flash.utils.setInterval;
import framework.namespaces.frameworkInternal;
use namespace frameworkInternal;
class ScheduleObject{
	private var _removeCallback:Function;
	private var _func:Function;
	private var _interval:Number;
	private var _repeat:int;
	private var _params:Array;
	
	private var _id:uint=0;
	
	private var _repeatCount:int;
	
	public function ScheduleObject(removeCallback:Function,func:Function,interval:Number,repeat:int,params:Array=null){
		_removeCallback=removeCallback;
		_func=func;
		_interval=interval; if(_interval<0)_interval=0;
		_repeat=repeat;
		_params=params;
	}
	
	frameworkInternal function pauseSchedule():void{
		unschedule(false);
	}
	
	frameworkInternal function resumeSchedule():void{
		schedule();
	}
	
	frameworkInternal function unschedule(isRemove:Boolean=true):void{
		clearInterval(_id);
		if(isRemove)_removeCallback.call(null,_func);
	}
	
	frameworkInternal function schedule():void{
		_id=setInterval(scheduleCallback,_interval*1000);
	}
	
	private function scheduleCallback():void{
		_repeatCount++;
		if(_repeatCount>_repeat){
			clearInterval(_id);
			_removeCallback.call(null,_func);
		}
		_func.apply(null,_params);
	}
}