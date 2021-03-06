﻿package g.objs{
	import flash.display.Sprite;
	import framework.Game;
	import framework.objs.GameObject;
	import framework.utils.RandomKb;
	/**
	 * 云背景
	 * @author kingBook
	 * 2016/3/11 9:18
	 */
	public class CloudBackgroup extends GameObject{
		
		/**
		 * 创建云背景
		 * @param	defName 多帧云朵元件链接名
		 */
		static public function create(defName:String,speedMin:Number,speedMax:Number,xmin:Number,xmax:Number,ymin:Number,ymax:Number):void{
			var game:Game=Game.getInstance();
			var info:*={
				defName:defName,
				speedMin:speedMin,
				speedMax:speedMax,
				xmin:xmin,
				xmax:xmax,
				ymin:ymin,
				ymax:ymax
			};
			game.createGameObj(new CloudBackgroup(),info);
		}
		
		public function CloudBackgroup(){
			super();
		}
		
		override protected function init(info:*=null):void{
			var xmin:Number=info.xmin;
			var xmax:Number=info.xmax;
			var ymin:Number=info.ymin;
			var ymax:Number=info.ymax;
			var speedMin:Number=info.speedMin;
			var speedMax:Number=info.speedMax;
			var defName:String=info.defName;
			var parent:Sprite=_game.global.layerMan.items1Layer;
			
			var total:int;
			total+=int((xmax-xmin)/300);
			total+=int((ymax-ymin)/200);
			
			var x:Number,y:Number,speed:Number;
			for(var i:int=0;i<total;i++){
				x=RandomKb.range(xmin,xmax,false);
				y=RandomKb.range(ymin,ymax,false);
				speed=RandomKb.range(speedMin,speedMax,false);
				Cloud.create(defName,x,y,parent,speed,xmax);
			}
		}
		
	};

}


import flash.display.Sprite;
import flash.geom.Rectangle;
import framework.Game;
import framework.UpdateType;
import framework.objs.Clip;
import framework.objs.GameObject;
import framework.utils.RandomKb;

class Cloud extends GameObject{
	static public function create(defName:String,x:Number,y:Number,parent:Sprite,speed:Number, mapWidth:Number):Cloud{
		var game:Game=Game.getInstance();
		var clip:Clip=Clip.fromDefName(defName,true,true,parent,x,y,true);
		clip.gotoAndStop(RandomKb.range(1,clip.totalFrames,true));
		parent.addChildAt(clip,0);
		return game.createGameObj(new Cloud(),{clip:clip,speed:speed,mapWidth:mapWidth}) as Cloud;
	}
	
	private var _clip:Clip;
	private var _speed:Number;
	private var _mapWidth:Number;
	
	override protected function init(info:*=null):void{
		_clip=info.clip;
		_speed=info.speed;
		_mapWidth=info.mapWidth;
	}
	
	override protected function update():void{
		_clip.x-=_speed;
		
		var r:Rectangle=_clip.getBounds(_clip.parent);
		var xmin:Number=r.x;
		var xmax:Number=r.bottomRight.x;
		
		if(xmax<0){//向左运动超出边界
			_clip.x=_mapWidth+(_clip.x-xmin);
		}
	}
	
	override protected function onDestroy():void{
		if(_clip&&_clip.parent)_clip.parent.removeChild(_clip);
		_clip=null;
		super.onDestroy();
	}
}