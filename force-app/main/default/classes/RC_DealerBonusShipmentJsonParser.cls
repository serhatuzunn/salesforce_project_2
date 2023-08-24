public class RC_DealerBonusShipmentJsonParser {

    public class Item {
		public String BSTNK;
		public String POSNR;
		public String ERDAT;
		public String NAME1;
		public String MATNR;
		public String MATNR_T;
		public String KWMENG;
		public String KONDM;
		public String KONDM_T;
		public String KUNNR;
		public String KUNNR_T;
		public String ZDATE;
		public Double ZFIYAT1_BR;
		public Double ZFIYAT1;
		public String ZFIYAT2_BR;
		public String ZFIYAT2;
		public String ORAN;
		public Double ZPRIM;
		public String ZPB;
		public String KANAL;
		public String PRODH;
		public String PRODH_T;
		public String BELNR_V;
	}

	public ET_RETURN ET_RETURN;

	public class ET_RETURN {
		public List<Item> item;
	}

	
	public static RC_DealerBonusShipmentJsonParser parse(String json) {
		return (RC_DealerBonusShipmentJsonParser) System.JSON.deserialize(json, RC_DealerBonusShipmentJsonParser.class);
        
    }

}