package g{
	import Box2D.Dynamics.b2World;
	import demo.TestObj;
	import framework.Game;
	import framework.system.Box2dManager;
	import framework.system.LocalManager;
	import flash.system.Capabilities;
	import g.Map;
	import g.objs.CloudBackgroup;
	import flash.display.Sprite;
	import flash.display.Stage;
	import app.GameCheck;

	public class MyGame extends Game{
		public function MyGame(){
			super();
		}
		
		public static function getInstance():MyGame{
			return (_instance||=new MyGame()) as MyGame;
		}
		
		override public function startup(main:Sprite,stage:Stage,info:*=null):void{
			trace("==== startup MyGame ====");
			_global = new MyGlobal(main, this, MyData.stageW, MyData.stageH, MyData.box2dDebugVisible,MyData.ptm_ratio);//初始全局对象
			var box2dMan:Box2dManager=Box2dManager.create(0,_global.layerMan.gameLayer,this,MyData.gravity,MyData.box2dDebugVisible,MyData.useMouseJoint,MyData.deltaTime,MyData.ptm_ratio);
			_global.setCurWorld(box2dMan.world);
			if (MyData.clearLocalData) _global.localManager.clear();
/*[IF-SCRIPT-BEGIN]
			var soundList:*=Assets_h5.getInstance().getSoundList();
			for(var name:String in soundList){
				_global.soundMan.addSoundInstance(name,soundList[name]);
			}
[IF-SCRIPT-END]*/
			if (MyData.closeSound) _global.soundMan.mute = true;
			if(MyData.languageVersion=="auto"){
				var isCN:Boolean=flash.system.Capabilities.language=="zh-CN";
				MyData.language=isCN?"cn":"en";
			}else{
				MyData.language=MyData.languageVersion;
			}
			super.startup(main,stage,info);
			
			//createGameObj(new ShowImage());
			//createGameObj(new ClipTest());
			
			//var mc:*=LibUtil.getDefMovie("HelpUI_mc");
			//trace(mc);
			//_global.layerMan.uiLayer.addChild(mc);
			toTitle();
			
		}
		
		/**保存解锁关卡*/
		public function saveUnlockLevel():void{
			var localMan:LocalManager = _global.localManager;
			// 解锁关卡
			var unlockLevel:int = int(localMan.get("unlockLevel"));
			if (myGlobal.gameLevel+1>unlockLevel)
				localMan.save("unlockLevel", (myGlobal.gameLevel + 1>MyData.maxLevel)?MyData.maxLevel:myGlobal.gameLevel+1);
		}
		
		private function destroyCurLevel():void{
			destroyAll();
			//TweenMax.killAll();
		}
		
		public function toTitle(isDestroyCurLevel:Boolean=false):void{
			if(isDestroyCurLevel)destroyCurLevel();
			UI.create(UI.TITLE);
			_global.soundMan.stopAll();
			_global.soundMan.playLoop("Sound_title");
		}
		
		public function toSelectLevel(isDestroyCurLevel:Boolean=false):void{
			if(isDestroyCurLevel)destroyCurLevel();
			UI.create(UI.SELECT_LEVEL);
			_global.soundMan.stopAll();
			_global.soundMan.playLoop("Sound_title");
		}
		
		public function toHelp():void{
			UI.create(UI.HELP);
		}
		
		public function gameWin():void{
			if (myGlobal.gameStatus==MyGlobal.GAME_END)return;
			trace("gameWin");
			myGlobal.gameWin();
			// 弹过关，通关 界面
			if (myGlobal.gameLevel<MyData.maxLevel){
				UI.create(UI.MISSION_COMPLETE);
			}else {
				UI.create(UI.VICTORY);
			}
			
			saveUnlockLevel();
			//播放胜利音效
			_global.soundMan.stopAll();
			_global.soundMan.play("Sound_win")
		}
		
		public function gameFaiure():void{
			if (myGlobal.gameStatus == MyGlobal.GAME_END) return;
			trace("gameFailure");
			myGlobal.gameFailure();
			UI.create(UI.FAILURE);
			
			_global.soundMan.stopAll();
			_global.soundMan.play("Sound_failure");
		}
		
		public function resetLevel():void{
			destroyCurLevel();
			myGlobal.resetLevel();
			gotoLevel(myGlobal.gameLevel);
		}
		
		public function nextLevel():void{
			destroyCurLevel();
			myGlobal.nextLevel();
			gotoLevel(myGlobal.gameLevel+1);
		}
		
		public function gotoLevel(level:int):void{
			myGlobal.gotoLevel(level);
			//创建 控制界面
			UI.create(UI.CONTROL_BAR);
			//创建地图
			Map.create();
			dispatchEvent(new MyEvent(MyEvent.CREATE_MAP_COMPLETE));
			//创建 游戏信息界面
			GameMessageUI.create();
			//创建玩家
			//创建云背景
			/*var map:Map=getGameObjList(Map)[0] as Map;
			CloudBackgroup.create("Cloud_view",0.5,2,0,map.width,20,250);*/
			GameCheck.create();
			
			
			//TestObj.create();
			// 播放背景音乐
			_global.soundMan.stopAll();
			_global.soundMan.playLoop("Sound_bg",0.6);
		}
		
		public function get myGlobal():MyGlobal{return _global as MyGlobal;}
	};
}

