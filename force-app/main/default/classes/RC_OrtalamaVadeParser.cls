public class RC_OrtalamaVadeParser {

	public class Item {
		public String BELNR;
		public String BUZEI;
		public String KUNNR;
		public String BUDAT;
		public String ZFBDT;
		public String WAERS;
		public String DMBTR;
		public String SGTXT;
		public String BLART;
		public String AWKEY;
		public String GJAHR;
		public String ZLSPR;
		public String ZLSCH;
		public String LTEXT;
		public String MATNR;
		public String MAKTX;
		public String MENGE;
		public String MEINS;
	}

	public Integer EV_BAKIYE;
	public String EV_ORTVADE;
	public ET_ITEMS ET_ITEMS;

	public class ET_ITEMS {
		public List<Item> item;
	}

	
	public static RC_OrtalamaVadeParser parse(String json) {
		return (RC_OrtalamaVadeParser) System.JSON.deserialize(json, RC_OrtalamaVadeParser.class);
	}
}