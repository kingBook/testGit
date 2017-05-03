package framework.utils{
	import flash.geom.Point;
	/**数学类*/
	public class Mathk{
		
		public function Mathk(){
			
		}
		
		/**两点的斜率*/
		public static function getKWithPoints(x1:Number,y1:Number,x2:Number,y2:Number):Number{
			return (y2-y1)/(x2-x1);
		}
		
		/**
		 * 判断两直线垂直
		 * @param	k1 直线1斜率
		 * @param	k2 直线2斜率
		 * @return  Boolean
		 */
		public static function isPerp(k1:Number,k2:Number):Boolean{
			return k1*k2==-1;
		}
		
		/**
		 * 求两直线的交点(需保证两直线有交点)
		 * @param	x1 直线1上的一点x
		 * @param	y1 直线1上的一点y
		 * @param	k1 直线1的斜率
		 * @param	x2 直线2上的一点x
		 * @param	y2 直线2上的一点y
		 * @param	k2 直线2的斜率
		 * @param	output 输出的Point
		 * @return
		 */
		public static function getLineIntersect(x1:Number,y1:Number,k1:Number,
										     x2:Number,y2:Number,k2:Number,output:Point=null):Point{
			var pt:Point=output; pt||=new Point();
			pt.x = (k1*x1-k2*x2+y2-y1)/(k1-k2);
			pt.y = k1*(pt.x-x1)+y1;
			return pt;
		}
		
		/**
		 * 求两直线是否有交点
		 * @param	x1 直线1上的一点x
		 * @param	y1 直线1上的一点y
		 * @param	k1 直线1的斜率
		 * @param	x2 直线2上的一点x
		 * @param	y2 直线2上的一点y
		 * @param	k2 直线2的斜率
		 * @return
		 */
		public static function isLineHasIntersect(/*x1:Number,y1:Number,*/k1:Number,
												/*x2:Number,y2:Number,*/k2:Number):Boolean{
			//var b1:Number=getBY(x1,y1,k1);
			//var b2:Number=getBY(x2,y2,k2);
			//1. k1!=k2 有一个交点
			//2. k1==k2时
			//   如果b1==b2，则两直线垂叠有无数个交点
			//   如果b1!=b2，没有交点
			return k1!=k2;
		}
		
		/**返回直线y轴上的截距*/
		public static function getBY(x1:Number,y1:Number,k1:Number):Number{
			//点斜式: (y-y1)=k(x-x1);
			// y-y1=k*x-k*x1
			// y=k*x-k*x1+y1
			//x=0时,截距y=-k*x1+y1;
			return -k1*x1+y1;
		}
		
		/**
		 * 旋转坐标
		 * @param	p 要旋转的坐标
		 * @param	rotateAngle 要旋转的弧度
		 * @param	output
		 * @return
		 */
		public static function rotatePoint(p:Point,rotateAngle:Number,output:Point=null):Point{
			if(output==null)output=new Point();
			var x:Number=p.x;
			var y:Number=p.y;
			var cos:Number=Math.cos(rotateAngle);
			var sin:Number=Math.sin(rotateAngle);
			output.x=x*cos-y*sin;
			output.y=x*sin+y*cos;
			return output;
		}
		
		/**
		 * 绕着某点旋转坐标
		 * @param	p 要旋转的坐标
		 * @param	rotateAngle 要旋转的弧度
		 * @param	origin 旋转的中心
		 * @param	output
		 * @return
		 */
		public static function rotatePointWithOrigin(p:Point,rotateAngle:Number,origin:Point,output:Point=null):Point{
			if(output==null)output=new Point();
			var tmp:Point=new Point(p.x-origin.x,p.y-origin.y);
			rotatePoint(tmp,rotateAngle,output);
			output.x+=origin.x;
			output.y+=origin.y;
			return output;
		}
		
		/**点在线段上的关系最好以0.1小数误差判断*/
		public static function pointOnSegment(x:Number,y:Number,x1:Number,y1:Number,x2:Number,y2:Number):Number{
			var ax:Number = x2-x1;
			var ay:Number = y2-y1;
			
			var bx:Number = x-x1;
			var by:Number = y-y1;
			return ax*by-ay*bx;
		}
		
		public static const Deg2Rad:Number=Math.PI/180;
		public static const Rad2Deg:Number=180/Math.PI;
		
	};

}