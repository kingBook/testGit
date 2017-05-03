package g.components{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import framework.objs.Component;
	import g.MyData;
	/*路径移动*/
	public class PathMoveBehavior extends Component{
		
		public function PathMoveBehavior(){
			super();
		}
		
		public function initialize(body:b2Body,points:Vector.<b2Vec2>/*像素为单位*/,speed:Number=3,isReverse:Boolean=false/*是否反向运动*/):void{
			_points=points;
			_speed=speed;
			_body=body;
			_isReverse=isReverse;
			_body.SetType(b2Body.b2_kinematicBody);
			
			//转换为world单位
			for(var i:int=0;i<_points.length;i++){
				_points[i].Multiply(1/MyData.ptm_ratio);
			}
			
			//设最近点为起点
			var dList:Array=[],pos:b2Vec2=_body.GetPosition();
			i=_points.length;
			while(--i>=0) dList.push({id:i,distance:b2Vec2.Distance(_points[i],pos)});
			dList.sortOn("distance",Array.NUMERIC);
			_curId=dList.length>=2?dList[0].id:0;
		}
		
		override protected function update():void{
			if(_points.length<2)return;
			if(gotoPoint(_points[_curId])){
				if(_isReverse){
					_curId--; if(_curId<0)_curId=_points.length-1;
				}else{
					_curId++; if(_curId>=_points.length)_curId=0;
				}
			}
			super.update();
		}
		
		private function gotoPoint(pos:b2Vec2):Boolean{
			var dx:Number=(pos.x-_body.GetPosition().x)*MyData.ptm_ratio;
			var dy:Number=(pos.y-_body.GetPosition().y)*MyData.ptm_ratio;
			var c:Number=Math.sqrt(dx*dx+dy*dy);
			if(c>_speed){
				var angleRadian:Number=Math.atan2(dy,dx);
				var vx:Number=Math.cos(angleRadian)*_speed;
				var vy:Number=Math.sin(angleRadian)*_speed;
				_body.SetLinearVelocity(new b2Vec2(vx,vy));
				_body.SetAwake(true);
			}else{
				_body.SetLinearVelocity(new b2Vec2(0,0));
				_body.SetPosition(pos);
				return true;
			}
			return false;
		}
		
		override protected function onDestroy():void{
			_points=null;
			_body=null;
			super.onDestroy();
		}
		
		private var _speed:Number;
		private var _curId:int;
		private var _body:b2Body;
		private var _points:Vector.<b2Vec2>;
		private var _isReverse:Boolean;
	};

}