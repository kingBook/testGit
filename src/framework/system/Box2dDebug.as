package framework.system {
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import framework.events.FrameworkEvent;
	import framework.Game;
	import framework.UpdateType;
	public class Box2dDebug {
		private var _game:Game;
		private var _debugDraw:b2DebugDraw;
		private var _parent:Sprite;
		private var _viewMan:LayerManager;
		private var _world:b2World;
		private var _global:Global;
		public function Box2dDebug(game:Game, viewMan:LayerManager, global:Global, ptm_ratio:Number) {
			_game=game;
			_viewMan=viewMan;
			_global = global;
			
			_parent=new Sprite();
			_parent.name = "napeDebugSprite";
			_viewMan.gameLayer.addChild(_parent);
			_debugDraw=new b2DebugDraw();
			_debugDraw.SetSprite(_parent);
			_debugDraw.SetDrawScale(ptm_ratio);
			_debugDraw.SetFillAlpha(0);
			_debugDraw.SetLineThickness(0.5);
			_debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit/*|b2DebugDraw.e_centerOfMassBit*/);
			
			_global.addEventListener(FrameworkEvent.CHANGE_CURRENT_WORLD, changeCurrentWorldHandler);
			
		}
		
		private function changeCurrentWorldHandler(e:FrameworkEvent):void{
			setWorld(_global.curWorld);
		}
		
		public function reset():void{
			_viewMan.gameLayer.addChild(_parent);
		}
		
		private function setWorld(world:b2World):void{
			_world = world;
			_world.SetDebugDraw(_debugDraw);
		}
		
		public function get debugDraw():b2DebugDraw{ return _debugDraw; }
	}

}