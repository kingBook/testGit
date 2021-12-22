package g{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import g.MyGame;

	public dynamic class Main extends MovieClip{
		public function Main(){
			layaInit();
			if(stage)addedToStage(); else addEventListener("addedToStage",addedToStage);
		}
		
		private function layaInit():void{
/*[IF-SCRIPT-BEGIN]
            //__JS__('MyData.stageW = Laya.window.innerWidth;');
            //__JS__('MyData.stageH = Laya.window.innerHeight;');

			IFlash.setSize(MyData.stageW, MyData.stageH); //2D项目中设置场景尺寸
			IFlash.setOrientationEx(1); //是否为横屏模式
			IFlash.setBgcolor("#ffffff"); //背景色
			IFlash.showInfo(true); //是否显示帧率
[IF-SCRIPT-END]*/
		}
		
		private function addedToStage(e:*=null):void{
			if(e)removeEventListener("addedToStage",addedToStage);
			addEventListener("enterFrame",init);
		}
		
		private function init(e:*):void{
			removeEventListener("enterFrame", init);
			if (!MyData.cancelStageMask) setMask();//进入帧后再设置舞台遮罩,避免在main的第一帧无法更改
			stage.frameRate = MyData.frameRate;//锁定帧频
/*[IF-FLASH]*/Assets.getInstance().addEventListener("complete", assetsLoaded);
//[IF-SCRIPT]Assets_h5.getInstance().addEventListener("complete", assetsLoaded);
		}
		
		private function setMask():void{
			var shape:Shape=new Shape();
			shape.graphics.beginFill(0,1);
			shape.graphics.drawRect(0,0,MyData.stageW,MyData.stageH);
			shape.graphics.endFill();
			addChild(shape);
			mask = shape;
		}
		
		/**资源加载完成*/
		private function assetsLoaded(e:*):void{
			e.target.removeEventListener("complete", assetsLoaded);
			MyGame.getInstance().startup(this,stage);
		}
		
	};
	
}
