package framework.objs{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import framework.Game;
	import framework.GameObjectListProxy;
	import framework.UpdateType;
	import framework.events.FrameworkEvent;
	import framework.namespaces.frameworkInternal;
	import flash.events.EventDispatcher;
	use namespace frameworkInternal;

	public class GameObject extends EventDispatcher{
		
		public static function dontDestroyOnDestroyAll(gameObject:GameObject):void{
			gameObject.isIgnoreDestroyAll=true;
		}
		
		public static function destroy(gameObject:GameObject):void{
			gameObject.destroy_private();
		}
		
		protected var _game:Game;
		frameworkInternal var isIgnoreDestroyAll:Boolean=false;
		private var _gameObjectListProxy:GameObjectListProxy;
		private var _components:Vector.<Component>;
		
		
		public function GameObject(){
			super();
		}
		
		frameworkInternal function init_internal(game:Game,gameObjectListProxy:GameObjectListProxy,info:*):void{
			_game=game;
			_gameObjectListProxy=gameObjectListProxy;
			_components=new Vector.<Component>();
			addToGameObjectList(_gameObjectListProxy);
			init(info);
			if(!isIgnoreDestroyAll){
				if(_game)_game.addEventListener(FrameworkEvent.DESTROY_ALL,destroyAll_self);
			}
			
			//
			scheduleUpdate(UpdateType.FOREVER);
			scheduleUpdate(UpdateType.FIXED);
			scheduleUpdate(UpdateType.UPDATE);
			scheduleUpdate(UpdateType.LATE);
		}
		virtual protected function init(info:*=null):void{}
		
		/**添加组件*/
		final protected function addComponent(componentClass:Class):Component{
			var component:Component=new componentClass() as Component;
			if(component==null)throw new Error("参数componentClass不是Component类");
			
			component.init_internal(this,_game);
			var id:int=_components.indexOf(component);
			if(id<0)_components.unshift(component);
			return component;
		}
		/**移除组件*/
		final protected function removeComponent(component:Component):void{
			if(_components==null)return;
			var id:int=_components.indexOf(component);
			if(id>-1&&_components[id]!=null){
				_components[id].destroy_internal();
				_components[id]=null;
			}
		}
		
		private function addToGameObjectList(gameObjectListProxy:GameObjectListProxy):void{
			//添加实例类
			gameObjectListProxy.addGameObject(getQualifiedClassName(this),this);
			//添加父类
			var parentClassName:String, o:*=this;
			var rootClassName:String=getQualifiedClassName(GameObject);//framework.objs::GameObject
			while (true) {
				parentClassName=getQualifiedSuperclassName(o);
				gameObjectListProxy.addGameObject(parentClassName,this);
				if(parentClassName==rootClassName)break;//只添加到GameObject类就中断
				o=getDefinitionByName(parentClassName);//下一个父类
			}
		}
		
		private function removeFromGameObjectList(gameObjectListProxy:GameObjectListProxy):void{
			//移除实例类
			gameObjectListProxy.removeGameObject(getQualifiedClassName(this),this);
			//移除父类
			var parentClassName:String, o:*=this;
			var rootClassName:String=getQualifiedClassName(GameObject);//framework.objs::GameObject
			while (true) {
				parentClassName=getQualifiedSuperclassName(o);
				gameObjectListProxy.removeGameObject(parentClassName,this);
				if(parentClassName==rootClassName)break;//只移除到GameObject类就中断
				o=getDefinitionByName(parentClassName);//下一个父类
			}
		}
		/**updateType=UpdateType.UPDATE*/
		private function scheduleUpdate(updateType:int=2):void{
			switch (updateType){
				case UpdateType.FOREVER: _game.addUpdate(updateType,foreverUpdate_private); break;
				case UpdateType.FIXED:   _game.addUpdate(updateType,fixedUpdate_private);   break;
				case UpdateType.UPDATE:  _game.addUpdate(updateType,update_private);        break;
				case UpdateType.LATE:    _game.addUpdate(updateType,lateUpdate_private);    break;
				default:
			}
		}
		/**updateType=UpdateType.UPDATE*/
		private function unscheduleUpdate(updateType:int=2):void{
			switch (updateType){
				case UpdateType.FOREVER: _game.removeUpdate(updateType,foreverUpdate_private); break;
				case UpdateType.FIXED:   _game.removeUpdate(updateType,fixedUpdate_private);   break;
				case UpdateType.UPDATE:  _game.removeUpdate(updateType,update_private);        break;
				case UpdateType.LATE:    _game.removeUpdate(updateType,lateUpdate_private);    break;
				default:
			}
		}
		
		/**指定的间隔(interval 秒)，重复调度(repeat+1)次函数*/
		final protected function schedule(func:Function,interval:Number,repeat:int,params:Array=null):void{
			_game.schedule(func,interval,repeat,params);
		}
		/**指定的间隔(delay 秒)，调度一次函数*/
		final protected function scheduleOnce(func:Function,delay:Number,params:Array=null):void{
			_game.scheduleOnce(func,delay,params);
		}
		
		/**移除函数调度*/
		final protected function unschedule(func:Function):void{
			_game.unschedule(func);
		}
		/**判断指定函数是否正在调度中*/
		final protected function isScheduleing(func:Function):Boolean{
			return _game.isScheduleing(func);
		}
		
		
		private function foreachComponetsCallUpdate(updateType:int):void{
			var i:int=_components.length;
			while(--i>=0){
				if(_components[i]==null) _components.splice(i,1);
				else _components[i].callUpdate(updateType);
			}
		}
		private function foreverUpdate_private():void{
			foreachComponetsCallUpdate(UpdateType.FOREVER);
			foreverUpdate();
		}
		private function fixedUpdate_private():void{
			foreachComponetsCallUpdate(UpdateType.FIXED);
			fixedUpdate();
		}
		private function update_private():void{
			foreachComponetsCallUpdate(UpdateType.UPDATE);
			update();
		}
		private function lateUpdate_private():void{
			foreachComponetsCallUpdate(UpdateType.LATE);
			lateUpdate();
		}
		
		virtual protected function foreverUpdate():void{}
		virtual protected function fixedUpdate():void{}
		virtual protected function update():void{}
		virtual protected function lateUpdate():void{}
		
		private function destroyAll_self(e:FrameworkEvent):void{destroy_private();}
		
		private var _isDestroyed:Boolean;
		private function destroy_private():void{
			if(_isDestroyed)return;
			_isDestroyed=true;
			onDestroy();
		}
		protected function onDestroy():void{
			unscheduleUpdate(UpdateType.FOREVER);
			unscheduleUpdate(UpdateType.FIXED);
			unscheduleUpdate(UpdateType.UPDATE);
			unscheduleUpdate(UpdateType.LATE);
			if(!isIgnoreDestroyAll){
				_game.removeEventListener(FrameworkEvent.DESTROY_ALL,destroyAll_self);
			}
			if(_gameObjectListProxy){
				removeFromGameObjectList(_gameObjectListProxy);
				_gameObjectListProxy = null;
			}
			if(_components){
				var i:int=_components.length;
				while (--i>=0){
					if(_components[i]!=null)_components[i].destroy_internal();
				}
				_components=null;
			}
			_game=null;
		}
		
	};
	
}