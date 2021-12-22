package app{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import framework.Game;
	import framework.objs.GameObject;
	import framework.system.KeyboardManager;
	import framework.utils.Box2dUtil;
	import framework.utils.LibUtil;
	import g.Map;
	import g.MyData;
	import g.components.WeightlessPlayerBehavior;
	import g.objs.Animator;
	import g.objs.MovableObject;
	import Box2D.Common.Math.b2Vec2;

	public class Player extends MovableObject{
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.body=Box2dUtil.createRoundBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio,5,10);
			game.createGameObj(new Player(),info);
		}
		public function Player(){}
		
		override protected function init(info:* = null):void{
			super.init(info);
			_behavior=addComponent(WeightlessPlayerBehavior) as WeightlessPlayerBehavior;
			_behavior.initialize(_body,
			new <String>["W","UP"],
			new <String>["S","DOWN"],
			new <String>["A","LEFT"],
			new <String>["D","RIGHT"],
			5,
			1);
			
			_animator=Animator.create(_game.global.layerMan.items3Layer);
			_animator.addAnimation("fly",LibUtil.getDefMovie("Player_fly"));
			_animator.addAnimation("shoot",LibUtil.getDefMovie("Player_shoot"));
			_animator.addAnimation("death",LibUtil.getDefMovie("Player_death"));
			_animator.setDefaultAnimation("fly");
			_animator.addTransitionCondition(null,"fly",function():Boolean{return   (_flags&e_isDeath)==0&&(_flags&e_isShoot)==0;});
			_animator.addTransitionCondition(null,"shoot",function():Boolean{return (_flags&e_isDeath)==0&&(_flags&e_isShoot)>0;});
			_animator.addTransitionCondition(null,"death",function():Boolean{return (_flags&e_isDeath)>0;});
			
			_km=_behavior.km;
			_shootKeys=new <String>["J","SPACE"];
			
			_bulletCount=25;
			
			_body.SetContactBeginCallback(contactBegin);
			
			var map:Map=_game.getGameObjList(Map)[0] as Map;
			map.camera.bindTargets([_body],true);
		}
		
		override protected function syncView():void{
			super.syncView();
			if(_animator){
				_animator.x=_body.GetPosition().x*MyData.ptm_ratio;
				_animator.y=_body.GetPosition().y*MyData.ptm_ratio;
				_animator.scaleX=Math.abs(_animator.scaleX)*_behavior.face;
				
				var curMc:MovieClip=_animator.curAnimation as MovieClip;
				if(curMc){
					if(_animator.curAniKey=="shoot"){
						if(curMc.currentFrame==curMc.totalFrames){
							_flags&=~e_isShoot;
						}
					}else if(_animator.curAniKey=="death"){
						if(curMc.currentFrame==curMc.totalFrames){
							_animator.visible=false;
							_body.SetActive(false);
							_isDeathFinish=true;
						}
					}
				}
			}
		}
		
		override protected function update():void{
			super.update();
			if((_flags&e_isIntoExit)>0)return;
			if(_km.jp_keys(_shootKeys)){
				shoot();
			}
		}
		
		private function shoot():void{
			if(_bulletCount<=0)return;
			var x:Number=_body.GetPosition().x*MyData.ptm_ratio+_behavior.face*50;
			var y:Number=_body.GetPosition().y*MyData.ptm_ratio+10;
			var bulletBody:b2Body=Box2dUtil.createBox(16,7,x,y,_game.global.curWorld,MyData.ptm_ratio);
			var destroyTypes:Vector.<String>=new <String>["Ground","EdgeGround","FireBird","BulletTouchSwitch"];
			var angleRadian:Number=_behavior.face>=0?0:Math.PI;
			Bullet.create(bulletBody,_body,destroyTypes,angleRadian,15);
			
			_flags|=e_isShoot;
			_bulletCount--;
		}
		
		private function contactBegin(contact:b2Contact,other:b2Body):void{
			var othis:*=other.GetUserData().thisObj;
			if(othis is SupplyPoint){
				var supplyPt:SupplyPoint=othis as SupplyPoint;
				if(!supplyPt.isOpen){
					supplyPt.open();
					addBulletNum(SupplyPoint.ADD_BULLET_NUM);
				}
			}else if(othis is FireBird){
				var fireBird:FireBird=othis as FireBird;
				if(!fireBird.isFreeze){
					deathHandler();
				}
			}else if(othis is Exit){
				_body.SetLinearVelocity(new b2Vec2(0,0));
				_body.SetSensor(true);
				_animator.visible=false;
				_flags|=e_isIntoExit;
				_behavior.enabled=false;
			}
		}
		
		/**添加子弹数*/
		private function addBulletNum(num:int):void{
			_bulletCount+=num;
			if(_bulletCount>_bulletMax){
				_bulletCount=_bulletMax;
			}
		}
		
		private function deathHandler():void{
			if((_flags&e_isDeath)>0)return;
			_flags|=e_isDeath;
			_body.SetLinearVelocity(new b2Vec2(0,0));
			_body.SetSensor(true);
			_behavior.enabled=false;
		}
		
		override protected function onDestroy():void{
			super.onDestroy();
			
			removeComponent(_behavior);
			GameObject.destroy(_animator);
			_behavior=null;
		}
		private const e_isShoot:uint=0x0001;
		private const e_isDeath:uint=0x0002;
		private const e_isIntoExit:uint=0x0004;
		private const _bulletMax:int=25;
		private var _behavior:WeightlessPlayerBehavior;
		private var _animator:Animator;
		private var _km:KeyboardManager;
		private var _shootKeys:Vector.<String>;
		private var _bulletCount:int;
		private var _flags:uint;
		private var _isDeathFinish;
		
		public function get bulletCount():int{ return _bulletCount; }
		public function get isDeathFinish():Boolean{ return _isDeathFinish; }
		public function get isIntoExit():Boolean{return (_flags&e_isIntoExit)>0;}
		
	};
}