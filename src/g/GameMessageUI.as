package g{
	import app.Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import framework.events.FrameworkEvent;
	import framework.utils.FuncUtil;
	import framework.UpdateType;
	import framework.Game;
	import framework.utils.LibUtil;
	import framework.objs.GameObject;

	//import g.objs.Item;
	
	public class GameMessageUI extends MyObj{
		private var _view:Sprite;
		
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new GameMessageUI(),{view:LibUtil.getDefSprite("GameMessageUI_mc")});
		}
		
		public function GameMessageUI(){
			super();
		}
		
		override protected function init(info:*=null):void{
			_view=info.view;
			MovieClip(_view).gotoAndStop(MyData.language=="en"?1:2);
			//level text
			var lvTxt:TextField=_view.getChildByName("lvTxt") as TextField;
			lvTxt.text=(_myGame.myGlobal.gameLevel<10 ? "0" : "")+_myGame.myGlobal.gameLevel;
			//
			_game.global.layerMan.uiLayer.addChild(_view);
		}
		
		override protected function foreverUpdate():void{
			var hpTxt:TextField=_view.getChildByName("hpTxt") as TextField;
			if(hpTxt){
				hpTxt.text="2"//_myGame.myGlobal.playerHp.toString();
			}
			
			//
			var itemTxt:TextField=_view.getChildByName("itemTxt") as TextField;
			if(itemTxt){
				itemTxt.text="15"//Item.itemCount+"/"+Item.itemTotal;
			}
			
			var bulletCountTxt:TextField=_view.getChildByName("bulletCountTxt") as TextField;
			if(bulletCountTxt){
				var players:Vector.<GameObject>=_game.getGameObjList(Player);
				if(players){
					var player:Player=_game.getGameObjList(Player)[0] as Player
					var cntStr:String=player.bulletCount.toString();
					bulletCountTxt.text=cntStr.length<2?"0"+cntStr:cntStr;
				}
			}
		}
		
		override protected function onDestroy():void{
			FuncUtil.removeChild(_view);
			_view=null;
			super.onDestroy();
		}
		
	}

}