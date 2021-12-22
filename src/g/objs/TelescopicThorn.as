package g.objs{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import framework.Game;
	import framework.UpdateType;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.objs.GameObject;
	import framework.utils.Box2dUtil;
	import framework.utils.FuncUtil;
	import g.MyData;
	import g.MyEvent;
	import g.MyObj;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Collision.b2Manifold;

	/**伸缩的刺*/
	public class TelescopicThorn extends MyObj{
		private static var _delayer_open:Delayer;//所有初始状态为"打开"的使用
		private static var _delayer_close:Delayer;//所有初始状态为"关闭"的使用
		private static var _isListenerDestroyAll:Boolean;
		private static function destroyAll(e:FrameworkEvent):void{
			e.target.removeEventListener(FrameworkEvent.DESTROY_ALL,destroyAll);
			_isListenerDestroyAll=false;
			_delayer_close=null;
			_delayer_open=null;
		}
		public static function create(childMc:MovieClip,clipADefName:String=null,clipBDefName:String=null):void{
			var nameList:Array=childMc.name.split("_");
			//[0] 名称
			//[1] 初始是否伸出
			var game:Game=Game.getInstance();
			
			var clipA:Sprite=new Sprite();
			var clipB:Sprite=new Sprite();
			if(clipADefName){
				var clip_a:Clip=Clip.fromDefName(clipADefName,true);
				clipA.addChild(clip_a);
			}
			
			if(clipBDefName){
				var clip_b:Clip=Clip.fromDefName(clipBDefName,true);
				clipB.addChild(clip_b);
			}
			
			var info:*={};
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			info.clipA=clipA;
			info.clipB=clipB;
			info.clipA.transform = childMc.transform;
			info.clipB.transform = childMc.transform;
			
			info.isOut=Boolean(int(nameList[1]));
			info.long=FuncUtil.getTransformWidth(childMc);
			info.transformHeight=FuncUtil.getTransformHeight(childMc);
			info.speed=10;
			info.isUseSyncDelayer=true;
			info.delayTime=1.5;
			game.createGameObj(new TelescopicThorn(),info);
		}
		
		public function TelescopicThorn(){
			super();
		}
		
		private var _body:b2Body;
		private var _clipA:Sprite;//主体
		private var _clipB:Sprite;//底座
		private var _isOut:Boolean;//是否伸出
		private var _transformWidth:Number;
		private var _transformHeight:Number;
		private var _speed:Number;
		private var _initPos:b2Vec2;
		private var _maskShape:flash.display.Shape;
		private var _myDelayer:Delayer;
		private var _isGotoEnd:Boolean;
		private var _isUseSyncDelayer:Boolean;//是否为所有刺使用同步的延时器
		private var _isFirst:Boolean=false;//第一次运行时不延时
		private var _delayTime:Number;
		
		override protected function init(info:* = null):void{
			_body=info.body;
			_body.SetType(b2Body.b2_kinematicBody);
			_body.SetUserData({thisObj:this,type:"TelescopicThorn"});
			_body.SetPreSolveCallback(preSolve);
			_clipA=info.clipA;
			_clipB=info.clipB;
			_isOut=info.isOut;
			_transformWidth=info.long;
			_transformHeight=info.transformHeight;
			_speed=info.speed;
			_delayTime=info.delayTime;
			_isUseSyncDelayer=info.isUseSyncDelayer;
			
			_initPos=new b2Vec2(_body.GetPosition().x + Math.cos(_body.GetAngle()+Math.PI)*_transformWidth/MyData.ptm_ratio*0.5,
							    _body.GetPosition().y + Math.sin(_body.GetAngle()+Math.PI)*_transformWidth/MyData.ptm_ratio*0.5);
			
			if(_clipB){
				if(_clipB is Clip)Clip(_clipB).smoothing=true;
				_clipB.x=_initPos.x*MyData.ptm_ratio;
				_clipB.y=_initPos.y*MyData.ptm_ratio;
			}
			if(!_isOut){
				var x:Number=Math.cos(_body.GetAngle()+Math.PI)*_transformWidth/MyData.ptm_ratio;
				var y:Number=Math.sin(_body.GetAngle()+Math.PI)*_transformWidth/MyData.ptm_ratio;
				_body.SetPosition(b2Vec2.MakeOnce(x,y));
			}
			_isGotoEnd=true;
			if(_clipA){
				if(_clipA is Clip)Clip(_clipA).smoothing=true;
				var maskX:Number=_initPos.x + Math.cos(_body.GetAngle())*_transformWidth/MyData.ptm_ratio*0.5;
				var maskY:Number=_initPos.y + Math.sin(_body.GetAngle())*_transformWidth/MyData.ptm_ratio*0.5;
				_maskShape = createShape(maskX*MyData.ptm_ratio,maskY*MyData.ptm_ratio,_transformWidth,_transformHeight+5,_body.GetAngle());
				_clipA.mask = _maskShape;
			}
			syncView();
			
			var parent:Sprite=_game.global.layerMan.items3Layer;
			if(_clipA){
				parent.addChild(_clipA);
				parent.addChild(_maskShape);
			}
			if(_clipB)parent.addChild(_clipB);
			
			_game.addEventListener(MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
		}
		
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold):void{
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var ob:b2Body=b1==_body?b2:b1;
			if(!inAcceptRange(ob)){
				contact.SetEnabled(false);
			}
		}
		
		private function createMapComplete(e:MyEvent):void{
			setVel();
			if(_isUseSyncDelayer){
				//设置所有刺的延时器
				var telThorns:Vector.<GameObject>=_game.getGameObjList(TelescopicThorn);
				var i:int=telThorns.length;
				var telThorn:TelescopicThorn;
				while (--i>=0){
					telThorn=telThorns[i] as TelescopicThorn;
					if(telThorn._isOut){
						_delayer_close||=Delayer.create();
						telThorn._myDelayer=_delayer_close;
					}else{
						_delayer_open||=Delayer.create();
						telThorn._myDelayer=_delayer_open;
					}
				}
			}else{
				_myDelayer=Delayer.create();
			}
			//
			_myDelayer.addEventListener(Delayer.EXECUTE,executeHandler);
			if(!_isListenerDestroyAll)_game.addEventListener(FrameworkEvent.DESTROY_ALL,destroyAll);
		}
		
		private function createShape(x:Number,y:Number,w:Number,h:Number, radian:Number):flash.display.Shape {
			var shape:flash.display.Shape = new flash.display.Shape();
			shape.graphics.beginFill(0xff0000);
			shape.graphics.drawRect(- w * 0.5, - h * 0.5, w, h);
			shape.graphics.endFill();
			shape.x = x;
			shape.y = y;
			shape.rotation = radian * 180 / Math.PI;
			return shape;
		}
		
		private function setVel():void{
			_isGotoEnd=false;
			var radian:Number = _isOut?_body.GetAngle():_body.GetAngle() + Math.PI;
			var v:b2Vec2=_body.GetLinearVelocity();
			v.x = Math.cos(radian) * _speed;
			v.y = Math.sin(radian) * _speed;
			_body.SetLinearVelocity(v);
			_body.SetAwake(true);
		}
		
		private function syncView():void {
			if(_clipA){
				_clipA.x=_body.GetPosition().x*MyData.ptm_ratio;
				_clipA.y=_body.GetPosition().y*MyData.ptm_ratio;
			}
		}
		
		private function executeHandler(e:MyEvent=null):void{
			_isOut=!_isOut;
			setVel();
		}
		
		override protected function update():void{
			syncView();
			var distance:Number=b2Vec2.Distance(_initPos,_body.GetPosition());
			if(!_isGotoEnd){
				if (distance >= _transformWidth/MyData.ptm_ratio*0.5) {
					_body.SetLinearVelocity(b2Vec2.MakeOnce(0,0));
					_body.SetAwake(true);
					var radian:Number=_isOut?_body.GetAngle():_body.GetAngle()+Math.PI;
					var x:Number=_initPos.x+Math.cos(radian)*_transformWidth/MyData.ptm_ratio*0.5;
					var y:Number=_initPos.y+Math.sin(radian)*_transformWidth/MyData.ptm_ratio*0.5;
					_body.SetPosition(b2Vec2.MakeOnce(x,y));
					_isGotoEnd=true;
					if(!_isFirst){
						if(!_myDelayer.isDelaying){
							_myDelayer.delayHandler(_delayTime);
						}
					}else{
						_isFirst=false;
						executeHandler();
					}
				}
			}
		}
		
		public function inAcceptRange(body:b2Body):Boolean {
			var p1:b2Vec2=new b2Vec2(_initPos.x+Math.cos(_body.GetAngle()-Math.PI*0.5)*4,
			                         _initPos.y+Math.sin(_body.GetAngle()-Math.PI*0.5)*4);
			var p2:b2Vec2=new b2Vec2(_initPos.x+Math.cos(_body.GetAngle()+Math.PI*0.5)*4,
			                         _initPos.y+Math.sin(_body.GetAngle()+Math.PI*0.5)*4);
			return pointOnSegment(body.GetPosition(),p1,p2) < 0;
		}
		
		private function pointOnSegment(p:b2Vec2,p1:b2Vec2,p2:b2Vec2):Number {
			var ax:Number = p2.x-p1.x;
			var ay:Number = p2.y-p1.y;
			
			var bx:Number = p.x-p1.x;
			var by:Number = p.y-p1.y;
			return ax*by-ay*bx;
		}
		
		override protected function onDestroy():void{
			if(_myDelayer){
				_myDelayer.removeEventListener(Delayer.EXECUTE,executeHandler);
				_myDelayer=null;
			}
			_game.removeEventListener(MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
			if(_body){
				_body.Destroy();
				_body=null;
			}
			if(_clipA){
				if(_clipA.parent)_clipA.parent.removeChild(_clipA);
				_clipA=null;
			}
			if(_clipB){
				if(_clipB.parent)_clipB.parent.removeChild(_clipB);
				_clipB=null;
			}
			if(_maskShape){
				if(_maskShape.parent)_maskShape.parent.removeChild(_maskShape);
				_maskShape=null;
			}
			super.onDestroy();
		}
	};

}