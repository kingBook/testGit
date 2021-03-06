package demo {
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import framework.Game;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import framework.utils.FuncUtil;
	import g.MyEvent;
	import g.MyGame;
	import g.MyObj;
	public class TestObj extends MyObj{
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new TestObj());
		}
		
		private var sp:Sprite;
		private var bb:Sprite;
		private var cc:Sprite;
		private var b:b2Body;
		public function TestObj() {
			super();
			trace("new player");
		}
		
		override protected function init(info:*=null):void {
			//胜利按钮
			bb = createBtn(150, 100, "胜利", _game.global.layerMan.uiLayer);
			bb.name = "胜利";
			//失败按钮
			cc = createBtn(250, 100, "失败", _game.global.layerMan.uiLayer);
			cc.name = "失败";
			bb.addEventListener(MouseEvent.CLICK, clickHandler);
			cc.addEventListener(MouseEvent.CLICK, clickHandler);
			
			//滚动地图
			//_game.global.scorllMan.addToTargetList(b);
			
			MapScorllTest.create();
		}
		
		private function clickHandler(e:MouseEvent):void {
			var targetName:String=e.target["name"];
			switch (targetName) {
				case "胜利":
					trace("发送胜利");
					_myGame.gameWin();
					break;
				case "失败":
					trace("发送失败");
					_myGame.gameFaiure();
					break;
				default:
			}
		}
		
		private function createBtn(x:Number,y:Number,text:String, parent:Sprite):Sprite {
			var sp:Sprite = new Sprite();
			sp.x = x;
			sp.y = y;
			sp.graphics.beginFill(0xcccccc, 1);
			sp.graphics.drawRect(0, 0, 60, 20);
			sp.graphics.endFill();
			var txt:TextField = new TextField();
			txt.textColor = 0x0000ff;
			txt.text = text;
			txt.width = 60;
			txt.height = 20;
			sp.addChild(txt);
			parent.addChild(sp);
			sp.mouseChildren = false;
			sp.buttonMode = true;
			return sp;
		}
		
		override protected function update():void{
		}
		
		override protected function onDestroy():void {
			trace("destroy TestObj");
			bb.removeEventListener(MouseEvent.CLICK, clickHandler);
			cc.removeEventListener(MouseEvent.CLICK, clickHandler);
			FuncUtil.removeChild(bb);
			FuncUtil.removeChild(cc);
			FuncUtil.removeChild(sp);
			_game.global.curWorld.DestroyBody(b);
			b = null;
			bb = null;
			cc = null;
			sp = null;
			super.onDestroy();
		}
	}

}