package app{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import framework.Game;
	import framework.objs.Clip;
	import g.components.BulletBehavior;
	import g.objs.MovableObject;
	public class Bullet extends MovableObject{
		public static function create(body:b2Body,shooter:b2Body,destroyTypes:Vector.<String>,
									  angleRadian:Number, speed:Number,sensorTypes:Vector.<String>=null):Bullet{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=body;
			info.shooter=shooter;
			info.destroyTypes=destroyTypes;
			info.angleRadian=angleRadian;
			info.speed=speed;
			info.sensorTypes=sensorTypes;
			info.view=Clip.fromDefName("Bullet_view",true);
			info.viewParent=game.global.layerMan.items2Layer;
			return game.createGameObj(new Bullet(),info)as Bullet;
		}
		
		public function Bullet(){
			super();
		}
		
		
		override protected function syncView():void{
			super.syncView();
			if(_behavior){
				_view.rotation=_behavior.angleRadian*57.3;
			}
		}
		
		override protected function init(info:* = null):void{
			super.init(info);
			_behavior=addComponent(BulletBehavior) as BulletBehavior;
			_behavior.initialize(info.body,info.shooter,info.destroyTypes,info.angleRadian,info.speed,info.sensorTypes,hitDestroyHandler);
			_body.SetPreSolveCallback(preSolve);
			_body.SetContactBeginCallback(contactBegin);
		}
		
		private function contactBegin(contact:b2Contact,other:b2Body):void{
			_behavior.contactBegin(contact,other);
		}
		
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold,other:b2Body):void{
			
			_behavior.preSlove(contact,oldManifold,other);
		}
		
		private function hitDestroyHandler(otype:String,othis:*):void{
			if(othis is FireBird){
				var fireBird:FireBird=othis as FireBird;
				fireBird.freeze();
			}else if(othis is BulletTouchSwitch){
				var bulletTouchSwitch:BulletTouchSwitch=othis as BulletTouchSwitch;
				bulletTouchSwitch.control(false,true);
			}
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
			removeComponent(_behavior);
			_behavior=null;
		}
		
		private var _behavior:BulletBehavior;
		
	};

}