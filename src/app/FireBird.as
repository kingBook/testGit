package app{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import framework.utils.LibUtil;
	import g.MyData;
	import g.components.PathMoveBehavior;
	import g.objs.Animator;
	import g.objs.MovableObject;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	
	public class FireBird extends MovableObject{
		
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			
			try{
			var points:Vector.<b2Vec2>=new Vector.<b2Vec2>();
			for(var i:int=0;i<childMc.path.length;i++){
				var stri:String=childMc.path[i];
				var strxy:Array=stri.split(",");
				points[i]=new b2Vec2(Number(strxy[0]),Number(strxy[1]));
			}
			}catch(err:Error){
				
				trace("error:",childMc.x,childMc.y);
				trace(childMc.path);
			}
			
			var info:*={};
			//info.body=Box2dUtil.createRoundBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio,5,10);
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			info.points=points;
			info.isReverse=Boolean(childMc.isReverse);
			game.createGameObj(new FireBird(),info);
		}
		
		public function FireBird(){
			super();
		}
		
		override protected function init(info:* = null):void{
			super.init(info);
			
			_body.SetSensor(true);
			_body.SetCustomGravity(new b2Vec2(0,0));
			_body.SetFixedRotation(true);
			_body.SetContactBeginCallback(contactBegin);
			
			_behavior=addComponent(PathMoveBehavior) as PathMoveBehavior;
			_behavior.initialize(_body,info.points,3,info.isReverse);
			
			_animator=Animator.create(_game.global.layerMan.items3Layer);
			_animator.addAnimation("fly",LibUtil.getDefMovie("FireBird_fly"));
			_animator.addAnimation("freeze",LibUtil.getDefMovie("FireBird_freeze"));
			_animator.addAnimation("broken",LibUtil.getDefMovie("FireBird_broken"));
			_animator.setDefaultAnimation("fly");
			
			_animator.addTransitionCondition(null,"fly",function():Boolean{return (_flags&e_isBroken)==0&&(_flags&e_isFreeze)==0;});
			_animator.addTransitionCondition(null,"freeze",function():Boolean{return (_flags&e_isBroken)==0&&(_flags&e_isFreeze)>0;});
			_animator.addTransitionCondition(null,"broken",function():Boolean{return (_flags&e_isBroken)>0;});
			
			
		}
		
		override protected function syncView():void{
			super.syncView();
			if(_animator){
				_animator.x=_body.GetPosition().x*MyData.ptm_ratio;
				_animator.y=_body.GetPosition().y*MyData.ptm_ratio;
				
				var clip:MovieClip=_animator.curAnimation as MovieClip;
				if(_animator.curAniKey=="freeze"){
					if(clip.currentFrame==clip.totalFrames){
						clip.stop();
						_body.SetCustomGravity(null);
						_body.SetType(b2Body.b2_dynamicBody);//结冰最后一帧开始下落
						_body.SetAwake(true);
					}
				}else if(_animator.curAniKey=="broken"){
					if(clip.currentFrame==clip.totalFrames){
						destroy(this);
					}
				}
			}
		}
		
		private function contactBegin(contact:b2Contact,other:b2Body):void{
			var othis:*=other.GetUserData().thisObj;
			var otype:String=other.GetUserData().type;
			if((_flags&e_isFreeze)>0&&_body.GetType()==b2Body.b2_dynamicBody){
				if(otype=="Ground"){
					broken();
					_body.SetLinearVelocity(new b2Vec2(0,0));
					_body.SetCustomGravity(new b2Vec2(0,0));
				}
			}
		}
		
		/**结冰*/
		public function freeze():void{
			if((_flags&e_isFreeze)>0)return;
			_flags|=e_isFreeze;
			
			_behavior.enabled=false;
			_body.SetLinearVelocity(new b2Vec2(0,0));
			_body.SetSensor(true);
			
		}
		
		/**破碎*/
		private function broken():void{
			if((_flags&e_isBroken)>0)return;
			_flags|=e_isBroken;
			
		}
		
		override protected function onDestroy():void{
			if(_animator)destroy(_animator);
			_animator=null;
			super.onDestroy();
		}
		
		private const e_isFreeze:uint=0x0001;
		private const e_isBroken:uint=0x0002;
		private var _flags:uint;
		
		private var _behavior:PathMoveBehavior;
		private var _animator:Animator;
		
		public function get isFreeze():Boolean{return (_flags&e_isFreeze)>0;}
		
		
	};

}