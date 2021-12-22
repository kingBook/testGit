package g.components{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import framework.system.KeyboardManager;
	import framework.utils.Box2dUtil;
	
	/*
	private var _pBehavior:PlayerBehavior;
	
	_pBehavior=addComponent(PlayerBehavior) as PlayerBehavior;
	_pBehavior.initialize(info.body,new <String>["W"],_downKeys,new <String>["A"],new <String>["D"],15,3,1);
	
	_pBehavior.setWalkDisbled(true);//禁止行走
	
	*/
	
	/**玩家行为组件*/
	public class PlayerBehavior extends CharacterBehavior{
		private const e_isPressL:uint=0x000004;
		private const e_isPressR:uint=0x000008;
		private const e_isWalkDisbled:uint=0x000010;
		private const e_isJumpDisbled:uint=0x000020;
		private const e_isWalkDelaying:uint=0x000040;
		private var _upKeys:Vector.<String>;
		private var _downKeys:Vector.<String>;
		private var _leftKeys:Vector.<String>;
		private var _rightKeys:Vector.<String>;
		private var _km:KeyboardManager;
		private var _jumpForce:Number;
		private var _walkSpeed:Number;
		private var _dirX:int;
		public function PlayerBehavior(){
			super();
		}
		
		public function initialize(body:b2Body,upKeys:Vector.<String>,downKeys:Vector.<String>,leftKeys:Vector.<String>,rightKeys:Vector.<String>,
								   jumpForce:Number,walkSpeed:Number,dirX:int=1):void{
			_body=body;
			_body.SetFixedRotation(true);
			_body.SetIsIgnoreFrictionY(true);
			_body.SetAllowBevelSlither(false);
			Box2dUtil.setBodyFixture(_body,NaN,0.5);
			
			_upKeys=upKeys;
			_downKeys=downKeys;
			_leftKeys=leftKeys;
			_rightKeys=rightKeys;
			_jumpForce=jumpForce;
			_walkSpeed=walkSpeed;
			_dirX=dirX;
			_km=new KeyboardManager(_game);
		}
		
		override protected function update():void{
			super.update();
			if((_flags&e_isWalkDelaying)>0){
				walk(_dirX*_walkSpeed);
			}else{
				if(_km.jp_keys(_upKeys)){
					if((_flags&e_isJumpDisbled)==0){
						jump(_jumpForce);
					}
				}
				
				if(_km.p_keys(_leftKeys)){
					if((_flags&e_isWalkDisbled)==0){
						_dirX=-1;
						walk(-_walkSpeed);
					}
					_flags|=e_isPressL;
					_flags&=~e_isPressR;
				}else if(_km.p_keys(_rightKeys)){
					if((_flags&e_isWalkDisbled)==0){
						_dirX=1;
						walk(_walkSpeed);
					}
					_flags|=e_isPressR;
					_flags&=~e_isPressL;
					
				}else{
					_flags&=~e_isPressL;
					_flags&=~e_isPressR;
				}
				
				/**在空中没按左右键，添加x移动向量摩擦*/
				if((_flags&e_isInAir)>0 && (_flags&(e_isPressL|e_isPressR))==0){
					var v:b2Vec2=_body.GetLinearVelocity();
					v.x*=0.1;
					_body.SetLinearVelocity(v);
				}
			}
		}
		
		public function walkDelay(dirX:int,delay:Number):void{
			if((_flags&e_isWalkDelaying)>0)return;
			_flags|=e_isWalkDelaying;
			_dirX=dirX;
			scheduleOnce(endWalkDelay,delay);
		}
		private function endWalkDelay():void{
			_flags&=~e_isWalkDelaying;
		}
		
		override protected function onDestroy():void{
			unschedule(endWalkDelay);
			if(_km){
				_km.destroy();
				_km=null;
			}
			super.onDestroy();
		}
		
		public function setWalkDisbled(disbled:Boolean):void{
			if(disbled) _flags|=e_isWalkDisbled;
			else        _flags&=~e_isWalkDisbled;
		}
		public function setJumpDisbled(disbled:Boolean):void{
			if(disbled) _flags|=e_isJumpDisbled;
			else        _flags&=~e_isJumpDisbled;
		}
		
		public function get upKeys():Vector.<String>{return _upKeys;}
		public function get downKeys():Vector.<String>{return _downKeys;}
		public function get leftKeys():Vector.<String>{return _leftKeys;}
		public function get rightKeys():Vector.<String>{return _rightKeys;}
		public function get km():KeyboardManager{ return _km; }
		public function get isPressLR():Boolean{ return (_flags&(e_isPressL|e_isPressR))>0; }
		public function get isPressL():Boolean{ return (_flags&e_isPressL)>0; }
		public function get isPressR():Boolean{ return (_flags&e_isPressR)>0; }
		public function get dirX():int{return _dirX;}
		public function get isWalkDisbled():Boolean{return (_flags&e_isWalkDisbled)>0;}
		public function get isWalkDelaying():Boolean{return (_flags&e_isWalkDelaying)>0;}
		
	};

}