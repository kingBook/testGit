package g{
	public class MapData{
		//关卡顺序列表
		private static var _levelOrderList:Array=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
		
		private static var _datas:Array;
		private static function initDatas():void{
			_datas=[];
			
			var i:int=_levelOrderList.length;
			while(--i>=0)_datas[i]={};
			
			_datas[1].size={width:1200,height:700};
			_datas[1].wallEff={name:"WallEff_mc",frame:1};
			_datas[1].hit={name:"Hit_mc",frame:1};
			_datas[1].objs={name:"_Objs01",frame:1};
			_datas[1].wallFrontEff={name:"WallFrontEff_mc",frame:1};
			_datas[1].wall={name:"Wall_mc",frame:1};
			_datas[1].wallBehindEff={name:"WallBehindEff_mc",frame:1};
			_datas[1].bgMiddle={name:"BgMiddle_mc",frame:1};
			_datas[1].bgBottom={name:"BgBottom_mc",frame:1};
			
			_datas[2].size={width:1400,height:700};
			_datas[2].wallEff={name:"WallEff_mc",frame:2};
			_datas[2].hit={name:"Hit_mc",frame:2};
			_datas[2].objs={name:"_Objs02",frame:1};
			_datas[2].wallFrontEff={name:"WallFrontEff_mc",frame:2};
			_datas[2].wall={name:"Wall_mc",frame:2};
			_datas[2].wallBehindEff={name:"WallBehindEff_mc",frame:2};
			_datas[2].bgMiddle={name:"BgMiddle_mc",frame:2};
			_datas[2].bgBottom={name:"BgBottom_mc",frame:2};
			
			_datas[3].size={width:2000,height:700};
			_datas[3].wallEff={name:"WallEff_mc",frame:3};
			_datas[3].hit={name:"Hit_mc",frame:3};
			_datas[3].objs={name:"_Objs03",frame:1};
			_datas[3].wallFrontEff={name:"WallFrontEff_mc",frame:3};
			_datas[3].wall={name:"Wall_mc",frame:3};
			_datas[3].wallBehindEff={name:"WallBehindEff_mc",frame:3};
			_datas[3].bgMiddle={name:"BgMiddle_mc",frame:3};
			_datas[3].bgBottom={name:"BgBottom_mc",frame:3};
			
			_datas[4].size={width:800,height:600};
			_datas[4].wallEff={name:"WallEff_mc",frame:4};
			_datas[4].hit={name:"Hit_mc",frame:4};
			_datas[4].objs={name:"_Objs04",frame:1};
			_datas[4].wallFrontEff={name:"WallFrontEff_mc",frame:4};
			_datas[4].wall={name:"Wall_mc",frame:4};
			_datas[4].wallBehindEff={name:"WallBehindEff_mc",frame:4};
			_datas[4].bgMiddle={name:"BgMiddle_mc",frame:4};
			_datas[4].bgBottom={name:"BgBottom_mc",frame:4};
			
			_datas[5].size={width:800,height:600};
			_datas[5].wallEff={name:"WallEff_mc",frame:5};
			_datas[5].hit={name:"Hit_mc",frame:5};
			_datas[5].objs={name:"_Objs05",frame:1};
			_datas[5].wallFrontEff={name:"WallFrontEff_mc",frame:5};
			_datas[5].wall={name:"Wall_mc",frame:5};
			_datas[5].wallBehindEff={name:"WallBehindEff_mc",frame:5};
			_datas[5].bgMiddle={name:"BgMiddle_mc",frame:5};
			_datas[5].bgBottom={name:"BgBottom_mc",frame:5};
			
			_datas[6].size={width:800,height:600};
			_datas[6].wallEff={name:"WallEff_mc",frame:6};
			_datas[6].hit={name:"Hit_mc",frame:6};
			_datas[6].objs={name:"_Objs06",frame:1};
			_datas[6].wallFrontEff={name:"WallFrontEff_mc",frame:6};
			_datas[6].wall={name:"Wall_mc",frame:6};
			_datas[6].wallBehindEff={name:"WallBehindEff_mc",frame:6};
			_datas[6].bgMiddle={name:"BgMiddle_mc",frame:6};
			_datas[6].bgBottom={name:"BgBottom_mc",frame:6};
			
			_datas[7].size={width:800,height:600};
			_datas[7].wallEff={name:"WallEff_mc",frame:7};
			_datas[7].hit={name:"Hit_mc",frame:7};
			_datas[7].objs={name:"_Objs07",frame:1};
			_datas[7].wallFrontEff={name:"WallFrontEff_mc",frame:7};
			_datas[7].wall={name:"Wall_mc",frame:7};
			_datas[7].wallBehindEff={name:"WallBehindEff_mc",frame:7};
			_datas[7].bgMiddle={name:"BgMiddle_mc",frame:7};
			_datas[7].bgBottom={name:"BgBottom_mc",frame:7};
			
			_datas[8].size={width:800,height:600};
			_datas[8].wallEff={name:"WallEff_mc",frame:8};
			_datas[8].hit={name:"Hit_mc",frame:8};
			_datas[8].objs={name:"_Objs08",frame:1};
			_datas[8].wallFrontEff={name:"WallFrontEff_mc",frame:8};
			_datas[8].wall={name:"Wall_mc",frame:8};
			_datas[8].wallBehindEff={name:"WallBehindEff_mc",frame:8};
			_datas[8].bgMiddle={name:"BgMiddle_mc",frame:8};
			_datas[8].bgBottom={name:"BgBottom_mc",frame:8};
			
			_datas[9].size={width:800,height:600};
			_datas[9].wallEff={name:"WallEff_mc",frame:9};
			_datas[9].hit={name:"Hit_mc",frame:9};
			_datas[9].objs={name:"_Objs09",frame:1};
			_datas[9].wallFrontEff={name:"WallFrontEff_mc",frame:9};
			_datas[9].wall={name:"Wall_mc",frame:9};
			_datas[9].wallBehindEff={name:"WallBehindEff_mc",frame:9};
			_datas[9].bgMiddle={name:"BgMiddle_mc",frame:9};
			_datas[9].bgBottom={name:"BgBottom_mc",frame:9};
			
			_datas[10].size={width:800,height:600};
			_datas[10].wallEff={name:"WallEff_mc",frame:10};
			_datas[10].hit={name:"Hit_mc",frame:10};
			_datas[10].objs={name:"_Objs10",frame:1};
			_datas[10].wallFrontEff={name:"WallFrontEff_mc",frame:10};
			_datas[10].wall={name:"Wall_mc",frame:10};
			_datas[10].wallBehindEff={name:"WallBehindEff_mc",frame:10};
			_datas[10].bgMiddle={name:"BgMiddle_mc",frame:10};
			_datas[10].bgBottom={name:"BgBottom_mc",frame:10};
			
			_datas[11].size={width:800,height:600};
			_datas[11].wallEff={name:"WallEff_mc",frame:11};
			_datas[11].hit={name:"Hit_mc",frame:11};
			_datas[11].objs={name:"_Objs11",frame:1};
			_datas[11].wallFrontEff={name:"WallFrontEff_mc",frame:11};
			_datas[11].wall={name:"Wall_mc",frame:11};
			_datas[11].wallBehindEff={name:"WallBehindEff_mc",frame:11};
			_datas[11].bgMiddle={name:"BgMiddle_mc",frame:11};
			_datas[11].bgBottom={name:"BgBottom_mc",frame:11};
			
			_datas[12].size={width:800,height:600};
			_datas[12].wallEff={name:"WallEff_mc",frame:12};
			_datas[12].hit={name:"Hit_mc",frame:12};
			_datas[12].objs={name:"_Objs12",frame:1};
			_datas[12].wallFrontEff={name:"WallFrontEff_mc",frame:12};
			_datas[12].wall={name:"Wall_mc",frame:12};
			_datas[12].wallBehindEff={name:"WallBehindEff_mc",frame:12};
			_datas[12].bgMiddle={name:"BgMiddle_mc",frame:12};
			_datas[12].bgBottom={name:"BgBottom_mc",frame:12};
			
			_datas[13].size={width:800,height:600};
			_datas[13].wallEff={name:"WallEff_mc",frame:13};
			_datas[13].hit={name:"Hit_mc",frame:13};
			_datas[13].objs={name:"_Objs13",frame:1};
			_datas[13].wallFrontEff={name:"WallFrontEff_mc",frame:13};
			_datas[13].wall={name:"Wall_mc",frame:13};
			_datas[13].wallBehindEff={name:"WallBehindEff_mc",frame:13};
			_datas[13].bgMiddle={name:"BgMiddle_mc",frame:13};
			_datas[13].bgBottom={name:"BgBottom_mc",frame:13};
			
			_datas[14].size={width:800,height:600};
			_datas[14].wallEff={name:"WallEff_mc",frame:14};
			_datas[14].hit={name:"Hit_mc",frame:14};
			_datas[14].objs={name:"_Objs14",frame:1};
			_datas[14].wallFrontEff={name:"WallFrontEff_mc",frame:14};
			_datas[14].wall={name:"Wall_mc",frame:14};
			_datas[14].wallBehindEff={name:"WallBehindEff_mc",frame:14};
			_datas[14].bgMiddle={name:"BgMiddle_mc",frame:14};
			_datas[14].bgBottom={name:"BgBottom_mc",frame:14};
			
			_datas[15].size={width:800,height:600};
			_datas[15].wallEff={name:"WallEff_mc",frame:15};
			_datas[15].hit={name:"Hit_mc",frame:15};
			_datas[15].objs={name:"_Objs15",frame:1};
			_datas[15].wallFrontEff={name:"WallFrontEff_mc",frame:15};
			_datas[15].wall={name:"Wall_mc",frame:15};
			_datas[15].wallBehindEff={name:"WallBehindEff_mc",frame:15};
			_datas[15].bgMiddle={name:"BgMiddle_mc",frame:15};
			_datas[15].bgBottom={name:"BgBottom_mc",frame:15};
			
			_datas[16].size={width:800,height:600};
			_datas[16].wallEff={name:"WallEff_mc",frame:16};
			_datas[16].hit={name:"Hit_mc",frame:16};
			_datas[16].objs={name:"_Objs16",frame:1};
			_datas[16].wallFrontEff={name:"WallFrontEff_mc",frame:16};
			_datas[16].wall={name:"Wall_mc",frame:16};
			_datas[16].wallBehindEff={name:"WallBehindEff_mc",frame:16};
			_datas[16].bgMiddle={name:"BgMiddle_mc",frame:16};
			_datas[16].bgBottom={name:"BgBottom_mc",frame:16};
			
			_datas[17].size={width:800,height:600};
			_datas[17].wallEff={name:"WallEff_mc",frame:17};
			_datas[17].hit={name:"Hit_mc",frame:17};
			_datas[17].objs={name:"_Objs17",frame:1};
			_datas[17].wallFrontEff={name:"WallFrontEff_mc",frame:17};
			_datas[17].wall={name:"Wall_mc",frame:17};
			_datas[17].wallBehindEff={name:"WallBehindEff_mc",frame:17};
			_datas[17].bgMiddle={name:"BgMiddle_mc",frame:17};
			_datas[17].bgBottom={name:"BgBottom_mc",frame:17};
			
			_datas[18].size={width:800,height:600};
			_datas[18].wallEff={name:"WallEff_mc",frame:18};
			_datas[18].hit={name:"Hit_mc",frame:18};
			_datas[18].objs={name:"_Objs18",frame:1};
			_datas[18].wallFrontEff={name:"WallFrontEff_mc",frame:18};
			_datas[18].wall={name:"Wall_mc",frame:18};
			_datas[18].wallBehindEff={name:"WallBehindEff_mc",frame:18};
			_datas[18].bgMiddle={name:"BgMiddle_mc",frame:18};
			_datas[18].bgBottom={name:"BgBottom_mc",frame:18};
			
			_datas[19].size={width:800,height:600};
			_datas[19].wallEff={name:"WallEff_mc",frame:19};
			_datas[19].hit={name:"Hit_mc",frame:19};
			_datas[19].objs={name:"_Objs19",frame:1};
			_datas[19].wallFrontEff={name:"WallFrontEff_mc",frame:19};
			_datas[19].wall={name:"Wall_mc",frame:19};
			_datas[19].wallBehindEff={name:"WallBehindEff_mc",frame:19};
			_datas[19].bgMiddle={name:"BgMiddle_mc",frame:19};
			_datas[19].bgBottom={name:"BgBottom_mc",frame:19};
			
			_datas[20].size={width:800,height:600};
			_datas[20].wallEff={name:"WallEff_mc",frame:20};
			_datas[20].hit={name:"Hit_mc",frame:20};
			_datas[20].objs={name:"_Objs20",frame:1};
			_datas[20].wallFrontEff={name:"WallFrontEff_mc",frame:20};
			_datas[20].wall={name:"Wall_mc",frame:20};
			_datas[20].wallBehindEff={name:"WallBehindEff_mc",frame:20};
			_datas[20].bgMiddle={name:"BgMiddle_mc",frame:20};
			_datas[20].bgBottom={name:"BgBottom_mc",frame:20};
		}
		
		public static function getDataObj(gameLevel:int):*{
			if(_datas==null)initDatas();
			var level:int=_levelOrderList[gameLevel];
			return _datas[level];
		}
		
		public static function getBodiesXml(gameLevel:int):XML{
			var level:int=_levelOrderList[gameLevel];
			/*[IF-FLASH]*/return Assets.getInstance().getMapXML(level);
			//[IF-SCRIPT]return Assets_h5.getInstance().getMapXML(level);
		}
		
		public static function getTmx(gameLevel:int):XML{
			var level:int=_levelOrderList[gameLevel];
			/*[IF-FLASH]*/return Assets.getInstance().getMapTmx(level);
			//[IF-SCRIPT]return Assets_h5.getInstance().getMapTmx(level);
		}
		
		public function MapData(){}
		
		
	};

}