package app{
	import framework.objs.GameObject;
	import framework.Game;
	import g.MyObj;

	public class GameCheck extends MyObj{
		public static function create():void{
			var game:Game=Game.getInstance();
			game.createGameObj(new GameCheck());
		}
		
		override protected function init(info:*=null):void{
			super.init(info);
			
		}
		
		override protected function update():void{
			var player:Player=_game.getGameObjList(Player)[0] as Player;
			//check the faiure
			if(player){
				if(player.isDeathFinish) _myGame.gameFaiure();
			}
			//check the game victory
			if(player){
				if(player.isIntoExit){
					_myGame.gameWin();
				}
			}
		}
	}
}