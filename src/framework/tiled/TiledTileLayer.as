package framework.tiled {
	/**
	 * Represents a single tile layer within a map.
	 */
	public class TiledTileLayer extends TiledLayer {
		/** The encoding used on the layer data. */
		public var encoding:String;
		/** The compression used on the layer data. */
		public var compression:String;
		/** The parsed layer data, uncompressed and unencoded. */
		public var data:Array;

		public function TiledTileLayer(tmx:XML) {
			super(tmx);
			
			var dataNode:XML = tmx.data[0];
			encoding = "@encoding" in dataNode ? dataNode.@encoding : null;
			compression = "@compression" in dataNode ? dataNode.@compression : null;
			data = TiledUtils.stringToTileData(dataNode.text(), width, encoding, compression);
		}
		
		public function toDataString():String{
			var str:String="";
			for(var i:int=0;i<height;i++){
				for(var j:int=0;j<width;j++){
					str+=data[i][j];
				}
				str+="\n";
			}
			return str;
		}
	}
}
