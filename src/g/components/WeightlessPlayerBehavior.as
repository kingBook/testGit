package g.components{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.geom.Point;
	import framework.objs.Component;
	import framework.system.KeyboardManager;
	import framework.utils.Box2dUtil;
	import g.Map;
	import g.MyData;
	/**没有重力的玩家*/
	public class WeightlessPlayerBehavior extends Component{
		
		public function WeightlessPlayerBehavior(){
			super();
		}
		
		public function initialize(body:b2Body,upKeys:Vector.<String>,downKeys:Vector.<String>,leftKeys:Vector.<String>,rightKeys:Vector.<String>,speed:Number=5,face:int=1):void{
			_body=body;
			_upKeys=upKeys;
			_downKeys=downKeys;
			_leftKeys=leftKeys;
			_rightKeys=rightKeys;
			_dir=new Point(0,0);
			_speed=speed;
			_face=face;
			
			_km=new KeyboardManager(_game);
			
			_body.SetCustomGravity(new b2Vec2(0,0),true);
			_body.SetFixedRotation(true);
			Box2dUtil.setBodyFixture(_body,NaN,0);
		}
		
		override protected function update():void{
			super.update();
			if(_km.p_keys(_upKeys)){
				_dir.y=-1;
			}else if(_km.p_keys(_downKeys)){
				_dir.y=1;
			}else{
				_dir.y=0;
			}
			if(_km.p_keys(_leftKeys)){
				_dir.x=-1;
				_face=-1;
			}else if(_km.p_keys(_rightKeys)){
				_dir.x=1;
				_face=1;
			}else{
				_dir.x=0;
			}
			
			var tvx:Number=_speed*_dir.x;
			var tvy:Number=_speed*_dir.y;
			
			var map:Map=_game.getGameObjList(Map)[0] as Map;
			var lower:b2Vec2=_body.GetAABB().lowerBound;
			var upper:b2Vec2=_body.GetAABB().upperBound;
			
			if(_dir.x>=0){
				if(upper.x*MyData.ptm_ratio>=map.width-5)tvx=0;
			}else{
				if(lower.x*MyData.ptm_ratio<=5)tvx=0;
			}
			if(_dir.y>=0){
				if(upper.y*MyData.ptm_ratio>=map.height-5)tvy=0;
			}else{
				if(lower.y*MyData.ptm_ratio<=5)tvy=0;
			}
			
			var vx:Number=tvx-_body.GetLinearVelocity().x;
			var vy:Number=tvy-_body.GetLinearVelocity().y;
			
			var i:b2Vec2=b2Vec2.Make(_body.GetMass()*vx,_body.GetMass()*vy);
			_body.ApplyImpulse(i,_body.GetWorldCenter());
				
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
			_km.destroy();
			_km=null;
			_body=null;
			_upKeys=null;
			_downKeys=null;
			_leftKeys=null;
			_rightKeys=null;
			_dir=null;
		}
		
		private var _body:b2Body;
		private var _upKeys:Vector.<String>;
		private var _downKeys:Vector.<String>;
		private var _leftKeys:Vector.<String>;
		private var _rightKeys:Vector.<String>;
		private var _dir:Point;
		private var _face:int;
		private var _km:KeyboardManager;
		private var _speed:Number;
		
		public function get face():int{ return _face; }
		
		public function get km():KeyboardManager{ return _km; }
	};

}