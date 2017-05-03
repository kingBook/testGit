package framework.system{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import flash.events.MouseEvent;
	import framework.Game;
	import framework.UpdateType;
	import framework.namespaces.frameworkInternal;
	import flash.display.DisplayObject;
	use namespace frameworkInternal;
	
	public class Box2dManager{
		public static function create(id:int,worldDisObj:DisplayObject,game:Game,gravity:b2Vec2,box2dDebugVisible:Boolean=false,useMouseJoint:Boolean=false,deltaTime:Number=30,ptm_ratio:Number=30):Box2dManager{
			var box2dMan:Box2dManager=new Box2dManager(worldDisObj,game,useMouseJoint,gravity,box2dDebugVisible,deltaTime,ptm_ratio);
			game.global.addBox2dMan(id,box2dMan);
			return box2dMan;
		}
		
		private var _deltaTime:Number;
		private var _ptm_ratio:Number;
		private var _world:b2World;
		private var _worldDisObj:DisplayObject;
		private var _mj:b2MouseJoint;
		private var _game:Game;
		private var _gravity:b2Vec2;
		private var _box2dDebugVisible:Boolean;
		public function Box2dManager(worldDisObj:DisplayObject,game:Game,useMouseJoint:Boolean,gravity:b2Vec2,box2dDebugVisible:Boolean,deltaTime:Number,ptm_ratio:Number){
			_deltaTime = deltaTime;
			_ptm_ratio = ptm_ratio;
			_worldDisObj = worldDisObj;
			_gravity = gravity;
			_box2dDebugVisible=box2dDebugVisible;
			_game = game;
			//初始wold
			_world = new b2World(_gravity,true);
			//添加刷新侦听
			_game.addUpdate(UpdateType.FIXED,step);
			if (useMouseJoint){
				_game.global.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				_game.addUpdate(UpdateType.UPDATE,update);
				//_game.global.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
				_game.global.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			}
		}

		private function mouseHandler(e:MouseEvent):void{
			var x:Number = _worldDisObj.mouseX;
			var y:Number = _worldDisObj.mouseY;
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					mouseDownHandler(x,y);
					break;
				case MouseEvent.MOUSE_MOVE:
					mouseMoveHandler(x,y);
					break;
				case MouseEvent.MOUSE_UP:
					mouseUpHandler();
					break;
				default:
			}
		}
		
		private function mouseUpHandler():void{
			stopDragBody();
		}
		
		private function update():void{
			var x:Number=_worldDisObj.mouseX;
			var y:Number=_worldDisObj.mouseY;
			mouseMoveHandler(x,y);
		}
		private function mouseMoveHandler(x:Number,y:Number):void{
			if(_mj)_mj.SetTarget(new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
		}
		
		private function mouseDownHandler(x:Number,y:Number):void{
			var b:b2Body=getPosBody(x,y,_world);
			startDragBody(b,x,y);
		}
		public function reset():void{
			if(_mj){
				_world.DestroyJoint(_mj);
				_mj=null;
			}
			clearWorld(_world);
		}
		
		private function clearWorld(world:b2World):void{
			for(var j:b2Joint=world.GetJointList(); j; j=j.GetNext()) world.DestroyJoint(j);
			for(var b:b2Body=world.GetBodyList(); b; b=b.GetNext()) world.DestroyBody(b);
		}
		
		public function step():void{
			//trace("box2dManager step();");
			_world.Step(1/_deltaTime,10,10);
			clearIsDestroyBody();
			_world.ClearForces();
			
			if(_box2dDebugVisible){
				_world.DrawDebugData();
			}
			
		}
		
		private function clearIsDestroyBody():void{
			var b:b2Body=_world.GetBodyList();
			var userData:*;
			for(b;b;b=b.GetNext()){
				userData=b.GetUserData();
				if(userData && userData.isDestroy) _world.DestroyBody(b);
			}
		}
		
		/**返回位置下的刚体*/
		private function getPosBody(x:Number,y:Number,world:b2World):b2Body{
			var b:b2Body;
			world.QueryPoint(function(fixture:b2Fixture):Boolean{
				b=fixture.GetBody();
				return false;
			},new b2Vec2(x/_ptm_ratio,y/_ptm_ratio));
			return b;
		}
		
		/** 开始拖动刚体*/
		private function startDragBody(b:b2Body, x:Number, y:Number):void{
			if (!b || b.GetType()!=b2Body.b2_dynamicBody) return;
			_mj && _world.DestroyJoint(_mj);
			var jointDef:b2MouseJointDef=new b2MouseJointDef();
				jointDef.bodyA = _world.GetGroundBody();
				jointDef.bodyB = b;
				jointDef.target.Set(x/_ptm_ratio,y/_ptm_ratio);
				jointDef.maxForce=1e6;
			_mj = _world.CreateJoint(jointDef) as b2MouseJoint;
		}
		
		private function stopDragBody():void{
			_mj && _world.DestroyJoint(_mj);
		}
		
		public function destroy():void{
			_game.global.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			_game.global.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
			_game.removeUpdate(UpdateType.UPDATE,update);
			_game.global.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			if (_game){
				_game.removeUpdate(UpdateType.FIXED, step);
				_game = null;
			}
			if (_mj){
				_world.DestroyJoint(_mj);
				_mj = null;
			}
			_worldDisObj = null;
			_world = null;
		}
		
		//=========================== setter/getter =========================
		public function get world():b2World{ return _world; }
		
	}

}