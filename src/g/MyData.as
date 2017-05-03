package g {
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 14:54
	 */
	public class MyData {
		public static var gravity:b2Vec2 = new b2Vec2(0,50);
		public static var deltaTime:Number=30;
		public static var ptm_ratio:Number = 30;
		public static var stageW:int = 800;
		public static var stageH:int = 600;
		public static var frameRate:uint = 30;
		public static var maxLevel:int = 15;
		public static var box2dDebugVisible:Boolean = false;
		public static var useMouseJoint:Boolean = true;
		public static var fpsVisible:Boolean = true;
		public static var unlock:Boolean = false;
		public static var clearLocalData:Boolean = false;
		public static var closeSound:Boolean = true;
		public static var cancelStageMask:Boolean = false;
		public static var linkHomePageFunc:Function = null;
		
		public static var languageVersion:String="cn";// cn | en | auto
		public static var language:String;//程序中判断的变量
		
		public function MyData() {
			
		}
		
	}

}