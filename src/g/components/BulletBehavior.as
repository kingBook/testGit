package g.components{
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import framework.objs.Component;
	import framework.objs.GameObject;
	/*
	private var _behavior:BulletBehavior;
	override protected function init(info:* = null):void{
		super.init(info);
		var destroyTypes:Vector.<String>=new <String>["Ground","Door","Rabbit"];
		var sensorTypes:Vector.<String>=new <String>["Rabbit"];
		_behavior=addComponent(BulletBehavior) as BulletBehavior;
		_behavior.initialize(_body,info.shooter,destroyTypes,info.angleRadian,20,sensorTypes,hitDestroyCallback);
		_body.SetPreSolveCallback(preSolve);
		_body.setContactBegin(contactBegin);
	}
	private function hitDestroyCallback(otype:String,othis:*):void{
		if(othis is Rabbit){
			var rabbit:Rabbit=Rabbit(othis);
			trace("rabbit is death~!");
		}
	}
	
	private function contactBegin(contact:b2Contact,other:b2Body):void{
		_behavior.contactBegin(contact,other);
	}
	
	private function preSolve(contact:b2Contact,oldManifold:b2Manifold,other:b2Body):void{
		_behavior.preSlove(contact,oldManifold,other);
	}
	
	override protected function onDestroy():void{
		removeComponent(_behavior);
		_behavior=null;
		super.onDestroy();
	}
	*/
	/**子弹行为组件*/
	public class BulletBehavior extends Component{
		
		public function BulletBehavior(){
			super();
		}
		
		/**
		 * 初始化函数
		 * @param	body
		 * @param	shooter 发射的人将忽略与其的碰撞
		 * @param	destroyTypes 销毁的类型
		 * @param	angleRadian 运动的角度弧
		 * @param	speed 运动的速度
		 * @param	sensorTypes 过滤的碰撞类型
		 * @param	hitDestroyCallback //function (otype:String,othis:*):void;
		 */
		public function initialize(body:b2Body,shooter:b2Body,destroyTypes:Vector.<String>,angleRadian:Number,speed:Number,sensorTypes:Vector.<String>=null,hitDestroyCallback:Function=null):void{
			_shooter=shooter
			_hitDestroyCallback=hitDestroyCallback;
			_destroyTypes=destroyTypes;
			_sensorTypes=sensorTypes;
			_angleRadian=angleRadian;
			_speed=speed;
			_body=body;
			_body.SetBullet(true);
			_body.SetType(b2Body.b2_dynamicBody);
			_body.SetCustomGravity(new b2Vec2(0,0));
			_body.SetLinearVelocity(b2Vec2.MakeFromAngle(_angleRadian,speed,true));
		}
		
		public function contactBegin(contact:b2Contact,other:b2Body):void{
			var otype:String=other.GetUserData().type;
			var othis:*=other.GetUserData().thisObj;
			if(_destroyTypes.indexOf(otype)>-1){
				if(_gameObject){
					if(_hitDestroyCallback!=null)_hitDestroyCallback(otype,othis);
					_body.SetPreSolveCallback(null);
					_body.SetContactBeginCallback(null);
					GameObject.destroy(_gameObject);
				}
			}
		}
		
		public function preSlove(contact:b2Contact,oldManifold:b2Manifold,other:b2Body):void{
			if(!contact.IsTouching())return;
			var otype:String=other.GetUserData().type;
			var othis:*=other.GetUserData().thisObj;
			if(other==_shooter){
				contact.SetSensor(true);
			}else if(_sensorTypes!=null&&_sensorTypes.indexOf(otype)>-1){
				contact.SetSensor(true);
			}
			
		}
		
		override protected function onDestroy():void{
			_body=null;
			_hitDestroyCallback=null;
			_destroyTypes=null;
			_sensorTypes=null;
			super.onDestroy();
		}
		
		private var _body:b2Body;
		private var _sensorTypes:Vector.<String>;
		private var _destroyTypes:Vector.<String>;
		private var _angleRadian:Number;
		private var _speed:Number;
		private var _hitDestroyCallback:Function;
		private var _shooter:b2Body;
		
		public function get angleRadian():Number{ return _angleRadian; }
		
		
	};

}