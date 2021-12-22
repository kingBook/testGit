package app{
	import g.objs.Switch;
	import flash.display.MovieClip;
	import framework.Game;
	import framework.utils.Box2dUtil;
	import g.MyData;
	import framework.objs.Clip;
	import Box2D.Dynamics.b2Body;

	public class BulletTouchSwitch extends Switch{
		public static function create(childMc:MovieClip):void{
			var game:Game=Game.getInstance();
			
			var nameList:Array=childMc.name.split("_");
			
			var info:*={};
			info.body=Box2dUtil.createBoxWithDisObj(childMc,game.global.curWorld,MyData.ptm_ratio);
			info.view=Clip.fromDefName("BulletTouchSwitch_view",true);
			info.viewParent=game.global.layerMan.items2Layer;
			info.myName=nameList[1];
			info.isOn=nameList[2];
			game.createGameObj(new BulletTouchSwitch(),info);
		}
		
		override protected function init(info:*=null):void{
			super.init(info);
			_myName=info.myName;
			_body.SetType(b2Body.b2_staticBody);
		}
		
		override protected function on():void{
			_view.visible=false;
			_body.SetSensor(true);
			scheduleOnce(resume,2);
		}
		
		override protected function off():void{
			_view.visible=true;
			_body.SetSensor(false);
		}
		
		private function resume():void{
			control(false,false);
		}
		
		override protected function onDestroy():void{
			unschedule(resume);
			super.onDestroy();
		}
	}
}