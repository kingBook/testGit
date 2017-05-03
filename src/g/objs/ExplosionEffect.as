package g.objs{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import framework.Game;
	import framework.objs.Clip;
	import framework.utils.Box2dUtil;
	import framework.utils.LibUtil;
	import framework.utils.RandomKb;
	import g.MyData;
	import g.MyObj;
	/**冰块等破碎特效*/
	public class ExplosionEffect extends MyObj{
		
		public static function create(bodyCenter:b2Vec2,explosionCenter:b2Vec2,explosionMcDefName:String,maxY:Number,velocity:Number=8):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.bodyCenter=bodyCenter;
			info.explosionCenter=explosionCenter;
			info.explosionMcDefName=explosionMcDefName;
			info.maxY=maxY;
			info.velocity=velocity;
			game.createGameObj(new ExplosionEffect(),info);
		}
		
		public static function create1(bodyCenter:b2Vec2,explosionCenter:b2Vec2,mcMatrix:Matrix,explosionMcDefName:String,maxY:Number,velocity:Number=8):void{
			var game:Game=Game.getInstance();
			var info:*={};
			info.bodyCenter=bodyCenter;
			info.explosionCenter=explosionCenter;
			info.mcMatrix=mcMatrix;
			info.explosionMcDefName=explosionMcDefName;
			info.maxY=maxY;
			info.velocity=velocity;
			game.createGameObj(new ExplosionEffect(),info);
		}
		
		public function ExplosionEffect(){
			super();
		}
		
		override protected function init(info:* = null):void{
			var explosionCenter:b2Vec2=info.explosionCenter;
			var bodyCenter:b2Vec2=info.bodyCenter;
			var velocity:Number=info.velocity;
			var defName:String=info.explosionMcDefName;
			var mcMatrix:Matrix=info.mcMatrix;
			var mc:MovieClip=LibUtil.getDefMovie(defName);
			if(mcMatrix) mc.transform.matrix=mcMatrix;
			var maxY:Number=info.maxY;
			var drawSp:Sprite=new Sprite();
			drawSp.addChild(mc);
			var len:int=mc.totalFrames;
			for(var i:int=0;i<len;i++){
				mc.gotoAndStop(i+1);
				var r:Rectangle=mc.getBounds(drawSp);
				
				//trace(r);
				var x:Number=bodyCenter.x*MyData.ptm_ratio+(r.x+r.width*0.5);
				var y:Number=bodyCenter.y*MyData.ptm_ratio+(r.y+r.height*0.5);
				var angleRadian:Number=Math.atan2(y-explosionCenter.y*MyData.ptm_ratio, x-explosionCenter.x*MyData.ptm_ratio);
				var body:b2Body=Box2dUtil.createBox(r.width,r.height,x,y,_game.global.curWorld,MyData.ptm_ratio);
				body.SetSensor(true);
				body.SetLinearVelocity(b2Vec2.MakeFromAngle(angleRadian,velocity));
				body.SetAngularVelocity(RandomKb.wave*10);
				
				var bmd:BitmapData=new BitmapData(int(r.width+0.9),int(r.height+0.9),true,0);
				var matrix:Matrix=new Matrix();
				matrix.tx=-r.x;
				matrix.ty=-r.y;
				bmd.draw(drawSp,matrix);
				var clip:Clip=Clip.fromBitmapData(bmd);
				clip.x=-bmd.width>>1;
				clip.y=-bmd.height>>1;
				clip.smoothing=true;
				var sp:Sprite=new Sprite();
				sp.addChild(clip);
				sp.filters=[new GlowFilter(0,1,2,2)];
				
				Fragment.create(body,maxY/MyData.ptm_ratio,sp,_game.global.layerMan.effLayer);
			}
			drawSp.removeChild(mc);
			drawSp=null;
		}
		
	};

}