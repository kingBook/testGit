package g{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;

	/*地图的相机*/
	public class MapCamera extends EventDispatcher{
		public static const MOVE:String="move";
		public const NONE:uint=0;
		public const POSITION_MODE:uint=1;
		public const TARGET_MODE:uint=2;
		public const CUSTOM_MOVE_MODE:uint=3;
		public static function create(size:Point,mapWidth:Number,mapHeight:Number,cameraTarget:DisplayObject):MapCamera{
			var camera:MapCamera=new MapCamera();
			camera.init(size,mapWidth,mapHeight,cameraTarget);
			return camera;
		}
		
		private const EASING:Number=0.2;
		private var _xmin:int;
		private var _xmax:int;
		private var _ymin:int;
		private var _ymax:int;
		private var _halfSizeX:int;
		private var _halfSizeY:int;
		private var _bindMode:uint=NONE;
		private var _position:Point;
		private var _targetPos:Point;
		private var _size:Point;
		private var _cameraTarget:DisplayObject;
		private var _bindTargets:Array;
		private var _bindTargetsCenter:Point;
		private var _moveEvent:MyEvent;
		public function dispose():void{
			stopCurShake();
			_size=null;
			_position=null;
			_targetPos=null;
			_cameraTarget=null;
			_bindTargets=null;
			_bindTargetsCenter=null;
			_moveEvent=null;
		}
		public function MapCamera(){ super(); }
		
		public function init(size:Point,mapWidth:Number,mapHeight:Number,cameraTarget:DisplayObject):void{
			_size=size;
			_cameraTarget=cameraTarget;
			
			_halfSizeX=_size.x>>1;
			_halfSizeY=_size.y>>1;
			
			_xmin=_halfSizeX;
			_xmax=mapWidth-_halfSizeX;
			_ymin=_halfSizeY;
			_ymax=mapHeight-_halfSizeY;
			
			_position=new Point(_halfSizeX,_halfSizeY);//相机默认在屏幕的中心
		}
		
		/**绑定相机到一个位置上，位置可以每一帧改变, isRightNow:表示立即到这个位置不执行缓动*/
		public function bindPos(x:Number,y:Number,isRightNow:Boolean=false):void{
			x=x>=0?int(x+0.9):int(x-0.9);
			y=y>=0?int(y+0.9):int(y-0.9);
			_targetPos||=new Point();
			_targetPos.x=x;
			_targetPos.y=y;
			if(isRightNow)move(_targetPos.x-_position.x,
							   _targetPos.y-_position.y);
			_bindMode=POSITION_MODE;
		}
		
		/**移动接口*/
		public function move(vx:Number=0,vy:Number=0):void{
			_bindMode=CUSTOM_MOVE_MODE;
			updatePosition(vx,vy);
		}
		
		/**绑定相机到多个目标中心,isRightNow:表示立即到目标中心不执行缓动*/
		public function bindTargets(targets:Array,isRightNow:Boolean=false,isClearTargets:Boolean=true):void{
			_bindTargets||=[];
			if(isClearTargets && _bindTargets.length>0)_bindTargets.splice(0);
			var i:int=targets.length;
			while(--i>=0)_bindTargets.push(targets[i]);
			_bindTargetsCenter||=new Point();
			getTargetsCenter(_bindTargets,_bindTargetsCenter);
			if(isRightNow)move(int(_bindTargetsCenter.x+0.9)-_position.x,
							   int(_bindTargetsCenter.y+0.9)-_position.y);
			_bindMode=TARGET_MODE;
		}
		
		/**调用更新*/
		public function update():void{
			var vx:Number=0, vy:Number=0;
			if(_bindMode==TARGET_MODE){//目标模式
				_bindTargetsCenter||=new Point();
				getTargetsCenter(_bindTargets,_bindTargetsCenter);
				vx=(_bindTargetsCenter.x-_position.x)*EASING;
				vy=(_bindTargetsCenter.y-_position.y)*EASING;
				updatePosition(vx,vy);
			}else if(_bindMode==POSITION_MODE){//位置模式
				vx=(_targetPos.x-_cameraTarget.x)*EASING;
				vy=(_targetPos.y-_cameraTarget.y)*EASING;
				updatePosition(vx,vy);
			}
		}
				
		private function updatePosition(vx:Number,vy:Number):void{
			vx=vx>=0?int(vx+0.9):int(vx-0.9);
			vy=vy>=0?int(vy+0.9):int(vy-0.9);
			if(vx!=0||vy!=0){
				var x:int=int(_position.x)+vx;
				var y:int=int(_position.y)+vy;
				if(x<_xmin)x=_xmin; else if(x>_xmax)x=_xmax;
				if(y<_ymin)y=_ymin; else if(y>_ymax)y=_ymax;
				
				vx=x-_position.x;
				vy=y-_position.y;
				if(vx!=0||vy!=0) dispatchMoveEvent(int(vx),int(vy));
				
				setPosition(x,y);
			}
		}
		
		private function dispatchMoveEvent(vx:int,vy:int):void{
			_moveEvent||=new MyEvent(MOVE,{});
			_moveEvent.info.vx=vx;
			_moveEvent.info.vy=vy;
			dispatchEvent(_moveEvent);
		}
		
		private function setPosition(x:int,y:int):void{
			if(x<_xmin)x=_xmin; else if(x>_xmax)x=_xmax;
			if(y<_ymin)y=_ymin; else if(y>_ymax)y=_ymax;
			_position.x=x;
			_position.y=y;
			_cameraTarget.x=-(_position.x-_halfSizeX);
			_cameraTarget.y=-(_position.y-_halfSizeY);
		}
		
		/**返回多个目标的中心*/
		private function getTargetsCenter(targets:Array,outputPoint:Point):void{
			var i:int=targets.length;
			var x:Number=0;
			var y:Number=0;
			while (--i>=0){
				if(targets[i] is b2Body){
					x+=targets[i].GetPosition().x*MyData.ptm_ratio;
					y+=targets[i].GetPosition().y*MyData.ptm_ratio;
				}else if(targets[i] is DisplayObject){
					x+=targets[i].x;
					y+=targets[i].y;
				}
			}
			outputPoint.x = targets.length>1 ? x>>1 : int(x);
			outputPoint.y = targets.length>1 ? y>>1 : int(y);
		}
		
			
		private var _shakeCount:int;
		private var _shakeMaxDistance:Number;
		private var _isShakeing:Boolean;
		private var _curShakeId:uint;
		private var _shakeTargetInitPos:Point=new Point();
		/**摇动*/
		public function shake(timeSecond:Number=0.5,maxDistance:Number=5):void{
			if(_isShakeing) stopCurShake();
			_isShakeing=true;
			_shakeMaxDistance=maxDistance;
			_shakeTargetInitPos.x=_cameraTarget.parent.x;
			_shakeTargetInitPos.y=_cameraTarget.parent.y;
			var delay:Number=1/MyData.frameRate;
			_shakeCount=int(timeSecond/delay+0.9);
			_curShakeId=flash.utils.setInterval(shakeHandler,delay);
		}
		private function shakeHandler():void{
			var tx:Number=Math.random() * _shakeMaxDistance *(Math.random()>0.5?1:-1);
			var ty:Number=Math.random() * _shakeMaxDistance *(Math.random()>0.5?1:-1);
			_cameraTarget.parent.x=_shakeTargetInitPos.x+tx;
			_cameraTarget.parent.y=_shakeTargetInitPos.y+ty;
			_shakeCount--;
			if(_shakeCount<=0)stopCurShake();
		}
		private function stopCurShake():void{
			flash.utils.clearInterval(_curShakeId);
			_isShakeing=false;
			_cameraTarget.parent.x=_shakeTargetInitPos.x;
			_cameraTarget.parent.y=_shakeTargetInitPos.y;
		}
		
	};

}