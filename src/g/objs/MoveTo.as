package g.objs{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import framework.Game;
	import framework.UpdateType;
	import framework.objs.GameObject;
	import g.MyData;
	public class MoveTo extends GameObject{
		
		public static function create1(disObj:DisplayObject,targetX:Number,targetY:Number,duration:Number,complete:Function=null,completeParams:Array=null):MoveTo{
			var game:Game=Game.getInstance();
			var info:*={};
			info.target=disObj;
			info.targetX=targetX;
			info.targetY=targetY;
			info.duration=duration;
			info.complete=complete;
			info.completeParams=completeParams;
			return game.createGameObj(new MoveTo(),info) as MoveTo;
		}
		
		public static function create2(body:b2Body,targetX:Number,targetY:Number,duration:Number,complete:Function=null,completeParams:Array=null):MoveTo{
			var game:Game=Game.getInstance();
			var info:*={};
			info.target=body;
			info.targetX=targetX;
			info.targetY=targetY;
			info.duration=duration;
			info.complete=complete;
			info.completeParams=completeParams;
			return game.createGameObj(new MoveTo(),info) as MoveTo;
		}
		
		public function MoveTo(){ super(); }
		
		private var _target:*;
		private var _targetX:Number;
		private var _targetY:Number;
		private var _duration:Number;
		private var _complete:Function;
		private var _completeParams:Array;
		
		private var _vx:Number;
		private var _vy:Number;
		
		private var _x:Number;
		private var _y:Number;
		private var _ox:Number;
		private var _oy:Number;
		private var _totalDistance:Number;
		
		override protected function init(info:*=null):void{
			_target=info.target;
			_targetX=info.targetX;
			_targetY=info.targetY;
			_duration=info.duration;
			_complete=info.complete;
			_completeParams=info.completeParams;
			
			//起点
			_ox=getX();
			_oy=getY();
			
			_x=_ox;
			_y=_oy;
			
			//起点到终点的距离
			var dx:Number=_targetX-_ox;
			var dy:Number=_targetY-_oy;
			_totalDistance=Math.sqrt(dx*dx+dy*dy);
			
			//起点到终点的向量夹角
			var angle:Number=Math.atan2(dy,dx);
			
			//计算移动速度向量
			var dSec:Number=_totalDistance/_duration;//每秒要移动的距离
			var dFrame:Number=dSec/_game.global.stage.frameRate;//每帧要移动的距离
			_vx=Math.cos(angle)*dFrame;
			_vy=Math.sin(angle)*dFrame;
			
		}
		
		override protected function update():void{
			//当前点
			_x+=_vx;
			_y+=_vy;
			
			//起点到当前点的距离
			var dx:Number=_x-_ox;
			var dy:Number=_y-_oy;
			var d:Number=Math.sqrt(dx*dx+dy*dy);
			
			if(d>=_totalDistance){
				_x=_targetX;
				_y=_targetY;
				setPos(_x,_y);
				if(_complete!=null) _complete.apply(null,_completeParams);
				GameObject.destroy(this);
			}else{
				setPos(_x,_y);
			}
		}
		
		private function getX():Number{
			var x:Number;
			if(_target is b2Body)x=_target.GetPosition().x;
			else x=_target.x;
			return x;
		}
		private function getY():Number{
			var y:Number;
			if(_target is b2Body)y=_target.GetPosition().y;
			else y=_target.y;
			return y;
		}
		
		private function setPos(x:Number,y:Number):void{
			if(_target is b2Body){
				_target.SetPosition(b2Vec2.MakeOnce(x,y));
			}else{
				_target.x=x;
				_target.y=y;
			}
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
		}
		
	};

}